範例 A：常用的字元字串函數

SELECT SUBSTRING('Microsoft SQL Server', 11, 3) AS Result;

SELECT	LEFT('Microsoft SQL Server', 9) AS left_example,
		RIGHT('Microsoft SQL Server',6) as right_example;

SELECT	LEN('Microsoft SQL Server     ') AS [LEN() 會忽略尾端空白],
		DATALENGTH('Microsoft SQL Server     ') AS [DATALENGTH() 不會忽略尾端空白];

SELECT CHARINDEX('SQL','Microsoft SQL Server') AS Result;

SELECT REPLACE('Learning about T-SQL string functions','T-SQL','Transact-SQL') AS Result;

SELECT STUFF('Learning about T-SQL string functions', 16, 5,'Transact-SQL') AS Result;

SELECT	UPPER('Microsoft SQL Server') AS [大寫],
		LOWER('Microsoft SQL Server') AS [小寫];

------------------------------------------------------------------------------------------------------------------------
範例 B：傳回指定文化特性之貨幣格式

DECLARE @m money = 120.595
SELECT  @m AS 未格式化的值, 
        FORMAT(@m,'C','zh-cn') AS 人民幣,
        FORMAT(@m,'C','en-us') AS 美元,
        FORMAT(@m,'C','de-de') AS 歐元;


------------------------------------------------------------------------------------------------------------------------
Exercises：實作字元字串函式 (HomeWork)

試著為 Sales.Customers 的 custid 資料值設計編碼格式 C##### 的處理邏輯，
例如：1 號客戶，就傳回 C00001，2 號客戶，就傳回 C00002，依此類推，並傳回下列需求：
CustID 原客戶編號
新客戶編號


--ANSWER：
SELECT  [custid],
		custid * 0.00001,
		cast(custid * 0.00001 as varchar(7)),
		right( cast(custid * 0.00001 as varchar(7)), 5),
		concat('C' , right( cast(custid * 0.00001 as varchar(7)), 5) )
FROM [TSQL2].[Sales].[Customers]

SELECT  [custid],
		replicate('0', 5),
		concat('C', replicate('0', 5)),
		cast(custid as varchar(5)),
		concat(replicate('0', 5), cast(custid as varchar(5))),
		right(concat(replicate('0', 5), cast(custid as varchar(5))), 5),
		concat('C', right(concat(replicate('0', 5), cast(custid as varchar(5))), 5))
FROM [TSQL2].[Sales].[Customers]


SELECT  [custid],
		format(custid, N'\C00000')
FROM [TSQL2].[Sales].[Customers]
