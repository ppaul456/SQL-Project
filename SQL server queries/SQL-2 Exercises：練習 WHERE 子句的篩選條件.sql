--Exercises�G�m�� WHERE �l�y���z�����
1.�Ǧ^�~��b London �����u��ơA�Ǧ^�U�C��Ʀ�G
EmpID ���u�s��
LastName �W�r
Salary �~��
Address ��}

--ANSWER:
select  EmpID ���u�s��,
		LastName �W�r,
		Salary �~��,
		Address ��}
from hr.Employees
where city = N'London';




2.��X�Ҧ��q�����b 9 ������q���ơA�H�ΥX�f��a�� USA �� UK�A�öǦ^�U�C��Ʀ� (��Ʀ�O�W)
OrderID �q��s��
CustID �Ȥ�s��
ShipCountry �X�f��a
�q����

--ANSWER:
select OrderID �q��s��,
		CustID �Ȥ�s��,
		ShipCountry �X�f��a,
		month([orderdate]) �q����
from sales.orders
where month([orderdate]) = 9 and (ShipCountry = N'USA' or ShipCountry = N'UK');


select OrderID �q��s��,
		CustID �Ȥ�s��,
		ShipCountry �X�f��a,
		month([orderdate]) �q����
from sales.orders
where month([orderdate]) = 9 and ShipCountry IN (N'USA', N'UK');