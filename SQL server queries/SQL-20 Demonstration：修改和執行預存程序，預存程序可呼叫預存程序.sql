create or alter procedure usp_p1(@eeid int) as
 
--DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< 大寫 N 不能移除, 資料型態
					@eid = @eeid;
GO

exec usp_p1 6 