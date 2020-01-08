USE MASTER;   --< 注意：這裡開啟查詢相關的系統資料庫
DECLARE @sqlStmt nvarchar(max) = 'USE TSQL2;SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt) as USER = 'HR';
GO
-- ERROR：無法以資料庫主體執行，因為主體 "HR" 不存在、無法模擬這種主體、或者您沒有權限


USE TSQL2;
DECLARE @sqlStmt nvarchar(max) = 'SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt) as USER = 'HR';
--EXEC (@sqlStmt) as USER = 'Sales';
-- 使用者HR,Sales....等建在TSQL2安全性下
GO


-----------------------------------------------------------------------------------

select SUSER_NAME();
--獲得登入者名稱

execute as login = 'HR';
execute as user = 'HR';
--切換使用者帳號成HR

select SUSER_NAME();