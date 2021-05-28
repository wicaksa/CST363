-- quiz 2

drop table world;

-- 1) Using the WORLD sample database, complete the following query that finds 
-- those world cities that have over 50% of the population of their entire country.  
-- (check all correct answers)

-- A) BAD
select city.name as CityName, co.name as CountryName 
from city 
inner join country co on (city.countrycode=co.code) 
where city.population > 0.50 * countryName.population;  

-- B) GOOD
select city.name as CityName, co.name as CountryName 
from city 
inner join country co on (city.countrycode = co.code) 
where city.population > 0.50 * co.population ;

-- C) BAD 
select city.name as CityName, co.name as CountryName 
from city 
inner join country co on (city.countrycode=co.code);
-- where population > 50%;

-- D) bad
select city.name as CityName, co.name as CountryName 
from city 
inner join country co on (city.countrycode=co.code);
-- where city.population > 50%;

-- 2) Which query would return the names and population of 
--    cities that are larger than the capital city of the country? 

-- a) wrong
select city.name, city.population 
from city, country 
where city.countrycode = country.code and city.population > capital.population; 

-- b) wrong
select city.name as CityName, city.population as CityPopulation 
from country co 
inner join city on (co.code = city.countrycode) 
where city.population > co.population;

-- c) right
select city2.name as CityName, city2.population as CityPopulation 
from country co 
inner join city city1 on (co.capital = city1.id) 
inner join city city2 on (city2.countrycode = co.code) 
where city2.population > city1.population;

-- d) wrong
select city2.name as CityName, city2.population as CityPopulation 
from country co , city city1 , city city2  
where city2.population > city1.population and city2.countrycode = co.code and city2.countrycode = co.code;

select * from city;

-- 3) The SQL statement 
-- insert into mytable values ( null, "socks", 9.95)
-- would be valid for which of the following tables?

drop table mytable;
select * from mytable; 
insert into mytable values ( null, "socks", 9.95);

-- A) DOESNT WORK
create table mytable 
(a int primary key auto_increment, 
 b int, 
 c char(5), 
 d double);
 
-- B) DOESNT WORK
create table mytable 
(a int default(0), 
 b int, 
 c char(5) not null, 
 d double not null);

-- C) WORKS puts first value as 1
create table mytable 
(a int primary key auto_increment, 
 b char(5), 
 c double) ;
 
 -- D) WORKS 
  create table mytable 
  ( a char(10), 
    b char(10), 
    c double);
    
-- 4) If table A has 10 rows and table B has 20 rows, 
-- a cross join of table A with table B would give a result set with:

-- a) 10 rows
-- b) 20 rows
-- c) 30 rows
-- d) 200 rows (multiply 20x10)

-- 5) Using the WORLD database, a SELECT to find all cities 
-- that have a population larger than Shanghai would be:

-- a) 
select a.name, a.population 
from city a, city b 
where b.name = 'Shanghai' and a.population > b.population order by 2;

-- b) 
select a.name, a.population 
from city a 
inner join city b on (a.population > b.population)  
where b.name = 'Shanghai' order by 2;

-- c) 
select a.name
from city a,
where a.population > 'Shanghai'.population;  

-- d)
select a.name, a.population 
from city a, city b 
where b.name = 'Shanghai'; 

select * from city;

-- 6) Using the sakila database, the store wants to send a thank you coupon to customer 
-- who have spent more than $150 on rentals
-- SELECT c.customer_id, sum(amount), c.first_name, c.last_name, c.email
-- Complete the query with:

-- a) wrong 
SELECT c.customer_id, sum(amount), c.first_name, c.last_name, c.email
FROM payment p  
join customer c on p.customer_id = c.customer_id
WHERE amount > 150
GROUP BY amount;

-- b) wrong
SELECT c.customer_id, sum(amount), c.first_name, c.last_name, c.email
FROM payment p  
join customer c on p.customer_id = c.customer_id
WHERE amount > 150
GROUP BY  customer_id;

-- c) wrong
SELECT c.customer_id, sum(amount), c.first_name, c.last_name, c.email
FROM payment p  
join customer c on p.customer_id = c.customer_id
WHERE sum(amount) > 150
GROUP BY customer_id;

-- d) correct
SELECT c.customer_id, sum(amount), c.first_name, c.last_name, c.email
FROM payment p  
join customer c on p.customer_id = c.customer_id
GROUP BY customer_id
HAVING sum(amount) > 150;

-- 7) 

-- Which category of films is most popular?  That is the most number of rentals?
-- select cat.name, count(*) as Number_of_rentals
-- from 
-- group by cat.name
-- order by 2 desc;

-- What would be a correct from clause?

-- a)
select cat.name, count(*) as Number_of_rentals
from category cat 
inner join rental r on inventory_id = category_id 
group by cat.name
order by 2 desc;

-- b) pick this one
select cat.name, count(*) as Number_of_rentals
from category cat 
inner join film_category fc on cat.category_id = fc.category_id
inner join  film f on fc.film_id = f.film_id
inner join inventory inv on f.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id  
group by cat.name
order by 2 desc;

-- c) suss 
select cat.name, count(*) as Number_of_rentals
from category cat 
inner join  film f on cat.category_id = f.film_id -- incorrect join
inner join inventory inv on f.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id   
group by cat.name
order by 2 desc;

-- d) wrong 
select cat.name, count(*) as Number_of_rentals
from film_category fc  
inner join  film f on fc.film_id = f.film_id
inner join inventory inv on f.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id    
group by cat.name
order by 2 desc;

-- 8) Using the sakila database, a correct SQL to retrieve the number of 
-- rentals and total dollar amount of the rentals by film rating is:

-- a) ok
select f.rating, 
	   sum(t.rental_count) as total_rentals,
       sum(f.rental_rate * t.rental_count) as total_revenue
from ( select inv.film_id, count(*) 
       from inventory inv join rental re on re.inventory_id = inv.inventory_id
       group by inv.film_id)
       as t(film_id, rental_count) 
join film f on f.film_id = t.film_id
group by f.rating
order by total_revenue desc;

-- b) wrong
select f.rating, 
       count(*) as total_rentals,
       sum(f.rental_rate*count(*)) as total_revenue
from inventory inv
     join rental re on re.inventory_id=inv.inventory_id
     join film f on f.film_id = inv.film_id
group by f.rating
order by total_revenue desc;

-- c) ok
select f.rating, 
       sum(
        (select count(*) 
		from rental re join inventory inv on re.inventory_id = inv.inventory_id
		where inv.film_id = f.film_id 
		)) as total_rentals, 
       sum(f.rental_rate * 
           (select count(*) 
           from rental re join inventory inv on re.inventory_id = inv.inventory_id
           where inv.film_id = f.film_id) 
           ) as total_revenue
from film f  
group by f.rating
order by total_revenue desc;

-- d) wrong 
select f.rating, 
      t.rental_count as total_rentals,
      f.rental_rate*t.rental_count as total_revenue
from ( select inv.film_id, count(*) 
       from inventory inv join rental re on re.inventory_id=inv.inventory_id
       group by inv.film_id)
       as t(film_id, rental_count ) 
     join film f on f.film_id = t.film_id
group by f.rating
order by total_revenue desc;

-- 9) 
-- Use the 1994-census-summary.sql  script to create the census table and load sample data from the 1994 census. 
-- What is the average years of education (column education_num) for people whose native country is not the US?
-- Answer with a number which is the result of the SQL (not the SQL statement).

SELECT AVG(education_num)
from census 
WHERE native_country != 'United_States';
-- 9.3170

select * from census;

-- 10) Use the file '1994-census-summary.sql'
-- How many executive managers have more than 12 years of education 
-- (use column education_num)?

SELECT count(*) as num
from census
where occupation = 'Exec_managerial' AND education_num > 12;


