import requests
from bs4 import BeautifulSoup, Tag
import pandas as pd
import re
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import apache_beam as beam
from utils.webscrapeConstants import HEADERS
import time

BASE_URL = 'https://fastfoodnutrition.org'

session = requests.Session()
retry = Retry(connect=3, backoff_factor=0.5)
adapter = HTTPAdapter(max_retries=retry)
session.mount('http://', adapter)
session.mount('https://', adapter)

def get_response(url):
    for _ in range(3):
        try:
            return session.get(url, headers=HEADERS, timeout=10)
        except (requests.exceptions.Timeout, requests.exceptions.ConnectionError):
            time.sleep(2)
    raise RuntimeError(f"Failed to fetch {url} after 3 retries")

class ExtractMenuItemNutritionFn(beam.DoFn):
    def __init__(self, base_url='https://fastfoodnutrition.org'):
        self.base_url = base_url
        self.item_attributes = ["name", "rest", "cal", "fat", "carbs", "protein"]
        self.attr_mapping = {'cal': 2, 'fat': 5, 'carbs': 10, 'sodium': 9, 'protein': 13}
        self.restaurants = self.get_restaurants()
        self.found, self.notFound = 0, 0

    def get_restaurants(self):
        response = get_response(f"{BASE_URL}/fast-food-restaurants")
        soup = BeautifulSoup(response.text, "html.parser")
        restaurants_html = soup.findAll('div', class_="filter_target")
        restaurants = dict()
        for restaurant in restaurants_html:
            if isinstance(restaurant, Tag):
                link = restaurant.a
                rest_name = link.text.replace('Nutrition', '').strip()
                restaurants[rest_name] = link['href']
        return restaurants

    def process(self, item):
        if item['rest'] in self.restaurants:
            url = self.base_url + self.restaurants[item['rest']] + '/' + item['item_name'].replace(' ', '-')
            response = get_response(url)
            soup = BeautifulSoup(response.text, "html.parser")
            stubs = soup.findAll('a', class_="stub_box")
            if len(stubs) == 0:
                nutrition_table = soup.find('table', class_="item_nutrition")
                if nutrition_table is not None:
                    rows = nutrition_table.findAll('tr')
                    parsed = {
                        "item_name": item['item_name'],
                        "price": item["price"],
                        "ingredients": '',
                        "category": '',
                        "rest_id": '',
                        "rest": item['rest'],
                        "grubhub": '',
                        "address": item["address"]
                    }
                    for macro, i in self.attr_mapping.items():
                        cols = []
                        if i < len(rows):
                            cols = [x for x in rows[i].children if isinstance(x, Tag)]

                        if cols:
                            target = re.sub(r'\D', '', cols[1].text.strip())
                            if len(target) == 0:
                                if i-1 < len(rows):
                                    cols = [x for x in rows[i-1].children if isinstance(x, Tag)]
                                target = re.sub(r'\D', '', cols[1].text.strip())
                                if len(target) == 0:
                                    parsed[macro] = None
                                else:
                                    parsed[macro] = float(target)
                            else:
                                parsed[macro] = float(target)
                    parsed['rating'] = 4.2
                    parsed['match score'] = 92
                    yield parsed
