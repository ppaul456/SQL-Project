----Exercises：T-SQL DML 實作練習 (HomeWork)
---1. 假設客戶編號 31 號在今天直接向銷售人員編號 6 號訂購產品，相關細節如下：

---ANSWER：
insert into [Sales].[Orders] ([custid], [empid], [orderdate], [requireddate], [shippeddate], [shipperid], [freight], [shipname], [shipaddress], [shipcity], [shipregion], [shippostalcode], [shipcountry])
values( 31, 6, cast(getdate() as date), cast(getdate() + 7 as date), cast(getdate() + 4 as date), 1, 50, concat(N'收件人：', N'Customer YJCBX'), N'Av. Brasil, 5678', N'Campinas', N'SP', N'10128', N'Brazil')

insert into [Sales].[OrderDetails] ([orderid], [productid], [unitprice], [qty], [discount])
values (@@IDENTITY, 30, 25.89, 3, 0.05)

update Production.Products
set InStock -= 3
where productid = 30