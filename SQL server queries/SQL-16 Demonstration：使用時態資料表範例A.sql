--�d�� A�G�p��ϥήɺA��ƪ�
--�������k�A�����ۦ�]�p���{�O����ƪ�ӧ��� (���|�ҡA�ëD�@�w�O�p���]�p)

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
--�{�b���k�A�u�ݭn�إߡu�t�α�����v����ƪ�Y�i

USE TSQL2;
GO


-- ���ͥΩ���ժ���ƪ� Sales.COPY_Orders
DROP TABLE IF EXISTS Sales.COPY_Orders
SELECT * INTO Sales.COPY_Orders
FROM Sales.Orders;
GO


-- �]�� SELECT...INTO ���|�@�ֽƻs�D��A�ҥH�����ۦ�A�[�J�D��
ALTER TABLE [Sales].[COPY_Orders] 
ADD CONSTRAINT [PK_COPY_Orders]
PRIMARY KEY CLUSTERED ( [orderid] ASC );
GO


-- ���ͥΩ���ժ���ƪ� Sales.COPY_OrderDetails
DROP TABLE IF EXISTS Sales.COPY_OrderDetails
SELECT * INTO Sales.COPY_OrderDetails
FROM Sales.OrderDetails;
GO


-- �]�� SELECT...INTO ���|�@�ֽƻs�D��A�ҥH�����ۦ�A�[�J�D��
-- �t�~�A�ɺA��n�D�����㦳�D������
ALTER TABLE [Sales].[COPY_OrderDetails]
ADD CONSTRAINT [PK_COPY_OrderDetails]
PRIMARY KEY CLUSTERED ( [orderid] ASC, [productid] ASC );
GO


-- �A�[�J�~���䪺�Ѧ�
alter table [Sales].[COPY_OrderDetails]
add constraint fk_FK_COPY_OrderDetails_COPY_Orders
foreign key (orderid)
references [Sales].[COPY_Orders] (orderid)
--on delete cascade on update cascade;
go


-- Add the two date range columns
-- �����[�J��Ӹ�Ʀ�ӰO���u�}�l�v�M�u�����v���ɶ�
-- �å[�J����l�y HIDDEN �Ψ����ø�Ʀ�
-- �å[�J����l�y PERIOD FOR SYSTEM_TIME �ѦҨ��Ӹ�Ʀ�
ALTER TABLE Sales.COPY_OrderDetails
ADD 
StartDate datetime2(0) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT DF_ProductSysStartDate DEFAULT SYSUTCDATETIME(), 
EndDate datetime2(0) GENERATED ALWAYS AS ROW END HIDDEN CONSTRAINT DF_ProductSysEndDate DEFAULT CONVERT(datetime2 (0), '9999-12-31 23:59:59'), 
PERIOD FOR SYSTEM_TIME (StartDate, EndDate); 
GO 


-- Enable system-versioning
-- �ҥΡu�t�α�����v����ƪ�A�ë��w�u�ۭq�W�پ��{�O���v��ƪ�
ALTER TABLE Sales.COPY_OrderDetails
SET	(
		SYSTEM_VERSIONING = ON 
		(HISTORY_TABLE = Sales.COPY_OrderDetails_History)
	);
GO

---------------------------- �ڬO���j�u ----------------------------

-- �d�ߨ��[��ʫe����ƦC
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
-- �`�N�G�ݤ��� StartDate, EndDate ��Ӹ�Ʀ�
SELECT	*
FROM	Sales.COPY_OrderDetails FOR SYSTEM_TIME ALL
WHERE	orderid = 10248;
GO

-- �ǥѩ��T���w���W�٤覡�H��� StartDate, EndDate ��Ӹ�Ʀ�
SELECT	*, StartDate, EndDate
FROM	Sales.COPY_OrderDetails FOR SYSTEM_TIME ALL
WHERE	orderid = 10248;
GO

---------------------------- �ڬO���j�u ----------------------------

-- Disable system-versioning
ALTER TABLE Sales.COPY_OrderDetails
SET (SYSTEM_VERSIONING = OFF);
GO
-- �q SSMS �[��u�t�α�����v����ƪ�M�u�ۭq�W�پ��{�O���v��ƪ����A

-- Clean up
DROP TABLE IF EXISTS Sales.COPY_OrderDetails;
DROP TABLE IF EXISTS Sales.COPY_OrderDetails_History;
DROP TABLE IF EXISTS Sales.COPY_Orders;
GO