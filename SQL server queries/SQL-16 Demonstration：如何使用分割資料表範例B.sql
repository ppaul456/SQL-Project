範例 B：如何拆分範圍或合併範圍到另一個分割區
/*
 1) 將檔案群組加入至資料分割配置中
	ALTER PARTITION SCHEME partition_scheme_name NEXT USED [ filegroup_name ];
 2) 將資料分割分成兩個資料分割
	ALTER PARTITION FUNCTION partition_function_name() SPLIT RANGE ( boundary_value );
	或合併成一個資料分割
	ALTER PARTITION FUNCTION partition_function_name() MERGE RANGE ( boundary_value );
*/
USE TSQL2_TEST
GO
-- START：此次測試的記錄取最後 10 筆
-- 查詢最後 10 筆訂單資料
select *
from Sales.SalesOrderHeader_Partitioned
order by orderid desc
offset 0 rows
fetch next 10 rows only;
go
-- 結果：OrderID 應該是 830 ~ 821 之間，OrderDate 全為 2008 年

-- 更新將最後 5 筆訂單日期加 1 年
update dt
set orderdate += '19010101'
from (
		select *
		from Sales.SalesOrderHeader_Partitioned
		order by orderid desc
		offset 0 rows
		fetch next 5 rows only
	 ) dt;
go

-- 再更新另外 5 筆訂單日期加 2 年
update dt
set orderdate += '19020101'
from (
		select *
		from Sales.SalesOrderHeader_Partitioned
		order by orderid desc
		offset 5 rows
		fetch next 5 rows only
	 ) dt;
go

-- 查詢最後 10 筆訂單資料，是否已經變更期望的訂單日期
select *
from Sales.SalesOrderHeader_Partitioned
order by orderid desc
offset 0 rows
fetch next 10 rows only;
go
-- END：此次測試的記錄取最後 10 筆



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
-- 注意：有 10 筆訂單在 FileGroup4 (其中有 5 筆 2009 年，另 5 筆 2010 年)



-- START：建立檔案群組和對應的資料檔案以供測試
-- Create new filegroups
ALTER DATABASE TSQL2_TEST ADD FILEGROUP FileGroup5;
ALTER DATABASE TSQL2_TEST ADD FILEGROUP FileGroup6;
GO

-- Add file to filegroup 5
ALTER DATABASE TSQL2_TEST 
ADD FILE 
(
    NAME = TSQL2_TEST_PD5,
    FILENAME = 'C:\DATA\TSQL2_TEST_PD5.ndf'
)
TO FILEGROUP FileGroup5;
GO

-- Add file to filegroup 6
ALTER DATABASE TSQL2_TEST 
ADD FILE 
(
    NAME = TSQL2_TEST_PD6,
    FILENAME = 'C:\DATA\TSQL2_TEST_PD6.ndf'
)
TO FILEGROUP FileGroup6;
GO
-- END：建立檔案群組和對應的資料檔案以供測試



-- 將檔案群組加入至資料分割配置中
-- 只能指定一個檔案群組標記為 NEXT USED (下一個使用的)
ALTER PARTITION SCHEME OrdersByYear  
NEXT USED FileGroup5;  --< 不指定檔案群組名稱，則解除檔案群組 NEXT USED 屬性，意即分割配置不再使用此檔案群組
GO

-- 查詢哪一個檔案群組標記為 NEXT USED (下一個使用的)
select FileGroupName, Destination_ID, Data_Space_ID, Name  from
(
	select  FG.Name as FileGroupName
	, dds.destination_id
	, dds.data_space_id
	, prv.value
	, ps.Name
	, RANK() OVER (PARTITION BY ps.name order by dds.destination_Id) as dest_rank
	from sys.partition_schemes PS
	inner join sys.destination_data_spaces as DDS 
	on DDS.partition_scheme_id = PS.data_space_id
	inner join sys.filegroups as FG 
	on FG.data_space_id = DDS.data_space_ID 
	left join sys.partition_range_values as PRV 
	on PRV.Boundary_ID = DDS.destination_id and prv.function_id=ps.function_id 
	where prv.Value is null
 ) as a
 where dest_rank = 2;
GO

-- 將資料分割分成兩個資料分割
-- 成功後，查詢不到檔案群組標記為 NEXT USED (下一個使用的)
ALTER PARTITION FUNCTION YearlyPartitionFunction () 
SPLIT RANGE ('2009-12-31');
GO

-- 將兩個資料分割合併成一個資料分割 (SPLIT 的互補)
/*
ALTER PARTITION FUNCTION YearlyPartitionFunction () 
MERGE RANGE ('2009-12-31');
GO
*/

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


-- 操作：再利用前面的查詢來顯示各分割區的分佈狀態


-- 以下為復原 OrderDate 的變更

-- 更新將最後 5 筆訂單日期減 1 年
update dt
set orderdate -= '19010101'
from (
		select *
		from Sales.SalesOrderHeader_Partitioned
		order by orderid desc
		offset 0 rows
		fetch next 5 rows only
	 ) dt;
go

-- 再更新另外 5 筆訂單日期減 2 年
update dt
set orderdate -= '19020101'
from (
		select *
		from Sales.SalesOrderHeader_Partitioned
		order by orderid desc
		offset 5 rows
		fetch next 5 rows only
	 ) dt;
go

-- 查詢最後 10 筆訂單資料
select *
from Sales.SalesOrderHeader_Partitioned
order by orderid desc
offset 0 rows
fetch next 10 rows only;
go
-- 結果：OrderID 應該是 830 ~ 821 之間，OrderDate 全為 2008 年

-- 操作：利用前面的查詢來顯示各分割區的分佈狀態