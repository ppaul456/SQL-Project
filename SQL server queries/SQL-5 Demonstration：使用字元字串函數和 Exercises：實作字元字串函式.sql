�d�� A�G�`�Ϊ��r���r����

SELECT SUBSTRING('Microsoft SQL Server', 11, 3) AS Result;

SELECT	LEFT('Microsoft SQL Server', 9) AS left_example,
		RIGHT('Microsoft SQL Server',6) as right_example;

SELECT	LEN('Microsoft SQL Server     ') AS [LEN() �|�������ݪť�],
		DATALENGTH('Microsoft SQL Server     ') AS [DATALENGTH() ���|�������ݪť�];

SELECT CHARINDEX('SQL','Microsoft SQL Server') AS Result;

SELECT REPLACE('Learning about T-SQL string functions','T-SQL','Transact-SQL') AS Result;

SELECT STUFF('Learning about T-SQL string functions', 16, 5,'Transact-SQL') AS Result;

SELECT	UPPER('Microsoft SQL Server') AS [�j�g],
		LOWER('Microsoft SQL Server') AS [�p�g];

------------------------------------------------------------------------------------------------------------------------
�d�� B�G�Ǧ^���w��ƯS�ʤ��f���榡

DECLARE @m money = 120.595
SELECT  @m AS ���榡�ƪ���, 
        FORMAT(@m,'C','zh-cn') AS �H����,
        FORMAT(@m,'C','en-us') AS ����,
        FORMAT(@m,'C','de-de') AS �ڤ�;


------------------------------------------------------------------------------------------------------------------------
Exercises�G��@�r���r��禡 (HomeWork)

�յ۬� Sales.Customers �� custid ��ƭȳ]�p�s�X�榡 C##### ���B�z�޿�A
�Ҧp�G1 ���Ȥ�A�N�Ǧ^ C00001�A2 ���Ȥ�A�N�Ǧ^ C00002�A�̦������A�öǦ^�U�C�ݨD�G
CustID ��Ȥ�s��
�s�Ȥ�s��


--ANSWER�G
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
