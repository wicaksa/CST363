-- e5.1 Exercises from chapter 5
-- Wicaksa Munajat
-- CST 363 CSUMB Summer '21

-- Before you begin:
-- re-create the tables and data using the script 
--   zagimore_schema.sql

-- 1  Display the RegionID, RegionName and number of stores in each region.
SELECT r.RegionID, r.RegionName, COUNT(StoreID) as NumberOfStoresInRegion
FROM region r
INNER JOIN store s
ON r.RegionID = s.RegionID
GROUP BY r.RegionID, r.RegionName;

-- 2 Display CategoryID and average price of products in that category.
SELECT c.CategoryID, AVG(ProductPrice)
FROM category c
INNER JOIN product p
ON c.CategoryID = p.CategoryID
GROUP BY CategoryID;

-- 3 Display CategoryID and number of items purchased in that category.
SELECT p.CategoryID, SUM(quantity)
FROM Product p
INNER JOIN Includes i 
ON p.ProductID = i.ProductID
GROUP BY p.CategoryID;

-- 4 Display RegionID, RegionName and total amount of sales as AmountSpent
SELECT r.RegionID, r.RegionName, SUM(i.quantity * p.ProductPrice) AS AmountSpent
FROM Region r, Includes i, Product p, SalesTransaction st, Store s
WHERE p.ProductID = i.ProductID AND st.tid = i.tid AND r.RegionID = s.RegionID AND s.StoreID = st.StoreID
GROUP BY r.RegionID, r.RegionName;

-- 5 Display the TID and total number of items in the sale
--    for all sales where the total number of items is greater than 3
SELECT TID, SUM(Quantity) as TotalSold
FROM includes 
GROUP BY TID
HAVING SUM(Quantity) > 3;

-- 6 For vendor whose product sales exceeds $700, display the
--    VendorID, VendorName and total amount of sales as "TotalSales"
SELECT v.VendorID, v.VendorName, SUM(p.ProductPrice * i.Quantity) AS TotalSales
FROM Vendor v
JOIN Product p ON p.VendorID = v.VendorID
JOIN Includes i ON i.ProductID = p.ProductID
JOIN Salestransaction s ON s.TID = i.TID
GROUP BY v.VendorID, v.VendorName
HAVING SUM(p.ProductPrice * i.Quantity) > 700;

-- 7 Display the ProductID, Productname and ProductPrice
--    of the cheapest product.
SELECT ProductID, ProductName, ProductPrice
FROM Product
WHERE ProductPrice = (SELECT MIN(ProductPrice)
					  FROM Product);

-- 8 Display the ProductID, Productname and VendorName
--    for products whose price is below average price of all products
--    sorted by productid.
SELECT p.ProductID, p.ProductName, v.VendorName
FROM Product p, Vendor v
WHERE p.VendorID = v.VendorID
GROUP BY p.ProductID, p.ProductName, v.VendorName, p.ProductPrice
HAVING p.ProductPrice <  (SELECT AVG(ProductPrice) 
                          FROM Product)
ORDER BY p.ProductID;

-- 9 Display the ProductID and Productname from products that
--    have sold more than 2 (total quantity).  Sort by ProductID
SELECT p.ProductID, p.ProductName
FROM Product p, Includes i
WHERE p.ProductID = i.ProductID
GROUP BY ProductID
HAVING SUM(quantity) > 2
ORDER BY p.ProductID;

-- 10 Display the ProductID for the product that has been 
--    sold the most (highest total quantity across all
--    transactions). 
SELECT ProductID
FROM (SELECT ProductID, SUM(Quantity) AS MaxQuantity
      FROM Includes 
	  GROUP BY ProductID) AS TABLE1
ORDER BY MaxQuantity DESC
LIMIT 1;

-- 11 Rewrite query 30 in chapter 5 using a join.
SELECT p.ProductID, p.ProductName, p.ProductPrice
FROM Product p
JOIN Includes i ON p.ProductID = i.ProductID
GROUP BY p.ProductID
HAVING SUM(i.Quantity) > 3;

-- 12 Rewrite query 31 using a join.
SELECT p.ProductID, p.ProductName, p.ProductPrice
FROM Product p
JOIN Includes i ON p.ProductID = i.ProductID
GROUP BY p.ProductID
HAVING COUNT(i.TID) > 1;

-- 13 create a view over the product, salestransaction, includes, customer, store, region tables
--     with columns: tdate, productid, productname, productprice, quantity, customerid, customername, 
--                   storeid, storezip, regionname

CREATE VIEW MAIN_VIEW AS
SELECT st.tdate, p.productid, p.productname, p.productprice, i.quantity, 
	   c.customerid, c.customername, s.storeid, s.storezip, r.regionname
FROM product p, salestransaction st, includes i, customer c, store s, region r
WHERE c.customerid = st.customerid AND i.productid = p.productid AND 
      st.tid = i.tid AND st.storeid = s.storeid AND r.regionid = s.regionid;

-- debug select * from MAIN_VIEW;
-- debug SELECT * FROM SALESTRANSACTION;
-- debug SELECT * FROM INCLUDES;

-- 14 Using the view created in question 13
--   Display ProductID, ProductName, ProductPrice  
--   for products sold in zip code "60600" sorted by ProductID
SELECT ProductID, ProductName, ProductPrice
FROM MAIN_VIEW
WHERE StoreZIP = '60600'
ORDER BY ProductID;

-- 15 Using the view from question 13 
--    display CustomerName and TDate for any customer buying a product "Easy Boot"
SELECT CustomerName, TDate
FROM MAIN_VIEW 
WHERE ProductName = 'Easy Boot';

-- 16 Using the view from question 13
--    display RegionName and total amount of sales in each region as "AmountSpent"
SELECT RegionName, SUM(ProductPrice * Quantity) AS AmountSpent
FROM MAIN_VIEW 
GROUP BY RegionName;

-- 17 Display the product ID and name for products whose 
--    total sales is less than 3 or total transactions is at most 1.
--    Use a UNION. 
SELECT p.ProductID, p.ProductName
FROM Product p, Includes i 
WHERE i.ProductID = p.ProductID
GROUP BY p.ProductID
HAVING SUM(i.Quantity) < 3
UNION
SELECT p.ProductID, p.ProductName
FROM Product p, Includes i 
WHERE p.ProductID = i.ProductID
GROUP BY p.ProductID
HAVING COUNT(i.TID) <= 1;

-- 18 Create a view named category_region 
--    over the category, region, store, salestransaction, includes,
--    and product tables that summarizes total quantity sold by region and category. The view 
--    should have columns: categoryid, categoryname, regionid, regionname, totalsales

CREATE VIEW category_region AS
SELECT c.categoryid, c.categoryname, r.regionid, r.regionname, SUM(quantity) AS totalsales
FROM category c, region r, store s, salestransaction st, includes i, product p
WHERE r.regionid = s.regionid AND s.storeid = st.storeid AND p.productid = i.productid AND 
	  p.categoryid = c.categoryid AND i.tid = st.tid
GROUP BY c.categoryid, c.categoryname, r.regionid, r.regionname;

-- debug select * from category_region;
-- debug ORDER BY categoryid, categoryname;

-- 19 Using the view created in 18, which region has the most sales in 
--    each category.
--    you should get the result
--    categoryname  regionname    totalsales
--    Electronics   Chicagoland   6
--    Climbing      Indiana       17
--    Camping       Tristate      9
--    Footwear      Tristate      20
--    Cycling       Chicagoland   13

SELECT categoryname, regionname, totalsales
FROM category_region
WHERE (categoryname, totalsales) IN (SELECT categoryname, MAX(totalsales) 
                     FROM category_region
                     GROUP BY categoryname);
