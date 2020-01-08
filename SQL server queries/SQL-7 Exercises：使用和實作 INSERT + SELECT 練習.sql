---Exercises：使用和實作 INSERT + SELECT 練習
---試寫出 INSERT + SELECT，根據 2007 年 10 月份訂單的訂單編號清單，找出這些銷售人員的相關資料，並完成下列需求：

----假設己經有一個預先建立好的資料表 Sales.OrderEmp_200710 (執行下列 T-SQL 來完成)，它是用來儲存銷售人員的相關資料
CREATE TABLE Sales.OrderEmp_200710
( EmpID tinyint,
  LastName nvarchar(20),
  SalesAmount money
);

-----根據 2007 年 10 月份訂單(如下)，找出下列訂單編號的銷售人員，新增到資料表 Sales.OrderEmp_200710
--10689
--10692
--10721
--10723
--資料行 SalesAmount 需存入 unitprice * qty 的統計結果

---ANSWER：

insert into Sales.OrderEmp_200710
select o.empid, e.lastname, od.SubTotal
from sales.orders o
	join sales.OrderDetails od on od.orderid = o.orderid
	join hr.Employees e on e.empid = o.empid
where o.orderid in (10689, 10692, 10721, 10723)