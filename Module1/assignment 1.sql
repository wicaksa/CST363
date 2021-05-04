-- NAME: WICAKSA MUNAJAT
-- CLASS: CST363 CSUMB SUMMER '21
-- DATE: 05/03/2021

-- e5.1 Exercises from chapter 5
--
-- Before you begin:
-- create the tables and data using the script 
--   zagimore_schema.sql
--
-- 1  Display all records in the REGION table
SELECT *
FROM region;

-- 2 Display StoreID and StoreZIP for all stores
SELECT StoreId, StoreZip
FROM store;

-- 3 Display CustomerName and CustomerZip for all customers
--   sorted alphabetically by CustomerName
SELECT CustomerName, CustomerZip
FROM customer
ORDER BY CustomerName;

-- 4 Display the RegionIDs where we have stores 
--   and do not display duplicates
SELECT DISTINCT RegionId
FROM store;

-- 5 Display all information for all stores in RegionID C 
SELECT *
FROM store
WHERE RegionId = 'C';

-- 6 Display CustomerID and CustomerName for customers who name 
--   begins with the letter T
SELECT CustomerId, CustomerName
FROM customer
WHERE CustomerName LIKE 'T%';

-- 7 Display ProductID, ProductName and ProductPrice for 
--   products with a price of $100 or higher
SELECT ProductId, ProductName, ProductPrice
FROM product
WHERE ProductPrice >= 100;

-- 8 Display ProductID, ProductName, ProductPrice and VendorName
--   for products sorted by ProductID
SELECT p.ProductId, p.ProductName, p.ProductPrice, v.VendorName
FROM product p, vendor v
WHERE p.VendorId = v.VendorId
ORDER BY ProductId;

-- 9 Display ProductID, ProductName, ProductPrice,  VendorName and CategoryName
--   for products.  Sort by ProductID
SELECT p.ProductId, p.ProductName, p.ProductPrice, v.VendorName, c.CategoryName
FROM product p, vendor v, category c
WHERE p.VendorId = v.VendorId AND p.CategoryId = c.CategoryId
ORDER BY ProductId;

-- 10 Display ProductID, ProductName, ProductPrice  
--   for products in category "Camping" sorted by ProductID
SELECT p.ProductId, p.ProductName, p.ProductPrice
FROM product p, category c
WHERE p.CategoryId = c.CategoryId AND c.CategoryName = 'Camping'
ORDER BY p.ProductId;

-- 11 Display ProductID, ProductName, ProductPrice  
--   for products sold in zip code "60600" sorted by ProductID
SELECT p.ProductId, p.ProductName, p.ProductPrice
FROM product p, store s
WHERE s.StoreZip = 60600
ORDER BY p.ProductId;

-- 12 Display ProductID, ProductName and ProductPrice for VendorName "Pacifica Gear" and were
--    sold in the region "Tristate".  Do not show duplicate information.
SELECT DISTINCT p.ProductId, p.ProductName, p.ProductPrice
FROM product p, vendor v, region r, store s
WHERE p.VendorId = v.VendorId AND v.VendorName = 'Pacifica Gear' AND s.RegionId = r.RegionId AND r.RegionName = 'Tristate';

-- 13 Display TID, CustomerName and TDate for any customer buying a product "Easy Boot"
--    Sorted by TID.
SELECT s.TID, c.CustomerName, s.TDate
FROM salestransaction s, customer c, product p, includes i
WHERE s.CustomerId = c.CustomerId AND s.TID = i.TID AND i.ProductId = p.ProductID AND p.ProductName = 'Easy Boot'
ORDER BY s.TID;

-- 14 Create table and insert the following data
-- create table company with columns
--    companyid char(3), name varchar(50), ceo varchar(50)
--    make column companyid the primary key

 CREATE TABLE company (
	CompanyId char(3),
    Name varchar(50),
    CEO varchar(50),
    PRIMARY KEY (CompanyId)
); 

-- insert the following data 
--    companyid   name          ceo
--    ACF         Acme Finance  Mike Dempsey
--    TCA         Tara Capital  Ava Newton
--    ALB         Albritton     Lena Dollar

INSERT INTO company
VALUES ('ACF', 'Acme Finance', 'Mike Dempsey'),
	     ('TCA', 'Tara Capital', 'Ava Newton'),
       ('ALB', 'Albritton', 'Lena Dollar');

-- create a table security with columns
--     secid, name, type
--     secid should be the primary key

CREATE TABLE security (
    SecId char(2),
    Name varchar(50),
    Type varchar(50),
    PRIMARY KEY (SecId)
);

-- insert the following data
--    secid    name                type
--    AE       Abhi Engineering    Stock
--    BH       Blues Health        Stock
--    CM       County Municipality Bond
--    DU       Downtown Utlity     Bond
--    EM       Emmitt Machines     Stock

INSERT INTO security
VALUES ('AE', 'Abhi Engineering', 'Stock'),
       ('BH', 'Blues Health', 'Stock'),
       ('CM', 'County Municipality','Bond'),
       ('DU', 'Downtown Utlity', 'Bond'),
       ('EM', 'Emmitt Machines', 'Stock');

-- create the following table called fund 
--  with columns companyid, inceptiondate, fundid, name
--   fundid should be the primary key
--   companyid should be a foreign key referring to the company table.

CREATE TABLE fund (
	CompanyId char(3),
    InceptionDate date,
    FundId char(2),
    Name varchar(50),
    PRIMARY KEY (FundId),
	FOREIGN KEY (CompanyId) REFERENCES company(CompanyId)
);
-- CompanyID  InceptionDate   FundID Name
--    ACF      2005-01-01     BG     Big Growth
--    ACF      2006-01-01     SG     Steady Growth
--    TCA      2005-01-01     LF     Tiger Fund
--    TCA      2006-01-01     OF     Owl Fund
--    ALB      2005-01-01     JU     Jupiter
--    ALB      2006-01-01     SA     Saturn

INSERT INTO fund
VALUES ('ACF', '2005-01-01', 'BG', 'Big Growth'),
       ('ACF', '2006-01-01', 'SG', 'Steady Growth'),
       ('TCA', '2005-01-01', 'LF', 'Tiger Fund'),
       ('TCA', '2006-01-01', 'OF', 'Owl Fund'),
	   ('ALB', '2005-01-01', 'JU', 'Jupiter'),
	   ('ALB', '2006-01-01', 'SA', 'Saturn');
       
-- create table holdings with columns
--   fundid, secid, quantity
--   make (fundid, secid) the primary key
--   fundid is also a foreign key referring to the fund table
--   secid is also a foreign key referring to the security table

CREATE TABLE holdings (
	FundId char(2),
    SecId char(2),
    Quantity int,
    PRIMARY KEY (FundId, SecId),
    FOREIGN KEY (FundId) REFERENCES fund (FundId),
    FOREIGN KEY (SecId) REFERENCES security (SecId)
);

--    fundid   secid    quantity
--     BG       AE           500
--     BG       EM           300
--     SG       AE           300
--     SG       DU           300
--     LF       EM          1000
--     LF       BH          1000
--     OF       CM          1000
--     OF       DU          1000
--     JU       EM          2000
--     JU       DU          1000
--     SA       EM          1000
--     SA       DU          2000

INSERT INTO holdings (FundId, SecId, Quantity)
VALUES  ('BG', 'AE',  500),
	    ('BG', 'EM',  300),
		('SG', 'AE',  300),
		('SG', 'DU',  300),
		('LF', 'EM',  1000),
		('LF', 'BH',  1000),
		('OF', 'CM',  1000),
		('OF', 'DU',  1000),
		('JU', 'EM',  2000),
		('JU', 'DU',  1000),
		('SA', 'EM',  1000),
		('SA', 'DU',  2000);

-- 15 Use alter table command to add a column "price" to the 
--    security table.  The datatype should be numeric(7,2)

ALTER TABLE security 
	ADD Price numeric(7,2); 

-- SELECT * 
-- FROM security;

-- 16 drop tables company, security, fund, holdings.
--    You must drop them in a certain order.

DROP TABLE holdings; 
DROP TABLE fund;
DROP TABLE security;
DROP TABLE company;

-- 17 Try to delete the row for product with productid '5X1'
DELETE FROM product
WHERE ProductId = '5X1';

-- SELECT * 
-- FROM product;

-- 18 Explain why does the delete in question 17 fails.
	-- When you try to delete an entry from the parent table,
	-- the Primary Key will get linked to the foreign key of the child table. 
	-- You can not delete it directly.

-- 19 Try to delete the row for product with productid '5X2'
DELETE FROM product
WHERE ProductId = '5X2';

-- SELECT * 
-- FROM product;

-- 20 Re-insert productid '5X2'
INSERT INTO product 
Values ('5X2', 'Action Sandal', 70.00, 'PG', 'FW');

-- 21  update the price of '5X2', 'Action Sandal' by $10.00
UPDATE product
SET ProductName = 'Action Sandal', ProductPrice = 70.00, VendorId = 'PG', CategoryId = 'FW'
WHERE ProductId = '5X2';

-- SELECT * 
-- FROM product;

-- 22 increase the price of all products in the 'CY' category by 5%
UPDATE product
SET ProductPrice = ProductPrice * 1.05
WHERE CategoryId = 'CY';

-- 23 decrease the price of all products made by vendorname 'Pacifica Gear' by $5.00
UPDATE product, vendor
SET ProductPrice = ProductPrice - 5.00
WHERE product.VendorId = vendor.VendorId AND VendorName = 'Pacifica Gear';

-- SELECT * 
-- FROM product;

-- 24 List productid and productprice for all products.  Sort by productid;
SELECT ProductId, ProductPrice
FROM product
ORDER BY ProductId;

