----Demonstration�G�ϥ� INSERT + SELECT �j�q�s�W�O��

-- �إߥΨӴ��ժ��ƥ���ƪ� (�u�����n���c�A�S����ƦC)
SELECT EmpID, Lastname, Salary, hiredate INTO HR.Copy_Emp
FROM HR2.Employees
WHERE 1=0;
GO

-- �ϥ� INSERT + SELECT �j�q�s�W�O��
INSERT INTO HR.Copy_Emp (EmpID, Lastname, Salary, hiredate)
SELECT EmpID, Lastname, Salary, hiredate 
FROM HR2.Employees;
GO

SELECT EmpID, Lastname, Salary, hiredate
FROM HR2.Employees;
