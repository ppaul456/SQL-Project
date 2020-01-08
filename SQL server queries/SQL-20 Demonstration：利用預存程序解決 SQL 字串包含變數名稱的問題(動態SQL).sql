簡單案例

-- 因為是區域變數的原因，獨立的執行階段看不到該變數
USE TSQL2; 
DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid;';
EXEC (@sqlStmt) as USER = 'HR';
GO
-- ERROR：必須宣告純量變數 "@eid"


-- 將宣告變數語法寫入獨立的執行階段就能看到該變數
USE TSQL2; 
DECLARE @sqlStmt nvarchar(max) = N'DECLARE @eid int = 5;SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid;';
EXEC (@sqlStmt) as USER = 'HR';
GO
-- (1 個資料列受到影響)


-- 建議做法
-- 另一種解決的方法，使用stored procedure(sp_executesql)它會自動宣告變數在獨立的執行階段
-- 真正做到動態SQL
USE TSQL2; 
DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< 大寫 N 不能移除, 資料型態
					@eid = 5;
GO
-- (1 個資料列受到影響)