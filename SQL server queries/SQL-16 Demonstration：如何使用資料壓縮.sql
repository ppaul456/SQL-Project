--Demonstration�G�p��ϥθ�����Y

USE MASTER
GO 

-- START�G�إߴ�������
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
-- END�G�إߴ�������



-- �[�J�D��|�۰ʲ����O������
ALTER TABLE [Sales].[SalesOrderDetails] ADD  CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[orderid] ASC,
	[productid] ASC
)
GO

-- �[�J�D�O������
CREATE NONCLUSTERED INDEX [idx_nc_productid] ON [Sales].[SalesOrderDetails]
(
	[productid] ASC
)
GO

/* sp_estimate_data_compression_savings ������ƪ�O�_�ȱo���Y

 �Y��ƪ�B���ީθ�Ƥ����٥����Y�A�h���O�H���P���Y�����A�Ǧ^���Y��ƪ���p����ƦC�����j�p
 �Y��ƪ�B���ީθ�Ƥ��Τw�g���Y�A�h�H 'NONE' �Ǧ^�����Y��ƪ���p����ƦC�����j�p

 �� 1 �ӰѼƬO���w�]�t��ƪ�ί����˵�����Ʈw�u���c�y�z�W�١v
 �� 2 �ӰѼƬO���w���ީҦb���u��ƪ�v�Ρu�����˵���v�W��
 �� 3 �ӰѼƬO���w�u���ު��ѧO�X�v�ANULL �N��Ҧ����ެ�����T�A�Y���w NULL�A�U�@�ӰѼƤ]�����O NULL
 �� 4 �ӰѼƬO���w�u���󪺤��ΰϽs���v�ANULL �N��Ҧ���Ƥ��Ϊ�������T
 �� 5 �ӰѼƬO���w�����������Y�����A�䴩 NONE, ROW, PAGE
 
 sys.partitions �i�q��� data_compression�Bdata_compression_desc ��ܸ�ƪ���ΰϪ����Y���A
*/

EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'ROW';
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'PAGE';
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
-- index_id �� 1 ���O�O�����ޡA2 �H�᪺�O�D�O������
GO

-- �ҥθ�ƪ����Y�A�]�w���u��ƦC���Y�v
ALTER TABLE Sales.SalesOrderDetails REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW); 
GO

-- �d�ߥثe��ƪ���ΰϪ����Y���A
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
GO

-- �T�w��ƪ�O�_�i�H�i�@�B�� PAGE ���Y
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'PAGE';
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
GO

-- ���د��ޡA�ñҥί��ު����Y�A�]�w���u�������Y�v
ALTER INDEX [PK_OrderDetails] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO
ALTER INDEX [idx_nc_productid] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO

-- �A�@�������A�Ǧ^�n�D������ثe���j�p�A�ðw��n�D�����Y���A�w������j�p
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetails', NULL, NULL, 'PAGE';
select * from sys.partitions where object_name(object_id) = N'SalesOrderDetails'
GO

-- ���θ�ƪ����Y
ALTER TABLE [Sales].[SalesOrderDetails] REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = NONE);  
GO  

-- ���ί��ު����Y
ALTER INDEX [PK_OrderDetails] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE);
GO
ALTER INDEX [idx_nc_productid] ON Sales.SalesOrderDetails REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE);
GO