/* CASE 1�A��@���z�� */
-- ���k�@
USE TSQL2;
EXEC ('SELECT empid, lastname, hiredate FROM hr.employees;');
GO


-- ���k�G
USE TSQL2;
DECLARE @sqlStmt nvarchar(max) = 'SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt);
GO


/* CASE 2�A�h�����z���A�ϥΤ@�� EXECUTE() */
-- �Q�Τ����j���U���z��
USE MASTER;   --< �`�N�G�o�̶}�Ҭd�߬������t�θ�Ʈw
DECLARE @sqlStmt nvarchar(max) = 'USE TSQL2;SELECT empid, lastname, hiredate FROM hr.employees;'; 
--USE ��select�����n�[;(��ӻy�k)

EXEC (@sqlStmt);
-- (10 �Ӹ�ƦC����v�T)


/* CASE 3�A�h�����z���A�ϥΦh�� EXECUTE() */
USE MASTER;   --< �`�N�G�o�̶}�Ҭd�߬������t�θ�Ʈw
DECLARE @sqlStmt1 nvarchar(max) = 'USE TSQL2;'
DECLARE @sqlStmt2 nvarchar(max) = 'SELECT empid, lastname, hiredate FROM hr.employees;';
EXEC (@sqlStmt1);
EXEC (@sqlStmt2);
-- ERROR�G�L�Ī�����W�� 'hr.employees'�n�ѦҤW���@�k���X(;)���P�y�k