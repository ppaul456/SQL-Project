--Demonstration：如何使用資料壓縮

USE MASTER
GO 

-- START：建立測試環境
if exists (select 1 from sys.databases where name = N'TSQL2_TEST')
	DROP DATABASE TSQL2_TEST
GO
CREATE DATABASE TSQL2_TEST
GO
USE TSQL2_TEST
GO
CREATE SCHEMA Sales
GO
DROP TABLE IF EXISTS [Sales].[SalesOrderDetails]
SELECT[orderid], [productid], [unitprice], [qty], [discount] into [TSQL2_TEST].[Sales].[SalesOrderDetails]
FROM [TSQL2].[Sales].[OrderDetails]
GO
-- END：建立測試環境



-- 加入主鍵會自動產生叢集索引
ALTER TABLE [Sales].[SalesOrderDetails] ADD  CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[orderid] ASC,
	[productid] ASC
)
GO

-- 加入非叢集索引
CREATE NONCLUSTERED INDEX [idx_nc_productid] ON [Sales].[SalesOrderDetails]
(
	[productid] ASC
)
GO

/* sp_estimate_data_compression_savings 評估資料表是否值得壓縮

 若資料表、索引或資料分割還未壓縮，則分別以不同壓縮類型，傳回壓縮資料表估計的資料列平均大小
 若資料表、索引或資料分割已經壓縮，則以 'NONE' 傳回未壓縮資料表估計的資料列平均大小

 第 1 個參數是指定包含資料表或索引檢視表的資料庫「結構描述名稱」
 第 2 個參數是指定索引所在的「資料表」或「索引檢視表」名稱
 第 3 個參數是指定「索引的識別碼」，NULL 代表所有索引相關資訊，若指定 NULL，下一個參數也必須是 NULL
 第 4 個參數是指定「物件的分割區編號」，NULL 代表所有資料分割的相關資訊
 第 5 個參數是指定欲評估的壓縮類型，支援 NONE, ROW, PAGE
 
 sys.partitions 可從欄位 data_compression、data_compression_desc 顯示資料表分割區的壓縮狀態
*/

EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'ROW';
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'PAGE';
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
-- index_id 為 1 的是叢集索引，2 以後的是非叢集索引
GO

-- 啟用資料表的壓縮，設定為「資料列壓縮」
ALTER TABLE Sales.SalesOrderDetails REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW); 
GO

-- 查詢目前資料表分割區的壓縮狀態
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
GO

-- 確定資料表是否可以進一步做 PAGE 壓縮
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'PAGE';
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
GO

-- 重建索引，並啟用索引的壓縮，設定為「頁面壓縮」
ALTER INDEX [PK_OrderDetails] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO
ALTER INDEX [idx_nc_productid] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO

-- 再一次評估，傳回要求之物件目前的大小，並針對要求的壓縮狀態預估物件大小
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'PAGE';
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
GO

-- 停用資料表的壓縮
ALTER TABLE [Sales].[SalesOrderDetails] REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = NONE);  
GO  

-- 停用索引的壓縮
ALTER INDEX [PK_OrderDetails] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE);
GO
ALTER INDEX [idx_nc_productid] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE);
GO