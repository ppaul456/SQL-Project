--範例 A：使用和實作「叢集索引」和「非叢集索引」的「包含資料行索引｣(涵蓋索引)：
--觀察索引片段(碎片) 產生原因
--解決「遺漏索引｣的問題

-- Step 1: 切換到 tempdb 資料庫
USE tempdb;
GO

-- Step 2: 建立指定主鍵的資料表，不指定「條件約束」名稱 (自動產生)
CREATE TABLE dbo.PhoneLog
( 
  PhoneLogID int IDENTITY(1,1) PRIMARY KEY,
  LogRecorded datetime2 NOT NULL,
  PhoneNumberCalled nvarchar(100) NOT NULL,
  CallDurationMs int NOT NULL
);
GO

-- Step 3: 查詢 sys.indexes 觀察其索引相關結構
/* (注意 SQL Server 為「條件約束｣和「索引｣選擇的名稱)
 在 SSMS 從右列路徑也可以看到：(如下)
 展開「資料庫｣ > 「系統資料庫｣ > 「tempdb｣ > 「資料表｣ > 「dbo.PhoneLog｣ > 「索引｣ > 「PK__PhoneLog__流水號｣ > 右鍵 > 「屬性｣
 */
SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'PhoneLog';
GO
SELECT * FROM sys.key_constraints WHERE OBJECT_NAME(parent_object_id) = N'PhoneLog';
GO

-- Step 4: 插入 10 萬筆記錄
/* 做法一，自行選擇是否執行
-- (請注意此命令運行的速度比 WHILE 慢，約執行 57 秒)
-- 不要在已經顯示「包括實際執行計畫｣ (CTR+M) 下執行，因為會更慢
SET NOCOUNT ON;
INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationMs)
	VALUES( SYSDATETIME(), '999-9999', CAST(RAND() * 1000 AS int) )
GO 100000 --insert dummy data, 100,000 times
SET NOCOUNT OFF;
*/

-- 做法二
-- 不要在已經顯示「包括實際執行計畫｣ (CTR+M) 下執行，因為會更慢
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 100000 BEGIN
	INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationMs)
		VALUES( SYSDATETIME(), '999-9999', CAST(RAND() * 1000 AS int) );
	SET @Counter += 1;
END;
SET NOCOUNT OFF;
GO



-- Step 5: 從 sys.dm_db_index_physical_stats 檢查索引片段 (碎片) 的層級
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('dbo.PhoneLog'), NULL, NULL, 'DETAILED');
GO

-- SQL-17 說明如何查詢目前資料庫所有資料表和檢視表相關的索引
select	db_name(database_id) [資料庫],
		object_name(object_id) [資料表和檢視表],
		partition_number [分割區],
		index_id [索引編號],
		(
			select name
			from sys.indexes i
			where i.object_id = d.object_id
				and i.index_id = d.index_id
		) [索引名稱],
		index_type_desc [索引種類],
		index_depth [索引層級數目],
		index_level [索引目前層級],
		avg_fragmentation_in_percent [片段總計],
		fragment_count [分葉層級的片段數目],
		avg_fragment_size_in_pages [分葉層級的一個片段平均頁數],
		page_count [索引或資料頁總數],
        avg_page_space_used_in_percent [頁面飽合度]
from sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('dbo.PhoneLog'), NULL, NULL, 'DETAILED') d
order by [資料表和檢視表], [索引名稱], [分葉層級的片段數目], [索引編號], [索引目前層級] desc;


-- Step 6: 注意資料行 avg_fragmentation_in_percent 和 avg_page_space_used_in_percent

-- Step 7: 修改資料表中的 10 萬筆記錄，這將增加資料並導致頁面碎片
-- (請注意此命令運行的速度要快得多，約執行 3 秒)
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 100000 BEGIN
	UPDATE dbo.PhoneLog 
	SET PhoneNumberCalled = REPLICATE('9',CAST(RAND() * 100 AS int))
    WHERE PhoneLogID = @Counter % 100000;
	IF @Counter % 100 = 0 PRINT @Counter;
	SET @Counter += 1;
END;
SET NOCOUNT OFF;
GO

-- Step 8: 從 sys.dm_db_index_physical_stats 檢查檢查索引片段 (碎片) 的層級
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('dbo.PhoneLog'), NULL, NULL, 'DETAILED');
GO

-- Step 9: 注意資料行 avg_fragmentation_in_percent 和 avg_page_space_used_in_percent

-- Step 10: 重建資料表的所有索引
ALTER INDEX ALL ON dbo.PhoneLog REBUILD;
GO

-- Step 11: 從 sys.dm_db_index_physical_stats 檢查檢查索引片段 (碎片) 的層級
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.PhoneLog'),NULL,NULL,'DETAILED');
GO

-- Step 12: 注意資料行 avg_fragmentation_in_percent 和 avg_page_space_used_in_percent

-- Step 13: 執行並顯示「包括實際執行計畫｣ (CTR+M)
/* 注意
 資料表 [PhoneLog] 只有一個叢集索引鍵為 PhoneLogID 的叢集索引，並沒有為其它 3 個欄位建立相關索引
 資料表 [AdventureWorks].[Production].Product 也有一個叢集索引鍵為 PhoneLogID 的叢集索引
 以及一個非叢集索引鍵為 Name 的唯一的非叢集索引
*/
SELECT [PhoneLogID]
      ,[LogRecorded]
      ,[PhoneNumberCalled]
      ,[CallDurationMs]
	  ,p.Name
FROM [tempdb].[dbo].[PhoneLog] pl 
	join [AdventureWorks].[Production].Product p ON pl.CallDurationMs = p.ProductID;
-- 執行計畫：遺漏索引 (影響 99.4916)：CREATE NONCLUSTERED INDEX ... <-- 這個訊息提供如何解決的涵蓋索引 T-SQL 語法
GO

-- Step 14: 建立一個涵蓋索引 Covering Index，要注意 INCLUDE 包含的資料行清單，是執行計畫中列出的資料行之一(共有3個資料行未建立索引)
-- 這可以解決「遺漏索引｣ 的問題
CREATE NONCLUSTERED INDEX NCIX_CallDurationMS
ON [dbo].[PhoneLog] ( [CallDurationMs] )		--< 前面執行計畫中列出的 1 個資料行
INCLUDE ( [LogRecorded], [PhoneNumberCalled] )	--< 前面執行計畫中列出的 2 個資料行
GO

-- Step 15: 執行並顯示「包括實際執行計畫｣ (CTR+M) - 這時已使用新的索引 [NCIX_CallDurationMS]
SELECT [PhoneLogID]
      ,[LogRecorded]
      ,[PhoneNumberCalled]
      ,[CallDurationMs]
	  ,p.Name
FROM [tempdb].[dbo].[PhoneLog] pl 
	join [AdventureWorks].[Production].Product p ON pl.CallDurationMs = p.ProductID;
-- 執行計畫：應看不到剛才的「遺漏索引｣訊息，但滑鼠移到「索引掃描｣ 的快顯訊息中，注意在「物件｣中應有使用新的索引 [NCIX_CallDurationMS]
GO

-- Step 16: Drop the table
DROP TABLE dbo.PhoneLog;
GO