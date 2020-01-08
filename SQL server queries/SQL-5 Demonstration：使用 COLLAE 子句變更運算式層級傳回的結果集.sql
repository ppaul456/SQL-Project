使用指定定序的基本語法：(COLLATE 必須接在運算式後面)

字元字串運算式 COLLATE 定序
指定要區分大小寫的定序：

/* COLLATE 必須接在運算式後面 */
-- 方式一
SELECT *
FROM [TSQL2].[HR].[Employees]
WHERE lastname = 'davis' COLLATE Latin1_General_CS_AI;

-- 方式二
SELECT *
FROM [TSQL2].[HR].[Employees]
WHERE lastname COLLATE Latin1_General_CS_AI = 'davis';
讓 ORDER BY 將結果排序成指定地區的結果：

/* COLLATE 必須接在運算式後面 */
SELECT Companyname 
FROM Sales.customers
ORDER BY Companyname COLLATE Latin1_General_CS_AI; 
若要查詢 SQL Server 支援 Taiwan 地區的定序：

SELECT Name, Description 
FROM fn_helpcollations()  
WHERE Name like '%Taiwan%';