import pandas as pd
import csv


def compare_place_to_people_in(data):
    Geo = data
    city = Geo.iloc[:,3]
    print(city)

    comper = pd.read_csv('table.csv')
    place = comper.iloc[:,0].values
    capicty_max = comper.iloc[:,1].values

    x = []
    for i in range(4):
        k = 0
        for j in range(len(city)):
            if place[i] == city[j]:
                k+=1
        x.append(k)

    #Comperting
    print(place)
    print(x)
    print(capicty_max)
    for f in range(len(x)):
        if x[f]>capicty_max[f]:
            if f==0:
                print("overflow in Makka")
            if f==1:
                print("overflow in Arafa")
            if f==2:
                print("overflow in mena")
            if f==3:
                print("overflow in muzdalifah")

