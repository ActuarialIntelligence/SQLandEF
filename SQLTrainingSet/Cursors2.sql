
--Now we will explain 4 important terminologies of cursors.
 
--Cursor Scope
 
--Microsoft SQL Server supports the GLOBAL and LOCAL keywords on the DECLARE CURSOR statement to define the scope of the cursor name.
--GLOBAL - specifies that the cursor name is global to the connection.
--LOCAL - specifies that the cursor name is local to the Stored Procedure, trigger, or query that holds the cursor.
--Data Fetch Option in Cursors
 
--Microsoft SQL Server supports the following two fetch options for data:
--FORWARD_ONLY - Specifies that the cursor can only be scrolled from the first to the last row.
--SCROLL - It provides 6 options to fetch the data (FIRST, LAST, PRIOR, NEXT, RELATIVE, and ABSOLUTE).
--Types of cursors
 
--Microsoft SQL Server supports the following 4 types of cursors.
--STATIC CURSOR
--A static cursor populates the result set during cursor creation and the query result is cached for the lifetime of the cursor. A static cursor can move forward and backward.

--FAST_FORWARD
--This is the default type of cursor. It is identical to the static except that you can only scroll forward.

--DYNAMIC
--In a dynamic cursor, additions and deletions are visible for others in the data source while the cursor is open.

--KEYSET
--This is similar to a dynamic cursor except we can't see records others add. If another user deletes a record, it is inaccessible from our recordset.
--Types of Locks
 
--Locking is the process by which a DBMS restricts access to a row in a multi-user environment. When a row or column is exclusively locked, other users are not permitted to access the locked data until the lock is released. It is used for data integrity. This ensures that two users cannot simultaneously update the same column in a row.
 
--Microsoft SQL Server supports the following three types of Locks.
--READ ONLY
--Specifies that the cursor cannot be updated.

--SCROLL_LOCKS
--Provides data integrity into the cursor. It specifies that the cursor will lock the rows as they are read into the cursor to ensure that updates or deletes made using the cursor will succeed.

--OPTIMISTIC
--Specifies that the cursor does not lock rows as they are read into the cursor. So, the updates or deletes made using the cursor will not succeed if the row has been updated outside the cursor.


--step 1
GO  
  
CREATE TABLE [dbo].[Employee](  
    [Emp_ID] [int] NOT NULL,  
    [Emp_Name] [nvarchar](50) NOT NULL,  
    [Emp_Salary] [int] NOT NULL,  
    [Emp_City] [nvarchar](50) NOT NULL,  
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED   
(  
    [Emp_ID] ASC  
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]  
) ON [PRIMARY]  
  
GO  

--step 2

Insert into Employee  
Select 1,'Pankaj',25000,'Alwar' Union All  
Select 2,'Rahul',26000,'Alwar' Union All  
Select 3,'Sandeep',25000,'Alwar' Union All  
Select 4,'Sanjeev',24000,'Alwar' Union All  
Select 5,'Neeraj',28000,'Alwar' Union All  
Select 6,'Naru',20000,'Alwar' Union All  
Select 7,'Omi',23000,'Alwar'

--step 3 cursor example

SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR CURSOR  
LOCAL  FORWARD_ONLY  FOR  -- these are the cursor types
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR  


--example: Example 2 (SCROLL)


SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR CURSOR  
LOCAL  SCROLL  FOR  
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
  
FETCH RELATIVE 3 FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH ABSOLUTE  3 FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH FIRST FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH LAST FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH PRIOR FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
  
  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR  

--Example 3 (STATIC CURSOR)

SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR CURSOR  
 STATIC  FOR  
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
If @EMP_ID%2=0  
BEGIN  
PRINT  'EMP_ID: ' + CONVERT(NVARCHAR(MAX),@EMP_ID)+  '  EMP_NAME '+@EMP_NAME +'  EMP_SALARY '  +CONVERT(NVARCHAR(MAX),@EMP_SALARY)  +  '  EMP_CITY ' +@EMP_CITY  
END  
FETCH  FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR  

--Example 4

SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR CURSOR  
 STATIC  FOR  
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
If @EMP_ID%2=0  
BEGIN  
UPDATE Employee SET Emp_Salary=15000 WHERE CURRENT OF EMP_CURSOR  
END  
FETCH  FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR  

--Example 5 (DYNAMIC CURSOR)

SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR CURSOR  
 DYNAMIC  FOR  
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
If @EMP_ID%2=0  
BEGIN  
UPDATE Employee SET Emp_Salary=15000 WHERE CURRENT OF EMP_CURSOR  
END  
FETCH  FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR  
SELECT * FROM Employee  

--Example 6

SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR CURSOR  
FAST_FORWARD  FOR  
SELECT * FROM Employee  
OPEN EMP_CURSOR  
FETCH NEXT FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
If @EMP_ID%2=0  
BEGIN  
UPDATE Employee SET Emp_Salary=15000 WHERE CURRENT OF EMP_CURSOR  
END  
FETCH  FROM EMP_CURSOR INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
CLOSE EMP_CURSOR  
DEALLOCATE EMP_CURSOR  


--Example 7


SET NOCOUNT ON  
DECLARE @EMP_ID INT  
DECLARE @EMP_NAME NVARCHAR(MAX)  
DECLARE @EMP_SALARY INT  
DECLARE @EMP_CITY NVARCHAR(MAX)  
  
DECLARE EMP_CURSOR1 CURSOR  
KEYSET scroll  
FOR  
SELECT  EMP_ID ,EMP_NAME,EMP_SALARY,EMP_CITY FROM Employee  order by Emp_Id  
OPEN EMP_CURSOR1  
IF @@CURSOR_ROWS > 0  
     BEGIN   
FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
WHILE @@FETCH_STATUS = 0  
BEGIN  
  
If @EMP_ID%2=0  
UPDATE Employee SET EMP_NAME='PANKAJ KUMAR CHOUDHARY' WHERE CURRENT OF EMP_CURSOR1  
FETCH NEXT FROM EMP_CURSOR1 INTO  @EMP_ID ,@EMP_NAME,@EMP_SALARY,@EMP_CITY  
END  
END  
CLOSE EMP_CURSOR1  
DEALLOCATE EMP_CURSOR1  
SET NOCOUNT OFF  
SELECT * FROM Employee  

