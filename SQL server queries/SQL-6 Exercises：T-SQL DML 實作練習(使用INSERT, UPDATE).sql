----Exercises�GT-SQL DML ��@�m�� (HomeWork)
---1. ���]�Ȥ�s�� 31 ���b���Ѫ����V�P��H���s�� 6 ���q�ʲ��~�A�����Ӹ`�p�U�G

---ANSWER�G
insert into [Sales].[Orders] ([custid], [empid], [orderdate], [requireddate], [shippeddate], [shipperid], [freight], [shipname], [shipaddress], [shipcity], [shipregion], [shippostalcode], [shipcountry])
values( 31, 6, cast(getdate() as date), cast(getdate() + 7 as date), cast(getdate() + 4 as date), 1, 50, concat(N'����H�G', N'Customer YJCBX'), N'Av. Brasil, 5678', N'Campinas', N'SP', N'10128', N'Brazil')

insert into [Sales].[OrderDetails] ([orderid], [productid], [unitprice], [qty], [discount])
values (@@IDENTITY, 30, 25.89, 3, 0.05)

update Production.Products
set InStock -= 3
where productid = 30