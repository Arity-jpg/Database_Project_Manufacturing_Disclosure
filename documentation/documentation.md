<link rel="stylesheet" type="text/css" media="all" href="./style.css" />

# Author of this project
Alice Zimpfer, Matrikelnr.: 327090

# Introduction
Sport product manufacturers 🏭 disclose details about their factories as a part of their marketing strategy for transparency. With the implementation of this database system, you can effortlessly access and compare information of renowned sport product brands as Nike, Adidas, VF Corporation and Puma. 🏀⚽👟
This database system is designed to investigate and understand factory details across those brands, making their manufacturing more transparent. 📊🌐 The data model intentionally abstracts away characteristics and relationships that are not crucial for problem solving. Ensuring an efficient representation of the real world of sport product manufacturing within the database design. 📊💻

# Model & Relational Schema
The relational schema of the Sport Product Manufacturing database
-
1.

Address_Mondial: information about the address of a factory connecting to Mondial by city, province and country

Address_M_ID: the ID of the address

Address: the address of the factory

Region: the region of the factory

Code: the country code of the factory

City: the city of the factory

Province: the province of the factory

2. 

Address_Extended: information about the address of a factory connecting to Mondial only by country

Address_E_ID: the ID of the address

Address: the address of the factory

Region: the region of the factory

Code: the country code of the factory

City: the city of the factory

Province: the province of the factory

Note that some data may be null or contains data that was not in Mondial.

3. 

Brand: information about the sport product brands

Brand_ID: the brand ID

Brand_Name: the brand name

Revenue_2022: the revenue made in 2022

Founding_Year: the founding year

Code: the country code

4. 

Supplier_Group: information about the supplier group of the factory

Supplier_ID: the ID of the supplier group

Supplier_Group: the name of the supplier group

Supplier_URL: the URL of the supplier group

Supplier_Number: the phonenumber of the supplier group

Supplier_Mail: the mail of the supplier group

Note that only the brands Nike and VF Corporation have this table. The URL, number and Mail was created with Faker.

5. 

Parent_Organization: information about the parent organization of the factory

Parent_Organization_ID: the ID of the parent organization

Parent_Organization: the name of the parent organization

Organization_URL: the URL of the parent organization

Organization_Number: the phonenumber of the parent organization

Organization_Mail: the mail of the parent organization

Note that only the brands Adidas and Puma have this table. The URL, number and Mail was created with Faker.

6.

Product_Type: information about the sport product type

Product_Type_ID: the ID of the product type

Product_Type: the type of product

7.

Worker_Amount_Int: information about the worker amount of a factory in exact numbers

Worker_Amount_Int_ID: the ID of Amount in numbers

Total_Worker_int: the total number of worker

Female_Worker_int: the female number of worker

Male_Worker_int: the male number of worker

Migrant_Worker_int: the migrant number of worker

Line_Worker_int: the line worker number of worker

Note that only the brands Nike and Adidas have this table.

8.

Worker_Amount_Percentage: information about the worker amount of a factory in percentages

Worker_Amount_Percentage_ID: the ID of Amount Percentage

Female_Worker_Percentage: the female worker amount (in percentage)

Migrant_Worker_Percentage: the migrant worker amount (in percentage)

Note that only the brands VF Corporation and Puma have this table.

9.

Worker_Amount_Range: information about the worker amount of a factory in number ranges

Worker_Amount_Range_ID: the ID of Amount Range

Worker_Amount_Lower_Bound: the lower range bound of worker amount

Worker_Amount_Upper_Bound: the upper range bound of worker amount

Note that only the brands VF Corporation and Puma have this table.

10.

Worker: information about the worker

Worker_ID: the ID of Worker

First_Name: the first name of a worker

Last_Name: the last name of a worker

Gender: the gender (m or f)

Worker_Mail: the mail of a worker

Worker_Number: the phonenumber of a worker

Migrant: the migrant status (true or false)

Line_Worker: the line worker status (true or false)

Factory_ID: the ID of the factory, the worker works at

Note that this has only information for one factory (Factory_ID: 55) and was fully created with Faker.

11.

Factory: information about the factory producing sport products

Factory_ID: the ID of the factory

Factory_Name: the name of the factory

Brand_ID: the ID of the brand

Product_Type_ID: the ID of the product type

Parent_Organization_ID: the ID of the parent organization

Supplier_ID: the ID of the supplier group

Worker_Amount_Int_ID: the ID of the worker amount in numbers

Worker_Amount_Percentage_ID: the ID of the worker amount in percentages

Worker_Amount_Range_ID: the ID of the worker amount in number ranges

Address_M_ID: the ID of the address with city, province and country connection to Mondial

Address_E_ID: the ID of the address with only country connection to Mondial

Mondial Database Update: Changes and Improvements
-
1. I began by creating entities based on the manufacturing disclosure table columns of Nike and Adidas. This involved adding some column titles as attributes for each entity and establishing connections between them.

2. Next, I added invented attributes for entities with fewer details like 'Supplier_Group' and 'Parent_Organization'. I also introduced an invented entity 'Worker' with its own invented data for one factory.

3. After this I created my first .sql Model Schema with Innovator, but I had to do some adjustments to the output.

4. To include manufacturing data from VF Corporation and Puma and make my model better, I had to make some changes. Specifically, I divided the initial 'Worker_Amount' into three new entities: 'Worker_Amount_Int', 'Worker_Amount_Percentage' and 'Worker_Amount_Range', so it could work well with the different kinds of data. Unfortunately while working on this part our Innovator license expired, but this didn't stop me from working on my project.

5. As I began to insert my data, I realized I needed to split the initial 'Address' entity into two parts, because I had no access to insert new data into the existing Mondial database. I encountered: "ERROR: in Tabelle »city«, auf die verwiesen wird, gibt es keinen Unique-Constraint, der auf die angegebenen Schlüssel passt"
So I created an entity called 'Address_Mondial' with attributes like code, city, province, which were already in Mondial and had not NULL values for the composite key of city. Then I also made another entity called 'Address_Extended' that could only connect directly to Mondial by the code, because some data for country, province or city was NULL (not given by the brand) or did not exist in Mondial. I filtert the Addresses with logical statements in Excel to see where all three attributes for the composite key of city were given and matched with the Mondial data. I also had to adjust my Schema Creation, which was a bit more challenging, because the Innovator license was still expired at this time.

# Technical Work
Creating Data
-
I decided to add made-up information to my existing real-world data. I specifically chose Factory ID 55 of Nike and aimed to expand my model with a total of 28751 worker profiles. While there were online tools like https://cobbl.io/ that could generate data quickly, I decided to build my own tables in Python to enhance my technical skills.
To kickstart the process, I used code from the "Demo: Bulk Data Import in PostgreSQL" by thomas-schuster on GitHub and adjusted it to suit my needs. I crafted a table for each worker in Factory_ID 55, utilizing the Faker package to generate realistic attributes such as ID, first name, last name, gender, migrant status, line worker status, email, phonenumber and factory ID. The Pandas library came in handy for CSV manipulation.

Preparing Data
-
I organized my data based on the manufacturing disclosure table columns, merging information from four different sources/brands using Excel. Some basic adjustments were needed, like dealing with product type abbreviations such as ACC for Accessories, APP for Apparel, ... and so one in the Puma table. Excel functions like SVERWEIS() - which I learned in the office test - were useful for mapping IDs to each entity. Empty cells where replaced with "NULL" for data insertion.

For Nike I converted the worker data from the original file from percentage into numeric, so Nike and Adidas have numeric values, meanwhile VF Corporation and Puma have percentage values. I accomplished the number conversion of Nike in Excel by calculating the total worker amount with the percentage amount in decimal for line, migrant and female worker - male worker was computed. Because of the rounding in Excel the results for female and male were incremented by one, causing the total worker amount to have one worker too much. I solved this by comparing the summed up rounded results of female and male to the total worker amount with logical statements and fixed the rounded numbers by decrementing the male row by one - ensuring the correctness of the data.

Another adjustment was to extend the initial worker range column (example: 100-1000) from the original Puma and VF Corporation files into two columns: upper bound (1000) and lower bound (100) range. This was a necessary step to be able to query later.

Inserting Data
-
To create my SQL statements, I used https://tableconvert.com/, a tool introduced in our lecture. During the data insertion process, I encountered an error: "VALUES-Listen müssen alle die gleiche Länge haben" (VALUES lists must all have the same length). Initially puzzled, I discovered that apostrophes in some names were causing unexpected issues. I resolved this by removing apostrophes from all data tables. Another issue related to spacing formats in Excel, particularly in factory names, was identified and resolved by inserting the data in "packages" of 10 - 100 rows until i found the line, which caused the problem.
Despite some challenges, including one mentioned in "Mondial Database Update: Changes and Improvements" point 5, I eventually succeeded in inserting my data.

Query Documentation
-
See "queries/Documentation_Queries_Sport_Product_Manufacturing.pdf" for further details.

# Conclusion & Outlook
Working on this project independently presented challenges, with a significant amount of time dedicated to data adjustments in Excel. Learning and implementing Faker and Pandas for data creation also consumed some time. While encountering manageable errors during data insertion, adjusting the model and Excel tables for the split address entity was somewhat tiring. The address entity, requiring logical statements for attribute checks, was a bit challenging. Nevertheless, the querying and writing routines part was in my opinion the most enjoyable. This gave me a sense of accomplishment and satisfaction after dealing with the data part for quite some time. 📊💻

In summary, I'm satisfied with my Sport Product Manufacturing database 🏭📊 and the problem-solving skills I developed on the way. Looking ahead, I would add more data from different sport brands, acknowledging potential model changes. It would be interesting to learn more about the supply chain by finding out which countries provide the materials and getting real data about the suppliers. However, it's important to note that adding more details depends on whether brands share that information. Despite this, the current database offers a detailed view on sport product manufacturing, focusing on the factories. Meanwhile the connection to the Mondial Database gave additional insights into the manufacturing, which wouldn't have been possible without Mondial. 📊🌐

Data Sources
-
Nike: https://manufacturingmap.nikeinc.com/

Adidas: https://www.adidas-group.com/en/sustainability/transparency/supplier-lists/

VF Corporation: https://www.vfc.com/responsibility/governance/factory-list

Puma: https://about.puma.com/en/sustainability/social

Sources to create data with Faker and Pandas in Python
-
https://gist.github.com/thomas-schuster/2ce01acff919c206a1c500c34b2d4587

https://faker.readthedocs.io/en/master/

https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.drop_duplicates.html

https://stackoverflow.com/questions/45574191/using-python-faker-generate-different-data-for-5000-rows

https://stackoverflow.com/questions/26063231/read-specific-columns-with-pandas-or-other-python-module

Sources for Routines
-
https://lms.hs-pforzheim.de/pluginfile.php/400413/mod_resource/content/0/4_4_relational_databases-procedures_triggers.pdf

https://www.postgresql.org/docs/current/sql-update.html

https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/

https://www.postgresql.org/docs/current/functions-matching.html

Sources for Emojis
-
All emojis designed by OpenMoji – the open-source emoji and icon project. License: CC BY-SA 4.0
