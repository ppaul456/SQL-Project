--範例 B：若「歷程記錄資料表」大小已經大到影響資料庫運作時，該如何清空「歷程記錄資料表」的記錄？

USE TSQL2;
GO

-- 產生用於測試的資料表 Sales.COPY_OrderDetails
DROP TABLE IF EXISTS Sales.COPY_OrderDetails
SELECT * INTO Sales.COPY_OrderDetails
FROM Sales.OrderDetails;
GO

-- 因為 SELECT...INTO 不會一併複製主鍵，所以必須自行再加入主鍵
-- 另外，時態表要求必須具有主索引鍵
ALTER TABLE [Sales].[COPY_OrderDetails]
ADD CONSTRAINT [PK_COPY_OrderDetails]
PRIMARY KEY CLUSTERED ( [orderid] ASC, [productid] ASC );
GO

-- Add the two date range columns
-- 必須加入兩個資料行來記錄「開始」和「結束」的時間
-- 並加入關鍵子句 HIDDEN 用來隱藏資料行
-- 並加入關鍵子句 PERIOD FOR SYSTEM_TIME 參考到兩個資料行
ALTER TABLE Sales.COPY_OrderDetails
ADD 
StartDate datetime2(0) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT DF_ProductSysStartDate DEFAULT SYSUTCDATETIME(), 
EndDate datetime2(0) GENERATED ALWAYS AS ROW END HIDDEN CONSTRAINT DF_ProductSysEndDate DEFAULT CONVERT(datetime2 (0), '9999-12-31 23:59:59'), 
PERIOD FOR SYSTEM_TIME (StartDate, EndDate); 
GO 

-- Enable system-versioning
-- 啟用「系統控制版本」的資料表，並指定「自訂名稱歷程記錄」資料表
ALTER TABLE Sales.COPY_OrderDetails
SET	(
		SYSTEM_VERSIONING = ON 
		(HISTORY_TABLE = Sales.COPY_OrderDetails_History)
	);
GO

---------------------------- 我是分隔線 ----------------------------

/* 以下模擬異動資料 */
-- 查詢並觀察異動前的資料列
SELECT *
FROM Sales.COPY_OrderDetails
WHERE orderid = 10248;
GO

-- 嘗試更新 QTY 資料行
UPDATE	Sales.COPY_OrderDetails
SET		QTY += 100
WHERE	orderid = 10248;
GO

-- 藉由明確指定欄位名稱方式以顯示 StartDate, EndDate 兩個資料行
SELECT	*, StartDate, EndDate
FROM	Sales.COPY_OrderDetails FOR SYSTEM_TIME ALL
WHERE	orderid = 10248;
GO

---------------------------- 我是分隔線 ----------------------------

/* 以下模擬整理「歷程記錄資料表」*/
/* 假設「歷程記錄資料表」大小已經大到影響資料庫運作時
 1) 備份資料庫
 2) 停用 系統版本控制
 3) 處理「歷程記錄資料表」的作業，例如資料匯出、清空等
 4) 啟用 系統版本控制
*/

-- 2) 停用 系統版本控制
ALTER TABLE Sales.COPY_OrderDetails
SET (SYSTEM_VERSIONING = OFF);
GO

-- 3) 處理「歷程記錄資料表」的作業，例如資料匯出、清空等
-- 假設已經資料匯出完畢，接著即可清空資料表
-- 以下會顯示清空前後的筆數
SELECT COUNT(*) FROM Sales.COPY_OrderDetails_History;
TRUNCATE TABLE Sales.COPY_OrderDetails_History;
SELECT COUNT(*) FROM Sales.COPY_OrderDetails_History;
GO

--  4) 啟用 系統版本控制
ALTER TABLE Sales.COPY_OrderDetails
SET	(
		SYSTEM_VERSIONING = ON 
		(HISTORY_TABLE = Sales.COPY_OrderDetails_History)
	);
GO

-- Clean up
ALTER TABLE Sales.COPY_OrderDetails
SET (SYSTEM_VERSIONING = OFF);
GO
DROP TABLE IF EXISTS Sales.COPY_OrderDetails;
DROP TABLE IF EXISTS Sales.COPY_OrderDetails_History;
GO