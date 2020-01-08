�d�� B�G�p�����d��ΦX�ֽd���t�@�Ӥ��ΰ�
/*
 1) �N�ɮ׸s�ե[�J�ܸ�Ƥ��ΰt�m��
	ALTER PARTITION SCHEME partition_scheme_name NEXT USED [ filegroup_name ];
 2) �N��Ƥ��Τ�����Ӹ�Ƥ���
	ALTER PARTITION FUNCTION partition_function_name() SPLIT RANGE ( boundary_value );
	�ΦX�֦��@�Ӹ�Ƥ���
	ALTER PARTITION FUNCTION partition_function_name() MERGE RANGE ( boundary_value );
*/
USE TSQL2_TEST
GO
-- START�G�������ժ��O�����̫� 10 ��
-- �d�̫߳� 10 ���q����
select *
from Sales.SalesOrderHeader_Partitioned
order by orderid desc
offset 0 rows
fetch next 10 rows only;
go
-- ���G�GOrderID ���ӬO 830 ~ 821 �����AOrderDate ���� 2008 �~

-- ��s�N�̫� 5 ���q�����[ 1 �~
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

-- �A��s�t�~ 5 ���q�����[ 2 �~
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

-- �d�̫߳� 10 ���q���ơA�O�_�w�g�ܧ���檺�q����
select *
from Sales.SalesOrderHeader_Partitioned
order by orderid desc
offset 0 rows
fetch next 10 rows only;
go
-- END�G�������ժ��O�����̫� 10 ��



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
-- �`�N�G�� 10 ���q��b FileGroup4 (�䤤�� 5 �� 2009 �~�A�t 5 �� 2010 �~)



-- START�G�إ��ɮ׸s�թM����������ɮץH�Ѵ���
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
-- END�G�إ��ɮ׸s�թM����������ɮץH�Ѵ���



-- �N�ɮ׸s�ե[�J�ܸ�Ƥ��ΰt�m��
-- �u����w�@���ɮ׸s�ռаO�� NEXT USED (�U�@�ӨϥΪ�)
ALTER PARTITION SCHEME OrdersByYear  
NEXT USED FileGroup5;  --< �����w�ɮ׸s�զW�١A�h�Ѱ��ɮ׸s�� NEXT USED �ݩʡA�N�Y���ΰt�m���A�ϥΦ��ɮ׸s��
GO

-- �d�߭��@���ɮ׸s�ռаO�� NEXT USED (�U�@�ӨϥΪ�)
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

-- �N��Ƥ��Τ�����Ӹ�Ƥ���
-- ���\��A�d�ߤ����ɮ׸s�ռаO�� NEXT USED (�U�@�ӨϥΪ�)
ALTER PARTITION FUNCTION YearlyPartitionFunction () 
SPLIT RANGE ('2009-12-31');
GO

-- �N��Ӹ�Ƥ��ΦX�֦��@�Ӹ�Ƥ��� (SPLIT ������)
/*
ALTER PARTITION FUNCTION YearlyPartitionFunction () 
MERGE RANGE ('2009-12-31');
GO
*/

-- �Ǧ^�C�@�Ӥ��ΰϬɭ���
-- �`�N��W data_space_id�Bfunction_id�Btype_desc�Bboundary_id�BBoundaryValue
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


-- �ާ@�G�A�Q�Ϋe�����d�ߨ���ܦU���ΰϪ����G���A


-- �H�U���_�� OrderDate ���ܧ�

-- ��s�N�̫� 5 ���q������ 1 �~
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

-- �A��s�t�~ 5 ���q������ 2 �~
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

-- �d�̫߳� 10 ���q����
select *
from Sales.SalesOrderHeader_Partitioned
order by orderid desc
offset 0 rows
fetch next 10 rows only;
go
-- ���G�GOrderID ���ӬO 830 ~ 821 �����AOrderDate ���� 2008 �~

-- �ާ@�G�Q�Ϋe�����d�ߨ���ܦU���ΰϪ����G���A