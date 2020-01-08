--基本語法
--用之前範例
create procedure usp_p1 as
 
DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< 大寫 N 不能移除, 資料型態
					@eid = 5;
GO

--使用預存程序
use TSQL2;

execute [dbo].[usp_p1] with recompile