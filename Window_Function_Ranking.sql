/*
	WINDOW RANKING FUNCTIONS

	INTEGER-BASED Ranking
		- ROW_NUMBER()
		- RANK()
		- DENSE_RANK()
		- NTILE()

	PERCENTAGE-BASED Ranking
		- CUME_DIST()
		- PERCENT_RANK()
*/

/*
	RANK():
		- In RANK(), ORDER BY is important in OVER()
		- In NTILE(Number is required)
		- FRAME clause is not allowed, meaning the window cannnot be changed (PRECEDDING/FOLLOWING not allowed)

*/


/*
	ROW_NUMBER()
		- Assign a unique number to each in a window
		- It Doesn't handle ties
		- Unique ranking without gaps or skipping (if 80 is repeated, one iwll get 2 and other will get 3 rank)
		- ROW_NUMBER() OVER (ORDER BY Sales)
*/

-- Rank the orders based on their sales from highest to lowest
SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row
FROM Sales.Orders;


/*	
	RANK ( )
		- Assign a rank to each row in a window, with gaps
		- It handle the ties
		- Unique ranking (if 80 is repeated, all get same rank)
		- RANK() OVER (ORDER BY Sales)
*/
SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders;


/*
		DENSE RANK()
			- Assign a rank to each row in a window. without gaps
			- It handles tie
			- But doesn't leave any gaps in ranking (80 is repeated 3 time, all 3 gets 2nd rank, but next 70 will get 3rd rank (in rank it would get 5th))
			- DENSE_RANK() OVER (ORDER BY Sales)
*/
SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_DenseRank
FROM Sales.Orders;

/*
	USE CASES:
*/
-- TOP-N Analysis
-- Find the top highest sales for each product
SELECT
*
FROM(
SELECT
	OrderID,
	ProductID,
	Sales,
	RANK() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankedByProductSale
FROM Sales.Orders
)t
WHERE RankedByProductSale = 1;

-- Bottom-N analysis
-- Find the lowest 2 customers based on thier total sales
SELECT 
*
FROM(
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales)) RankedByCustSales
FROM Sales.Orders
GROUP BY CustomerID
)t WHERE RankedByCustSales <= 2;


-- GENERATE UNIQUE IDs (Row_number use case)
-- Assign unique IDs to the rows of the OrderArchieve table

SELECT
	ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
	*
FROM Sales.OrdersArchive;

-- ROW_NUMBER: Identifying Duplicated
-- Identify duplicate rows in the table 'Orders Archive' and return a clean result without any duplicates
SELECT 
*
FROM(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
		*
	FROM Sales.OrdersArchive
)t
WHERE rn = 1;


/*
	NTILE(n)
		- Divides the rows into a specified number of approximately equal groups
		- Larger group comes first (10/3 -> 4,3,3) (10/4 -> 3,3,2,2)
		- NTILE (2) OVER (ORDER BY sales)
*/
SELECT
	OrderID,
	Sales,
	NTILE(1) OVER (ORDER BY Sales DESC) OneBucket,
	NTILE(2) OVER (ORDER BY Sales DESC) TwoBucket,
	NTILE(3) OVER (ORDER BY Sales DESC) ThreeBucket,
	NTILE(4) OVER (ORDER BY Sales DESC) FourBucket
FROM Sales.Orders;


-- USECASE: Data Segmentation
-- Segment all orders into 3 categories:high, medium and low sales
SELECT
	*,
	CASE WHEN Buckets = 1 THEN 'High'
		WHEN Buckets = 2 THEN 'Medium'
		WHEN Buckets = 3 THEN 'Low'
	END SalesSegmentation
FROM
(SELECT
	OrderID,
	Sales,
	NTILE(3) OVER(ORDER BY Sales DESC) Buckets
FROM Sales.Orders
)t;

-- USECASE: Equilizing Load
-- In order to export the data, divide the orders into 2 groups
SELECT
	NTILE(2) OVER(ORDER BY OrderID) Buckets,
	*
FROM Sales.Orders;




/*	
	CUME_DIST()
		- calculates the cumulative distribution of a value within a set of values
		- CUME_DIST() OVER (ORDER BY Sales)
		- Position Nr / Number of rows
		- Tie Rule: The position of the last occurance is the calue for all
		- The current row is included

	PERCENT_RANK ()
		- Calculates the relative position of each row
		- Position Nr - 1 / Number of rows - 1
		- Tie Rule: The position of the first occurance is the calue for all
		- The current row is excluded
*/

-- Find the products that fall within the highest 40% of prices
SELECT 
	*,
	CONCAT(CumeRank*100, '%') DistRankPerc
FROM (SELECT
	Product,
	Price,
	CUME_DIST() OVER(ORDER BY Price DESC) CumeRank,
	PERCENT_RANK() OVER(ORDER BY Price DESC) PercentageRank
FROM Sales.Products
)t WHERE CumeRank <= 0.4;


