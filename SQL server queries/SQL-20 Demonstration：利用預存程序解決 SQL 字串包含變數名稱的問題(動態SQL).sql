²��ר�

-- �]���O�ϰ��ܼƪ���]�A�W�ߪ����涥�q�ݤ�����ܼ�
USE TSQL2; 
DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid;';
EXEC (@sqlStmt) as USER = 'HR';
GO
-- ERROR�G�����ŧi�¶q�ܼ� "@eid"


-- �N�ŧi�ܼƻy�k�g�J�W�ߪ����涥�q�N��ݨ���ܼ�
USE TSQL2; 
DECLARE @sqlStmt nvarchar(max) = N'DECLARE @eid int = 5;SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid;';
EXEC (@sqlStmt) as USER = 'HR';
GO
-- (1 �Ӹ�ƦC����v�T)


-- ��ĳ���k
-- �t�@�ظѨM����k�A�ϥ�stored procedure(sp_executesql)���|�۰ʫŧi�ܼƦb�W�ߪ����涥�q
-- �u������ʺASQL
USE TSQL2; 
DECLARE @eid int = 5;
DECLARE @sqlStmt nvarchar(max) = N'SELECT empid, lastname, hiredate FROM hr.employees WHERE empid = @eid';
EXEC sp_executesql	@stmt = @sqlStmt,  --statement
					@params = N'@eid int',   --< �j�g N ���ಾ��, ��ƫ��A
					@eid = 5;
GO
-- (1 �Ӹ�ƦC����v�T)