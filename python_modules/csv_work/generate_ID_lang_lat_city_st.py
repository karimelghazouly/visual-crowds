from faker import Faker
import pandas as pd
import csv
from Generator import lng_lat
#makka
land = [[21.422487,39.826206]]
fake = Faker('ar_SA')
latitude,longitude = lng_lat(land[0][0],land[0][1])
with open('Test.csv', 'w') as csvfile:
    fieldnames = ['id', 'lat', 'long','city','st']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for i in range(1,10):
        writer.writerow({'id': str(i), 'lat': str(latitude[i]), 'long': str(longitude[i])})

print("Writing complete")
