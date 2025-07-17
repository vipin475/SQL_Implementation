/*
	WHAT is NULL?
		NULL means nothing, unknown!
		NULL is not equal to anything!
		- NULL is not zero
		- NULL is not empty string
		- NULL is not blank space
*/

/*
	ISNULL()
		- Replace "NULL' with a specified value
		- ISNULL(value, replacement_value)	(firstvalue is column name)
		- Ex - ISNULL(Shipping_Address, 'unknown')

	COALESCE()
		- Returns the first non-null value from a list
		- COALESCE(val1, val2, val3, .....)
		- Ex - COALESCE(Shipping_address, Billing_address, 'Unknown') (returns the first non-null value from the 3)
	
	- UseCase
		- handle the NULL before doing data aggregations or mathematical operations
*/

-- Find the average scores of the customers
SELECT 
CustomerID, 
Score, 
COALESCE(Score, 0) SCORE2,
AVG(SCORE) OVER() AvgScore,
AVG(COALESCE(Score, 0)) OVER() AvgScore2
FROM Sales.Customers;


-- Display the full name of customers in a single field by merging their first and last names, and add 10 bonus points to each customer's score.

SELECT
CONCAT(FirstName, ' ', LastName) as FullName,
Score OriginalScore,
COALESCE(Score,0) +10 AddedScore
FROM Sales.Customers;

-- Alternate we can use FirstName + ' ' + COALESCE(LastName, '') AS FullName


/*
	1. Handle the Nulls before JOINING tables
		- If tableA and TableB are joining on 2 columns (year ans type) and one of them have null values in both tables, ideally that rows should come in joined inner table, but it wont come, as the joiing keys were NULL

		SELECT
		a.year, a.type, a.orders, b.sales
		FROM Table1 a,
		JOIN Table2 b
		ON a.year = b.year
		AND a.type = b.type


		instead use the following line in last line place
		AND ISNULL(a.type, '') = ISNULL(b.type, '')

	2. SORTING DATA

*/

-- Sort the customers from Lowest to highest scores, with nulls appearing at last
SELECT
CustomerID,
Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END Flag
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score;


/*
	NULLIF ( )
		- Compares two expressions returns:
		- NULL, if they are equal.
		- First Value, if they are not equal.
		- NULLIF(val1, val2)
	- UseCase: Preventing the error of dividing by zero
*/

-- Find the sales price for each order by divinding sales by quantity
SELECT
OrderId,
Sales,
Quantity,
Sales / NULLIF(Quantity, 0) As SalesPrice
FROM Sales.Orders;


/*
	IS NULL: Returns TRUE if the value is NULL, otherwise return FALSE
		- Value IS NULL
	IS NOT NULL: Returns TRUE if the value is not NULL, otherwise return FALSE
		- Value IS NOT NULL

	- Usecase: Searching for missing information
	- Usecase: Finding the unmatched rows between two tables
*/

-- Identify the customers who have no scores
SELECT 
*
FROM Sales.Customers
WHERE Score IS NULL;

-- List all customers who have scores
SELECT
*
FROM Sales.Customers
WHERE Score IS NOT NULL;

/*
	LEFT ANTI JOIN: Left Join + IS NULL
	RIGHT ANTI JOIN: Right Join + IS NULL
*/
-- Show all details for customers who have not placed any orders
SELECT
c.*
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;


/*
	NULL - means nothing, unknown!!
	EMPTY STRING '': String value has zero characters
	BLANK SPACE '': String value has one or more space characters
*/
WITH Orders AS (
SELECT 1 ld, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, ' '
)
SELECT 
*,
DATALENGTH(Category) CategoryLen
FROM Orders;


/*
	TRIM()
		- remove unwanted leading and trailing spaces from a string 

	Only use NULLs and empty strings, but avoid blank spaces.
*/

WITH Orders AS (
SELECT 1 ld, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, ' '
)
SELECT 
*,
DATALENGTH(Category) CategoryLen,
TRIM(Category) TrimCat,
DATALENGTH(TRIM(Category)) CategoryLenTrim
FROM Orders;


/*
	Only use NULLS and avoid using empty strings and blank spaces
	NULLIF()
*/
WITH Orders AS (
SELECT 1 ld, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, ' '
)
SELECT 
*,
DATALENGTH(Category) CategoryLen,
TRIM(Category) TrimCat,
NULLIF(TRIM(Category), '') CatNullIf
FROM Orders;

/*
	Use the default value 'unknown' and avoid using nulls, empty strings, and blank spaces.

	USECASE: Replacing empty strings, blanks,NULL with default value during data preparation before using it in reporting to improve readiblity and reduce confusion
*/

WITH Orders AS (
SELECT 1 ld, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, ' '
)
SELECT 
*,
DATALENGTH(Category) CategoryLen,
TRIM(Category) TrimCat,
NULLIF(TRIM(Category), '') CatNullIf,
COALESCE(NULLIF(TRIM(Category), ''), 'unknown') DefaultValues
FROM Orders;