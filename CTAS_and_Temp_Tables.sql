/*
	CTAS Table & Temp Tables 
*/

/*
	Two types of tables
	1. Permanent Tables
		a. CREATE/SELECT
		b. CTAS (Create Table As SELECT)

	2. Temporary Tables

	CREATE/ INSERT
		1. Create I Define the strucutre of table.
		2. Insert I Insert Data into the table.
	
	CTAS
		- CREATE TABLE AS SELECT
		- Create a new table based on the result of an SQL query.

	CTAS vs VIEW
		- VIEW: The query of view has no+ yet been executed (when view is created, the data is populated when select statement is used)
		- CTAS: The query CTAS has been executed already (when CTAS is created, the data is populated inside the table) 

		- Querying Views is slower than querying CTAS tables
*/

/*
	----- In MySQL, Postgres, Oracle
	CREATE TABLE Name AS
	(
		SELECT ....
		FROM ....
		WHERE ....
	)


	----- In SQL Server
	SELECT .....
	INTO New-Table
	FROM ....
	WHERE ...

*/

SELECT
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)


SELECT * FROM Sales.MonthlyOrders;


-- How to update the CTAS Tables
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrders;
GO
	SELECT
		DATENAME(month, OrderDate) OrderMonth,
		COUNT(OrderID) TotalOrders
	INTO Sales.MonthlyOrders
	FROM Sales.Orders
	GROUP BY DATENAME(month, OrderDate)


	/*
		Temporary Tables
			- Stores intermediate results in temporary storage within the database during the session.
			- The database will drop all temporary tables once the session ends.
		  
		SESSION
			- The time between connecting to and disconnecting from the database.

		SELECT ...
		INTO #New-Tab1e
		FROM ...
		WHERE ...

	*/

SELECT
	*
INTO #Orders
FROM Sales.Orders;

SELECT
*
FROM #Orders;


/*
	Why to use?

	#1STEP - Load Data to TEMP Table
	#2STEP - Transform Data in TEMP Table
	#3STEP - Load TEMP Table into Permanent Table
*/
