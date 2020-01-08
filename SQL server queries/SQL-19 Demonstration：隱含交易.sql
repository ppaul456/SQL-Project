--²��ר� (�H�U���Ѧp���˵��ثe����Ҧ��� T-SQL)

drop table if exists #tbl;
create table #tbl
(	pid int primary key,
	pname varchar(20),
	price numeric(6, 1)	);
go

----------------------- �ڬO���j�u -----------------------
-- �]�w�����t���
SET IMPLICIT_TRANSACTIONS ON;
GO

-- �˵��ثe����Ҧ����]�w
IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 0)
	PRINT '�S�����椤������A�y�۰ʻ{�i����z�Ҧ�(�w�])';
ELSE IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 2)
	PRINT '�w�ҥΡy���t����z�A���|���Ұʥ��';
ELSE IF (@@OPTIONS & 2 = 0)
	PRINT '�w�ҥΡy���t����z�A�y���T����z���b���椤';
ELSE 
	PRINT '�w�ҥΡy���t����z�A���y���t����z�Ρy���T����z���b���椤' + CAST(@@OPTIONS & 2 AS VARCHAR(5));
GO

----------------------- �ڬO���j�u -----------------------

insert into #tbl values (1, 'Product 1', 100.5);
insert into #tbl values (2, 'Product 2', 20000.5);
insert into #tbl values (3, 'Product 3', 30000.5);
GO

ROLLBACK;  --< �i�令 COMMIT �A�ոլ�

----------------------- �ڬO���j�u -----------------------
-- ��_���۰ʻ{�i
SET IMPLICIT_TRANSACTIONS OFF;
GO

-- �˵��ثe����Ҧ����]�w
IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 0)
	PRINT '�S�����椤������A�y�۰ʻ{�i����z�Ҧ�(�w�])';
ELSE IF @@TRANCOUNT = 0 AND (@@OPTIONS & 2 = 2)
	PRINT '�w�ҥΡy���t����z�A���|���Ұʥ��';
ELSE IF (@@OPTIONS & 2 = 0)
	PRINT '�w�ҥΡy���t����z�A�y���T����z���b���椤';
ELSE 
	PRINT '�w�ҥΡy���t����z�A���y���t����z�Ρy���T����z���b���椤' + CAST(@@OPTIONS & 2 AS VARCHAR(5));
GO

select * from #tbl;
go