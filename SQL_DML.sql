/*
DML - Data Manipulation Langauge
*/

-- 1. Manual inserting
/*
INSERT INTO table_name (col1, col2, col3...)
VALUES (value1, value2, value3)

	- Match the number of columns adn values
	- Multiple values can be inserted a time
	- Columns and values must be in same order
	- RULE: Amtching Datatype, Column Count and Constraints
	- You can skip the columns if you insert values for every column
	- Columns not included in INSERT become NULL (unless a default or constraint exist)
*/
INSERT INTO customers(id, first_name, country, score)
VALUES (6, 'Anna', 'USA', NULL);

INSERT INTO customers(id, first_name, country, score)
VALUES 
	(7, 'SAM', NULL, 100),
	(8, 'JACK', 'UK', NULL);

-- You can skip the columns if you insert values for every column
INSERT INTO customers
VALUES 
	(9, 'Andreas', 'Germany', 260);

-- Columns not included in INSERT become NULL (unless a default or constraint exist)
INSERT INTO customers(id, first_name)
VALUES 
	(10, 'Sarah');

SELECT * FROM customers;


/*
2. Insert using SELECT (from another table)
*/
-- Insert data from 'customers' into 'persons'
INSERT INTO persons (id, person_name, birth_date, phone) SELECT id, first_name, NULL, 'Unknown' FROM customers;

SELECT * FROM persons;

/*
UPDATE - change the content of already existing rows
	UPDATE table_name SET col1 = val1, col2 = val2 WHERE condition
	- Always use WHERE to avoid UPDATING all rows unintentionally
*/

-- change the score of customer with ID 6 to 0
SELECT * FROM customers where id = 6;

UPDATE customers 
	SET score = 0 
	WHERE id = 6;

-- change the score of customer with ID 10 to 0 and update the country to 'UK'
SELECT * FROM customers WHERE id = 10;

UPDATE customers 
	SET score = 0,
		country = 'UK'
	WHERE id = 10;

-- update all customers with NULL scores by seeting their score to 0
SELECT * FROM customers WHERE score IS NULL;

UPDATE customers
SET score = 0
WHERE score IS NULL;

/*
DELETE - Delete existing rows
	DELETE FROM table_name WHERE condition
	- Always use WHERE to avoid DELETING all rows unintentionally
*/

-- delete all customers with an ID greater than 5
DELETE FROM customers WHERE ID > 5;

SELECT * FROM customers;

-- delete all data from table persons
DELETE FROM persons;

/*
TRUNCATE - Clears the whole table at once without checking or logging
	TRUNCATE TABLE table_name
*/
TRUNCATE TABLE persons;