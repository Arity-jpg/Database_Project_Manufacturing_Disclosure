# note that the created data was inserted and manipulated in excel, the created csv doesn't exactly correspond to the data in 'Supplier_Group.sql' and 'Parent_Organization.sql'
from faker import Faker
import pandas as pd
import random
import os
fake = Faker()

#python code

# Path to data storage
directory = 'data'

# Check if path exists
if not os.path.exists(directory):
    os.makedirs(directory)

# Generate data for Supplier and Organization
def create_rows_supplier_faker(num=1):
    output = [{
        #problem: won't create unique ids -> ids were overwritten in excel
        "Fake_ID": fake.random_int(min=1, max=2817),
        "Fake_URL": fake.url(),
        "Fake_Number": fake.basic_phone_number(),
        "Fake_Mail":fake.ascii_company_email()} for x in range(num)]
    return output

# create DataFrames with defined numbers of rows
df_faker_supplier = pd.DataFrame(create_rows_supplier_faker(2817))

# Saving Location
supplier_file = "./data/Supplier_and_Organization.csv"

# Saving to CSV files
df_faker_supplier.to_csv(supplier_file, index=False)

supplier_file
