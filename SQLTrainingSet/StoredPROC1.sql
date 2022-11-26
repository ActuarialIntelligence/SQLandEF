--What is a Stored Procedure?
--A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.

--So if you have an SQL query that you write over and over again, save it as a stored procedure, and then just call it to execute it.

--You can also pass parameters to a stored procedure, so that the stored procedure can act based on the parameter value(s) that is passed.

--Stored Procedure Syntax :

CREATE PROCEDURE procedure_name
AS
--sql_statements
GO;

--Execute a Stored Procedure
EXEC procedure_name;

--Stored Procedure Example
--The following SQL statement creates a stored procedure named "SelectAllCustomers" that selects all records from the "Customers" table:

--Example

--CREATE PROCEDURE SelectAllCustomers -- can be the only ststement in the batch script
--AS
--SELECT * FROM Customers
--GO;

--Execute the stored procedure above as follows:

--Example

EXEC SelectAllCustomers;

