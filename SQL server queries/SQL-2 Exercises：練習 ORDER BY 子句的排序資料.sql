----Exercises：練習 ORDER BY 子句的排序資料

----將上一個 Exercises 之結果，將「出貨國家」以升序排序

--ANSWER:
select OrderID 訂單編號,
		CustID 客戶編號,
		ShipCountry 出貨國家,
		month([orderdate]) 訂單月份
from sales.orders
where month([orderdate]) = 9 and ShipCountry IN (N'USA', N'UK')
order by 出貨國家 ASC;  --< ASC 為預設值

select OrderID 訂單編號,
		CustID 客戶編號,
		ShipCountry 出貨國家,
		month([orderdate]) 訂單月份
from sales.orders
where month([orderdate]) = 9 and ShipCountry IN (N'USA', N'UK')
order by 出貨國家;