��X Lastname �Ĥ@�Ӧr���� B �� C �}�Y���W�r

select empid, lastname
from HR.Employees
where lastname LIKE '[BC]%'
�Q�� escape_character�A�M�� #mytbl ��ƪ� c1 ��Ʀ椤�����۲Ū� 10-15% �r���r��

USE tempdb;  
GO  

CREATE TABLE #mytbl
(  c1 sysname  );  
GO

INSERT #mytbl VALUES ('Discount is 10-15% off'), ('Discount is 10-15 off');
GO  

SELECT c1   
FROM #mytbl  
WHERE c1 LIKE '%10-15!% off%' ESCAPE '!';  
GO

--------------------------------------------------------------------------------------------------------

Exercises�G�ݵ��P��@
1.�аݡALIKE �O�_�i�Ψӷj�M�ƭȫ��A����ơH
�Ҧp�n��X Sales.Orders �� OrderID �q��s���� 3 ��Ʀr�� 5 ���q��


--ANSWER�G
select *
from sales.orders
where orderid like '%5__'


2.�аݡALIKE �O�_�i�Ψӷj�M����ɶ�����ơH
�Ҧp�n��X Sales.Orders �� OrderDate �q������ 2007 �~ 10 ������q��


--ANSWER�G
select *
from sales.orders
where orderdate like '10____2007%'