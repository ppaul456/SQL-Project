--�z�L @@TRANCOUNT �A�ѥ�����h�M�S��
 
select @@TRANCOUNT
begin tran   --< �Ĥ@�h
	select @@TRANCOUNT	

	begin tran   --< �ĤG�h
		select @@TRANCOUNT	

		begin tran   --< �ĤT�h
			select @@TRANCOUNT	
		commit   --< �i�H�A�令 rollback �ոլ�

		select @@TRANCOUNT
	commit
	select @@TRANCOUNT
commit
select @@TRANCOUNT


--²��ר�
USE TSQL2;
go

-- �إߴ��եγ~����ƪ�
drop table if exists sales.copy_orders;
select	orderid + 0 orderid,
		orderdate into sales.copy_orders		
from sales.orders
where orderdate >= '20070101' and orderdate < '20070201';
go

drop table if exists sales.copy_orderdetails;
select	orderid,
		productid,
		qty,
		unitprice into sales.copy_orderdetails
from sales.OrderDetails
where orderid in (select orderid from sales.copy_orders);
go

drop table if exists Production.copy_Products;
select	productid + 0 productid,
		productname into Production.copy_Products
from Production.Products;
go

-- �d�߲��ʫe����ƦC
select  o.orderid,
		o.orderdate,
		od.productid,
		od.qty,
		od.unitprice,
		p.productname
from sales.copy_orders o 
	join sales.copy_orderdetails od on od.orderid = o.orderid
	join Production.copy_Products p on p.productid = od.productid;
go

----------------------- �ڬO���j�u -----------------------

-- �}�l���T�_����� + �Хܴ���
-- ��ĳ�u�b�_�� BEGIN�KCOMMIT �� BEGIN�KROLLBACK ���z�����̥~�@�ըϥΥ���W�� transaction_name
SET NOCOUNT ON;
GO
BEGIN TRAN [��s�q��D�ɡB�q����ӡB���~���T�Ӹ�ƪ�];

	UPDATE sales.copy_orders set orderdate = dateadd(m, 1, orderdate); 
	SELECT * FROM sales.copy_orders;

	BEGIN TRAN ��s�q����ӭq�ʼƶq WITH MARK '�U�[ 100';  

		UPDATE sales.copy_orderdetails set qty += 100;  
		SELECT * from sales.copy_orderdetails;  

	COMMIT TRAN ��s�q����ӭq�ʼƶq;  

	UPDATE Production.copy_Products set productname = REVERSE(productname);
	SELECT * FROM  Production.copy_Products;

COMMIT TRAN [��s�q��D�ɡB�q����ӡB���~���T�Ӹ�ƪ�];
GO
SET NOCOUNT OFF;
GO

-- �d�߲��ʫ᪺��ƦC
select  o.orderid,
		o.orderdate,
		od.productid,
		od.qty,
		od.unitprice,
		p.productname
from sales.copy_orders o 
	join sales.copy_orderdetails od on od.orderid = o.orderid
	join Production.copy_Products p on p.productid = od.productid;
go

-- Clean Up
drop table if exists Production.copy_Products;
drop table if exists sales.copy_orderdetails;
drop table if exists sales.copy_orders;