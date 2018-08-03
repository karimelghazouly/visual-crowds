import googlemaps as gmaps
import pandas as pd
import os
import random
import mpu

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
    """Reads csv file of user's geo information and adds city and street."""
    csv = pd.read_csv('python_modules/csv_work/geo_data.csv')

    # Add street and city based on latitude and longitude
    for i in range(0,len(csv)):
        lat = csv['lat'][i]
        lng = csv['lng'][i]
        street, city = get_adress_and_city(lat, lng)

        csv.loc[i,'city'] = city
        csv.loc[i, 'street'] = street

    csv.set_index('id', inplace=True)
    csv.to_csv('python_modules/csv_work/geo_data.csv')
    return csv

def manipulate_geo_data():
    """Shuffles data locations."""
    csv = pd.read_csv('python_modules/csv_work/geo_data.csv')

    for i in range(0, len(csv)-1):
        csv.loc[i, 'lat'] += 0.00000005
        csv.loc[i, 'lng'] += 0.00000005

    csv.set_index('id', inplace=True)
    csv.to_csv('python_modules/csv_work/geo_data.csv')
    return csv

def get_location_by_name(name):
    """Returns location of a user given his name.
    :param name: String of the user's full name.
    :return: Pair of (latitude, longitude).
    """
    info_csv = pd.read_csv('python_modules/csv_work/Info.csv')
    # Get user's id from info file
    geo_csv = pd.read_csv('python_modules/csv_work/geo_data.csv')
    
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
    geo_csv = pd.read_csv('python_modules/csv_work/geo_data.csv')

    # Get lat and lng from geo_data file using user's id
    lat = geo_csv.loc[geo_csv['id'] == id]['lat'][id]
    lng = geo_csv.loc[geo_csv['id'] == id]['lng'][id]

    return lat, lng

def get_places(type, lat, lng):
    """Returns a list of places of given type, with how crowded they are.
    :param type: String of the place type.
    :param lat: Targeted city latitude.
    :param lng: Targeted city longitude.
    :return: List of dicts containing place name, lat, lng.
    """
    api = gmaps.Client(key='AIzaSyBRTtk15JKrytkz540PDf7ibEwIzhdKPa4')
    results = api.places_nearby(location=(lat, lng), radius=1000, type=type)

    # Create list with hospitals nearby
    places = []
    for result in results['results']:
        # Index 0:name, 1:lat, 2:lng, 3:people
        place = [
            result['name'],
            result['geometry']['location']['lat'],
            result['geometry']['location']['lng'],
            0
        ]
        places.append(place)

    return places

def add_places_capacity(type, lat, lng):
    """Count number of people in every place.
    :return: List of dicts containing place name, lat, lng, people.
    """
    csv = pd.read_csv('python_modules/csv_work/geo_data.csv')
    places = get_places(type, lat, lng)
    for place in places:
        for i, row in csv.iterrows():
            dist = mpu.haversine_distance((place[1],place[2]), (row['lat'],row['lng']))
            if dist < 0.1:
                place[3] += 1

    return places



