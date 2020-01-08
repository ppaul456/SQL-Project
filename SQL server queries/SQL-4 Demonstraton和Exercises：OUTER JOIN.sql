Demonstraton：OUTER JOIN

--範例 A： 找出哪些員工還未曾有訂單業績，傳回員工編號和名字
EmpID 員工編號
LastName 名字
select e.EmpID 員工編號,
		e.LastName 名字
from hr.Employees e
	LEFT OUTER JOIN sales.orders o ON e.empid = o.empid
where o.empid is null;

-------------------------------------------------------------------------------------
Exercises：OUTER JOIN 練習

找出哪些客戶還未曾下訂單，傳回下列資料
custid 客戶編號
companyname 公司名稱

--ANSWER：
select	c.custid 客戶編號,
		c.companyname 公司名稱
from sales.Customers c
	left join sales.orders o on o.custid = c.custid
where o.custid is null;
找出 2007 年 5 月份的訂單中，未曾訂購過的產品，傳回下列資料
ProductID 產品編號
ProductName 產品名稱
ANSWER：
select	p.ProductID 產品編號,
		p.ProductName 產品名稱
from sales.orders o
	inner join sales.OrderDetails od 
		on od.orderid = o.orderid 
			and year(o.orderdate) = 2007
			and month(o.orderdate) = 5
	right outer join Production.Products p on p.productid = od.productid
where od.productid is null;


select	p.ProductID 產品編號,
		p.ProductName 產品名稱
from sales.orders o
	inner join sales.OrderDetails od 
		on od.orderid = o.orderid 
			and o.orderdate between '20070501' and '20070531'
	right outer join Production.Products p on p.productid = od.productid
where od.productid is null;