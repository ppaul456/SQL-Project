----Exercises�G�m�� ORDER BY �l�y���ƧǸ��

----�N�W�@�� Exercises �����G�A�N�u�X�f��a�v�H�ɧǱƧ�

--ANSWER:
select OrderID �q��s��,
		CustID �Ȥ�s��,
		ShipCountry �X�f��a,
		month([orderdate]) �q����
from sales.orders
where month([orderdate]) = 9 and ShipCountry IN (N'USA', N'UK')
order by �X�f��a ASC;  --< ASC ���w�]��

select OrderID �q��s��,
		CustID �Ȥ�s��,
		ShipCountry �X�f��a,
		month([orderdate]) �q����
from sales.orders
where month([orderdate]) = 9 and ShipCountry IN (N'USA', N'UK')
order by �X�f��a;