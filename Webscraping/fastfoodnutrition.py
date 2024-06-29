import requests
from bs4 import BeautifulSoup, Tag
import pandas as pd
import re
import threading
from queue import Queue
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import os

from utils.webscrapeConstants import HEADERS

session = requests.Session()
retry = Retry(connect=3, backoff_factor=0.5)
adapter = HTTPAdapter(max_retries=retry)
session.mount('http://', adapter)
session.mount('https://', adapter)

ITEM_ATTRIBUTES = ["name", "rest", "cal", "fat", "carbs", "protein"]
ATTR_MAPPING = {'cal': 2, 'fat': 5, 'carbs': 9, 'protein': 12}
BASE_URL = 'https://fastfoodnutrition.org'
ITEM_IMAGE_STYLE = 'max-width:100%;max-height:275px;'


def get_response(url):
    for _ in range(3):
        try:
            return session.get(url, headers=HEADERS, timeout=10)
        except (requests.exceptions.Timeout, requests.exceptions.ConnectionError):
            time.sleep(2)
    raise RuntimeError(f"Failed to fetch {url} after 3 retries")

def save_image(restaurant_name, item_name, image_tag, root_dir='FastFoodImages_mvp0'):
    img_url = f"{BASE_URL}{image_tag['src']}"
    img_data = get_response(img_url).content
    save_path = f"{root_dir}/{restaurant_name}/"
    clean_item_name = re.sub(r"[\\/:*?\"<>|]", "", item_name)
    if not os.path.exists(save_path):
        os.makedirs(save_path)
    with open(f'{save_path}{clean_item_name}.jpg', 'wb') as handler:
        handler.write(img_data)

def get_restaurants():
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

def get_nutrition_for_item(name: str, rest_name: str, url: str) -> pd.DataFrame:
    response = get_response(url)
    soup = BeautifulSoup(response.text, "html.parser")
    stubs = soup.findAll('a', class_="stub_box")
    if len(stubs) == 0:
        nutrition_table = soup.find('table', class_="item_nutrition")
        if nutrition_table is not None:
            rows = nutrition_table.findAll('tr')
            parsed = {"name": name, "rest": rest_name}
            for macro, i in ATTR_MAPPING.items():
                cols = [x for x in rows[i].children if isinstance(x, Tag)]
                target = re.sub(r'\D', '', cols[1].text.strip())
                if len(target) == 0:
                    parsed[macro] = None
                else:
                    parsed[macro] = float(target)
            return pd.DataFrame([parsed], columns=ITEM_ATTRIBUTES, index=[f'{rest_name}-{name}'])
        return pd.DataFrame([], columns=ITEM_ATTRIBUTES)
    else:
        merged_df = pd.DataFrame([], columns=ITEM_ATTRIBUTES)
        for i, stub in enumerate(stubs):
            title = stub["title"].replace("Nutrition Facts", "").strip()
            df = get_nutrition_for_item(title, rest_name, f'{BASE_URL}{stub["href"]}')
            merged_df = pd.concat([merged_df, df])
        return merged_df

def get_items_from_restaurant(url, rest_name, queue):
    response = get_response(url)
    soup = BeautifulSoup(response.text, "html.parser")
    items_html = soup.findAll('li', class_="filter_target")
    result = pd.DataFrame([], columns=ITEM_ATTRIBUTES)
    for item in items_html:
        if isinstance(item, Tag):
            link = item.div.a
            item_name = link.text.strip()
            try:
                result = pd.concat(
                    [result, get_nutrition_for_item(item_name, rest_name, f"{BASE_URL}{link['href']}")]
                )
            except TypeError:
                return
    queue.put(result)

def run_scraper():
    rests = get_restaurants()
    all_menu_df = pd.read_csv('allmenu.csv', names=['item_name', 'price', 'rest', 'address', 'rest_id'])
    unique_restaurants = set(all_menu_df['rest'].unique())
    supported_rests = {rest_name: link for rest_name, link in rests.items() if rest_name in unique_restaurants}
    parsed_items = pd.DataFrame([], columns=ITEM_ATTRIBUTES)
    threads = list()
    result_queue = Queue()
    for rest_name, url in supported_rests.items():
        worker_thread = threading.Thread(target=get_items_from_restaurant, args=(
            f"{BASE_URL}{url}", rest_name, result_queue
        ))
        threads.append(worker_thread)
    for i, thread in enumerate(threads):
        thread.start()
    for i, thread in enumerate(threads):
        thread.join()
        result = result_queue.get()
        if result is not None:
            parsed_items = pd.concat([parsed_items, result], )
    parsed_items.to_csv('fastfoodnutrition.csv', index=False)
    return parsed_items

if __name__ == "__main__":
    run_scraper()
