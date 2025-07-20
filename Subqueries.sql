/*
	Advanced SQL Techniques - 
		- Subqueries
		- CTE
		- Views
		- CTAS Tables & Temp Tables
		- Stored Procedures
		- Triggers
*/

/*
	DATA WAREHOUSE
		- A special database that collects and integrates data from different sources to enable analytics and support decision-making.

	DATABASE ENGINE
		- It is the brain of the database, executing multiple operations such as storing, retrieving, and managing data within the database.


	Two types of memory in storage
	1. DISK STORAGE
		- Long-term memory, where data is stored permanently.
		+ Capacity: can hold a large amount of data.
		- Speed: slow to read and to write.

	2. CACHE STORAGE
		- Fast short-term memory, where data is stored temporarily.
		+ Speed: extremely fast to read and to write
		- Capacity: can hold smaller amout of data.


	Three types of Storages
	1. USER DATA STORAGE
		- It's the main content of the database.
		- This is where the actual data that users care about is stored.

	2. SYSTEM CATALOG
		- Database's internal storage for its own information.
		- A blueprint that keeps track of everything about the database itself, not the user data.
		- It holds the Metadata information about the database
		- Stored in INFORMATION SCHEMA 
			- A system-defined schema with built-in views that provide info about the database, like tables and columns.

	3. TEMP DATA STORAGE
		- Temporary space used by the database for short-term tasks, like processing queries or sorting data.
		- Once these tasks are done, the storage is cleared.



*/

/*
	SUBQUERIES
		- A query inside another query

	Types of Subqueries
	1. Based on dependency
		a. Non-Correlated Subquery
		b. Correlated Subquery

	2. Based on Result Types
		a. Scaler Subquery
		b. Row Subquery
		c. Table Subquery

	3. Based on Location/ Clauses
		a. In SELECT 
		b. In FROM
		c. In JOINs
		d. In WHERE
*/


/*
	Based on Result Types
		a. Scaler Subquery
			- Single value returned

		b. Row Subquery
			- Multiple rows + Single column returned

		c. Table Subquery
			- Multiple rows and Multiple columns returned

*/

-- Scaler Subquery
SELECT
	AVG(Sales)
FROM Sales.Orders;

-- Row Subquery
SELECT
	CustomerID
FROM Sales.Orders;

-- Table Subquery
SELECT
	*
FROM Sales.Orders;



/*
	Based on Location/ Clauses
		a. In SELECT 
		b. In FROM
		c. In JOINs
		d. In WHERE
*/

/*
	In FROM Clause
		- Used as Temporary table for the main query
*/
-- Find the products that have a price higher than the average price of all products.
SELECT
	*
FROM (
	SELECT
		*,
		AVG(Price) OVER() AvgPrice
	FROM Sales.Products
)t
WHERE Price > AvgPrice;

-- Rank customers based on their total amount of sales
SELECT
	*,
	RANK() OVER(ORDER BY TotalCustomerSale DESC) CustomerRank
FROM (
	SELECT
		CustomerID,
		SUM(Sales) TotalCustomerSale
	FROM Sales.Orders
	GROUP BY CustomerID
)t 
 


/*
	SELECT Subquery
		- Used to aggregate data side by side with the main query's data, allowing for direct comparison.
		- Only scaler subqueries are allowed to be used
*/

-- Show the product IDs, names, prices and total number of orders
SELECT
	ProductID,
	Product,
	Price,
	(SELECT 
		COUNT(*) 
	FROM Sales.Orders) AS TotalOrders
FROM Sales.Products;


/*
	JOIN Subquery
		- Used to prepare the data (filtering or aggregation) before joining it with other tables.
*/

-- Show all customer details and find the total orders for each customer.
SELECT
	c.*,
	o.TotalOrders
FROM Sales.Customers c
LEFT JOIN(
	SELECT
		CustomerID,
		COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID;


/*
	WHERE Subquery
		- Used for complex filtering logic and makes query more flexible and dynamic.
		- Comparision Operator - <, >, =, !=, >=, <=
		- Logical Operators = IN, ANY, ALL, EXISTS
*/

-- Find the products that have a price higher than the average price of all products
SELECT
	*,
	(SELECT AVG(Price) FROM Sales.Products) AvgPrice
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);


-- Show the details of orders made by customers in Germany
SELECT
	*
FROM Sales.Orders
WHERE CustomerID IN (
	SELECT
		CustomerID
	FROM Sales.Customers
	WHERE Country = 'GERMANY');


-- Show the details of orders for customers who are not from Germany
SELECT
	*
FROM Sales.Orders
WHERE CustomerID NOT IN (
	SELECT
		CustomerID
	FROM Sales.Customers
	WHERE Country = 'GERMANY');


-- Find female employees whose salaries are greater than the salaries of any male employees
SELECT
	*
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY (
	SELECT
		Salary
	FROM Sales.Employees
	WHERE Gender = 'M');



-- Find female employees whose salaries are greater than the salaries of all male employees
SELECT
	*
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ALL (
	SELECT
		Salary
	FROM Sales.Employees
	WHERE Gender = 'M');



/*
	NON-CORRELATED SUBQUERY
		- A Subquery that can run independtly from the Main Query
		- Executed once and its result is used by the main query
		- Can be executed on its own

	CORRELATED SUBQUERY
		- A Subquery that relays on values from the Main Query
		- Executed for each row processed by the main query
		- Can't be executed on its own.
*/

-- CORRELATED SUBQUERY
-- Show all customer details and find the total orders for each customer.
SELECT
	*,
	(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c;


/*
	EXISTS
		- Check if a subquery returns any rows
*/
-- Show the details of orders made by customers in Germany
SELECT
	*
FROM Sales.Orders o
WHERE EXISTS (SELECT 1
			FROM Sales.Customers c
			WHERE Country = 'GERMANY'
			AND o.CustomerID = c.CustomerID)

 