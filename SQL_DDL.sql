/*
DDL - Data Defination Language

- Define structure of you data
*/

/*
CREATE - Ceate new tables with required columns, thier datatype, constraints and a PRIMARY KEY
*/
-- Create a new table called persons with columns: id, person_name, birth_date and phone
USE MyDatabase;
CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
);
SELECT * FROM persons;

/*
ALTER - Change the defination of table (add new column, deleting column, changing datatype, etc)
*/
-- add a new column called email to the persons table
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

-- The new columns are appended at the end of table by default (no way to add in middle)

-- remove the column phone fromm persons table
ALTER TABLE persons
DROP COLUMN phone;

/*
DROP - DELETING a table from database (table and its values)
*/
-- Delete the table persons from the database
DROP TABLE persons;
