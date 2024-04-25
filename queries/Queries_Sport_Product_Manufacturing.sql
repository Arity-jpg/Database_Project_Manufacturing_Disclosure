------------------
-- documentation start
------------------

-- 1.1) Using Address_Mondial: Count the Factories per Country.
SELECT am.Code AS Country_Code, COUNT(f.Factory_ID) AS Factory_Count_AM
FROM Factory f
JOIN Address_Mondial am ON f.Address_M_ID = am.Address_M_ID
GROUP BY am.Code
ORDER BY Factory_Count_AM DESC;

-- 1.2) Using Address_Extended: Count the Factories per Country.
SELECT ae.Code AS Country_Code, COUNT(f.Factory_ID) AS Factory_Count_AE
FROM Factory f
JOIN Address_Extended ae ON f.Address_E_ID = ae.Address_E_ID
GROUP BY ae.Code
ORDER BY Factory_Count_AE DESC;

------------------

-- 1.3) Factory count per country for Address_Mondial and Address_Extended combined.
CREATE OR REPLACE VIEW Factory_Count_Country AS
SELECT Country_Code, SUM(Factory_Count) AS Factory_Count_All
FROM (-- Address_Mondial
    SELECT am.Code AS Country_Code, COUNT(f.Factory_ID) AS Factory_Count
    FROM Factory f
    JOIN Address_Mondial am ON f.Address_M_ID = am.Address_M_ID
    GROUP BY am.Code
    UNION ALL -- won't remove duplicates
    -- Address_Extended
    SELECT ae.Code AS Country_Code, COUNT(f.Factory_ID) AS Factory_Count
    FROM Factory f
    JOIN Address_Extended ae ON f.Address_E_ID = ae.Address_E_ID
    GROUP BY ae.Code
) AS All_Addresses
GROUP BY Country_Code
ORDER BY Factory_Count_All DESC;

SELECT *
FROM Factory_Count_Country;

------------------

-- 2.1) All information for all EU member countries, with their country, organization and type.
CREATE OR REPLACE VIEW EU_Members AS
SELECT *
FROM ismember
WHERE organization = 'EU' AND type = 'member';

SELECT *
FROM EU_Members;

-- 2.2) The EU countries and their factory count per country.
CREATE OR REPLACE VIEW Factory_Count_Country_EU AS
SELECT country_code AS EU_Countries, factory_Count_All
FROM Factory_Count_Country
JOIN ismember ON Factory_Count_Country.Country_Code = ismember.country
WHERE ismember.organization = 'EU' AND ismember.type = 'member';

SELECT *
FROM Factory_Count_Country_EU;

-- 2.3) The Non-EU countries and their factory count per country.
CREATE OR REPLACE VIEW Factory_Count_Country_Non_EU AS
SELECT country_code AS Non_EU_Countries, factory_Count_All
FROM Factory_Count_Country
WHERE NOT EXISTS (
        SELECT *
        FROM ismember
        WHERE Factory_Count_Country.Country_Code = ismember.country AND ismember.organization = 'EU' AND ismember.type = 'member');

SELECT *
FROM Factory_Count_Country_Non_EU;

------------------

-- 2.4) The factory sum of all EU countries and their average GDP.
CREATE OR REPLACE VIEW Factory_Sum_EU AS
SELECT SUM(Factory_Count_All) AS Sum_EU_Factories, ROUND(AVG(gdp)) AS Average_GDP
FROM Factory_Count_Country
JOIN ismember ON Factory_Count_Country.Country_Code = ismember.country
JOIN economy ON Factory_Count_Country.Country_Code = economy.country
WHERE ismember.organization = 'EU' AND ismember.type = 'member';

SELECT *
FROM Factory_Sum_EU;

-- 2.5) The factory sum of all non-EU.
CREATE OR REPLACE VIEW Factory_Sum_Non_EU AS
SELECT SUM(Factory_Count_All) AS Sum_Non_EU_Factories
FROM Factory_Count_Country
WHERE NOT EXISTS (
        SELECT *
        FROM ismember
        WHERE Factory_Count_Country.Country_Code = ismember.country AND ismember.organization = 'EU' AND ismember.type = 'member');

SELECT *
FROM Factory_Sum_Non_EU;

------------------

-- 2.6) The brand's, China's and Vietnam's: brand or country, code, GDP, service, industry and factory count.
CREATE OR REPLACE VIEW GDP_Comparison AS
SELECT brand.brand_name AS brand_or_country, brand.code, economy.gdp, service, industry, Factory_Count_Country.factory_count_all
FROM brand
JOIN economy ON brand.code = economy.country
JOIN Factory_Count_Country ON brand.code = Factory_Count_Country.country_code
UNION
SELECT country, country, gdp, service, industry, Factory_Count_Country.factory_count_all
FROM economy
JOIN Factory_Count_Country ON economy.country = Factory_Count_Country.country_code
Where country = 'CN'
UNION
SELECT country, country, gdp, service, industry, Factory_Count_Country.factory_count_all
FROM economy
JOIN Factory_Count_Country ON economy.country = Factory_Count_Country.country_code
Where country = 'VN';

SELECT *
FROM GDP_Comparison;

------------------

-- 3.1) How many people of a population in a city might work in the factory with the same city?
-- Worker_Amount_Range is used to compute the relation worker to city population.
-- Return the factory name, city, the worker upper bound, city population, computation and brand name.
-- This will be only an indicator, because some workers might commute to work.
-- Note that Worker_Amount_Range (in %) is limited to VF Corporation and Puma.
-- Also note that we are optimistic in our calculations by using the upper bound instead of the lower bound.
CREATE OR REPLACE VIEW Worker_In_City_VF_Puma AS
SELECT Factory.Factory_Name,
        City.Name AS City_Name,
        Worker_Amount_Range.Worker_Amount_Upper_Bound AS Worker_Upper_Bound,
        City.Population AS City_Population,
        (Worker_Amount_Range.Worker_Amount_Upper_Bound / City.Population) * 100 AS Worker_to_Population_Relation_in_Percentage,
        Brand.Brand_Name
FROM Factory
JOIN Brand ON Factory.Brand_ID = Brand.Brand_ID
JOIN Address_Mondial ON Factory.Address_M_ID = Address_Mondial.Address_M_ID
JOIN City ON Address_Mondial.City = City.Name
JOIN Worker_Amount_Range ON Factory.Worker_Amount_Range_ID = Worker_Amount_Range.Worker_Amount_Range_ID
WHERE Worker_Amount_Range.Worker_Amount_Upper_Bound IS NOT NULL
-- IS NOT NULL: Avoid empty columns
ORDER BY Worker_to_Population_Relation_in_Percentage DESC;
-- The result is limited to VF Corporation, because Puma didn’t provide data for province.
-- Therefore no queries with Mondial’s city table is possible due to the composite key of city, needing data for city, province and country.

SELECT *
FROM Worker_In_City_VF_Puma;

------------------

-- 3.2) This is the same query as 3.1, except it uses Total_Worker_Int instead of Worker_Amount_Range to get results of Nike and Adidas.
-- These brands are limited to Worker_Amount_Int.
CREATE OR REPLACE VIEW Worker_In_City_Nike_Adidas AS
SELECT Factory.Factory_Name,
        City.Name AS City_Name,
        Worker_Amount_int.Total_Worker_int AS Total_Workers,
        City.Population AS City_Population,
        (Worker_Amount_int.Total_Worker_int / City.Population) * 100 AS Worker_to_Population_Relation_in_Percentage,
        Brand.Brand_Name
FROM Factory
JOIN Brand ON Factory.Brand_ID = Brand.Brand_ID
JOIN Address_Mondial ON Factory.Address_M_ID = Address_Mondial.Address_M_ID
JOIN City ON Address_Mondial.City = City.Name
JOIN Worker_Amount_int ON Factory.Worker_Amount_Int_ID = Worker_Amount_int.Worker_Amount_Int_ID
ORDER BY Worker_to_Population_Relation_in_Percentage DESC;

SELECT *
FROM Worker_In_City_Nike_Adidas;

------------------

-- 4.1) All the factory’s related information by name or number instead of the IDs.
CREATE MATERIALIZED VIEW Factory_View AS
SELECT f.Factory_ID,
        f.Factory_Name,
        b.Brand_Name,
        pt.Product_Type,
        po.Parent_Organization,
        sg.Supplier_Group,
        wai.Total_Worker_int,
        wai.Female_Worker_int,
        wai.Male_Worker_int,
        wai.Migrant_Worker_int,
        wai.Line_Worker_int,
        wap.Female_Worker_percentage,
        wap.Migrant_Worker_percentage,
        war.Worker_Amount_Lower_Bound,
        war.Worker_Amount_Upper_Bound,
        am.Address AS Address_Mondial,
        ae.Address AS Address_Extended
FROM Factory f
LEFT OUTER JOIN Brand b ON f.Brand_ID = b.Brand_ID
LEFT OUTER JOIN Product_Type pt ON f.Product_Type_ID = pt.Product_Type_ID
LEFT OUTER JOIN Parent_Organization po ON f.Parent_Organization_ID = po.Parent_Organization_ID
LEFT OUTER JOIN Supplier_Group sg ON f.Supplier_ID = sg.Supplier_ID
LEFT OUTER JOIN Worker_Amount_int wai ON f.Worker_Amount_Int_ID = wai.Worker_Amount_Int_ID
LEFT OUTER JOIN Worker_Amount_Percentage wap ON f.Worker_Amount_Percentage_ID = wap.Worker_Amount_Percentage_ID
LEFT OUTER JOIN Worker_Amount_Range war ON f.Worker_Amount_Range_ID = war.Worker_Amount_Range_ID
LEFT OUTER JOIN Address_Mondial am ON f.Address_M_ID = am.Address_M_ID
LEFT OUTER JOIN Address_Extended ae ON f.Address_E_ID = ae.Address_E_ID;
-- LEFT OUTER JOIN: returns all rows from the left table on the matched right table. If there is no match on the right table, NULL is returned

SELECT *
FROM Factory_View;

SELECT *
FROM factory

------------------

-- 4.2) The factory's ID, name, female and migrant percentage number, excluding rows of null. Worker_Amount_Int being computed in percentage, excluding rows of null.
-- Create materialized view, so the calculation will be saved locally and we are faster.
CREATE MATERIALIZED VIEW Factory_Percentage AS
SELECT Factory_View.Factory_ID, Factory_View.Factory_Name,
        Factory_View.Female_Worker_percentage,
        Factory_View.Migrant_Worker_percentage
FROM Factory_View
WHERE Factory_View.Female_Worker_percentage IS NOT NULL AND Factory_View.Migrant_Worker_percentage IS NOT NULL
-- VF Corporation and Puma
UNION ALL -- won't remove duplicates
SELECT Factory_View.Factory_ID, Factory_View.Factory_Name,
        ROUND((Factory_View.Female_Worker_int * 100.0 / Factory_View.Total_Worker_int), 0) AS Percentage_Female_Workers,
        ROUND((Factory_View.Migrant_Worker_int * 100.0 / Factory_View.Total_Worker_int), 0) AS Percentage_Migrant_Workers
FROM Factory_View
WHERE Factory_View.Female_Worker_Int IS NOT NULL AND Factory_View.Migrant_Worker_Int IS NOT NULL;
-- Nike and Adidas
-- note: some factories don't have all the numbers

SELECT *
FROM Factory_Percentage;

------------------

-- 5.1) The factory’s ID, name and where female worker percentage is 95 % or higher. Excluded is Factory with the ID 674, because the brand provided false data.
CREATE OR REPLACE VIEW Countries_above_95_female AS
SELECT Factory_Percentage.Factory_ID, Factory_Percentage.Factory_Name, Factory_Percentage.Female_Worker_percentage
FROM Factory_Percentage
JOIN Factory_View ON Factory_View.Factory_ID = Factory_Percentage.Factory_ID 
WHERE Factory_Percentage.Female_Worker_Percentage >= 95 AND Factory_Percentage.Factory_ID <> 674
-- Factory_ID 674 - Can Sports Shoes Co., Ltd. - would give an output of 393% female workers - which shouldn't be possible
-- so when i checked the data of adidas, they gave a total worker count of 1652 and female worker count of 6493 which results in 393%
-- this is where we can see the importance of working with correct data
ORDER BY Female_Worker_percentage DESC;

SELECT *
FROM Countries_above_95_female;

-- 5.2) The Address_Extended and Address_Mondial for the factory with the ID of 674.
SELECT address_m_id, address_e_id
FROM Factory
WHERE Factory_ID = 674;
-- it has an Address_Extended instead of Address_Mondial!

-- 5.3) For each country the average of female factory worker in percentage, where it is 50% or higher. Excluded is Factory with the ID 674.
-- Displayed in the following format: “This country: <Country_Code> has this avg % of females: <ROUND(AVG(female_worker_percentage), 4)> in sport product factories.”
CREATE OR REPLACE VIEW Countries_above_50_female AS
SELECT 'This country: ' AS text1, Country_Code, ' has this avg % of females: ' AS text2, ROUND(AVG(female_worker_percentage), 4) AS female_worker_percentage_new,  ' in sport product factories.' AS text3
FROM (
SELECT am.Code AS Country_Code, female_worker_percentage
        FROM Factory_Percentage fp
        JOIN Address_Mondial am ON fp.Factory_ID = am.Address_M_ID
        UNION ALL
        SELECT ae.Code AS Country_Code, female_worker_percentage
        FROM Factory_Percentage fp
        JOIN Address_Extended ae ON fp.Factory_ID = ae.Address_E_ID
        WHERE fp.Factory_ID <> 674
) AS All_Factories
GROUP BY Country_Code
HAVING AVG(female_worker_percentage) >= 50
ORDER BY female_worker_percentage_new DESC;

SELECT *
FROM Countries_above_50_female;

-- 5.4) For each country the average of female factory worker in percentage, where it is lower than 50%. Excluded is Factory with the ID 674.
-- Displayed in the following format: “This country: <Country_Code> has this avg % of females: <ROUND(AVG(female_worker_percentage), 4)> in sport product factories.”
CREATE OR REPLACE VIEW Countries_below_50_female AS
SELECT 'This country: ' AS text1, Country_Code, ' has this avg % of females: ' AS text2, ROUND(AVG(female_worker_percentage), 4) AS female_worker_percentage_new, ' in sport product factories.' AS text3
FROM (
SELECT am.Code AS Country_Code, female_worker_percentage
        FROM Factory_Percentage fp
        JOIN Address_Mondial am ON fp.Factory_ID = am.Address_M_ID
        UNION ALL
        SELECT ae.Code AS Country_Code, female_worker_percentage
        FROM Factory_Percentage fp
        JOIN Address_Extended ae ON fp.Factory_ID = ae.Address_E_ID
        WHERE fp.Factory_ID <> 674
) AS All_Factories
GROUP BY Country_Code
HAVING AVG(female_worker_percentage) < 50
ORDER BY female_worker_percentage_new DESC;

SELECT *
FROM Countries_below_50_female;

------------------
-- documentation end
------------------

-- The following queries have no direct contribution to my topic, but I wanted to do at least one query with my invented data.

-- Counts the starting letter of the worker's last name, divided by gender.
-- SELECT LEFT(Last_Name, 1): takes the first letter from the left
SELECT LEFT(Last_Name, 1) AS Starting_Letter_M, COUNT(*) AS Letter_Count_M
FROM Worker
WHERE Gender = 'm'
GROUP BY LEFT(Last_Name, 1)
ORDER BY Letter_Count_M DESC;

SELECT LEFT(Last_Name, 1) AS Starting_Letter_F, COUNT(*) AS Letter_Count_F
FROM Worker
WHERE Gender = 'f'
GROUP BY LEFT(Last_Name, 1)
ORDER BY Letter_Count_F DESC;

-- Creates a table selecting female line workers with their last name starting with 'M' and being shorter than 5 characters.
Select *
FROM Worker
Where Gender = 'f' AND Line_Worker = true AND Last_Name LIKE 'M%' AND LENGTH(Last_Name) < 5;

------------------

-- Notes to myself:
SELECT Factory.Factory_Name, Brand.Brand_Name
FROM Factory, Brand
Where Factory.Brand_ID = Brand.Brand_ID;

-- those are the same

SELECT Factory.Factory_Name, Brand.Brand_Name
FROM Factory
JOIN Brand ON Factory.Brand_ID = Brand.Brand_ID;
------------------
