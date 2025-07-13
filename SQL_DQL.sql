-- Use this database
USE MyDatabase;

/*
SELECT - statement for viewing all data from customer data
	SELECT * FROM table;
*/
SELECT * FROM customers;

-- Retrieve all data from order
SELECT * FROM orders;

-- select few columns from table
SELECT 
	first_name,
	country,
	score 
from customers;

/* 
WHERE - filter our data based on condition
	SELECT * FROM table WHERE condition;
*/
-- select customers having score higher 500
SELECT * FROM customers WHERE score > 500;
SELECT first_name, score FROM customers WHERE score > 500;

-- select customer having score not equal to zero
SELECT * FROM customers WHERE score != 0;

-- retrieve customers from Germany
SELECT * FROM customers WHERE country = 'Germany';

/*
ORDERBY - Sort your data (asc or desc)
	SELECT * FROM table ORDER BY column name ASC/DESC (ASC by default)
*/
-- view data sorted by score desc
SELECT * FROM customers ORDER BY score DESC;

/*
NESTED SORTING
	SELECT * FROM table ORDER BY column 1 (ASC/DESC), column2 (ASC/DESC)....;
*/
-- Sorting by country and then by score
SELECT * FROM customers ORDER BY country ASC, score DESC;

/*
GROUP BY - Aggregate your data (combine the rows with same values)
	It agregate a column by another column
	SELECT category (column name) SUM(score) (Aggragation) FROM table GROUP BY country
*/
-- Find total scores by country
SELECT 
	country, 
	SUM(score) AS total_score 
FROM customers 
GROUP BY country;

-- Find total scores by country ans first)name
SELECT 
	country,
	first_name,
	SUM(score) AS total_score 
FROM customers 
GROUP BY country, first_name;

-- find total score and total number of customer for each country
SELECT
	country,
	SUM(score) as total_score,
	COUNT(id) as total_customer
FROM customers
GROUP BY country;

/*
HAVING - Filter Aggregated Data (filter data after Aggregation) 
	can be used only with Group by
	SELECT country, SUM(score) FROM table GROUP BY country HAVING condition
*/
-- find countries whos total score is grater than 800
SELECT 
	country,
	SUM(score) as total_score
FROM customers
GROUP BY country
HAVING SUM(score) > 800;

-- Filter your data before aggregation  - WHERE
-- Filter your data after aggregation - HAVING

-- find the average score of each country, considerinng only customers with  a score not equal to 0 and return only those counties with an average score greater than 430
SELECT
	country,
	AVG(score) as savg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

/*
DISTINCT - With SELECT: Removing Duplicates
	Each value appears only once
	SELECT DISTINCT col FROM table;
*/
-- return unique list of all countries
SELECT DISTINCT country from customers;

/*
TOP (LIMIT) - Limit your data
	Restrict the number of rows returned (also known as LIMIT in other dbs)
	SELECT TOP N * FROM table
*/
-- return only 3 customers
SELECT TOP 3 * FROM customers;

-- retrieve top 3 customers with highest socres
SELECT TOP 3 * FROM customers ORDER BY score DESC;

-- retrieve the lowest 2 customers based on the score
SELECT TOP 2 * FROM customers ORDER BY score ASC;

-- get the two most recent orders
SELECT TOP 2 * FROM orders ORDER BY order_date DESC;

/*
EXECUTION ORDER
	1. FROM
	2. WHERE
	3. GROUP BY
	4. HAVING
	5. SELEFCT DISTINCT
	6. ORDER BY
	7. TOP
*/


/*
CODING ORDER
	SELECT DISTINNCT TOP 2
		col1,
		col2
	FROM table
	WHERE col = 10
	GROUP BY col1
	HAVINNG SUM(col2) > 30
	ORDER BY col1 ASC
*/


/*
MULTI QUERY
*/
SELECT * FROM customers;
SELECT * FROM orders;

/*
STATIC (Fixed) Values
*/
SELECT 123 as static_number;
SELECT 'hello' as static_string;
SELECT id, first_name, 'New Customer' as customer_type from customers;

