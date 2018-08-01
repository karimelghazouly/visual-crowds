import googlemaps as gmaps

def get_adress(lat, lng):
    """Returns street address of the given location.
    :param lng: longitude of the user's location.
    :param lat: latitude of the user's location.
    """
    api = gmaps.Client(key='AIzaSyBRTtk15JKrytkz540PDf7ibEwIzhdKPa4')

    address = api.reverse_geocode({'lat':lat, 'lng':lng})
    return address[0]['formatted_address']

