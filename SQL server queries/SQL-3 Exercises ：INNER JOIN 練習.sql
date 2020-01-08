Exercises ：INNER JOIN 練習

1.找出所有訂單日期在 9 月份的訂單資料，以及出貨國家為 USA 或 UK，並傳回下列資料行別名

OrderID 訂單編號
CustID 客戶編號
EmpID 員工編號
LastName 員工名字
ShipCountry 出貨國家
訂單月份 <== 來自 OrderDate

--ANSWER：

-- ANSI SQL-89
select
			o.OrderID 訂單編號,
			o.CustID 客戶編號,
			o.EmpID 員工編號,
			e.LastName 員工名字,
			o.ShipCountry 出貨國家,
			month(o.orderdate) 訂單月份
from sales.orders o, hr.employees e
where o.ShipCountry in (N'USA', N'UK')
	and month(o.orderdate) = 9
	and o.empid = e.empid;

-- ANSI SQL-92
select
			o.OrderID 訂單編號,
			o.CustID 客戶編號,
			o.EmpID 員工編號,
			e.LastName 員工名字,
			o.ShipCountry 出貨國家,
			month(o.orderdate) 訂單月份
from sales.orders o 
	inner join hr.employees e on o.empid = e.empid
where o.ShipCountry in (N'USA', N'UK')
	and month(o.orderdate) = 9;




------------------------------------------------------------------------------------------------------------------------
2.試編寫 INNER JOIN，根據 stats.grades 資料表的分數等級內容，
在 SELECT 傳回 stats.scores 資料表所有資料行的記錄時，額外加入一個「等級」資料行


--ANSWER:
select s.[testid], s.[studentid], s.[score], s.[testdate],
		g.gra 等級
from [Stats].[Scores] s
	inner join [Stats].[Grades] g on s.score >= g.lowest_score
		and s.score <= g.highest_score;
