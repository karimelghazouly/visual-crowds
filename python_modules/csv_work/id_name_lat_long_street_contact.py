import csv
import pandas as pd
Geo = pd.read_csv('geo_data.csv')
Info = pd.read_csv('Info.csv')
name = Info.iloc[:,1].values
ID = Geo.iloc[:,0].values
lat = Geo.iloc[:,1].values
long = Geo.iloc[:,2].values
street = Geo.iloc[:,4].values
with open('Collector.csv', 'a') as csvfile:
    fieldnames = ['id', 'name', 'lat','long','street']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for i in range(1,40):
        writer.writerow({'id': str(i), 'name': str(name[i]), 'lat': str(lat[i]),'long': str(long[i]) ,'street':str(street[i]),})
