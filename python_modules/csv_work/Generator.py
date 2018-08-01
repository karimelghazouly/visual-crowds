import numpy as np
import json
import geog
import shapely.geometry
#El haram Cordanates
#lng , lat


def lng_lat(lat,lngg):
    '''
    Return points around a cretian area on a map
    :return: Two lists of lng and lat
    '''
    global lng
    global latt
    lng = list()
    latt= list()

    p = shapely.geometry.Point([lat,lngg])
    n_points = 10
    d = 10 * 10  # meters
    angles = np.linspace(0, 360, n_points)
    polygon = geog.propagate(p, angles, d)
    all_points=json.dumps(shapely.geometry.mapping(shapely.geometry.Polygon(polygon)))
    print(all_points)
    x = json.loads(all_points)
    for i in range(n_points):
        # lng
        print(x['coordinates'][0][i][1])
        # lat
        print(x['coordinates'][0][i][0])
        lng.append(x['coordinates'][0][i][1])
        latt.append(x['coordinates'][0][i][0])

    return latt, lng
