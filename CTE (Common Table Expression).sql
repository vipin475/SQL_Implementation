/*
	CTE (Common Table Expression)
		- Temporary, named result set (virtual table), that can be used multiple times within your query to simplify and organize complex query.

	- Subquery: Bottom to top, result can be used only once
	- CTE:  Top to bottom, result can be used any number of time (any number of places )

	CTE Types
		- Non-Recursive CTE
			- Standalone CTE
			- Nested CTE
		- Recursive CTE

	Rules:
		1. You cannot use ORDER BY directly within the CTE

*/

/*
	Standalone CTE
		- Defined and Used independently.
		- Runs independently as it's self-contained and doesn't rely on other CTEs or queries.

		- CTE Syntax
		- WITH CTE-name AS		---------> CTE Query
		  (
			SELECT....
			FROM....
			WHERE....
		  )

		  SELECT ....			----------> Main Query
		  FROM CTE-Name
		  WHERE
*/

-- Step1: Find the total Sales Per Customers
WITH CTE_Total_Sales AS
(
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)

-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte.TotalSales
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cte
ON cte.CustomerID = c.CustomerID;



/*
	Multiple Standalone CTE
*/

-- Step1: Find the total Sales Per Customers
WITH CTE_Total_Sales AS
(
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)

-- Step2: Find the last order date per customer
, CTE_Last_Order AS
(
	SELECT
		CustomerID,
		MAX(OrderDate) AS Last_Order
	FROM Sales.Orders
	GROUP BY CustomerID
)
-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte.TotalSales,
	clo.Last_Order
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cte
ON cte.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID;



/*
	Nested CTE
		- CTE inside another CTE
		- A nested CTE uses the result of another CTE, so it can't run independently.

		- Standalone CTE	WITH CTE-Name1 AS
							(
								SELECT....
								FROM...
								WHERE...
							)

		  NESTED CTE		, CTE-Name2 AS
							(
								SELECT ...
								FROM CTE-Name1
								WHERE ...
							)
*/


-- Step1: Find the total Sales Per Customers
WITH CTE_Total_Sales AS
(
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)

-- Step2: Find the last order date per customer
, CTE_Last_Order AS
(
	SELECT
		CustomerID,
		MAX(OrderDate) AS Last_Order
	FROM Sales.Orders
	GROUP BY CustomerID
)
-- Step3: Rank Customers based on total sales per customer.
, CTE_Customer_Rank AS
(
	SELECT
		CustomerID,
		TotalSales,
		RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
	FROM CTE_Total_Sales
)
-- Step4: segment customers based on their total sales
, CTE_Customer_Segments AS
(
	SELECT
		CustomerID,
		CASE WHEN TotalSales > 100 THEN 'High'
			 WHEN TotalSales > 80 THEN 'Medium'
			 ELSE 'Low'
		END CustomerSegment
	FROM CTE_Total_Sales
)

-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte.TotalSales,
	clo.Last_Order,
	ccr.CustomerRank,
	ccs.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cte
	ON cte.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
	ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
	ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
	ON ccs.CustomerID = c.CustomerID;



/*
	CTE Best Practices
		- Rethink and refactor your CTEs before starting a new one.
		- Don't use more than 5 CTEs in one query; otherwise, your code will be hard to understand and maintain.
*/

/*
	Recursive CTE
		- Self-referencing query that repeatedly processes data until a specific condition is met.
		- OPTION (MAXRECURSION N) - Limit the number of time recursion query runs


		WITH CTE-Name AS
		(
			SELECT ....			Anchor Query
			FROM ....
			WHERE ....
			
			UNION ALL
			
			SELECT				Recursive Query
			FROM CTE-Name
			WHERE [Break Condition}
		)

		-- MAIN Query
		SELECT
		FROM CTE-Name
		WHERE....
*/

-- Generate a Sequence of Numbers from 1 to 20

WITH Series AS (
-- Anchor Query
	SELECT
		1 AS MyNumber

	UNION ALL
	--Recursive Query
	SELECT
		MyNumber + 1
	FROM Series
	WHERE MyNumber < 10
)

-- Main Query
SELECT
	*
FROM Series;


-- Show the employee hierarchy by displaying each employee's level within the organization.

WITH CTE_Emp_Hierarchy AS
(
	-- Anchor Query
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID IS NULL

	UNION ALL
	-- Recursive Query
	SELECT 
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level + 1 AS Level
		FROM Sales.Employees AS e
		INNER JOIN CTE_Emp_Hierarchy ceh
		ON e.ManagerID = ceh.EmployeeID
)

-- Main query
SELECT
	*
FROM CTE_Emp_Hierarchy;