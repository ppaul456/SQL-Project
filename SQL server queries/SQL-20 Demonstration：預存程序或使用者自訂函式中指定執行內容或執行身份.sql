
create or alter procedure usp_p1(@eeid int)
with execute as caller --caller = 預設值
--with execute as self --self = 建立者
--with execute as owner --owner = 模組擁有者
--with execute as 'sales' --指定user
as
--DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< 大寫 N 不能移除, 資料型態
					@eid = @eeid;
select SUSER_SNAME() --查詢目前使用者 
GO

exec usp_p1 6 

-------------------------------
execute as user = 'sales'         
revert --身分切換回來

select SUSER_SNAME()

dbo.usp_p1 6 