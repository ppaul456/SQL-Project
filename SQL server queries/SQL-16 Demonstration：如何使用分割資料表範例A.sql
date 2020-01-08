操作前，先確認 C:\ 是否存在資料夾名稱為 DATA，若無，則必須自行建立

範例 A：建立並觀察分割資料表

USE master;
GO

-- START：開始建立測試環境
IF EXISTS (select 1 from sys.databases where name = N'TSQL2_TEST')
	DROP DATABASE TSQL2_TEST
GO
CREATE DATABASE TSQL2_TEST
GO

-- Create new filegroups
ALTER DATABASE TSQL2_TEST ADD FILEGROUP FileGroup1;
ALTER DATABASE TSQL2_TEST ADD FILEGROUP FileGroup2;
ALTER DATABASE TSQL2_TEST ADD FILEGROUP FileGroup3;
ALTER DATABASE TSQL2_TEST ADD FILEGROUP FileGroup4;
GO

-- Add file to filegroup 1
ALTER DATABASE TSQL2_TEST 
ADD FILE 
(
    NAME = TSQL2_TEST_PD1,
    FILENAME = 'C:\DATA\TSQL2_TEST_PD1.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup1;
GO

-- Add file to filegroup 2
ALTER DATABASE TSQL2_TEST 
ADD FILE 
(
    NAME = TSQL2_TEST_PD2,
    FILENAME = 'C:\DATA\TSQL2_TEST_PD2.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup2;
GO

-- Add file to filegroup 3
ALTER DATABASE TSQL2_TEST 
ADD FILE 
(
    NAME = TSQL2_TEST_PD3,
    FILENAME = 'C:\DATA\TSQL2_TEST_PD3.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup3;
GO

-- Add file to filegroup 4
ALTER DATABASE TSQL2_TEST 
ADD FILE 
(
    NAME = TSQL2_TEST_PD4,
    FILENAME = 'C:\DATA\TSQL2_TEST_PD4.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup4;
GO

USE TSQL2_TEST
GO
CREATE SCHEMA Sales
GO
-- END：開始建立測試環境


-- 建立分割函數 partition function
CREATE PARTITION FUNCTION YearlyPartitionFunction (datetime) 
AS RANGE LEFT   --< 可省略關鍵子句 LEFT
FOR VALUES ('2006-12-31 00:00:00.000', '2007-12-31 00:00:00.000',  '2008-12-31 00:00:00.000');
GO

-- 建立分割配置 partition scheme
CREATE PARTITION SCHEME OrdersByYear 
AS PARTITION YearlyPartitionFunction 
TO (FileGroup1, FileGroup2, FileGroup3, FileGroup4);
GO

create sequence SeqNO as bigint
start with 1
increment by 1

-- 建立分割資料表 partitioned table
CREATE TABLE Sales.SalesOrderHeader_Partitioned
(
	[orderid] [int] NOT NULL DEFAULT next value for dbo.SeqNO,
	[custid] [int] NULL,
	[empid] [int] NOT NULL,
	[orderdate] [datetime] NOT NULL,
	[requireddate] [datetime] NOT NULL,
	[shippeddate] [datetime] NULL,
	[shipperid] [int] NOT NULL,
	[freight] [money] NOT NULL,
	[shipname] [nvarchar](40) NOT NULL,
	[shipaddress] [nvarchar](60) NOT NULL,
	[shipcity] [nvarchar](15) NOT NULL,
	[shipregion] [nvarchar](15) NULL,
	[shippostalcode] [nvarchar](10) NULL,
	[shipcountry] [nvarchar](15) NOT NULL,
) 
-- 檔案群組的配置 Filegroup scheme
ON OrdersByYear(OrderDate);  --< 必須在關鍵子句 ON 指定「分割配置」名稱
GO

-- Copy data into the partitioned table
INSERT INTO Sales.SalesOrderHeader_Partitioned 
	([custid], [empid], [orderdate], [requireddate], [shippeddate], [shipperid], [freight], [shipname], [shipaddress], [shipcity], [shipregion], [shippostalcode], [shipcountry])
SELECT  [custid], [empid], [orderdate], [requireddate], [shippeddate], [shipperid], [freight], [shipname], [shipaddress], [shipcity], [shipregion], [shippostalcode], [shipcountry]
FROM	[TSQL2].[Sales].[Orders]
GO

-- 以下顯示各分割區的分佈狀態

-- Count of rows per year - the partitions should match this
SELECT	DISTINCT DATEPART(YEAR, OrderDate) AS [Year], COUNT(*) AS TotalOrders
FROM	Sales.SalesOrderHeader_Partitioned
GROUP	BY DATEPART(YEAR, OrderDate)
ORDER	BY 1
GO

-- Count of rows per partition - the numbers should be the same as the query above
-- 判斷資料表是否已分割
-- 資料表已分割時，傳回一個或多個資料列，如果資料表未分割，則不會傳回任何資料列
-- 注意欄名 durability_desc、type_desc、name(最右側)、data_space_id、type、type_desc、function_id
SELECT *   
FROM sys.tables AS t   
JOIN sys.indexes AS i   
    ON t.[object_id] = i.[object_id]   
    AND i.[type] IN (0,1)   
JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id   
WHERE t.name = 'SalesOrderHeader_Partitioned';   
GO

-- 傳回每一個分割區界限值
-- 注意欄名 data_space_id、function_id、type_desc、boundary_id、BoundaryValue
SELECT t.name AS TableName, i.name AS IndexName, p.partition_number, p.partition_id, i.data_space_id, f.function_id, f.type_desc, r.boundary_id, r.value AS BoundaryValue   
FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p  
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE t.name = 'SalesOrderHeader_Partitioned' AND i.type <= 1  
ORDER BY p.partition_number;
GO

-- 傳回資料表之分割區資料行的名稱
SELECT   
    t.[object_id] AS ObjectID   
    , t.name AS TableName   
    , ic.column_id AS PartitioningColumnID   
    , c.name AS PartitioningColumnName   
FROM sys.tables AS t   
JOIN sys.indexes AS i   
    ON t.[object_id] = i.[object_id]   
    AND i.[type] <= 1 -- clustered index or a heap   
JOIN sys.partition_schemes AS ps   
    ON ps.data_space_id = i.data_space_id   
JOIN sys.index_columns AS ic   
    ON ic.[object_id] = i.[object_id]   
    AND ic.index_id = i.index_id   
    AND ic.partition_ordinal >= 1 -- because 0 = non-partitioning column   
JOIN sys.columns AS c   
    ON t.[object_id] = c.[object_id]   
    AND ic.column_id = c.column_id   
WHERE t.name = 'SalesOrderHeader_Partitioned' ;   
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

-- 異動資料以觀察記錄是否移動在不同的分割區之間

-- 查詢某一筆訂單資料
select top 1 *
from Sales.SalesOrderHeader_Partitioned
order by orderid desc;
go

-- 嘗試更新將某一筆訂單日期加 1 年 (自行再加到 2 年以上)
update dt
set orderdate += '19010101'
from (
		select top 1 *
		from Sales.SalesOrderHeader_Partitioned
		order by orderid desc
	 ) dt;
go

-- 操作：利用前面的查詢來顯示各分割區的分佈狀態

-- 嘗試更新將某一筆訂單日期減 1 年 (復原變更)
update dt
set orderdate -= '19010101'
from (
		select top 1 *
		from Sales.SalesOrderHeader_Partitioned
		order by orderid desc
	 ) dt;
go

-- 操作：再利用前面的查詢來顯示各分割區的分佈狀態