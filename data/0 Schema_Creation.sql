-- deletes existing tables
DROP TABLE IF EXISTS Address_Mondial Cascade; -- Cascade to kill all referenced records
DROP TABLE IF EXISTS Address_Extended Cascade;
DROP TABLE IF EXISTS Brand Cascade;
DROP TABLE IF EXISTS Factory Cascade;
DROP TABLE IF EXISTS Parent_Organization Cascade;
DROP TABLE IF EXISTS Product_Type Cascade;
DROP TABLE IF EXISTS Supplier_Group Cascade;
DROP TABLE IF EXISTS Worker Cascade;
DROP TABLE IF EXISTS Worker_Amount_Percentage Cascade;
DROP TABLE IF EXISTS Worker_Amount_Range Cascade;
DROP TABLE IF EXISTS Worker_Amount_int Cascade;
--

CREATE TABLE Address_Mondial
    ( Address_M_ID integer PRIMARY KEY,
    Address varchar(300),
    Region varchar(20),
    Code varchar(4) NOT NULL,
    City varchar(50) NOT NULL,
    Province varchar(50) )
;

CREATE TABLE Address_Extended
    ( Address_E_ID integer PRIMARY KEY,
    Address varchar(300),
    Region varchar(20),
    Code varchar(4) NOT NULL,
    City varchar(50) NOT NULL,
    Province varchar(50) )
;

CREATE TABLE Brand
    ( Brand_ID integer PRIMARY KEY,
    Brand_Name varchar(20),
    Revenue_2022 decimal(15, 0),
    Founding_Year integer,
    Code varchar(4) NOT NULL )
;

CREATE TABLE Factory
    ( Factory_ID integer PRIMARY KEY,
    Factory_Name varchar(100),
    Brand_ID integer NOT NULL,
    Product_Type_ID integer NOT NULL,
-- NOT NULL ends here, because not every factory has data for every attribute
    Parent_Organization_ID integer,
    Supplier_ID integer,
    Worker_Amount_Int_ID integer,
    Worker_Amount_Percentage_ID integer,
    Worker_Amount_Range_ID integer,
    Address_M_ID integer,
    Address_E_ID integer )
;

CREATE TABLE Parent_Organization
    ( Parent_Organization_ID integer PRIMARY KEY,
    Parent_Organization varchar(100),
    Organization_URL varchar(50),
    Organization_Number varchar(20),
    Organization_Mail varchar(50) )
;

CREATE TABLE Product_Type
    ( Product_Type_ID integer PRIMARY KEY,
    Product_Type varchar(20) )
;

CREATE TABLE Supplier_Group
    ( Supplier_ID integer PRIMARY KEY,
    Supplier_Group varchar(100),
    Supplier_URL varchar(50),
    Supplier_Number varchar(20),
    Supplier_Mail varchar(50) )
;

CREATE TABLE Worker
    ( Worker_ID integer PRIMARY KEY,
    First_Name varchar(20),
    Last_Name varchar(20),
    Gender char(1),
    Worker_Mail varchar(40),
    Worker_Number varchar(20),
    Migrant boolean, -- 1 = TRUE
    Line_Worker boolean, -- 0 = FALSE
    Factory_ID integer NOT NULL )
;

CREATE TABLE Worker_Amount_Percentage
    ( Worker_Amount_Percentage_ID integer PRIMARY KEY,
    Female_Worker_percentage integer,
    Migrant_Worker_percentage integer )
;

CREATE TABLE Worker_Amount_Range
    ( Worker_Amount_Range_ID integer PRIMARY KEY,
    Worker_Amount_Lower_Bound integer,
    Worker_Amount_Upper_Bound integer )
;

CREATE TABLE Worker_Amount_int
    ( Worker_Amount_Int_ID integer PRIMARY KEY,
    Total_Worker_int integer,
    Female_Worker_int integer,
    Male_Worker_int integer,
    Migrant_Worker_int integer,
    Line_Worker_int integer )
;

--add Foreign Keys
ALTER TABLE Address_Mondial
    ADD CONSTRAINT country FOREIGN KEY
    ( Code )
    REFERENCES country
    ( Code )
; 

ALTER TABLE Address_Mondial
    ADD CONSTRAINT City FOREIGN KEY
    ( City, code, province )
    REFERENCES City
    ( name, country, province )
;

ALTER TABLE Address_Mondial
    ADD CONSTRAINT Province FOREIGN KEY
    ( Province, code )
    REFERENCES Province
    ( name, country )
;

ALTER TABLE Address_Extended
    ADD CONSTRAINT country FOREIGN KEY
    ( Code )
    REFERENCES country
    ( Code )
; 

ALTER TABLE Brand
    ADD CONSTRAINT country FOREIGN KEY
    ( Code )
    REFERENCES country
    ( Code )
;

ALTER TABLE Factory
    ADD CONSTRAINT Address_Mondial FOREIGN KEY
    ( Address_M_ID )
    REFERENCES Address_Mondial
    ( Address_M_ID )
; 

ALTER TABLE Factory
    ADD CONSTRAINT Address_Extended FOREIGN KEY
    ( Address_E_ID )
    REFERENCES Address_Extended
    ( Address_E_ID )
; 


ALTER TABLE Factory
    ADD CONSTRAINT Supplier_Group FOREIGN KEY
    ( Supplier_ID )
    REFERENCES Supplier_Group
    ( Supplier_ID )
; 

ALTER TABLE Factory
    ADD CONSTRAINT Parent_Organization FOREIGN KEY
    ( Parent_Organization_ID )
    REFERENCES Parent_Organization
    ( Parent_Organization_ID )
; 

ALTER TABLE Factory
    ADD CONSTRAINT Brand FOREIGN KEY
    ( Brand_ID )
    REFERENCES Brand
    ( Brand_ID )
; 

ALTER TABLE Factory
    ADD CONSTRAINT Product_Type FOREIGN KEY
    ( Product_Type_ID )
    REFERENCES Product_Type
    ( Product_Type_ID )
; 

ALTER TABLE Factory
    ADD CONSTRAINT Worker_Amount_int FOREIGN KEY
    ( Worker_Amount_Int_ID )
    REFERENCES Worker_Amount_int
    ( Worker_Amount_Int_ID )
; 

ALTER TABLE Factory
    ADD CONSTRAINT Worker_Amount_Percentage FOREIGN KEY
    ( Worker_Amount_Percentage_ID )
    REFERENCES Worker_Amount_Percentage
    ( Worker_Amount_Percentage_ID )
;

ALTER TABLE Factory
    ADD CONSTRAINT Worker_Amount_Range FOREIGN KEY
    ( Worker_Amount_Range_ID )
    REFERENCES Worker_Amount_Range
    ( Worker_Amount_Range_ID )
; 

ALTER TABLE Worker
    ADD CONSTRAINT Factory FOREIGN KEY
    ( Factory_ID )
    REFERENCES Factory
    ( Factory_ID )
; 
--
