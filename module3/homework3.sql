-- Wicaksa Munajat
-- CST363 - Intro to Database design
-- 05/18/2021
-- Module 3 Homework

-- Before you begin create the database and tables with the script
--  assignment_2a_schema.sql

-- 1  Find the model number and price of all products (of any type) made by 
--    manufacturer B?  The result should be in order by model number and 
--    then by  price (low to high)  
--    hint:  use a union over the pc, laptop and printer tables

--    result: B 1004 pc
--            B 1005 pc
--            B 1006 pc
--            B 2007 laptop

--    debug 
-- select * from pc; 
-- select * from printer; 
-- select * from laptop;
-- select * from product order by maker;

SELECT pc.model, pc.price
FROM pc, product p
WHERE pc.model = p.model AND p.maker = 'B'
UNION
SELECT l.model, l.price
FROM laptop l, product p
WHERE l.model = p.model AND p.maker = 'B'
UNION
SELECT pr.model, pr.price
FROM  printer pr, product p
WHERE pr.model = p.model AND p.maker = 'B'
ORDER BY model, price ASC;

-- 2  Find those manufacturers that sell laptops but not pc’s. 
--    Sort result by maker.
--    hint: use "not in" predicate and a subselect on the pc table.
--    Should be  F G
 
SELECT DISTINCT maker as Manufacturers
FROM product
WHERE type = 'Laptop' AND maker NOT IN (
	SELECT maker 
    FROM product
    WHERE type = 'PC')
ORDER BY maker;

-- 3  Find the hard-drive sizes that occur in two or more PC’s.   
--    Sort the list low to high. [hint: use group and having]
--    Should be 80, 160, 250

SELECT hd as HDSize, count(model) as NumberOfPCs
FROM pc
GROUP BY hd 
HAVING NumberOfPCs >= 2
ORDER BY HDSize ASC; 

-- 4  Find  PC models that have both the same speed and RAM.  
--    The output should have 2 columns,  "model1" and "model2".  
--    A pair should be listed only once:  
--    e.g. if (f, g) is in the result then (g,f) should not appear.   
--    Sort the output by the first column.
--    1012, 1004 (1024, 2.80)

SELECT pc1.model as model1, pc2.model as model2
FROM pc pc1, pc pc2
WHERE pc1.model < pc2.model 
AND pc1.speed = pc2.speed AND
    pc1.RAM = pc2.RAM
ORDER BY pc1.model;
 
-- 5  Find the maker or makers of PC’s with at least three different speeds. 
--    If more than one, order by maker.
--    hint: use a having clause containing a count(distinct) function.
--    A:3, B: 2, C:1, D:3, E:3

-- DEBUG 
-- SELECT p.maker, pc.speed
-- FROM product p, pc
-- WHERE p.model = pc.model;

-- HAS EXTRA COLUMN
-- SELECT p.maker as PCMaker, count(distinct pc.speed) as PCSpeeds
-- FROM product p, pc
-- WHERE p.model = pc.model
-- GROUP BY p.maker
-- HAVING PCSPeeds >= 3
-- ORDER BY PCMaker;

SELECT Maker
FROM product p, pc 
WHERE p.model = pc.model
GROUP BY Maker 
HAVING COUNT(DISTINCT (speed)) >= 3
ORDER BY Maker;

-- 6  Find those makers of at least two different computers (PC’s or 
--    laptops)  with speeds of at least 2.80.  Order the list by maker. 
--    hint:  use a subquery that does a UNION of the pc and laptop tables.
SELECT DISTINCT Maker
FROM product p1, (SELECT pc.model, pc.speed
				  FROM pc
				  UNION
				  SELECT l.model, l.speed
				  FROM laptop l) AS p2
WHERE p1.model  = p2.model AND 
      p2.speed >= 2.80
ORDER BY Maker;

-- 7  Find the maker(s) of the computer (PC or laptop) with the highest 
--    speed.  If there are multiple makers, list all of them and order by maker.

-- DEBUG
-- select product.maker, pc.model, pc.speed
-- where product.model = pc.model
-- order by speed desc; 

-- select product.maker, l.model, l.speed
-- from laptop l, product 
-- where product.model = l.model
-- order by speed desc; 

-- select * from laptop order by speed desc;
-- select * from product order by maker;

SELECT DISTINCT Maker
FROM product p1, (SELECT pc.model, pc.speed
				  FROM pc
				  UNION
				  SELECT l.model, l.speed
				  FROM laptop l) AS p2
WHERE p1.model = p2.model AND 
      speed >= ALL( SELECT speed 
				    FROM pc
                    UNION
                    SELECT speed
                    FROM
                    laptop)
ORDER BY Maker;
