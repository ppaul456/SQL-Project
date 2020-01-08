
create or alter procedure usp_p1(@eeid int)
with execute as caller --caller = 箇砞
--with execute as self --self = ミ
--with execute as owner --owner = 家舱局Τ
--with execute as 'sales' --﹚user
as
--DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< 糶 N ぃ簿埃, 戈篈
					@eid = @eeid;
select SUSER_SNAME() --琩高ヘ玡ㄏノ 
GO

exec usp_p1 6 

-------------------------------
execute as user = 'sales'         
revert --ōだち传ㄓ

select SUSER_SNAME()

dbo.usp_p1 6 