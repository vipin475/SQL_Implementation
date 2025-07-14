USE MyDatabase;

/*
	We have two tables - TableA and TableB
	And we want to combine them, then we have two options - 
	1. Combine Rows - SET operators (require exact same number of columns)
		SET Operator -  UNION
						UNION ALL
						EXCEPT (Minus)
						INTERSECT

	2. Combine Columns - JOIN (need Key columns)
		Types of Join - Inner Join
						Full Join
						Left Join
						Right Join
						Left Anti Join
						Right Anti Join
						Full Anti Join
						Cross Join
*/




-- No Join
-- Retrieve all data from customers and orders in two different results
Select * FROM customers;
Select *  FROM orders;

/*
	Inner Join
	- Returns only Matching rows from both tables
	- SELECT * FROM tableA [Type] JOIN tableB ON <condition> (tableA.Key = tableB.Key)
	- Default type is INNER
	- Order of table doesn't matter in INNER JOIN
	- Add the table name before the column to avoid confusion in joins with same-named columns
*/

-- Get all customers along with their orders, but only for customers who have placed an order
SELECT * 
FROM customers 
INNER JOIN orders 
ON customers.id = orders.customer_id;

-- best practice
SELECT 
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;



/*
	LEFT JOIN
	- Return all the rows from left table and only matching rows from right table
	- SELECT * FROM tableA LEFT JOIN tableB ON tableA.Key = tableB.Key
	- Order of tables is important
*/

-- Get all customers along with thier orders including those without orders
SELECT
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date
FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id;


/*
	RIGHT JOIN
	- Return all the rows from right table and only matching rows from left table
	- SELECT * FROM tableA RIGHT JOIN tableB ON tableA.Key = tableB.Key
	- Order of tables is important
*/

-- Get all customers along with thier orders including orders without matching customers
SELECT 
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date
FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id;

-- same above task with LEFT JOIN
SELECT 
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date
FROM orders as o
LEFT JOIN customers as c
ON c.id = o.customer_id;


/*
	FULL JOIN
	- Return all the rows from both table (even the rows which are not matching)
	- SELECT * FROM tableA FULL JOIN tableB ON tableA.Key = tableB.Key
	- Order of tables is not important
*/

-- Get all customers and all orders even if there's no match
SELECT
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date
FROM customers as c
FULL JOIN orders as o
ON c.id = o.customer_id;