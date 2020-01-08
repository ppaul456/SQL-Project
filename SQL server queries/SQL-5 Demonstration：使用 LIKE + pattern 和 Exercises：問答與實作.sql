找出 Lastname 第一個字母為 B 或 C 開頭的名字

select empid, lastname
from HR.Employees
where lastname LIKE '[BC]%'
利用 escape_character，尋找 #mytbl 資料表 c1 資料行中完全相符的 10-15% 字元字串

USE tempdb;  
GO  

CREATE TABLE #mytbl
(  c1 sysname  );  
GO

INSERT #mytbl VALUES ('Discount is 10-15% off'), ('Discount is 10-15 off');
GO  

SELECT c1   
FROM #mytbl  
WHERE c1 LIKE '%10-15!% off%' ESCAPE '!';  
GO

--------------------------------------------------------------------------------------------------------

Exercises：問答與實作
1.請問，LIKE 是否可用來搜尋數值型態的資料？
例如要找出 Sales.Orders 的 OrderID 訂單編號第 3 位數字為 5 的訂單


--ANSWER：
select *
from sales.orders
where orderid like '%5__'


2.請問，LIKE 是否可用來搜尋日期時間的資料？
例如要找出 Sales.Orders 的 OrderDate 訂單日期為 2007 年 10 月份的訂單


--ANSWER：
select *
from sales.orders
where orderdate like '10____2007%'