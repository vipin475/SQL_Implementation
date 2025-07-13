/*
	FILTERING DATA

WHERE OPERATORS
1. Comparison Operators: =, <>/!=, >, >=, <, <=
2. Logical Operators: AND, OR, NOT
3. Range Operator: BETWEEN
4. Membership Operator: IN, NOT IN
5. Search Operator: LIKE
*/


/*
	1. Comparion Opeartor: Compare two things
		Expression Operator Expression
		- Col1 = col2			first_name = last_name
		- col1 = val1			first_name = 'John'
		- Function = val		UPPER(first_name) = 'JOHN'
		- Expression = val		price*qantity = 1000
		- subquery = val		(SELECT AVG(sales) FROM orders) = 1000
*/
USE MyDatabase;

-- Retrievve all csutomers from Germany
SELECT * FROM customers WHERE country = 'GERMANY';

-- Retrieve all customers who are not from GERMANY
SELECT * FROM customers WHERE country != 'GERMANY';

-- Retrieve all customers with a score greater than 500
SELECT * FROM customers WHERE score > 500;

-- Retrieve all customers with a score of 500 or more
SELECT * FROM customers WHERE score >= 500;

-- Retrieve all customers with a score less than 500
SELECT * FROM customers WHERE score < 500;

-- Retrieve all customers with a score of 500 or less
SELECT * FROM customers WHERE score <= 500;


/*
Logical Operators
	AND - All conditions must be TRUE
	OR - Atleast one condition must be TRUE
	NOT - (Reverse) Exclude the matching values
*/

-- Retrieve all customers who are fromm USA and have a score greater than 500
SELECT * FROM customers WHERE country = 'USA' AND score > 500;

-- Retrieve all customers who are fromm USA or have a score greater than 500
SELECT * FROM customers WHERE country = 'USA' OR score > 500;

-- Retrieve all customers with a score not less than 500
SELECT * FROM customers WHERE NOT(score < 500);

/*
RANGE Operator
	BETWEEN: Check if a value is within a range
		- Lower Bounday and Upper boundary is inclusive (included in range)
*/

-- Retrieve all customers whose score falls in the range between 100 and 500
SELECT * FROM customers WHERE score BETWEEN 100 AND 500;

-- other way
SELECT * FROM customers WHERE score >= 100 AND score <= 500;


/*
	Membership Operation
	IN: Check if a value exist in a list
		- Use IN instead of OR for multiple values in the same column to simplify SQL
*/
-- Retrieve all customers from either Germany USA
SELECT * FROM customers WHERE country IN ('USA', 'Germany');

SELECT * FROM customers WHERE country = 'USA' OR country = 'Germany';

/*
Search Operator
	LIKE - Search for a pattern in text
		- '%' for Anything (0/1/Many)
		- '_' for exact 1

		Example: First char M and then anything  => M% (Maria, Ma, M)
				 Anything and ending with in     => %in (Martin, Vin)
				 Contain 'r' anywhere            => %r% (Maria, Peter, r, ra)
				 Third position should be 'b"    => __b% (Albert, Rob)

*/

-- Find all customers whose first name starts with 'M'
SELECT * FROM customers WHERE first_name LIKE 'M%';

-- Find all customers whose first name ends with 'n'
SELECT * FROM customers WHERE first_name LIKE '%n';

-- Find all customers whose first name contains 'r'
SELECT * FROM customers WHERE first_name LIKE '%r%';

-- Find all customers whose first name contains 'r' at 3rd position
SELECT * FROM customers WHERE first_name LIKE '__r%';