--簡單案例 (以下提供如何檢視目前交易模式的 T-SQL)

drop table if exists #tbl;
create table #tbl
(	pid int primary key,
	pname varchar(20),
	price numeric(6, 1)	);
go

----------------------- 我是分隔線 -----------------------
-- 設定為隱含交易
SET IMPLICIT_TRANSACTIONS ON;
GO

-- 檢視目前交易模式的設定
IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 0)
	PRINT '沒有執行中的交易，『自動認可交易』模式(預設)';
ELSE IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 2)
	PRINT '已啟用『隱含交易』，但尚未啟動交易';
ELSE IF (@@OPTIONS & 2 = 0)
	PRINT '已啟用『隱含交易』，『明確交易』正在執行中';
ELSE 
	PRINT '已啟用『隱含交易』，但『隱含交易』或『明確交易』正在執行中' + CAST(@@OPTIONS & 2 AS VARCHAR(5));
GO

----------------------- 我是分隔線 -----------------------

insert into #tbl values (1, 'Product 1', 100.5);
insert into #tbl values (2, 'Product 2', 20000.5);
insert into #tbl values (3, 'Product 3', 30000.5);
GO

ROLLBACK;  --< 可改成 COMMIT 再試試看

----------------------- 我是分隔線 -----------------------
-- 恢復成自動認可
SET IMPLICIT_TRANSACTIONS OFF;
GO

-- 檢視目前交易模式的設定
IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 0)
	PRINT '沒有執行中的交易，『自動認可交易』模式(預設)';
ELSE IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 2)
	PRINT '已啟用『隱含交易』，但尚未啟動交易';
ELSE IF (@@OPTIONS & 2 = 0)
	PRINT '已啟用『隱含交易』，『明確交易』正在執行中';
ELSE 
	PRINT '已啟用『隱含交易』，但『隱含交易』或『明確交易』正在執行中' + CAST(@@OPTIONS & 2 AS VARCHAR(5));
GO

select * from #tbl;
go