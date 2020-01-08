USE TSQL2_TEST
GO
-- 準備移動第 1 個分割區到非分割區的資料表 (應有 152 筆資料列)
-- 統計各檔案群組(分割區)擁有的資料列筆數和資料頁面數量
SELECT	s.name AS SchemaName,
		t.name AS TableName,
		COALESCE(f.name, d.name) AS [FileGroup], 
		SUM(p.rows) AS [RowCount],
		SUM(a.total_pages) AS DataPages
FROM	sys.tables AS t
INNER	JOIN sys.indexes AS i ON i.object_id = t.object_id
INNER	JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id = i.index_id
INNER	JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
INNER	JOIN sys.schemas AS s ON s.schema_id = t.schema_id
LEFT	JOIN sys.filegroups AS f ON f.data_space_id = i.data_space_id
LEFT	JOIN sys.destination_data_spaces AS dds ON dds.partition_scheme_id = i.data_space_id AND dds.destination_id = p.partition_number
LEFT	JOIN sys.filegroups AS d ON d.data_space_id = dds.data_space_id
WHERE	t.[type] = 'U' AND i.index_id IN (0, 1) AND t.name LIKE 'SalesOrderHeader_Partitioned'
GROUP	BY s.NAME, COALESCE(f.NAME, d.NAME), t.NAME, t.object_id
ORDER	BY t.name
GO

-- 建立非分割資料表 (必須和分割資料表結構相同)
DROP TABLE IF EXISTS Sales.SalesOrderHeader_Archive
SELECT * INTO Sales.SalesOrderHeader_Archive
FROM Sales.SalesOrderHeader_Partitioned
WHERE 1 = 0;
GO



-- START：為非分割資料表指定檔案群組
-- 必須加入主鍵才能移轉
alter table Sales.SalesOrderHeader_Archive add constraint pk_orderid primary key (orderid);
go

-- 檔案群組從 PRIMARY 到 FileGroup1
-- 因為非分割資料表和分割資料表必須在相同的檔案群組
alter table Sales.SalesOrderHeader_Archive
drop constraint pk_orderid with
(move to FileGroup1);
go
-- END：為非分割資料表指定檔案群組



-- 從分割區資料表指定的分割區移轉到非分割資料表
DECLARE @p int = $PARTITION.YearlyPartitionFunction('2006-12-31');
ALTER TABLE Sales.SalesOrderHeader_Partitioned
SWITCH PARTITION @p TO Sales.SalesOrderHeader_Archive 
GO

-- 確認筆數為 152 筆資料列
SELECT COUNT(*) 非分割區筆數
FROM Sales.SalesOrderHeader_Archive 
GO

-- 統計各檔案群組(分割區)擁有的資料列筆數和資料頁面數量
SELECT	s.name AS SchemaName,
		t.name AS TableName,
		COALESCE(f.name, d.name) AS [FileGroup], 
		SUM(p.rows) AS [RowCount],
		SUM(a.total_pages) AS DataPages
FROM	sys.tables AS t
INNER	JOIN sys.indexes AS i ON i.object_id = t.object_id
INNER	JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id = i.index_id
INNER	JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
INNER	JOIN sys.schemas AS s ON s.schema_id = t.schema_id
LEFT	JOIN sys.filegroups AS f ON f.data_space_id = i.data_space_id
LEFT	JOIN sys.destination_data_spaces AS dds ON dds.partition_scheme_id = i.data_space_id AND dds.destination_id = p.partition_number
LEFT	JOIN sys.filegroups AS d ON d.data_space_id = dds.data_space_id
WHERE	t.[type] = 'U' AND i.index_id IN (0, 1) AND t.name LIKE 'SalesOrderHeader_Partitioned'
GROUP	BY s.NAME, COALESCE(f.NAME, d.NAME), t.NAME, t.object_id
ORDER	BY t.name
GO
-- 結果：第 1 個分割區應有 0 筆資料列



-- 以下示範再移轉回來，從非分割區資料表移轉到分割資料表指定的分割區

-- 必須加入 CHECK 條件約束以符合分割函數的界限值，否則不能從非分割區資料表移轉到分割資料表指定的分割區
ALTER TABLE Sales.SalesOrderHeader_Archive
WITH CHECK ADD CONSTRAINT CK_OrderDate CHECK( OrderDate <= '20061231' )
GO

-- 從非分割區資料表移轉到分割資料表指定的分割區
DECLARE @p int = $PARTITION.YearlyPartitionFunction('20061231');
ALTER TABLE Sales.SalesOrderHeader_Archive
SWITCH TO Sales.SalesOrderHeader_Partitioned PARTITION @p
GO

-- 確認非分割區資料表已無任何資料列
select * from Sales.SalesOrderHeader_Archive

-- 統計各檔案群組(分割區)擁有的資料列筆數和資料頁面數量
SELECT	s.name AS SchemaName,
		t.name AS TableName,
		COALESCE(f.name, d.name) AS [FileGroup], 
		SUM(p.rows) AS [RowCount],
		SUM(a.total_pages) AS DataPages
FROM	sys.tables AS t
INNER	JOIN sys.indexes AS i ON i.object_id = t.object_id
INNER	JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id = i.index_id
INNER	JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
INNER	JOIN sys.schemas AS s ON s.schema_id = t.schema_id
LEFT	JOIN sys.filegroups AS f ON f.data_space_id = i.data_space_id
LEFT	JOIN sys.destination_data_spaces AS dds ON dds.partition_scheme_id = i.data_space_id AND dds.destination_id = p.partition_number
LEFT	JOIN sys.filegroups AS d ON d.data_space_id = dds.data_space_id
WHERE	t.[type] = 'U' AND i.index_id IN (0, 1) AND t.name LIKE 'SalesOrderHeader_Partitioned'
GROUP	BY s.NAME, COALESCE(f.NAME, d.NAME), t.NAME, t.object_id
ORDER	BY t.name
GO
-- 結果：第 1 個分割區應有 152 筆資料列