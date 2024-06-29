import sys
import os

# Add the project root to the Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

import apache_beam as beam
from apache_beam.dataframe.convert import to_dataframe
import allmenuScraperDoFns
import fastFoodNutritionDoFns

ITEM_ATTRIBUTES = ["item_name", "price", "ingredients", "category", "rest_id", "rest", 'grubhub', 'address']
BASE_URL = 'https://www.allmenus.com'
STATE = 'ca'

def run_scraper(city_names: list[str], save_filename: str) -> None:
    with beam.Pipeline() as pipeline:
        all_menu = (
            pipeline
            | "insert city names" >> beam.Create(city_names)
            | "extract restaurants in cities" >> beam.ParDo(allmenuScraperDoFns.ExtractRestaurantsFromLocationFn('ca'))
            | "extract menu items from restaurant" >> beam.ParDo(allmenuScraperDoFns.ExtractMenuItemFromRestaurantFn())
            | "extract nutrition from menu items" >> beam.ParDo(fastFoodNutritionDoFns.ExtractMenuItemNutritionFn())
            | "write to csv" >> beam.io.WriteToText(save_filename, file_name_suffix='.csv')
        )

if __name__ == "__main__":
    run_scraper(city_names=['irvine'], save_filename='allmenuNutritionUpdated')
