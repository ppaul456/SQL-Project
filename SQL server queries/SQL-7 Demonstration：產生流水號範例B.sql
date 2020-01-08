範例 B：資料庫層級的 SEQUENCE (人工取號)

USE TempDB;

-- 建立名為 CountBy1 的順序 (預設快取大小為 50)
CREATE SEQUENCE dbo.CountBy1 as INT  --< 預設為 BigInt
    START WITH 10  --< 不可低於 MINVALUE
    INCREMENT BY 10
    MINVALUE 1   --< 可省略，預設最小值是序列物件之資料類型的最小值
    MAXVALUE 100; --< 可省略，預設最大值是序列物件之資料類型的最大值
GO  

-- 建立測試用的資料表
CREATE TABLE #Tbl1
( col1 int,
  col2 varchar(20) );
GO
CREATE TABLE #Tbl2
( col1 int,
  col2 varchar(20) );
GO


-- 在 INSERT 指定欄名和欄值
INSERT INTO #Tbl1 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test1');
SELECT * FROM #Tbl1;
INSERT INTO #Tbl2 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test2');
SELECT * FROM #Tbl2;

-- 傳回目前工作階段最後產生的識別值
SELECT current_value FROM sys.sequences WHERE name = 'CountBy1';

/* Question：
 若將號碼用完會如何？ --> 預設不重複使用號碼
*/

-- 變更順序物件，可重複使用號碼 --> 預設不重複使用號碼
ALTER SEQUENCE dbo.CountBy1
START WITH 1
INCREMENT BY 1
MAXVALUE 1000;
GO
-- ERROR：引數 'START WITH' 不可使用在 ALTER SEQUENCE 陳述式中


-- 再次變更順序物件，可重複使用號碼 --> 預設不重複使用號碼
-- 也可以試著加入 RESTART WITH 1 看看
ALTER SEQUENCE dbo.CountBy1
INCREMENT BY 1
MAXVALUE 1000;
GO

-- 查詢現在的設定
SELECT * FROM sys.sequences WHERE name = 'CountBy1';


-- 再次 INSERT 指定欄名和欄值 --> 會發現已使用新的設定
INSERT INTO #Tbl1 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test1');
SELECT * FROM #Tbl1;
INSERT INTO #Tbl2 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test2');
SELECT * FROM #Tbl2;

-- Clean Up
DROP SEQUENCE dbo.CountBy1;
GO