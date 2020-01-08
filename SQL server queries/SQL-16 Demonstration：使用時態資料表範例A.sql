--範例 A：如何使用時態資料表
--早期做法，必須自行設計歷程記錄資料表來完成 (僅舉例，並非一定是如此設計)

drop table if exists hr.COPY_Employees
CREATE TABLE [HR].[COPY_Employees](
    [empid] [int] NOT NULL,
    [lastname] [nvarchar](20) NOT NULL,
    [salary] [money] NOT NULL)
GO

insert into hr.COPY_Employees
select empid, lastname, salary from hr.Employees
GO

create table hr.COPY_Employees_History
(
    [empid] [int] NOT NULL,
    [salary] [money] NOT NULL,
    [EndDate] date
)
GO

update hr.COPY_Employees
set salary += 1000
output deleted.empid, deleted.salary, getdate() into hr.COPY_Employees_History
where empid = 1

select * from hr.COPY_Employees
select * from hr.COPY_Employees_History

-------------------------------------------------------------------------------------------------------------
--現在做法，只需要建立「系統控制版本」的資料表即可

USE TSQL2;
GO


-- 產生用於測試的資料表 Sales.COPY_Orders
DROP TABLE IF EXISTS Sales.COPY_Orders
SELECT * INTO Sales.COPY_Orders
FROM Sales.Orders;
GO


-- 因為 SELECT...INTO 不會一併複製主鍵，所以必須自行再加入主鍵
ALTER TABLE [Sales].[COPY_Orders] 
ADD CONSTRAINT [PK_COPY_Orders]
PRIMARY KEY CLUSTERED ( [orderid] ASC );
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


-- 再加入外來鍵的參考
alter table [Sales].[COPY_OrderDetails]
add constraint fk_FK_COPY_OrderDetails_COPY_Orders
foreign key (orderid)
references [Sales].[COPY_Orders] (orderid)
--on delete cascade on update cascade;
go


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

-- 查詢並觀察異動前的資料列
SELECT *
FROM Sales.COPY_OrderDetails
WHERE orderid = 10248;
GO

-- Make Data Modifications
UPDATE	Sales.COPY_OrderDetails
SET		QTY += 100
WHERE	orderid = 10248;
GO

-- Query the data changes
-- 注意：看不到 StartDate, EndDate 兩個資料行
SELECT	*
FROM	Sales.COPY_OrderDetails FOR SYSTEM_TIME ALL
WHERE	orderid = 10248;
GO

-- 藉由明確指定欄位名稱方式以顯示 StartDate, EndDate 兩個資料行
SELECT	*, StartDate, EndDate
FROM	Sales.COPY_OrderDetails FOR SYSTEM_TIME ALL
WHERE	orderid = 10248;
GO

---------------------------- 我是分隔線 ----------------------------

-- Disable system-versioning
ALTER TABLE Sales.COPY_OrderDetails
SET (SYSTEM_VERSIONING = OFF);
GO
-- 從 SSMS 觀察「系統控制版本」的資料表和「自訂名稱歷程記錄」資料表的狀態

-- Clean up
DROP TABLE IF EXISTS Sales.COPY_OrderDetails;
DROP TABLE IF EXISTS Sales.COPY_OrderDetails_History;
DROP TABLE IF EXISTS Sales.COPY_Orders;
GO