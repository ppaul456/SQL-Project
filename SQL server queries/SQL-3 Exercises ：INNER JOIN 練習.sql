Exercises �GINNER JOIN �m��

1.��X�Ҧ��q�����b 9 ������q���ơA�H�ΥX�f��a�� USA �� UK�A�öǦ^�U�C��Ʀ�O�W

OrderID �q��s��
CustID �Ȥ�s��
EmpID ���u�s��
LastName ���u�W�r
ShipCountry �X�f��a
�q���� <== �Ӧ� OrderDate

--ANSWER�G

-- ANSI SQL-89
select
			o.OrderID �q��s��,
			o.CustID �Ȥ�s��,
			o.EmpID ���u�s��,
			e.LastName ���u�W�r,
			o.ShipCountry �X�f��a,
			month(o.orderdate) �q����
from sales.orders o, hr.employees e
where o.ShipCountry in (N'USA', N'UK')
	and month(o.orderdate) = 9
	and o.empid = e.empid;

-- ANSI SQL-92
select
			o.OrderID �q��s��,
			o.CustID �Ȥ�s��,
			o.EmpID ���u�s��,
			e.LastName ���u�W�r,
			o.ShipCountry �X�f��a,
			month(o.orderdate) �q����
from sales.orders o 
	inner join hr.employees e on o.empid = e.empid
where o.ShipCountry in (N'USA', N'UK')
	and month(o.orderdate) = 9;




------------------------------------------------------------------------------------------------------------------------
2.�սs�g INNER JOIN�A�ھ� stats.grades ��ƪ����Ƶ��Ť��e�A
�b SELECT �Ǧ^ stats.scores ��ƪ�Ҧ���Ʀ檺�O���ɡA�B�~�[�J�@�ӡu���šv��Ʀ�


--ANSWER:
select s.[testid], s.[studentid], s.[score], s.[testdate],
		g.gra ����
from [Stats].[Scores] s
	inner join [Stats].[Grades] g on s.score >= g.lowest_score
		and s.score <= g.highest_score;
