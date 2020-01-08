--透過 @@TRANCOUNT 瞭解交易階層和特性
 
select @@TRANCOUNT
begin tran   --< 第一層
	select @@TRANCOUNT	

	begin tran   --< 第二層
		select @@TRANCOUNT	

		begin tran   --< 第三層
			select @@TRANCOUNT	
		commit   --< 可以再改成 rollback 試試看

		select @@TRANCOUNT
	commit
	select @@TRANCOUNT
commit
select @@TRANCOUNT


--簡單案例
USE TSQL2;
go

-- 建立測試用途的資料表
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

-- 查詢異動前的資料列
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

----------------------- 我是分隔線 -----------------------

-- 開始明確巢狀交易 + 標示測試
-- 建議只在巢狀 BEGIN…COMMIT 或 BEGIN…ROLLBACK 陳述式的最外一組使用交易名稱 transaction_name
SET NOCOUNT ON;
GO
BEGIN TRAN [更新訂單主檔、訂單明細、產品等三個資料表];

	UPDATE sales.copy_orders set orderdate = dateadd(m, 1, orderdate); 
	SELECT * FROM sales.copy_orders;

	BEGIN TRAN 更新訂單明細訂購數量 WITH MARK '各加 100';  

		UPDATE sales.copy_orderdetails set qty += 100;  
		SELECT * from sales.copy_orderdetails;  

	COMMIT TRAN 更新訂單明細訂購數量;  

	UPDATE Production.copy_Products set productname = REVERSE(productname);
	SELECT * FROM  Production.copy_Products;

COMMIT TRAN [更新訂單主檔、訂單明細、產品等三個資料表];
GO
SET NOCOUNT OFF;
GO

-- 查詢異動後的資料列
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