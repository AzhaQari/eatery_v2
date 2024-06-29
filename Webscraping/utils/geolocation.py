import requests
import pandas as pd
import numpy as np
import pygeohash as pgh

GEOCODE_API_KEY = 'AIzaSyBc0PI7GYhP65sX9n4KSvag2eGvaeh1bw8'
URL = "https://maps.googleapis.com/maps/api/geocode/json"
PARAMS = {'key': GEOCODE_API_KEY}


def callGeocode(addr: str) -> (int, int):
    """
    :param addr: Street address to get latitude and longitude for
    :return: Tuple of (latitude, longitude) for the given street address
    """
    PARAMS['address'] = addr
    r = requests.get(url=URL, params=PARAMS)
    raw_data = r.json()
    lat = raw_data['results'][0]['geometry']['location']['lat']
    lon = raw_data['results'][0]['geometry']['location']['lng']
    return lat, lon


def getUniqueAddresses(df: pd.DataFrame) -> list:
    """
    :param df: Pandas dataframe of CSV menu item data. Assumes dataframe contains 'address' column
    :return: List of unique street addresses
    """
    return df['address'].unique()


def getCoordinates(address_list: list) -> np.ndarray:
    """
    :param address_list: List of unique addresses from stored CSV
    :return: Numpy array with latitude and longitude for each address
    """
    return np.vectorize(callGeocode)(address_list)


def saveDataframeToCsv(dataframe: pd.DataFrame, filename: str) -> None:
    """
    :param dataframe: Pandas dataframe to write to CSV
    :param filename: Name of CSV file
    """
    dataframe.to_csv(f'../Data/{filename}.csv')


def loadDataframeFromCsv(filename: str) -> pd.DataFrame:
    """
    :param filename: Name of CSV file to load into a dataframe
    :return: Dataframe containing CSV file data
    """
    return pd.read_csv(f'../Data/{filename}.csv')


if __name__ == "__main__":
    allmenu_df = loadDataframeFromCsv('allmenu')
    unique_address_list = getUniqueAddresses(allmenu_df)
    print('Starting geocode API calling...')
    coordinates = getCoordinates(unique_address_list)
    print('Finished geocode API calling')
    addr_coord_df = pd.DataFrame(
        {
            'address': unique_address_list,
            'latitude': coordinates[0],
            'longitude': coordinates[1]
        }
    )
    merged_df = pd.merge(allmenu_df, addr_coord_df, on='address', how='left')
    merged_df['geohash'] = merged_df.apply(lambda row: pgh.encode(row['latitude'], row['longitude'], precision=9),
                                           axis=1)
    saveDataframeToCsv(merged_df, 'allmenu')