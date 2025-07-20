/*
	VALUE WINDOW FUNCTIONS
		- Access a value from other row
		- Order Clause is required in all

	LEAD(expr, offset, default)
		- FRAME clasue is not allowed
		- Returns the value from a previous row within a window
		- LEAD (Sales, 2, 0) OVER (ORDER BY OrderDate)

	LAG(expr, offset, default)
		- FRAME clasue is not allowed
		- Returns the value from a sunsequent row within a window
		- LAG (Sales, 2, 0) OVER (ORDER BY OrderDate)

	FIRST_VALUE(expr)
		- FRAME clasue is optional
		- Returns the first in a window
		- FIRST_VALUE(Sales) OVER (ORDER BY OrderDate)

	LAST_VALUE(expr)
		- FRAME clasue should be used
		- Returns the last in a window
		- LAST_VALUE(Sales) OVER (ORDER BY OrderDate)


	Things to remember:
		- Offset (optional): Number of rows forward or backward from currtent row (default 1)
		- Default Value (optional): Returns default value if next/previous row is not available (default NULL)
*/

-- Analyze the month-over-month (MOM) performance by finding the percentage change in sales between the current and previous month
SELECT
	*,
	CurrentMonthSale - PreviousMonthSale as MOM_Change,
	ROUND((CAST(CurrentMonthSale AS FLOAT) - PreviousMonthSale)/PreviousMonthSale * 100, 1) as MOM_Perc
FROM(
	SELECT
		Month(OrderDate) OrderMonth,
		SUM(Sales) CurrentMonthSale,
		LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSale
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)t;


-- Analyze customer loyalty by ranking customers based on the average number of days between orders
SELECT
	CustomerID,
	AVG(DaysBetweenOrder) AvgDaysCustomerOrder,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysBetweenOrder), 99999)) RankedCustomer
FROM(
SELECT
	OrderID,
	CustomerID,
	OrderDate,
	LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) PreviousDate,
	DATEDIFF(DAY, LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) DaysBetweenOrder
FROM Sales.Orders
)t GROUP BY CustomerID;


-- Find the lowest and highest sales for each product
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSale2,
	MAX(Sales) OVER(PARTITION BY ProductID) HighestSale3
FROM Sales.Orders;



-- Find the difference in sales between the current and the lowest sales
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM Sales.Orders;