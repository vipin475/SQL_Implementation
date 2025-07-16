/*
	SQL Functions: A built-in SQL code:
		- accepts an input value
		- processes it
		- returns an output value

	Two types of functions:
		- Single row Functions (Row-Level-Calculations)
			- String functions
			- Numeric functions
			- Date & Time functions
			- Null Functions

		- Multi row Functions (Aggregation)
			- Aggregate Functions (Basic)
			- Window Functions (Advance)

	Nested Functions - Functions used inside the function
		- Maria -> Left(2) -> Ma -> LOWER() -> ma
		- LOWER(LEFT('Maria', 2))

*/


/*
	STRING Functions
		- Manipulation		- Calculation		- String Extraction
			- CONCAT			- LEN				- LEFT
			- UPPER									- RIGHT
			- LOWER									- SUBSTRING
			- TRIM
			- REPLACE
*/

USE MyDatabase;


-- CONCAT: Combine multiple strings into one value
-- Show a list of customers first names together with their country in one column
SELECT CONCAT(first_name, '-', country) AS name_country FROM customers;

-- UPPER: Convert all characters to uppercase
-- LOWER: Convert all characters to lowercase
SELECT UPPER(first_name) FROM customers;
SELECT LOWER(first_name) FROM customers;

-- TRIM: Removes Leading and Trailing spaces
-- Find customers whose firstname contains leading or trailing spaces
SELECT 
	first_name,
	LEN(first_name) as len_name,
	LEN(TRIM(first_name)) as len_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) AS flag
FROM customers 
WHERE LEN(first_name) != LEN(TRIM(first_name));
-- WHERE first_name != TRIM(first_name);


-- REPLACE: Replaces specific character with a new character
-- Remove dashes (-) from a phone number
SELECT '123-456-789' AS phone, REPLACE('123-456-789', '-', '') AS clean_phone;

-- Replace File Extension from txt to csv
SELECT 'report.txt' AS original_file, REPLACE('report.txt', 'txt', 'csv') AS updated_file;


-- LEN: Count how many characters are in the value
-- Calculate the length of each customer's first name
SELECT
	first_name,
	LEN(first_name)
FROM customers;



/*
	LEFT: Extracts specific Number of Characters from the start
	RIGHT: Extracts specific Number of Characters from the end
*/
-- Retrieve the first two characters of each first name
SELECT 
	first_name, 
	LEFT(TRIM(first_name), 2), 
	RIGHT(TRIM(first_name), 2) 
FROM customers;


/*
	SUBSTRING: Extracts a part of string at a specified position
*/
-- Retrieve a list of customers' first names removing the first character
SELECT
	first_name,
	SUBSTRING(TRIM(first_name), 2, LEN(first_name))
FROM customers;



/*
	NUMERIC Functions
*/
-- ROUND
SELECT 
	3.516,
	ROUND(3.516, 2) AS round_2,
	ROUND(3.516, 1) AS round_1,
	ROUND(3.516, 0) AS round_0;

-- ABS: Returns the absolute (positive) value of a number, removing any negative sign
SELECT 
	-10,
	ABS(-10) as abs_val,
	ABS(10);


/*
	DATE & TIME Functions
		-		Date		Time
			2025-08-20		18:55:45
			year month day	hours minutes seconds
					TIMESTAMP
*/
USE SalesDB;

SELECT
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime,
	'2025-08-20' HardCoded,
	GETDATE() Today
FROM Sales.Orders;

-- GATEDATE() : Returns the current date and time at the monent when the query is executed.

/*
	FUNCTIONS for DATE & TIME
		- Extract parts of date
		- Change format of date
		- Date calculations (add dates, subtract dates)
		- Validate dates, if correct date is passed or not

		Part Extract	Format & Casting	Calculations	Validation
		- DAY			- FORMAT			- DATEADD		- ISDATE
		- MONTH			- CONVERT			- DATEDIFF
		- YEAR			- CAST
		- DATEPART
		- DATENAME
		- DATETRUNC
		- EOMONTH
*/

/*
	DAY() - returns the day from the date
	MONTH() - returns the month from the date
	YEAR() - returns the year from the date
*/

SELECT
	'2025-08-20',
	DAY('2025-08-20') AS day,
	MONTH('2025-08-20') AS month,
	YEAR('2025-08-20') AS year;

SELECT
	OrderID,
	CreationTime,
	DAY(CreationTime) AS day,
	MONTH(CreationTime) AS month,
	YEAR(CreationTime) AS year
FROM Sales.Orders;

/*
	DATEPART() - Returns a specific part of a date as a number
		- DATEPART(part, date)
*/

SELECT
	OrderID,
	CreationTime,
	DATEPART(month, CreationTime) AS month,
	DATEPART(mm, CreationTime) AS month2,
	DATEPART(year, CreationTime) AS year,
	DATEPART(quarter, CreationTime) AS quarter,
	DATEPART(hour, CreationTime) AS hour,
	DATEPART(day, CreationTime) AS day,
	DATEPART(weekday, CreationTime) AS weekday,
	DATEPART(week, CreationTime) AS week
FROM Sales.Orders;


/*
	DATENAME() - Returns the name of a specific part of a date
		- DATENAME(part, date)
*/
SELECT
	OrderID,
	CreationTime,
	DATENAME(month, CreationTime) AS month,
	DATENAME(mm, CreationTime) AS month2,
	DATENAME(year, CreationTime) AS year,
	DATENAME(quarter, CreationTime) AS quarter,
	DATENAME(hour, CreationTime) AS hour,
	DATENAME(day, CreationTime) AS day,
	DATENAME(weekday, CreationTime) AS weekday,
	DATENAME(week, CreationTime) AS week
FROM Sales.Orders;



/*
	DATETRUNC() - Truncate the date to a specific part
		- DATETRUNC(part, date)
		- the date till the part is kept and rest of the part is reset
*/
SELECT
	OrderID,
	CreationTime,
	DATETRUNC(second, CreationTime) AS second,
	DATETRUNC(minute, CreationTime) AS minutes,
	DATETRUNC(hour, CreationTime) AS hour,
	DATETRUNC(day, CreationTime) AS day,
	DATETRUNC(week, CreationTime) AS week,
	DATETRUNC(month, CreationTime) AS month,
	DATETRUNC(quarter, CreationTime) AS quarter,
	DATETRUNC(year, CreationTime) AS year
FROM Sales.Orders;



SELECT
 DATETRUNC(month, CreationTime),
 COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month, CreationTime);



/*
	EOMONTH - Returns the last day of the month
*/

SELECT '2025-08-15', EOMONTH('2025-08-15');

SELECT
	OrderID,
	CreationTime,
	EOMONTH(CreationTime),
	CAST(DATETRUNC(month, CreationTime) AS DATE) StartOfMonth
FROM Sales.Orders;


-- How many orders were placed each year
SELECT
	YEAR(orderDate) Year,
	COUNT(*)
FROM Sales.Orders
GROUP BY YEAR(orderDate);

-- How many orders were placed each month
SELECT 
	DATENAME(month, orderDate),
	COUNT(*)
FROM Sales.Orders
GROUP BY DATENAME(month, orderDate);


-- Show all orders that were placed during the month of february
SELECT
*
FROM Sales.Orders
WHERE LOWER(DATENAME(month, OrderDate)) = 'february';

/*
	- Filtering data using an integer is faster than using a string
	- Avoid using DATENAME for filterinng data, instead use DATEPART
*/


/*
	When to use which function?
	- Day, Month	-> Numeric		-> DAY(), MONTH()
					-> FULL NAME	-> DATENAME()
	- YEAR							-> YEAR()
	- OTHER PART					-> DATEPART()
*/


/*
	Format & Casting 
	- What is date format?
	- yyyy-MM-dd hh:mm:ss (International standard) - SQL
	- MM-dd-yyyy (USA Standard)
	- dd-MM-yyyy (European Standard)

	FORMATTING
		- Changing the format of a value from one to another
		- Changing how the data looks like
		- CONVERT Function()

	CASTING
		- Change the datatype
		- Date to string, String to date, String to number
		- CAST/CONVERT
*/

-- FORMAT(): Formats a date or Time value
-- FORMAT(value, format, [,culture])
-- default culture - en-US

SELECT
	OrderDate,
	FORMAT(OrderDate, 'MM/dd/yyyy') as USA_format,
	FORMAT(OrderDate, 'dd/MM/yyyy') as EURO_format,
	FORMAT(OrderDate, 'dd/MM/yyyy', 'ja-JP') as japan_df,
	FORMAT(OrderDate, 'dd') as dd,
	FORMAT(OrderDate, 'ddd') as ddd,
	FORMAT(OrderDate, 'dddd') as dddd,
	FORMAT(OrderDate, 'MM') as MM,
	FORMAT(OrderDate, 'MMM') as MMM,
	FORMAT(OrderDate, 'MMMM') as MMMM,
	FORMAT(123.4, 'D', 'fr-FR')
FROM Sales.Orders;

-- Show CreationTime using following format - DAY Wed JAN Q1 2025 12:34:56 PM
SELECT
	CreationTime,
	CONCAT(
		'DAY ', 
		FORMAT(CreationTime, 'ddd MMM'),
		' Q',
		DATEPART(quarter, CreationTime),
		' ',
		FORMAT(CreationTime, 'yyyy hh:mm:ss tt')
	) as CustomFormat
FROM Sales.Orders;

/*
	Data Aggregation
*/
SELECT
	FORMAT(OrderDate, 'MMM yy'),
	COUNT(*) as OrderCOunt
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy');


/*
	Data Standardization (2025-08-20 18:55:45)

	FORMAT		DESCRIPTION						RESULT
	D			Full day name					Wednesday, August 20, 2505
	d			Day of the month				8/20/2025
	dd			Day of the month (2-digit)		20
	ddd			Abbreviated day name			Wed
	dddd		Full day name					Wednesday
	M			Month Number					August 20
	MM			Month Number (2-digit)			8
	MMM			Abbreviated Month name			Aug
	MMMM		Full Month name					August
	yy			Year (2-digit)					25
	yyyy		Year (4-digit)					2025
	hh			Hour (12-hour format)			06
	HH			Hour (24-hour format)			18
	m
	mm			Minutes (2-digits)				55
	s			Seconds							2025-08-20T18:55:45
	ss			Seconds (2-digits)				45
	f			Fractional seconds(1-digit)		Wednesday, August 20, 2025 6:55 PM
	ff			Fractional seconds(1-digit)		00
	fff			Fractional seconds(1-digit)		000
	tt			MA/PM designator				PM

*/



/*
	Number Format Specifiers - 1234.56

	FORMAT	DESCRIPTION				Result
	N		Numeric Default			1,234.56
	P		Percentage				123,456.00 %
	C		Currency				$ 1,234.56
	E		Scientific Notation		1,23E+09
	F		Fixed-point				1234.56
	N0		Numeric No decimals		1,235
	N1		Numeric 1 decimals		1,234.6
	N2		Numeric 2 decimals		1,234.56
*/

/*
	CONVERT()
		- Converts a date or time value to a different data type and formats the value
		- CONVERT(data_type, value, [style])
*/

SELECT CONVERT(INT, '123'),
CONVERT(DATE, '2025-06-04'),
CreationTime,
CONVERT(DATE, CreationTime) FROM Sales.Orders;

SELECT
CONVERT(VARCHAR, CreationTime, 32) AS [USA Std Style],
CONVERT(VARCHAR, CreationTime, 34) AS [Euro Std Style]
FROM Sales.Orders;

/*
	ALL STYLES

	1.Date

	STYLE	Format			Example
	1		mm/dd/yy		12/30/25
	2		YY.mm.dd		25.12.30
	3		dd/mm/yy		30-12-2025
	4		dd.mm.yy		30.12.25
	5		dd-mm-yy		30-12-2025
	6		dd-Mon-yy		30-Dec-25
	7		Mon dd, yy		Dec 30, 25
	10		mm-dd-yy		12-30-25
	11		yy/mm/dd		25-12-1930
	12		yymmdd			251230
	23		yyyy-mm-dd		30-12-2025
	31		YYYY-dd-mm		2025-30-12
	32		mm-dd-yyyy		12-30-2025
	33		mm-yyyy-dd		12-2025-30
	34		dd-mm-yyyy		30-12-2025
	35		dd-yyyy-mm		30-2025-12
	101		mm/dd/yyyy		12/30/2025
	102		yyyy.mm.dd		2025.12.30
	103		dd/mm/yyyy		30-12-2025
	104		dd.mm.yyyy		30.12.2025
	105		dd-mm-yyyy		30-12-2025
	106		dd Mon yyyy		30-Dec-25
	107		Mon dd, YYYY	Dec 30, 2025



	2. TIME
	STYLE	FORMAT			Example
	8		hh:mm:ss		00:38:54
	14		hh:mm:ss:nnn	00:38:84:840
	24		hh:mm:ss		00:38:54
	108		hh:mm:ss		00:38:54
	114		hh:mm:ss:nnn	00:38:54:840

	3. Datetime2

	STYLE		Format								Exam le
		0		Mon dd yyyy hh:mm AM/PM				Dec 30 2025 12:38AM
		9		Mon dd yyyy hh:mm:ss:nnn AM/PM		Dec 30 2025 12:38:58:840AM
		13		dd Mon yyyy hh:mm:ss:nnn AM/PM		30-Dec-2025 00:38:58:840AM
		20		yyyy-mm-dd hh:mm:ss					30-12-2025 00:38:58
		21		yyyy-mm-dd hh:mm:ss:nnn				30-12-2025 00:38:58:840
		22		mm/dd/yy hh:mm:ss AM/PM				12/30/25 12:38:54 AM
		25		yyyy-mm-dd hh:mm:ss:nnn				30-12-2025 00:38:58:840
		26		yyyy-dd-mm hh:mm:ss:nnn				2025-30-12 00:38:58:840
		27		mm-dd-yyyy hh:mm:ss:nnn				12-30-2025 00:38:58:840
		28		mm-yyyy-dd hh:mm:ss:nnn				12-2025-30 00:38:58:840
		29		dd-mm-yyyy hh:mm:ss:nnn				30-12-2025 00:38:58:840
		30		dd-yyyy-mm hh:mm:ss:nnn				30-2025-12 00:38:58:840
		100		Mon dd yyyy hh:mm AM/PM				Dec 30 2025 12:38AM
		109		Mon dd yyyy hh:mm:ss:nnn AM/PM		Dec 30 2025 12:38:58:840AM
		113		dd Mon yyyy hh:mm:ss:nnn			30-Dec-25  00:38:58:840AM
		120		yyyy-mm-dd hh:mm:ss					2025-12-30  00:38:58
		121		yyyy-mm-dd hh:mm:ss:nnn				2025-12-30  00:38:58:840
		126		yyyy-mm-dd T hh:mm:ss:nnn			2025-12-30T00:38:58:840
		127		yyyy-mm-dd T hh:mm:ss:nnn			2025-12-30T00:38:58:840
*/


/*
	CAST() 
		- Converts a value to a specified data type
		- CAST(value AS data_type)
*/

SELECT
CAST( '123' AS INT) AS [String to Int],
CAST(123 AS VARCHAR) AS [Int to String],
CAST('2025-08-20' AS DATE) AS [String to Date],
CAST('2025-08-20' AS DATETIME2) AS [String to Datetime],
CreationTime,
CAST(CreationTime AS DATE) AS [Datetime to Date]
FROM Sales.Orders;


/*
	Date Calculations

	DATEADD()
		- Adds or Subtracts a specific time interval to/from a date
		- DATEADD(part, interval, date)
*/
SELECT
	OrderDate,
	DATEADD(year, 2, OrderDate) AS TwoYearsLater,
	DATEADD(month, -5, OrderDate) AS FiveMonthsEarlier,
	DATEADD(day, 10, OrderDate) AS TenDaysLater
FROM Sales.Orders;


/*
	DATEDIFF()
		- Find the difference between two dates
		- DATEDIFF(part, start_date, end_date)
*/
-- Calculate the age of employees
SELECT
	EmployeeID,
	CONCAT(FirstName, '' , LastName) AS FullName,
	DATEDIFF(year, BirthDate, GETDATE()) AS Age
FROM Sales.Employees;

-- Find the average shipping duration in days for each month
SELECT
	DATENAME(month, OrderDate) as OrderDate,
	AVG(DATEDIFF(day, OrderDate, ShipDate)) as ShippingDuration
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);


-- GAP Analysis
-- Find the number of days between each order and the previous order
SELECT
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER(ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER(ORDER BY OrderDate), OrderDate)
FROM Sales.Orders;


/*
	Date Validation
	ISDATE()
		- Check if a value is a date
		- Returns 1, if the string value is a valid date
		- ISDATE(value)
*/
SELECT ISDATE('sdf'), ISDATE('2025-06-12')


SELECT
	--CAST(OrderDate AS DATE) orderDate,
	OrderDate,
	ISDATE (OrderDate),
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		 ELSE '9999-01-01'
	END NewOrderDate
FROM
(
SELECT '2025-08-20' AS OrderDate UNION
SELECT '2025-08-21' UNION
SELECT '2025-08-23' UNION
SELECT '2025-08'
)t