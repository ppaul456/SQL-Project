Demonstration：如何使用 IIF()
範例 A：試以 IIF()，評估員工資料表的 Salary 的年薪，在傳回的結果集中再加入一個「標記」資料行，
如以下資料行所示，該資料行用於標示超過百萬年薪者，以一個符號 V 做為標示：
--標記
--EmpID 員工編號
--LastName 名字

select	iif( salary * 12 > 1000000, 'V', '' ) 標記,
		EmpID 員工編號,
		LastName 名字
from hr.Employees;



-----------------------------------------------------------------------------------
篩選資料使用 WHERE 子句

--WHERE 使用 OR 邏輯運算子

SELECT custid, companyname, country
FROM Sales.Customers
WHERE country = N'UK' OR country = N'Spain';

--WHERE 使用 IN 運算子

SELECT custid, companyname, country
FROM Sales.Customers
WHERE country IN (N'UK',N'Spain');

--WHERE 使用 AND 邏輯運算子處理連續範圍區間的資料

SELECT orderid, custid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20070101' AND orderdate <= '20080630';


--WHERE 使用 BETWEEN 運算子處理連續範圍區間的資料

SELECT orderid, custid, orderdate
FROM Sales.Orders
WHERE orderdate BETWEEN '20070101' AND '20080630';