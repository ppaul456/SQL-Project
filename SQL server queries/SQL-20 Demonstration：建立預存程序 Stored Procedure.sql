--�򥻻y�k
--�Τ��e�d��
create procedure usp_p1 as
 
DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< �j�g N ���ಾ��, ��ƫ��A
					@eid = 5;
GO

--�ϥιw�s�{��
use TSQL2;

execute [dbo].[usp_p1] with recompile