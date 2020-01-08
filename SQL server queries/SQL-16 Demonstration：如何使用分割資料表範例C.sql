USE TSQL2_TEST
GO
-- �ǳƲ��ʲ� 1 �Ӥ��ΰϨ�D���ΰϪ���ƪ� (���� 152 ����ƦC)
-- �έp�U�ɮ׸s��(���ΰ�)�֦�����ƦC���ƩM��ƭ����ƶq
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

-- �إ߫D���θ�ƪ� (�����M���θ�ƪ��c�ۦP)
DROP TABLE IF EXISTS Sales.SalesOrderHeader_Archive
SELECT * INTO Sales.SalesOrderHeader_Archive
FROM Sales.SalesOrderHeader_Partitioned
WHERE 1 = 0;
GO



-- START�G���D���θ�ƪ���w�ɮ׸s��
-- �����[�J�D��~�ಾ��
alter table Sales.SalesOrderHeader_Archive add constraint pk_orderid primary key (orderid);
go

-- �ɮ׸s�ձq PRIMARY �� FileGroup1
-- �]���D���θ�ƪ�M���θ�ƪ����b�ۦP���ɮ׸s��
alter table Sales.SalesOrderHeader_Archive
drop constraint pk_orderid with
(move to FileGroup1);
go
-- END�G���D���θ�ƪ���w�ɮ׸s��



-- �q���ΰϸ�ƪ���w�����ΰϲ����D���θ�ƪ�
DECLARE @p int = $PARTITION.YearlyPartitionFunction('2006-12-31');
ALTER TABLE Sales.SalesOrderHeader_Partitioned
SWITCH PARTITION @p TO Sales.SalesOrderHeader_Archive 
GO

-- �T�{���Ƭ� 152 ����ƦC
SELECT COUNT(*) �D���ΰϵ���
FROM Sales.SalesOrderHeader_Archive 
GO

-- �έp�U�ɮ׸s��(���ΰ�)�֦�����ƦC���ƩM��ƭ����ƶq
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
-- ���G�G�� 1 �Ӥ��ΰ����� 0 ����ƦC



-- �H�U�ܽd�A����^�ӡA�q�D���ΰϸ�ƪ������θ�ƪ���w�����ΰ�

-- �����[�J CHECK ��������H�ŦX���Ψ�ƪ��ɭ��ȡA�_�h����q�D���ΰϸ�ƪ������θ�ƪ���w�����ΰ�
ALTER TABLE Sales.SalesOrderHeader_Archive
WITH CHECK ADD CONSTRAINT CK_OrderDate CHECK( OrderDate <= '20061231' )
GO

-- �q�D���ΰϸ�ƪ������θ�ƪ���w�����ΰ�
DECLARE @p int = $PARTITION.YearlyPartitionFunction('20061231');
ALTER TABLE Sales.SalesOrderHeader_Archive
SWITCH TO Sales.SalesOrderHeader_Partitioned PARTITION @p
GO

-- �T�{�D���ΰϸ�ƪ�w�L�����ƦC
select * from Sales.SalesOrderHeader_Archive

-- �έp�U�ɮ׸s��(���ΰ�)�֦�����ƦC���ƩM��ƭ����ƶq
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
-- ���G�G�� 1 �Ӥ��ΰ����� 152 ����ƦC