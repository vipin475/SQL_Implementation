/*
	VIEWS
		- VIEW is a virtual table that shows data without storing it physically.
		- Slow Response
		- Read Only

		CREATE VIEW View-Name AS
		(
			SELECT ...
			FROM ....
			WHERE ....
		)
*/

-- Find the running total of sales for each month

-- Using CTE
WITH CTE_Monthly_Summary AS (
	SELECT
		DATETRUNC(month, OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantity
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)
SELECT
	OrderMonth,
	TotalSales,
	TotalOrders,
	TotalQuantity,
	SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary


-- Using VIEW
CREATE VIEW Sales.V_Monthly_Summary AS
(
	SELECT
		DATETRUNC(month, OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantity
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)

SELECT
	OrderMonth,
	TotalSales,
	TotalOrders,
	TotalQuantity,
	SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM V_Monthly_Summary;


-- DELEETE VIEW
DROP VIEW V_Monthly_Summary;

-- Update view
-- No way to update view, drop and create new view
IF OBJECT_ID ('Sales.V_Monthly_Summary', 'V') IS NOT NULL
	DROP VIEW Sales.V_Monthly_Summary;
GO
CREATE VIEW Sales.V_Monthly_Summary AS
(
	SELECT
	DATETRUNC(month, OrderDate) OrderMonth,
	SUM(Sales) TotalSa1es,
	COUNT(OrderID) Tota10rders
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)


-- TASK : Provide view that combines details from orders, products, customers, and employees
CREATE VIEW Sales.V_Order_Details AS
(
	SELECT
		o.OrderID,
		o.OrderDate,
		p.Product,
		p.Category,
		COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') CustomerName,
		c.Country CustomerCountry,
		COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') SalesPersonName,
		e.Department,
		o.Sales,
		o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
		ON p.ProductID = o.ProductID
	LEFT JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
		ON e.EmployeeID = o.SalesPersonID
)


SELECT * FROM Sales.V_Order_Details;


-- Provide a view for the EU Sales Team that combines.details from all tables and excludes data related to the USA.

CREATE VIEW Sales.V_Order_Details_EU AS
(
	SELECT
		o.OrderID,
		o.OrderDate,
		p.Product,
		p.Category,
		COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') CustomerName,
		c.Country CustomerCountry,
		COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') SalesPersonName,
		e.Department,
		o.Sales,
		o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
		ON p.ProductID = o.ProductID
	LEFT JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
		ON e.EmployeeID = o.SalesPersonID
	WHERE c.Country != 'USA'
)

SELECT * FROM Sales.V_Order_Details_EU;
