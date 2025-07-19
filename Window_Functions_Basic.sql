/*
	Windows Functions Basics

	WINDOW Function
		 - Perform calculations (eg. aggregation) on a specific subset of data, without losing the level of details of rows
		 - Performs Row-level calculations
		 - Fir 4 rows are present with 2 rows of each categories, using GROUP BY will give you result in 2 rows, but WINDOW function will give you 4 records (same as total number of rows you have)

	GROUP BY - Returns a single rpw for each group (chnages the granularity)
	WINDOW - Returns a result for each row (the granularity stays the same)

	WINDOW Functions

	Type				Function Name
	Aggregate Function	COUNT, SUM, AVG, MIN, MAX
	RANK Function		ROW_NUMBER, RANK, DENSE_RANK, CUME_DIST, PERCENT_RANK, NTILE
	VALUE Function		LEAD, LAG, FIRST_VALUE, LAST_VALUE
*/

-- Find the total sales across all orders
SELECT
	SUM(Sales) TotalSale
FROM Sales.Orders;

-- Find total sales for each product
SELECT
	ProductID,
	SUM(Sales) TotalProductSale
FROM Sales.Orders
GROUP BY ProductID;


-- Find total sales for each product, additionally provide details like orderId, orderdate
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalProductSale
FROM Sales.Orders;

/*
	WINDOW Function Syntax

	Window Function: OVER Clause
						- Partition Clause
						- Order Clause
						- Prame Clause
*/

/*
	OVER()
		- Tells SQL that the function used is a Window Function
		- It defines a window or subset of data

	Ex. AVG(Sales) OVER (PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)
		
		Here -  AVG: Window Function
				Sales: Function Expression (something you pass to function, it can be anything EMPTY, Column, Number, Multiple Arguments, Conditional Logic)
				OVER: Over clasue

	PARTITION BY:
		- Divides the dataset into windows
		- multiple columns, conditions can be used
		- Optional for all window functions

		ORDER BY
		- Sort the data within a window (ASC/DESC)
		- Optional for Aggregate, but required for Rank and Value functions
*/
-- Find total sales accross all product, additionally provide details like orderId, orderdate
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() TotalProductSale
FROM Sales.Orders;

-- Find total sales for each product, additionally provide details like orderId, orderdate
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalProductSale
FROM Sales.Orders;


-- Find total sales accross all product, total sales for each product, additionally provide details like orderId, orderdate
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSale,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalProductSale
FROM Sales.Orders;



-- Find total sales accross all product, 
-- Find total sales for each product, 
-- Find the total sales for each combination of product and order status
-- additionally provide details like orderId, orderdate
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSale,
	SUM(Sales) OVER(PARTITION BY ProductID) SalesByProduct,
	OrderStatus,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductAndStatus
FROM Sales.Orders;

SELECT * FROM Sales.Orders;



/*
	ORDER BY
		- Sort the data within a window (ASC/DESC) default is ASC
		- Optional for Aggregate, but required for Rank and Value functions
*/

-- Rank each order based on their sales from highest to lowest, additionally provide details such as orderid and order date
SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) RankedSales
FROM Sales.Orders;

-- Alternative
SELECT
	OrderID,
	OrderDate,
	Sales
FROM Sales.Orders
ORDER BY Sales DESC;


/*
	WINDOW FRAME
		- Defines a subset of rows within each window that is releveant for the calculation
		- AVG(Sa1es) OVER (PARTITION BY Category ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)

		Here ROWS		->		Frame Types (Rows / Range)
			 CURRENT ROW ->		Frame Boundary (Lower value) (Current Row / N precedding / Unbounded Precedding)
			 UNBOUNDED FOLLOWING ->		Frame Boundary (Higher value) (Current Row / N Following / Unbounded Following)

	RULES
		- Frame Clause can only be used together with ORDER BY clause.
		- Lower Value must be BEFORE the higher Value.

	UNBOUNDED FOLLOWING
		- The last possible row within a window
	
	N PRECEDDING
		- The n-th row before the current row

	UNBOUNDED PRECEDING
		- The first possible rov within a window	
*/

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders;

/*
	COMPACT FRAME
		- For only PRECEDING, the CURRENT ROW can be skipped
			NORMAL FORM - ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
			SHORT FORM - ROWS 2 FOLLOWING

*/

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) TotalSales
FROM Sales.Orders;

-- same result using 
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS 2 PRECEDING) TotalSales
FROM Sales.Orders;


/*
	DEFAULT FRAME
		- SQL uses Default Frame, if ORDER BY is used without FRAME
		- DEFAULT FRAME is ROWS BETWEEN UNBOUNDED PRECEDDING AND CURRRENT ROW
*/

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate) TotalSales
FROM Sales.Orders;

-- SAME RESULT USING SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDDING AND CURRRENT ROW) TotalSales
-- SAME RESULT using SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS  UNBOUNDED PRECEDDING) TotalSales

/*
	RULES 

	1. Window functions can be used ONLY in SELECT and ORDER BY Clauses (can't use windows function to filter data)
	2. Nesting Windows Functions is not allowed
	3. SQL execute WINDOW Functions after, WHERE Clause
	4. Window Function can be used together with GROUP BY in the same query, ONLY if the same column are used
*/

-- Find the total sales for each order status, only for two products 101 and 102
SELECT
	OrderID,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101, 102);

-- Rank the customers based on their total sales
SELECT
	CustomerID,
	SUM(Sales) TotalSale,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankedCustomer
FROM Sales.Orders
GROUP BY CustomerID;