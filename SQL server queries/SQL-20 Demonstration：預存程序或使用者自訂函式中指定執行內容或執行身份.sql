
create or alter procedure usp_p1(@eeid int)
with execute as caller --caller = �w�]��
--with execute as self --self = �إߪ�
--with execute as owner --owner = �Ҳվ֦���
--with execute as 'sales' --���wuser
as
--DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< �j�g N ���ಾ��, ��ƫ��A
					@eid = @eeid;
select SUSER_SNAME() --�d�ߥثe�ϥΪ� 
GO

exec usp_p1 6 

-------------------------------
execute as user = 'sales'         
revert --���������^��

select SUSER_SNAME()

dbo.usp_p1 6 