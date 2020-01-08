USE AdventureWorks;
GO

-- 啟用查詢存放區
ALTER DATABASE AdventureWorks SET QUERY_STORE = ON;  
GO

-- START：準備測試環境
-- 建立檢視表
DROP VIEW IF EXISTS dbo.vw_TransactionHistorySummary;
GO
CREATE VIEW dbo.vw_TransactionHistorySummary
	WITH SCHEMABINDING
	AS
		SELECT ProductID, SUM(Quantity) AS 'Quantity', COUNT_BIG(*) AS 'Count'
			FROM Production.TransactionHistory
			GROUP BY ProductID;
GO

-- 在檢視表建立唯一叢集索引 (建立索引檢視表)
CREATE UNIQUE CLUSTERED INDEX ix_TransactionHistorySummary
	ON dbo.vw_TransactionHistorySummary(ProductID);
GO

-- 清除查詢存放區
ALTER DATABASE AdventureWorks SET QUERY_STORE CLEAR;
GO
-- END：準備測試環境



-- 以下為測試的用途
-- 連續執行 SELECT 查詢 (執行 6 次)
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;
GO 6

-- 延遲連續執行 SELECT 查詢 (執行 5 次)
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;

WAITFOR DELAY '00:00:03';   --< 模擬不同時間點的查詢
GO 5


-- 以高額的數量來更新查詢最佳化統計資料 (其數字只要比目前查詢量大即可)
UPDATE STATISTICS dbo.vw_TransactionHistorySummary
	WITH ROWCOUNT = 60000000, PAGECOUNT = 10000000;
GO

-- 延遲連續執行 SELECT 查詢 (執行 2 次)
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;

WAITFOR DELAY '00:00:05';   --< 模擬不同時間點的查詢
GO 2



/* 操作：從查詢存放區中開啟「資源耗用量排名在前的查詢｣ (檢視) - Top Resource Consuming Queries report
 1) 左上窗格是各 SELECT 查詢的查詢識別碼，選擇不同查詢識別碼會影響右上窗格
	1-1) 滑鼠停留在各 SELECT 查詢識別碼，會顯示其摘要資訊，注意預設顯示查詢識別碼
	1-2) 摘要資訊中的「總計 持續時間 (毫秒)｣，是從開始以來到目前的統計資訊
	1-3) 長條圖下有下拉式選單，內容有「查詢識別碼｣、「總計 持續時間｣、「執行計數｣
 2) 右上窗格是查詢識別碼的「計劃 # 的摘要｣，應有兩個方案識別碼，選擇不同方案識別碼會影響下方窗格
	這裡可以為左上窗格的各 SELECT 查詢，強制指定不同的執行計畫，可評估不同執行計畫的影響
 3) 下方窗格是各方案識別碼的「執行計畫｣，在上下窗格中間橫條的右側，注意各執行計畫都未選用「強制執行計畫｣
	這裡的「執行計畫｣都是「估計執行計畫｣
*/



/* 操作：選用「強制執行計畫｣
 1) 自由選擇右上窗格的方案識別碼
 2) 在上下窗格中間橫條的右側，選擇「強制執行計畫｣
 3) 在「確認｣的對話框，按【是】
*/



-- 延遲連續執行 SELECT 查詢 (執行 3 次)
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;

WAITFOR DELAY '00:00:03';   --< 模擬不同時間點的查詢
GO 3



/* 操作：觀察「資源耗用量排名在前的查詢｣ (檢視)
 1) 按【F5】重整檢視內容
 2) 注意下方窗格不同執行計畫中：
	* 應只有一個執行計畫內容有一個「叢集索引搜尋｣和多個「叢集索引掃描｣
	* 另一個執行計畫內容有多個「叢集索引掃描｣
*/



-- 以下為復原變更，和主題無關
-- 停用查詢存放區
ALTER DATABASE AdventureWorks SET QUERY_STORE = OFF;
GO

-- 清除查詢存放區
ALTER DATABASE AdventureWorks SET QUERY_STORE CLEAR;
GO