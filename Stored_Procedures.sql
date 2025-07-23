/*
	STORED PROCEDURES (SP)
	
	-- SP Defination
		CREATE PROCEDURE ProcedureName AS 
		BEGIN
			-- SQL Statements Go here

		END

	-- SP Execution (Call)
		EXEC ProcedureName
*/

/*
	Step 1: Write a Query
	- For US Customers Find the Total Number of Customers and the Average Score
*/

SELECT
	COUNT(CustomerID) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA';

-- Step 2: Turning the Query Into a Stored Procedure

CREATE PROCEDURE GetCustomerSummary AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(Score) AvgScore
	FROM Sales.Customers
	WHERE Country = 'USA';
END;


-- Step 3: Execute the Stored Procedure
EXEC GetCustomerSummary;


/*
	Stored Procedure: PARAMETERS
		- Placeholders used to pass values as input from the caller to the procedure, allowing dynamic data to be processed. 
*/

-- For German Customers Find the Total Number of Customers and the Average Score

CREATE PROCEDURE GetCustomerSummaryGermany AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(Score) AvgScore
	FROM Sales.Customers
	WHERE Country = 'Germany'
END;

EXEC GetCustomerSummaryGermany;

-- DELETE SP
DROP PROCEDURE GetCustomerSummaryGermany;


-- AVOID REPEATATION

/*
	Parameter
		- @ParameterName Datatype
		- If you want to pass default value for that parameter, 
				@ParameterName Datatype = defaultValue
*/
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(Score) AvgScore
	FROM Sales.Customers
	WHERE Country = @Country
END;

-- Execution for Germany
EXEC GetCustomerSummary @Country = 'Germany';

-- Execution for USA
EXEC GetCustomerSummary @Country = 'USA';

-- Execution without parameter (default value will be used, USA)
EXEC GetCustomerSummary;


/*
	Multiple statements in SP
*/

-- Find the total Nr.of Orders and Total Sales


ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(Score) AvgScore
	FROM Sales.Customers
	WHERE Country = @Country;

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END;

-- Execution for Germany
EXEC GetCustomerSummary @Country = 'Germany';

-- Execution for USA
EXEC GetCustomerSummary @Country = 'USA';

-- Execution without parameter (default value will be used, USA)
EXEC GetCustomerSummary;



/*
	VARIABLES
		 - Placeholders used to store values to be used later in the procedure.
		 - Variables temporarily store and manipulate data during its execution.
*/

-- Total Customers from Germany: 2
-- Average Score from Germany: 425

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN

	DECLARE @TotalCustommrs INT, @AvgScore FLOAT;
	SELECT
		@TotalCustommrs = COUNT(CustomerID),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;

	PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustommrs AS NVARCHAR);
	PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END;

-- Execution for Germany
EXEC GetCustomerSummary @Country = 'Germany';

-- Execution for USA
EXEC GetCustomerSummary @Country = 'USA';

-- Execution without parameter (default value will be used, USA)
EXEC GetCustomerSummary;



/*
	Control Flow in SP using IF-ELSE
*/
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN

	DECLARE @TotalCustommrs INT, @AvgScore FLOAT;
	-- Preparing & Cleaning Data
	IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
	BEGIN
		PRINT('Updating NULL Scores to 0');
		UPDATE Sales.Customers
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country
	END

	ELSE
	BEGIN
		PRINT('No NULL Scores found');
	END
	
	-- Generating Report
	SELECT
		@TotalCustommrs = COUNT(CustomerID),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;

	PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustommrs AS NVARCHAR);
	PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END;

-- Execution for Germany
EXEC GetCustomerSummary @Country = 'Germany';

-- Execution for USA
EXEC GetCustomerSummary @Country = 'USA';

-- Execution without parameter (default value will be used, USA)
EXEC GetCustomerSummary;



/*
	Error Handling - Try Catch
*/

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN

	BEGIN TRY
		-- Declaration of variables
		DECLARE @TotalCustommrs INT, @AvgScore FLOAT;

		-- ==================================
		-- Step 1: Preparing & Cleaning Data
		-- ==================================
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
			PRINT('Updating NULL Scores to 0');
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country
		END

		ELSE
		BEGIN
			PRINT('No NULL Scores found');
		END
	
		-- ==================================
		-- Step 2: Generating summary report
		-- ==================================
		-- Calculate Total customers and Average score for specific country
		SELECT
			@TotalCustommrs = COUNT(CustomerID),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustommrs AS NVARCHAR);
		PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

		-- Calculate Total Number of Orders and Total Sales for specific Country
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
			ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country;
	END TRY

	BEGIN CATCH
		-- Error handling
		PRINT('An error occured');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: ' + CAST(ERROR_Line() AS NVARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH
END;

-- Execution for Germany
EXEC GetCustomerSummary @Country = 'Germany';

-- Execution for USA
EXEC GetCustomerSummary @Country = 'USA';

-- Execution without parameter (default value will be used, USA)
EXEC GetCustomerSummary;
