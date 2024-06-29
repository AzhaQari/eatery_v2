from utils.webscrapeConstants import removeNonChar
import apache_beam as beam
import requests
from bs4 import BeautifulSoup, NavigableString, Tag
import hashlib
import time

class ExtractRestaurantsFromLocationFn(beam.DoFn):
    def __init__(self, state, base_url='https://www.allmenus.com'):
        self.base_url = base_url
        self.state = state

    def process(self, location):
        response = self.make_request(f'{self.base_url}/{self.state}/{location}/-/')
        soup = BeautifulSoup(response.text, "html.parser")
        lists = soup.find_all('ul', {'class': 'restaurant-list'})
        for restaurant_list in lists:
            for restaurant in restaurant_list.children:
                if isinstance(restaurant, NavigableString):
                    continue
                if isinstance(restaurant, Tag):
                    restaurant_info = dict()
                    desc = restaurant.div.find('h4', class_='name')
                    cuisine = restaurant.div.find('p', class_='cuisine-list')
                    addresses = restaurant.div.find_all('p', class_='address')

                    restaurant_info['name'] = desc.text
                    restaurant_info['menu_url'] = self.base_url + desc.a["href"]
                    restaurant_info['address'] = " ".join([loc.text for loc in addresses])

                    if cuisine is not None:
                        restaurant_info['cuisine'] = cuisine.text

                    restaurant_info['rest_id'] = self.hash_restaurant(restaurant_info['name'], restaurant_info['address'])
                    yield restaurant_info

    def hash_restaurant(self, restaurant_name: str, restaurant_address: str):
        return hashlib.md5((restaurant_name + restaurant_address).encode()).hexdigest()[:16]

    def make_request(self, url, retries=3):
        for _ in range(retries):
            try:
                return requests.get(url, timeout=10)
            except (requests.exceptions.Timeout, requests.exceptions.ConnectionError) as e:
                time.sleep(2)
        raise RuntimeError(f"Failed to fetch {url} after {retries} retries")

class ExtractMenuItemFromRestaurantFn(beam.DoFn):
    def process(self, restaurant_info):
        response = self.make_request(restaurant_info['menu_url'])
        soup = BeautifulSoup(response.text, "html.parser")
        container = soup.find('div', class_='menu-container')
        if container:
            for menu_category in container.children:
                if isinstance(menu_category, Tag):
                    category_info = menu_category.li
                    category_name = category_info.find('div', class_='category-name').text
                    item_lists = category_info.find_all('ul', class_='menu-items-list')
                    for items in item_lists:
                        for item in items.children:
                            if isinstance(item, Tag):
                                parsed_item = {
                                    'item_name': removeNonChar(item.div.find('span', class_='item-title').text.strip()),
                                    'price': removeNonChar(item.div.find('span', class_='item-price').text.strip()),
                                    'description': removeNonChar(item.find('p', class_='description').text.strip())
                                }
                                parsed_item['price'] = str(parsed_item['price'].replace('$', '').replace('+', ''))
                                parsed_item['ingredients'] = removeNonChar(item.p.text)
                                parsed_item['category'] = removeNonChar(category_name)
                                parsed_item['rest_id'] = restaurant_info['rest_id'].replace(',', '')
                                parsed_item['rest'] = restaurant_info['name'].replace(',', '')
                                parsed_item['address'] = restaurant_info['address'].replace(',', '')
                                yield parsed_item

    def make_request(self, url, retries=3):
        for _ in range(retries):
            try:
                return requests.get(url, timeout=10)
            except (requests.exceptions.Timeout, requests.exceptions.ConnectionError) as e:
                time.sleep(2)
        raise RuntimeError(f"Failed to fetch {url} after {retries} retries")
