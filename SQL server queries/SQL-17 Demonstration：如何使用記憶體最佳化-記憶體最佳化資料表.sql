範例 A：資料表變數搭配交易控制
DECLARE @TblVar TABLE
( SeqNo int identity,
  AttachName varchar(10),
  CreatedDate datetime
);

BEGIN TRANSACTION

	INSERT INTO @TblVar (AttachName, CreatedDate) VALUES ('Demo1', getdate());
	INSERT INTO @TblVar (AttachName, CreatedDate) VALUES ('Demo2', getdate());

	SELECT * FROM @TblVar;

ROLLBACK

SELECT * FROM @TblVar;



---------------------------------------------------------------------------------------------------------
範例 B：如何建立和使用記憶體最佳化資料表 Memory-Optimized Tables
USE MASTER
DROP DATABASE IF EXISTS MemDemo
GO

CREATE DATABASE MemDemo
GO

-- 若要建立記憶體最佳化資料表，必須先建立記憶體最佳化檔案群組
-- https://docs.microsoft.com/zh-tw/sql/relational-databases/in-memory-oltp/the-memory-optimized-filegroup?view=sql-server-2017
ALTER DATABASE MemDemo 
ADD FILEGROUP imoltp_mod 
CONTAINS MEMORY_OPTIMIZED_DATA
GO

ALTER DATABASE MemDemo 
ADD FILE (name='imoltp_mod1', filename='c:\data\imoltp_mod1') TO FILEGROUP imoltp_mod
GO

-- Step 1 - Create a memory-optimized table
USE MemDemo
GO
CREATE TABLE dbo.MemoryTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),
 date_value DATETIME NULL)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);


-- Step 2 - Create a disk-based table
CREATE TABLE dbo.DiskTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED,
 date_value DATETIME NULL);


-- Step 3 - Insert 500,000 rows into DiskTable
-- This code uses a transaction to insert rows into the disk-based table.
-- When code execution is complete, look at the lower right of the query editor status bar and note how long it has taken.
BEGIN TRAN
	DECLARE @Diskid int = 1
	WHILE @Diskid <= 500000
	BEGIN
		INSERT INTO dbo.DiskTable VALUES (@Diskid, GETDATE())
		SET @Diskid += 1
	END
COMMIT;

-- Step 4 - Verify DiskTable contents 
-- Confirm that the table now contains 500,000 rows
SELECT COUNT(*) FROM dbo.DiskTable;

-- Step 5 - Insert 500,000 rows into MemoryTable 
-- This code uses a transaction to insert rows into the memory-optimized table.
/* When code execution is complete, look at the lower right of the query editor status bar
   and note how long it has taken. It should be significantly lower than the time that it 
   takes to insert data into the disk-based table.
*/
BEGIN TRAN
	DECLARE @Memid int = 1
	WHILE @Memid <= 500000
	BEGIN
		INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
		SET @Memid += 1
	END
COMMIT;

-- Step 6 - Verify MemoryTable contents
-- Confirm that the table now contains 500,000 rows.
SELECT COUNT(*) FROM dbo.MemoryTable;

-- Step 7 - Delete rows from DiskTable 
-- Note how long it has taken for this code to execute.
DELETE FROM DiskTable;

-- Step 8 - Delete rows from MemoryTable 
/* Note how long it has taken for this code to execute. 
It should be significantly lower than the time that it takes to 
delete rows from the disk-based table.
*/
DELETE FROM MemoryTable;

-- Step 9 - View memory-optimized table stats
SELECT o.Name, m.*
FROM
sys.dm_db_xtp_table_memory_stats m
JOIN sys.sysobjects o
ON m.object_id = o.id




---------------------------------------------------------------------------------------------------------
範例 C：如何建立和使用原生編譯的預存程序 Natively Compiled Stored Procedures
-- Step 1 - Use the MemDemo database
USE MemDemo

-- Step 2 - Create a native stored proc
CREATE PROCEDURE dbo.InsertData
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
	DECLARE @Memid int = 1
	WHILE @Memid <= 500000
	BEGIN
		INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
		SET @Memid += 1
	END
END;
GO

-- Step 3 - Use the native stored proc
/* Note how long it has taken for the stored procedure to execute. 
This should be significantly lower than the time that it takes to 
insert data into the memory-optimized table by using a Transact-SQL INSERT statement.
*/
EXEC dbo.InsertData;

-- Step 4 - Verify MemoryTable contents
-- Confirm that the table now contains 500,000 rows.
SELECT COUNT(*) FROM dbo.MemoryTable;