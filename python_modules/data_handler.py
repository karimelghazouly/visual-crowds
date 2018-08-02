import googlemaps as gmaps
import pandas as pd
import random

def get_adress_and_city(lat, lng):
    """Returns street address of the given location.
    :param lng: longitude of the user's location.
    :param lat: latitude of the user's location.
    :return: pair of strings (street_address, city_name).
    """
    api = gmaps.Client(key='AIzaSyBRTtk15JKrytkz540PDf7ibEwIzhdKPa4')

    address = api.reverse_geocode({'lat':lat, 'lng':lng})

    # Return street address and city name
    length = len(address)
    return address[0]['formatted_address'], address[length - 3]['formatted_address'] #address[0]['address_components'][2]['short_name']

def read_fill_person_geo():
    """Reads and returns csv file of user's geo information and adds city and street."""
    csv = pd.read_csv('csv_work/geo_data.csv')

    # Add street and city based on latitude and longitude
    for i in range(0,len(csv)):
        lat = csv['lat'][i]
        lng = csv['lng'][i]
        street, city = get_adress_and_city(lat, lng)

        csv.loc[i,'city'] = city
        csv.loc[i, 'street'] = street

    csv.set_index('id', inplace=True)
    csv.to_csv('csv_work/geo_data.csv')
    return csv

def manipulate_geo_data():
    """Shuffles data locations and returns rendered file."""
    csv = pd.read_csv('csv_work/geo_data.csv')

    for i in range(0, len(csv)):
        # Swap current row's location with random row
        rand_no = random.randint(0,len(csv)-1)
        csv.loc[i,'lat'], csv.loc[rand_no, 'lat'] = csv.loc[rand_no, 'lat'], csv.loc[i,'lat']
        csv.loc[i, 'lng'], csv.loc[rand_no, 'lng'] = csv.loc[rand_no, 'lng'], csv.loc[i, 'lng']

    csv.to_csv('csv_work/geo_data.csv')
    return csv

def get_location_by_name(name):
    """Returns location of a user given his name.
    :param name: String of the user's full name.
    :return: Pair of (latitude, longitude).
    """
    info_csv = pd.read_csv('csv_work/info.csv')
    geo_csv = pd.read_csv('csv_work/geo_data.csv')

    # Get user's id from info file
    id = info_csv.loc[info_csv['name'] == name]['id'].values[0]

    # Get lat and lng from geo_data file using user's id
    lat = geo_csv.loc[geo_csv['id'] == id]['lat'][id]
    lng = geo_csv.loc[geo_csv['id'] == id]['lng'][id]

    return lat, lng

def get_location_by_id(id):
    """Returns user's location given his id.
    :param id: Integer of the user's id
    :return: Pair of (latitude, longitude).
    """
    geo_csv = pd.read_csv('csv_work/geo_data.csv')

    # Get lat and lng from geo_data file using user's id
    lat = geo_csv.loc[geo_csv['id'] == id]['lat'][id]
    lng = geo_csv.loc[geo_csv['id'] == id]['lng'][id]

    return lat, lng
