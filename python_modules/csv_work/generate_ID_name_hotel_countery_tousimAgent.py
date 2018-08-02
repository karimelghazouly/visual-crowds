from faker import Faker
import csv
import random
fake = Faker()
with open('Info.csv', 'w') as csvfile:
    fieldnames = ['id', 'name', 'hotel','country','tourismAgent']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    hotels = ["agyad", "abrag makka" , "Mariden" , "el haramen ","Hilton Makkah","Dar Al Ghufran"]
    Agents =["FreeHajj", "TravelCairoAgent","TravelUSAAgent","Travel Local Hajj"]
    for i in range(0,4000):
        writer.writerow({'id': str(i), 'name': fake.name(), 'hotel': str(hotels[random.randrange(0,5)]),'country': fake.country(),'tourismAgent':str(Agents[random.randrange(0,3)]),})

print("Writing complete")
