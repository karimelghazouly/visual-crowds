from faker import Faker
import csv
from Generator import lng_lat
#makka 3arf mozdlifa mena
land = [[21.422487,39.826206], [21.3549, 39.9841], [21.231979,39.56959],[21.4146,39.8946]]
fake = Faker('ar_SA')
x=0
for i in range(4):
    latitude,longitude = lng_lat(land[i][0],land[i][1])
    print(len(latitude))
    with open('geo_data.csv', 'a') as csvfile:
        fieldnames = ['id', 'lat', 'long', 'city', 'street']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        #writer.writeheader()

        for i in range(0,10):
            writer.writerow({'id': str(x), 'lat': str(latitude[i]), 'long': str(longitude[i])})
            x+=1

print("Writing complete")
