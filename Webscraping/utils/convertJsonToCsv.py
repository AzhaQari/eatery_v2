import csv
import json


def getJsonData(json_filename: str) -> [dict]:
    with open(f"{json_filename}.json", 'r') as f:
        return json.load(f)


def writeToCSV(csv_filename: str, data: [dict], fieldnames) -> None:
    with open(f"{csv_filename}.csv", mode='a', newline='') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        if csv_file.tell() == 0:
            writer.writeheader()
        for d in data:
            writer.writerow(d)


BRANDS_FEATURELIST = ['name', 'menu_url']
CATEGORY_FEATURELIST = ['category', 'category_url', 'rest']
MENU_ITEM_FEATURELIST = ['calories', 'fat', 'carbs', 'protein', 'name', 'rest', 'category']

filename = 'menuItemListFatSecret'
loaded_data = getJsonData(filename)
writeToCSV(filename, loaded_data, MENU_ITEM_FEATURELIST)