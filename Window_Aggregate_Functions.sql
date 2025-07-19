/*
	AGGREGATE WINDOW FUNCTIONS
		- AVG(Sales) OVER(PARTITION BY ProductID ORDER BY Sales)
		- Aggregate functions are COUNT, SUM, AVG, MIN, MAX

	COUNT(exp)
		- Returns the number Of Rows in a window
		- COUNT(*) OVER (PARTITION BY Product)

	SUM(exp)
		- Returns the sum of values in a window
		- SUM(*) OVER (PARTITION BY product)

	AVG(exp)
		- Returns the average of values in a window
		- AVG(*) OVER (PARTITION BY product)

	MIN(exp)
		- Returns the minimim values in a window
		- MIN(*) OVER (PARTITION BY product)

	MAX(exp)
		- Returns the maximum values in a window
		- MAX(*) OVER (PARTITION BY product)
*/


/*
	COUNT(exp)
*/
-- Find total number of orders
SELECT
	COUNT(*) TotalOrders
FROM Sales.Orders;

-- Find total number of orders, with additional details like orderID, orderDate
SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() TotalOrders
FROM Sales.Orders;

-- Find total number of orders for each customers
SELECT
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) OrderByCustomers
FROM Sales.Orders;

-- Find the total number of Customers, 
-- Find the total number of scores for the customers
-- Additionally provide All customers Details
SELECT
	*,
	COUNT(CustomerID) OVER() TotalCustomerCount,
	COUNT(Score) OVER() TotalCustScores
FROM Sales.Customers;

-- Check,whether the table 'Orders' contains any duplicate rows
SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) CheckPK
FROM Sales.Orders; 


SELECT
	*
FROM (
	SELECT
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
	)t
WHERE CheckPK > 1;


/*
	SUM(exp)
*/
-- Find the total sales across all orders and the total sales for each product
-- Additionally, provide details such as order ID and order date.
SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER() as TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) as ProductSales
FROM Sales.Orders;

-- Find the percentage contribution of each product's sales to the total sales
SELECT
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) ProductSale,
	ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() *100, 2) PercentageOfTotalSales
FROM Sales.Orders;


/*
	AVG(exp)
*/
-- Find the average sales across all orders
-- And Find the average sales for each product
-- Additionally provide details such order ld, order date
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() AvgSales,
	AVG(Sales) OVER(PARTITION BY ProductID) ProductAvgSales
FROM Sales.Orders;


-- Find the average scores of customers
-- Additionally provide details such CustomerID and LastName
SELECT
	CustomerID,
	LastName,
	Score,
	COALESCE(Score, 0) CustomerScore,
	AVG(COALESCE(Score, 0)) OVER() AvgScore
FROM Sales.Customers;

-- Find all orders where sales are higher than the average sales across all orders
SELECT
*
FROM (
SELECT 
	OrderID,
	OrderDate,
	Sales,
	AVG(Sales) OVER() AvgSales
FROM Sales.Orders
)t
WHERE Sales > AvgSales;

/*
	MIN(exp) / MAX(exp)
*/

-- Find the highest & lowest sales across all orders
-- and the highest & lowest sales for each product.
-- Additionally, provide details such as order ID and order date.

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	MIN(Sales) OVER() MinimumSale,
	MAX(Sales) OVER() MaximumSale,
	MIN(Sales) OVER(PARTITION BY ProductID) MinProductSale,
	MAX(Sales) OVER(PARTITION BY ProductID) MaxProductSale
FROM Sales.Orders;

-- Show the employees who have the highest salaries
SELECT
	*
FROM(SELECT
	*,
	MAX(Salary) OVER() MaxSalary
FROM Sales.Employees)t
WHERE Salary = MaxSalary;

-- Calculate the deviationof each sale from both the minimum and maximum sales amounts.
SELECT
	OrderID,
	Sales,
	MIN(Sales) OVER() MinSalesAmount,
	MAX(Sales) OVER() MaxSalesAmount,
	(Sales - MIN(Sales) OVER()) MinSalesAmountDeviation,
	(MAX(Sales) OVER() - Sales) MaxSalesAmountDeviation
FROM Sales.Orders;


/*
	RUNNING & ROLLING TOTAL
		- They aggregate sequence of members, and the aggregation is updated each time a new member is added

	RUNNING TOTAL
		- Aggregate all values from the beginning up to the current point without dropping off older data.

	ROLLING TOTAL
		- Aggregate all values within a fixed time window (e.g. 30 days). As new data is added, the oldest data point will be dropped.

*/

-- Calculate the moving average of sales for each product over time
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
FROM Sales.Orders;

-- Calculate the moving average of sales for each product over time, ,including only the next order
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders;