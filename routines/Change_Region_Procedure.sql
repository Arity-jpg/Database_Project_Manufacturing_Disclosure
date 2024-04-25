-- Region is limited to Nike, so there are many NULL values in the database!
-- that is why i created this procedure to compare existing data of code, city, province to get an idea, what will be the region
-- the code is modular and reusable!

-- STEP 1
-- updates the Region of Address_Mondial
-- it takes an input which is the ID of Address_Mondial and takes another input for the new region, which will be the output for the Region of the Address ID
create or replace procedure Update_Region_Address_Mondial(Address_M_ID_Input int, new_region_Output varchar(20))
as $$
begin
-- update from this table
update Address_Mondial
-- set the old region to the input for region
set Region = new_region_Output
-- where the address id is the same as the input for the address id
where Address_M_ID = Address_M_ID_Input;
end
$$
language plpgsql;

-- STEP 2
-- search for address id and region you want to change
-- initially the region for the Address_Mondial ID 23 is NULL
Select *
From Address_Mondial am;

-- STEP 3
-- we call our procedure for Address_Mondial ID and set a new region
call Update_Region_Address_Mondial(23, 'N ASIA');

-- now we can see our update in the database
Select am.Address_M_ID, am.region
From Address_Mondial am
Where Address_M_ID = '23';

-- REDO CHANGES
-- set the region of the Address_Mondial ID 23 to it's initial value
call Update_Region_Address_Mondial(23, NULL);



--- the following is the same, but for Address_Extended:



-- STEP 1
-- updates the Region of Address_Extended
-- it takes an input which is the ID of Address_Extended and takes another input for the new region, which will be the output for the Region of the Address ID
create or replace procedure Update_Region_Address_Extended(Address_E_ID_Input int, new_region_Output varchar(20))
as $$
begin
-- update from this table
update Address_Extended
-- set the old region to the input for region
set Region = new_region_Output
-- where the address id is the same as the input for the address id
where Address_E_ID = Address_E_ID_Input;
end
$$
language plpgsql;

-- STEP 2
-- search for address id and region you want to change
Select *
From Address_Extended ae;

-- STEP 3
-- we call our procedure for the Address_Extended ID and set a new region
call Update_Region_Address_Extended(250, 'AMERICANAS');

-- now we can see our update in the database
Select ae.Address_E_ID, ae.region
From Address_Extended ae
Where Address_E_ID = '250';

-- REDO CHANGES
-- set the region of the Address_Extended ID 250 to it's initial value
call Update_Region_Address_Extended(250, 'EMEA');

-- Sources
-- https://lms.hs-pforzheim.de/pluginfile.php/400413/mod_resource/content/0/4_4_relational_databases-procedures_triggers.pdf
-- https://www.postgresql.org/docs/current/sql-update.html
-- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/