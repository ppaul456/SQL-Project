1. �аݡA�Y�ܧ�ثe MS-SQL Server ���媩���w�� (�q�����אּ�`��) �A�Ҧp�b�B�⦡�W���ܩw�ǡA�� Predicate �O�_���v�T�H
�Ҧp�n��X HR.Employess �� 10 �����u�APredicate �� Lastname = N���j����

�Цۦ�H T-SQL ��@

--ANSWER�G
select *
from hr.Employees
where Lastname = N'�j��' collate Chinese_Taiwan_Bopomofo_CI_AS



2.�аݡA�ثe MS-SQL Server ���媩���w�ǡA�O�_�i�H�b Predicate �ϥΤ�����Ϊ����ԧB�Ʀr����ơH
�Ҧp�n��X HR.Employess �� 10 �����u�APredicate �����ϥΥ��Ϊ����ԧB�Ʀr �����A�Ҧp�GEmpID = ��������

�Цۦ�H T-SQL ��@

--ANSWER�G
select *
from hr.Employees
where cast(empid as varchar(2)) = '����'