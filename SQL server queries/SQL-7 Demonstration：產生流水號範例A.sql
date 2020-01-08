範例 A：資料行層級的 IDENTITY (自動取號和人工取號)

-- 建立測試用的資料表
CREATE TABLE #Tbl
( col1 int IDENTITY(1, 1) NOT NULL, --< (1, 1) 可省略
  col2 varchar(20) NOT NULL);
GO

-- 預設不可在 INSERT 指定欄名
INSERT INTO #Tbl (col2) VALUES ('Identity Test');
SELECT * FROM #Tbl;

-- 在 INSERT 指定欄名和欄值
INSERT INTO #Tbl (col1, col2) VALUES (20, 'Identity Test');
SELECT * FROM #Tbl;
-- ERROR：當 IDENTITY_INSERT 設為 OFF 時，無法將外顯值插入資料表 '#Tbl' 的識別欄位中

-- 傳回目前工作階段最後產生的識別值
SELECT @@IDENTITY

-- 重置「種子識別值」為 100 --> 會傳回目前最後的識別值
DBCC CHECKIDENT ('#Tbl', RESEED, 100);

-- 再次傳回目前工作階段最後產生的識別值 --> 其值不變，仍是重置前的號碼
SELECT @@IDENTITY

-- 實際 INSERT 測試看看 --> 其值已改變 (從 101 開始)
INSERT INTO #Tbl (col2) VALUES ('Identity Test');
SELECT * FROM #Tbl;

-- 再次傳回目前工作階段最後產生的識別值 (應是 101 以後的號碼)
SELECT @@IDENTITY

/* Question：
 如何在間隔值中間，以人工安排號碼？
    1. SET IDENTITY_INSERT 資料表 ON
    2. 在 INSERT 指定欄名和欄值
    3. SET IDENTITY_INSERT 資料表 OFF --< 用完要復原
*/

--	1. SET IDENTITY_INSERT 資料表 ON
    SET IDENTITY_INSERT #Tbl ON;

--	2. 在 INSERT 指定欄名和欄值
    INSERT INTO #Tbl (col1, col2) VALUES (50, 'Identity Test');
    SELECT * FROM #Tbl;

--	3. SET IDENTITY_INSERT 資料表 OFF --< 用完要復原
    SET IDENTITY_INSERT #Tbl OFF;


-- 恢復自動取號後號碼是？
-- 再次傳回目前工作階段最後產生的識別值 --> 哪個會是正確答案？
SELECT @@IDENTITY, IDENT_CURRENT('#Tbl'), SCOPE_IDENTITY()

-- 使用其它方式查詢
DBCC CHECKIDENT('#Tbl')


-- 實際 INSERT 測試看看 --> 應是重置「種子識別值」為 100 以後的號碼
INSERT INTO #Tbl (col2) VALUES ('Identity Test');
SELECT * FROM #Tbl;