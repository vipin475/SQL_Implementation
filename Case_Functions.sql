/*
	CASE STATEMENT
		- Evaluates a list of conditions and returns a value when the first condition is met
		- CASE 
			WHEN condition1 THEN result1
			WHEN condition2 THEN result2
			.
			.
			ELSE result
		  END

	USECASE:
		- Categorization of data: Group the data into different categories based on certain conditions.
		- Transform the values from one form to another

	RULES:
		- Datatypes of all results must be matching
		- CASE statement can be used anywhere
		- Handling NULLs
		- Conditional Aggregation: Apply aggregate functions only on subset of data that fulfill certain conditions

*/

/*	Generate a report showing the total sales for each category
		- High: If the sales higher than 50
		- Medium: If the sales between 20 and 50
		- Low: If the sales equal or lower than 20
*/
SELECT 
SalesCategory,
SUM(Sales) as TotalSales
FROM (
	SELECT
		OrderId,
		Sales,
		CASE
			WHEN Sales > 50 THEN 'High'
			WHEN Sales > 20  THEN 'Medium'
			ELSE 'Low'
		END SalesCategory
	FROM Sales.Orders
) t
GROUP BY SalesCategory
ORDER BY TotalSales DESC;


-- Retrive employee details with gender displayed as full text
SELECT 
	EmployeeID,
	FirstName,
	LastName,
	Gender,
	CASE
		WHEN Gender = 'M' THEN 'Male'
		WHEN Gender = 'F' THEN 'Female'
		ELSE 'Not Available'
	END GendarFulltext
FROM Sales.Employees;

-- Retrieve customer details wit abbreviated country code
SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE
		WHEN Country = 'USA' THEN 'US'
		WHEN Country = 'Germany' THEN 'DE'
		ELSE 'N/A'
	END CountryAbbrev
FROM Sales.Customers;

/*
	QUICK FORM: CASE Column WHEN condition1
*/
SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE Country
		WHEN 'USA' THEN 'US'
		WHEN 'Germany' THEN 'DE'
		ELSE 'N/A'
	END CountryAbbrev
FROM Sales.Customers;


-- Find average scores of customers and treat NULLs as 0, also provide details like customerID and lastName
SELECT
	CustomerID,
	LastName,
	Score,
	AVG(CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END) OVER() AvgScore,
	AVG(Score) OVER() AvgScore1
FROM Sales.Customers;

-- Count how many times each customer has made an order with sales greater than 30
SELECT
	CustomerID,
	SUM(CASE 
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) TotalOrdersHighSales,
	COUNT(*) TotalOrder
FROM Sales.Orders
GROUP BY CustomerID;