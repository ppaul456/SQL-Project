/* CASE 1，單一陳述式 */
-- 做法一
USE TSQL2;
EXEC ('SELECT empid, lastname, hiredate FROM hr.employees;');
GO


-- 做法二
USE TSQL2;
DECLARE @sqlStmt nvarchar(max) = 'SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt);
GO


/* CASE 2，多重陳述式，使用一個 EXECUTE() */
-- 利用分號隔離各陳述式
USE MASTER;   --< 注意：這裡開啟查詢相關的系統資料庫
DECLARE @sqlStmt nvarchar(max) = 'USE TSQL2;SELECT empid, lastname, hiredate FROM hr.employees;'; 
--USE 跟select中間要加;(兩個語法)

EXEC (@sqlStmt);
-- (10 個資料列受到影響)


/* CASE 3，多重陳述式，使用多個 EXECUTE() */
USE MASTER;   --< 注意：這裡開啟查詢相關的系統資料庫
DECLARE @sqlStmt1 nvarchar(max) = 'USE TSQL2;'
DECLARE @sqlStmt2 nvarchar(max) = 'SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt1);
EXEC (@sqlStmt2);
-- ERROR：無效的物件名稱 'hr.employees'要參考上面作法結合(;)不同語法