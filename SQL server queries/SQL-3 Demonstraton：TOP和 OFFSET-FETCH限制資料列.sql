TOP相關的用法有：

可用來限制傳回筆數
-- 傳回最後 5 筆訂單資料
SELECT TOP (5) orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;
TOP + WITH TIES (平手的意思)

-- 傳回最後 5 筆訂單資料以及同一時間的訂單
SELECT TOP (5) WITH TIES orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;

--限制百分比的筆數，但筆數都是固定的，也可以加上 WITH TIES
SELECT TOP (10) PERCENT orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;

隨機抽樣 (使用 newid())，限制百分比的筆數，但筆數都是固定的，
也可以加上 WITH TIES，若想傳回不固定筆數，則可改用 TABLESAMPLE
-- 做法一
SELECT TOP (10) PERCENT orderid, custid, orderdate
FROM Sales.Orders
ORDER BY newid(), orderdate DESC;

-- 做法二
SELECT orderid, custid, orderdate
FROM Sales.Orders TABLESAMPLE SYSTEM (10 PERCENT )
ORDER BY orderdate DESC;



----------------------------------------------------------------------------
使用 OFFSET-FETCH 子句限制資料列
FIRST 或 NEXT 子句意思相同

--相關的用法有：
--傳回第 11 筆到第 20 筆的記錄
SELECT orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate, orderid DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

--傳回前 50 筆記錄
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC
OFFSET 0 ROWS
FETCH FIRST 50 ROWS ONLY;
