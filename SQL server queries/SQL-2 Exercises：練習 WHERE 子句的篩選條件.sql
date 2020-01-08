--Exercises：練習 WHERE 子句的篩選條件
1.傳回居住在 London 的員工資料，傳回下列資料行：
EmpID 員工編號
LastName 名字
Salary 薪資
Address 住址

--ANSWER:
select  EmpID 員工編號,
		LastName 名字,
		Salary 薪資,
		Address 住址
from hr.Employees
where city = N'London';




2.找出所有訂單日期在 9 月份的訂單資料，以及出貨國家為 USA 或 UK，並傳回下列資料行 (資料行別名)
OrderID 訂單編號
CustID 客戶編號
ShipCountry 出貨國家
訂單月份

--ANSWER:
select OrderID 訂單編號,
		CustID 客戶編號,
		ShipCountry 出貨國家,
		month([orderdate]) 訂單月份
from sales.orders
where month([orderdate]) = 9 and (ShipCountry = N'USA' or ShipCountry = N'UK');


select OrderID 訂單編號,
		CustID 客戶編號,
		ShipCountry 出貨國家,
		month([orderdate]) 訂單月份
from sales.orders
where month([orderdate]) = 9 and ShipCountry IN (N'USA', N'UK');