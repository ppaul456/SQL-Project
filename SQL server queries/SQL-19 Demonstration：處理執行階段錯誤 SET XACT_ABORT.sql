drop table if exists #tbl;
create table #tbl
(	pid int primary key,
	pname varchar(20),
	price numeric(6, 1)	);
go

insert into #tbl values (1, 'Product 1', 100.5);
insert into #tbl values (2, 'Product 2', 20000.5);
insert into #tbl value  (3, 'Product 3', 30000.5);   --< ���ͭ�R���q���~�A�i�յ۵��ѥ��C�A������
insert into #tbl values (4, 'Product 4', 400000.5);   --< ���Ͱ��涥�q���~
insert into #tbl values (5, 'Product 5', 50000.5);   --< �o���b���涥�q���~�٬O�|�g�J
go

select * from #tbl;
go




--------------------------------------------------------------------------------

--�B�z���涥�q���~ SET XACT_ABORT--

drop table if exists #tbl;
create table #tbl
(	pid int primary key,
	pname varchar(20),
	price numeric(6, 1)	);
go

SET XACT_ABORT ON;
insert into #tbl values (1, 'Product 1', 100.5);
insert into #tbl values (2, 'Product 2', 20000.5);
--insert into #tbl value  (3, 'Product 3', 30000.5);   --< ���ͭ�R���q���~�A�i�յ۵��ѥ��C�A������
insert into #tbl values (4, 'Product 4', 400000.5);   --< ���Ͱ��涥�q���~
insert into #tbl values (5, 'Product 5', 50000.5);   --< SET XACT_ABORT ON ��A�o���b���涥�q���~�N���|�g�J
SET XACT_ABORT OFF;  --< ��_��w�]��
go

select * from #tbl;
go