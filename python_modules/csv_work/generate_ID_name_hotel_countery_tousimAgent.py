from faker import Faker
import csv
fake = Faker()
with open('Info.csv', 'w') as csvfile:
    fieldnames = ['id', 'name', 'hotel','country','tourismAgent']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for i in range(1,10):
        writer.writerow({'id': str(i), 'name': fake.name(), 'hotel': fake.name(),'country': fake.country(),'tourismAgent':"nan",})

print("Writing complete")
