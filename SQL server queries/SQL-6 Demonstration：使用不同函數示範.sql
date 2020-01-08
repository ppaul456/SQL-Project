ㄏノずㄧ计
-- Step 1: Open a new query window to the TSQL database
USE TSQL2;
GO
-- Step 2: Select and execute the following queries to illustrate
-- scalar functions

SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders;

SELECT ABS(-1.0), ABS(0.0), ABS(1.0);

SELECT CAST(SYSDATETIME() AS DATE) AS [current_date];

SELECT DB_NAME() AS [Current Database];

-- Step 3: Select and execute the following query to illustrate
-- a simple Aggregate function demo without GROUP BY
-- (GROUP BY will be covered in a later module)
SELECT COUNT(*) AS numorders, SUM(unitprice) AS totalsales
FROM Sales.OrderDetails;

-- Step 4: Select and execute the following query to illustrate
-- a simple ranking function
SELECT TOP(5) productid, productname, listprice,
    RANK() OVER(ORDER BY listprice DESC) AS rankbyprice
FROM Production.Products
ORDER BY rankbyprice;

------------------------------------------------------------------------------------------------
ㄏノ锣传ㄧ计
-- Step 1: Open a new query window to the TSQL database
USE TSQL2;
GO
-- Step 2: Select and execute the following query to illustrate
-- the CAST function
-- This will succeed
SELECT CAST(SYSDATETIME() AS DATE);

-- Step 3: Select and execute the following query to illustrate
-- the CAST function
-- THIS WILL FAIL
SELECT CAST(SYSDATETIME() AS INT);

-- Step 4a: Select and execute the following query to illustrate
-- the CONVERT function
-- This will succeed at converting datetime2 to date
SELECT CONVERT(DATE, SYSDATETIME());

-- Step 4b:
-- THIS WILL FAIL at converting datetime2 to int
SELECT CONVERT(INT, SYSDATETIME());

-- Step 5: Select and execute the following query to illustrate
-- CONVERT with datetime data and a style option
SELECT  CONVERT(datetime, '20120212', 102) AS ANSI_style ;
SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP,112) AS ISO_style;

-- Step 6: Select and execute the following query to illustrate
-- PARSE converting a string date to a US-style date
SELECT PARSE('01/02/2012' AS datetime2 USING 'en-US') AS parse_result; 

-- Step 7: Select and execute the following query to illustrate
-- PARSE converting a string date to a UK-style date
SELECT PARSE('01/02/2012' AS datetime2 USING 'en-GB') AS parse_result; 

-- Step 8a: Select and execute the following query to illustrate
-- TRY_PARSE compared to PARSE
-- THIS WILL FAIL
SELECT PARSE('SQLServer' AS datetime2 USING 'en-US') AS parse_result;

-- Step 8b:
-- This will succeed
SELECT TRY_PARSE('SQLServer' AS datetime2 USING 'en-US') AS try_parse_result;


------------------------------------------------------------------------------------------------
ㄏノ呸胯ㄧ计
-- Step 1: Open a new query window to the TSQL database
USE TSQL2;
GO

-- Step 2: Select and execute the following query to illustrate
--the ISNUMERIC function with a character input
SELECT ISNUMERIC('SQL') AS isnmumeric_result;

-- Step 3: Select and execute the following query to illustrate
--the ISNUMERIC function with a float input
SELECT ISNUMERIC('1E3') AS isnumeric_result;

-- Step 4: Select and execute the following query to illustrate
--the IIF Function
SELECT 	productid, listprice, IIF(listprice > 50, 'high','low') AS pricepoint
FROM Production.Products;


-- Step 5: Select and execute the following query to illustrate
--the CHOOSE function
SELECT CHOOSE (3, 'Beverages', 'Condiments', 'Confections') AS choose_result;


------------------------------------------------------------------------------------------------
ㄏノㄧ计矪瞶 NULL
-- Step 1: Open a new query window to the TSQL database
USE TSQL2;
GO

-- Step 2: Select and execute the following query to illustrate
-- The ISNULL function
SELECT custid, city, ISNULL(region, 'N/A') AS region, country
FROM Sales.Customers;

-- Step 3: Select and execute the following query to illustrate the
-- COALESCE function
SELECT	custid, country, region, city, 
            country + ',' + COALESCE(region, ' ') + ', ' + city as location
FROM Sales.Customers;

-- Step 4a: Select and execute the following queries to illustrate the
-- NULLIF function
-- First, set up sample data
CREATE TABLE dbo.employee_goals(emp_id INT , actual int, goal int);
GO

-- Step 4b: Populate the sample data
INSERT INTO dbo.employee_goals
VALUES(1, 100, 110), (2, 90, 90), (3, 100, 90), (4, 100, 80);

-- Step 4c: Show the sample data
SELECT emp_id, actual, goal
FROM dbo.employee_goals;

-- Step 4d: Use NULLIF to show which employees have actual
-- values different from their goals
SELECT emp_id, NULLIF(actual, goal) AS actual_if_different
FROM dbo.employee_goals;

-- Step 5: Clean up demo table
DROP TABLE dbo.employee_goals;