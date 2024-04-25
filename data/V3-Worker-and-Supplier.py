# note that the created data was inserted and manipulated in excel, the created csv doesn't exactly correspond to the data in 'Worker.sql' and 'Supplier_Group.sql'

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

# reads nike csv
file = "merged_adidas_nike.csv"
df = pd.read_csv(file, sep=",")
# removes duplicates of column Supplier Group, because I want to add more data to each Supplier
df["Supplier_Group"] = df["Supplier_Group"].drop_duplicates()
# defines every column except supplier group
drop_except_supplier_columns = ["Factory_Number","Parent_Organization_Name","Factory_Name","Factory_Type","Product_Type","Corporation_Brand","Address","City","Province","Code","Country","Region" ,"Total_Workers","Line_Workers","Female_Workers","Migrant_Workers","Male_Workers"]
# drops defined columns
df_dropped_supplier = df.drop(columns=drop_except_supplier_columns)

# Generate data for Supplier
def create_rows_supplier_faker(num=1):
    output = [{
        #problem: won't create unique ids -> ids were overwritten in excel
        "Supplier_ID": fake.random_int(min=1, max=295),
        "Supplier_Mail":fake.company_email()} for x in range(num)]
    return output

# Generate data for Female Workers with Faker
def create_rows_female_faker(num=1):
    output = [{
        "First_Name":fake.first_name_female(),
        "Last_Name":fake.last_name_female(),
        "Gender":"female",
        "Worker_Mail":fake.email()} for x in range(num)]
    return output

# Generate data for Male Workers with Faker
def create_rows_male_faker(num=1):
    output = [{
        "First_Name":fake.first_name_male(),
        "Last_Name":fake.last_name_male(),
        "Gender":"male",
        "Worker_Mail":fake.email()} for x in range(num)]
    return output

# create DataFrames with defined numbers of rows
df_faker_supplier = pd.DataFrame(create_rows_supplier_faker(len(df_dropped_supplier)))
df_faker_female = pd.DataFrame(create_rows_female_faker(22138))
df_faker_male = pd.DataFrame(create_rows_male_faker(6613))

# joins the gender tables to worker table
df_merged_genders = pd.concat([df_faker_female, df_faker_male], ignore_index=True)

# Function to generate random phone numbers
def generate_random_phone_number():
    phone_number = ''.join(random.choices(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], k=random.randint(6, 8)))
    return phone_number

# Generate id and phone numbers
df_workers_ID = pd.DataFrame({
    # problem: won't create unique ids -> ids were overwritten in excel
    "Worker_ID": fake.random_int(min=1, max=len(df_merged_genders)),
    "Worker_Number": [generate_random_phone_number() for _ in range(28751)],
    "Factory_Name": "CHANG SHIN VIETNAM COMPANY, LTD."
})

# Generate id for worker
def create_id_worker(num=1):
    output = [{
        "Worker_ID": fake.random_int(min=1, max=len(df_merged_genders))} for x in range(num)]
    return output

# Generate Dataframe for worker id
df_id_worker = pd.DataFrame(create_id_worker(len(df_merged_genders)))

# Generate Dataframe for worker number
df_number_worker = pd.DataFrame({
    "Worker_Number": [generate_random_phone_number() for _ in range(len(df_merged_genders))],
})

# joins the workers table with the rest of the attributes
df_merged_worker = pd.concat([df_id_worker, df_merged_genders, df_number_worker], axis=1)

# joins existing data of suppliers with fake data
df_merged_suppliers = pd.concat([df_faker_supplier, df_dropped_supplier], axis=1)

#drops NaN rows
df_merged_suppliers = df_merged_suppliers.dropna(axis=0, how='any')

# Saving Location
supplier_file = "./data/Supplier_Group.csv"
workers_file = "./data/Worker.csv"

# Saving to CSV files
df_merged_suppliers.to_csv(supplier_file, index=False)
df_merged_worker.to_csv(workers_file, index=False)

supplier_file, workers_file
