--�d�� A�G�U�C�Ȱw��ϥβv���W�c������d��إ� Filtered Index

CREATE NONCLUSTERED INDEX nonIdx1 ON [Sales2].[Orders]
(
	[orderdate] ASC
)
WHERE orderdate >= '20070101' and orderdate < '20080101'



--�d�� B�G�U�C�Ȱw��ϥβv���W�c���q��s���d��إ� Filtered Index
CREATE NONCLUSTERED INDEX nonIdx2 ON [Sales2].[Orders]
(
	[orderid] ASC
)
WHERE orderid >= 10500 and orderid <= 10599