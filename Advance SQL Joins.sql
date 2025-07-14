USE MyDatabase;

/*
	LEFT ANTI JOIN
	- Return rows from left table that has no match in right table
	- SELECT * FROM tableA LEFT JOIN tableB ON tableA.Key = tableB.Key WHERE tableB.Key IS NULL
	- Order of tables is important
*/

-- Get all customers who haven't placed any order
SELECT 	
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;


/*
	RIGHT ANTI JOIN
	- Return rows from Right table that has no match in left table
	- SELECT * FROM tableA RIGHT JOIN tableB ON tableA.Key = tableB.Key WHERE tableA.Key IS NULL
	- Order of tables is important
*/

-- Get all orders without matching customers
SELECT 	
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id
WHERE c.id IS NULL;

-- same with LEFT JOIN
SELECT 	
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date FROM orders as o
LEFT JOIN customers as c
ON c.id = o.customer_id
WHERE c.id IS NULL;



/*
	FULL ANTI JOIN
	- Return only rows that don't match in either table
	- SELECT * FROM tableA FULL JOIN tableB ON tableA.Key = tableB.Key WHERE tableA.Key IS NULL OR tableB.Key IS NULL
	- Order of tables is not important
*/

-- Get customers without orders or orders without customers
SELECT 	
	c.id, 
	c.first_name,
	o.order_id,
	o.sales,
	o.order_date FROM customers as c
FULL JOIN orders as o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL;

/*
	Challenge - Get all customers along with their order but only for customers who have placed an order (without using inner join)
*/
SELECT * 
FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;


/*
	CROSS JOIN - Combine every row from Left with every row from Right
		- Alll possible combinations = Cartersion Join
		- SELECT * FROM tableA CROSS JOIN tableB
		- No consition needed
		- The order of tables doesn't matter
*/

-- Generate all possible combinations of customers and orders
SELECT * FROM customers CROSS JOIN orders;


/*
	How to choose correct type of JOIN
		- Only Matching data of two tables - INNER JOIN
		- All rows: One Side more important - LEFT/RIGHT JOIN
		- All rows: BOTH Sides are important - FULL JOIN
		- Only Unmatching: One side important - LEFT/RIGHT ANTI JOIN
		- Only Unmatching: Both Important - FULL ANTI JOIN
*/



/*
	Multi-Table JOIN
		SELECT * 
		FROM A 
		LEFT JOIN B on ....
		LEFT JOIN C on ....
		LEFT JOIN D on ....
		WHERE <conditions>		---------> Control what to keep
		LEFT JOIN B on ....
*/

/*
	Using SalesDB, Retrieve a list of all orders, along with the related customer, product, and employee details.
		For each order, display:
		- Order ID
		- Customer's name
		- Product name
		- Sales amount
		- Product price
		- Salesperson's name
*/

USE SalesDB;

SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName as CustomerFirstName,
	c.LastName as CustomerLastName,
	p.Product,
	p.Price,
	e.FirstName as EmployeeFirstName,
	e.LastName as EmployeeLastName
FROM Sales.Orders as o
LEFT JOIN Sales.Customers as c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products as p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees as e
ON o.SalesPersonID = e.EmployeeID





/*
	SET OPERATORS
		- Combining ROWS: UNION, UNIONALL, EXCEPT, INTERSECTION
		- 1st SELECT Statement (SET OPERATOR) 2nd SELECT Statement

	RULES of SET OPERATOR
		1. SQL Clauses
			- SET operators can be used almost in all clauses (WHERE, JOIN, GROUP BY, HAVING)
			- ORBER BY is allowed only once at the end of query

		2. Number of columns
			- Number of columns in each query must be same

		3. Data Types
			- Datatype of columns in each query must be compatible

		4. Order of columns
			- Order of columns in each query must be same.

		5. Column Aliases
			- The column names in the result set are determined bu the column names specified in the first query

		6. Correct Columns
			- Even if all rules are met ans SQL shows no errors, the result may be incorrect.
			- Incorrect column selection leads to inaccurate result.
*/

/*
	UNION 
		- Return all distinct rows from both queries
		- Remove duplicates from the result
*/
-- Combine the data from employees and customers into one table
SELECT FirstName, LastName FROM Sales.Customers
UNION
SELECT FirstName, LastName FROM Sales.Employees;


/*
	UNION ALL
		- Return all rows from both queries, including duplicates
*/
-- Combine the data from employees and customers into one table including duplicates
SELECT FirstName, LastName FROM Sales.Customers
UNION ALL
SELECT FirstName, LastName FROM Sales.Employees;


/*
	EXCEPT 
		- Return all distinct rows from first query that are not found in the second query
		- Order of queries affect the final result
*/
-- Find employees who are not customers at the same time
SELECT FirstName, LastName FROM Sales.Employees
EXCEPT
SELECT FirstName, LastName FROM Sales.Customers;


/*
	INTERSECT 
		- Return only the rows that are common in both queries
*/
-- Find employees who are also customers
SELECT FirstName, LastName FROM Sales.Employees
INTERSECT
SELECT FirstName, LastName FROM Sales.Customers;

-- USECASES
-- Orders are stored in separate tables (Orders and OrdersArchive).Combine all orders into one report without duplicates.

SELECT 
	'Orders' as SourceType,
	OrderID,
	ProductID,
	CustomerID,
	SalesPersonID,
	OrderDate,
	ShipDate,
	OrderStatus,
	ShipAddress,
	BillAddress,
	Quantity,
	Sales,
	CreationTime
FROM Sales.Orders
UNION
SELECT
	'OrdersArchive' as SourceType,
	OrderID,
	ProductID,
	CustomerID,
	SalesPersonID,
	OrderDate,
	ShipDate,
	OrderStatus,
	ShipAddress,
	BillAddress,
	Quantity,
	Sales,
	CreationTime
FROM Sales.OrdersArchive;


/*
	Delta Detection
		- Identifying the difference or changes (delta) between two batches of data
		- Use MINUS

	Data Completeness Check
		- EXCEPT operator can be used to compare tables to detect discrepancies between databases.
*/
