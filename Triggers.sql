/*
	TRIGGERS
		- special stored procedure (set of statements) that automatically runs in response to a specific event on a table or view.

	Types of Triggers
		- DML Troggers (INSERT, UPDATE, DELETE)
		- DDL Trigger (CREATE, ALTER, DROP)
		- LOGGON 

	AFTER Trigger: Runs AFTER the Event
	INSTEAD OF Trigger: Runs during the Event


	CREATE TRIGGER TriggerName ON TableName
	AFTER INSERT, UPDATE, DELETE
	BEGIN
		- SQL STATEENTS GO HERE
	END
*/

-- Crate a table to store trigger logs
CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
)

-- Crate a Trigger on Employees Table
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New EmployeeAdded = ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END


/*
	INSERTED
		- virtual table that holds a copy of the rows that are being inserted into the target table
*/


SELECT * FROM Sales.EmployeeLogs;

INSERT INTO Sales.Employees VALUES
(6, 'Marla', 'Doe', 'HR', '1988-01-12', 'F', 8000, 3);