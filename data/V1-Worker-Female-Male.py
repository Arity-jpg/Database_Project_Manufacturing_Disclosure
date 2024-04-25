# note that this code was an earlier version of my final program and the features here can be found in 'V3-Worker-and-Supplier'

from faker import Faker
import pandas as pd
import random
import os
fake = Faker()

#python code to create worker data

# Path to data storage
directory = 'data'

# Check if path exists
if not os.path.exists(directory):
    os.makedirs(directory)

# Function to generate random phone numbers
def generate_random_phone_number():
    phone_number = ''.join(random.choices(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], k=random.randint(6, 8)))
    return phone_number

# Generate data for Female Workers with Faker
def create_rows_female_faker(num=1):
    output = [{"first_name_female":fake.first_name_female(),
                   "last_name_female":fake.last_name_female(),
                   "gender":"female",
                   "email":fake.email()} for x in range(num)]
    return output

# Generate data for Male Workers with Faker
def create_rows_male_faker(num=1):
    output = [{"first_name_male":fake.first_name_male(),
                   "last_name_male":fake.last_name_male(),
                   "gender":"male",
                   "email":fake.email()} for x in range(num)]
    return output

df_faker_female = pd.DataFrame(create_rows_female_faker(5000))
df_faker_male = pd.DataFrame(create_rows_male_faker(2500))

# Generate id and phone numbers for females
female_workers = pd.DataFrame({
    "worker_id": range(1, 5001),
    "phone_number": [generate_random_phone_number() for _ in range(5000)],
})

# Generate id and phone numbers for males
male_workers = pd.DataFrame({
    "worker_id": range(5002, 7502),
    "phone_number": [generate_random_phone_number() for _ in range(2500)],
})

# join DataFrames for each genders
df_merged_male = pd.concat([male_workers, df_faker_male], axis=1)
df_merged_female = pd.concat([female_workers, df_faker_female], axis=1)

# Saving to CSV files
female_workers_file = "./data/workerFemales.csv"
male_workers_file = "./data/workerMales.csv"

df_merged_female.to_csv(female_workers_file, index=False)
df_merged_male.to_csv(male_workers_file, index=False)

female_workers_file, male_workers_file
