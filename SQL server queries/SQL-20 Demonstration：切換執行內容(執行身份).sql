USE MASTER;   --< �`�N�G�o�̶}�Ҭd�߬������t�θ�Ʈw
DECLARE @sqlStmt nvarchar(max) = 'USE TSQL2;SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt) as USER = 'HR';
GO
-- ERROR�G�L�k�H��Ʈw�D�����A�]���D�� "HR" ���s�b�B�L�k�����o�إD��B�Ϊ̱z�S���v��


USE TSQL2;
DECLARE @sqlStmt nvarchar(max) = 'SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt) as USER = 'HR';
--EXEC (@sqlStmt) as USER = 'Sales';
-- �ϥΪ�HR,Sales....���ئbTSQL2�w���ʤU
GO


-----------------------------------------------------------------------------------

select SUSER_NAME();
--��o�n�J�̦W��

execute as login = 'HR';
execute as user = 'HR';
--�����ϥΪ̱b����HR

select SUSER_NAME();