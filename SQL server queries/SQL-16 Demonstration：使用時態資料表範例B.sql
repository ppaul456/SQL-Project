--�d�� B�G�Y�u���{�O����ƪ�v�j�p�w�g�j��v�T��Ʈw�B�@�ɡA�Ӧp��M�šu���{�O����ƪ�v���O���H

USE TSQL2;
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

/* �H�U�������ʸ�� */
-- �d�ߨ��[��ʫe����ƦC
SELECT *
FROM Sales.COPY_OrderDetails
WHERE orderid = 10248;
GO

-- ���է�s QTY ��Ʀ�
UPDATE	Sales.COPY_OrderDetails
SET		QTY += 100
WHERE	orderid = 10248;
GO

-- �ǥѩ��T���w���W�٤覡�H��� StartDate, EndDate ��Ӹ�Ʀ�
SELECT	*, StartDate, EndDate
FROM	Sales.COPY_OrderDetails FOR SYSTEM_TIME ALL
WHERE	orderid = 10248;
GO

---------------------------- �ڬO���j�u ----------------------------

/* �H�U������z�u���{�O����ƪ�v*/
/* ���]�u���{�O����ƪ�v�j�p�w�g�j��v�T��Ʈw�B�@��
 1) �ƥ���Ʈw
 2) ���� �t�Ϊ�������
 3) �B�z�u���{�O����ƪ�v���@�~�A�Ҧp��ƶץX�B�M�ŵ�
 4) �ҥ� �t�Ϊ�������
*/

-- 2) ���� �t�Ϊ�������
ALTER TABLE Sales.COPY_OrderDetails
SET (SYSTEM_VERSIONING = OFF);
GO

-- 3) �B�z�u���{�O����ƪ�v���@�~�A�Ҧp��ƶץX�B�M�ŵ�
-- ���]�w�g��ƶץX�����A���ۧY�i�M�Ÿ�ƪ�
-- �H�U�|��ܲM�ūe�᪺����
SELECT COUNT(*) FROM Sales.COPY_OrderDetails_History;
TRUNCATE TABLE Sales.COPY_OrderDetails_History;
SELECT COUNT(*) FROM Sales.COPY_OrderDetails_History;
GO

--  4) �ҥ� �t�Ϊ�������
ALTER TABLE Sales.COPY_OrderDetails
SET	(
		SYSTEM_VERSIONING = ON 
		(HISTORY_TABLE = Sales.COPY_OrderDetails_History)
	);
GO

-- Clean up
ALTER TABLE Sales.COPY_OrderDetails
SET (SYSTEM_VERSIONING = OFF);
GO
DROP TABLE IF EXISTS Sales.COPY_OrderDetails;
DROP TABLE IF EXISTS Sales.COPY_OrderDetails_History;
GO