Demonstration�G�p��ϥ� IIF()
�d�� A�G�եH IIF()�A�������u��ƪ� Salary ���~�~�A�b�Ǧ^�����G�����A�[�J�@�ӡu�аO�v��Ʀ�A
�p�H�U��Ʀ�ҥܡA�Ӹ�Ʀ�Ω�ХܶW�L�ʸU�~�~�̡A�H�@�ӲŸ� V �����ХܡG
--�аO
--EmpID ���u�s��
--LastName �W�r

select	iif( salary * 12 > 1000000, 'V', '' ) �аO,
		EmpID ���u�s��,
		LastName �W�r
from hr.Employees;



-----------------------------------------------------------------------------------
�z���ƨϥ� WHERE �l�y

--WHERE �ϥ� OR �޿�B��l

SELECT custid, companyname, country
FROM Sales.Customers
WHERE country = N'UK' OR country = N'Spain';

--WHERE �ϥ� IN �B��l

SELECT custid, companyname, country
FROM Sales.Customers
WHERE country IN (N'UK',N'Spain');

--WHERE �ϥ� AND �޿�B��l�B�z�s��d��϶������

SELECT orderid, custid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20070101' AND orderdate <= '20080630';


--WHERE �ϥ� BETWEEN �B��l�B�z�s��d��϶������

SELECT orderid, custid, orderdate
FROM Sales.Orders
WHERE orderdate BETWEEN '20070101' AND '20080630';