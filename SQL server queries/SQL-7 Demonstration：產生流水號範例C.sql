範例 C：資料庫層級的 SEQUENCE (自動取號)

USE TempDB;

-- 建立名為 CountBy2 的順序 (預設快取大小為 50)
CREATE SEQUENCE dbo.CountBy2 as INT  --< 預設為 BigInt
    START WITH 1
    INCREMENT BY 1
GO  

-- 建立測試用的資料表
CREATE TABLE #Tbl3
( col1 int DEFAULT (NEXT VALUE FOR dbo.CountBy2),
  col2 varchar(20) );
GO


-- 在 INSERT 指定欄名和欄值 --> 使用 DEFAULT 自動取號
INSERT INTO #Tbl3 (col1, col2) VALUES (DEFAULT, 'Identity Test1');
SELECT * FROM #Tbl3;


-- Clean Up
DROP TABLE IF EXISTS #Tbl3 
DROP SEQUENCE IF EXISTS dbo.CountBy2;
GO