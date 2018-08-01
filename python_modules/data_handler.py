import googlemaps as gmaps
import pandas as pd

def get_adress_and_city(lat, lng):
    """Returns street address of the given location.
    :param lng: longitude of the user's location.
    :param lat: latitude of the user's location.
    :return: pair of strings (street_address, city_name).
    """
    api = gmaps.Client(key='AIzaSyBRTtk15JKrytkz540PDf7ibEwIzhdKPa4')

    address = api.reverse_geocode({'lat':lat, 'lng':lng})

    # Return street address and city name
    return address[0]['formatted_address'], address[0]['address_components'][2]['short_name']

def read_fill_person_geo():
    """Reads csv file of user's geo information and adds city and street."""
    csv = pd.read_csv('csv_work/geo_data.csv')

    # Add street and city based on latitude and longitude
    for i in range(0,len(csv)):
        lat = csv['lat'][i]
        lng = csv['lng'][i]
        street, city = get_adress_and_city(lat, lng)

        csv.loc[i,'city'] = city
        csv.loc[i, 'street'] = street
    csv.to_csv('csv_work/geo_data.csv')
    return csv

read_fill_person_geo()


