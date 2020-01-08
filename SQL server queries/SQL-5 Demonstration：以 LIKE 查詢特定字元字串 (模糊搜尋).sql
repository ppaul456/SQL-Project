LIKE 支援 ASCII 模式比對 (char 和 varchar) 和 Unicode 模式比對 (nchar 和 nvarchar)

當所有「引數」全部都是 ASCII 字元資料類型時，就會執行 ASCII 模式比對
如果有任何「引數」之一是 Unicode 資料類型，所有「引數」都會轉換成 Unicode，且會執行 Unicode 模式比對
當您搭配 LIKE 使用 Unicode 資料 (nchar 或 nvarchar 資料類型) 時，尾端空白很重要；
不過，針對非 Unicode 資料，尾端空白就不重要

-- 第 1 例
-- ASCII pattern matching with char column  
CREATE TABLE #t1 (col1 char(30));  
INSERT INTO #t1 VALUES ('Robert King');
GO
SELECT *   
FROM #t1   
WHERE col1 LIKE '% King';   -- returns 1 row  

-- 第 2 例
-- Unicode pattern matching with nchar column  
CREATE TABLE #t2 (col1 nchar(30));  
INSERT INTO #t2 VALUES ('Robert King');  -- 有沒有加 N 都一樣
GO
SELECT *   
FROM #t2
WHERE col1 LIKE '% King';   -- no rows returned (有沒有加 N 都一樣)

-- 第 3 例
-- Unicode pattern matching with nchar column and RTRIM  
CREATE TABLE #t3 (col1 nchar (30));  
INSERT INTO #t3 VALUES ('Robert King');  -- 有沒有加 N 都一樣
GO
SELECT *   
FROM #t3   
WHERE RTRIM(col1) LIKE '% King';   -- returns 1 row (有沒有加 N 都一樣)