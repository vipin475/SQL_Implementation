/*
	Aggregate Functions
		- COUNT()
		- SUM()
		- AVG()
		- MAX()
		- MIN()
*/

-- Find the total number of orders, total sales, average sale, highest sale and lowest sales of all orders
USE MyDatabase;
SELECT
	customer_id,
	COUNT(*) as total_nr_orders,
	SUM(sales) AS totalSales,
	AVG(sales) AS avgSales,
	MAX(sales) AS highestSales,
	MIN(sales) AS lowestSales
FROM orders
GROUP BY customer_id;


-- Analyse the scores in customers table
USE SalesDB;
SELECT
	CustomerID,
	COUNT(*) as total_nr_orders,
	SUM(Score) AS totalSales,
	AVG(Score) AS avgSales,
	MAX(Score) AS highestSales,
	MIN(Score) AS lowestSales
FROM Sales.Customers
GROUP BY CustomerID;