--�d�� B�G UNIQUE�A���O���� Column-Level�BTable-Level ����ذ��k
/*
 col1 ���w UNIQUE�A�u�����ߤ@�ȩM�ŭ� NULL
*/
USE TSQL2;
GO

-- START�GColumn-Level�BTable-Leve �ܤ@����
/******************** Column-Level ********************/
-- �ϥιw�]���u�D�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int null constraint uq_tbl1_col1 UNIQUE , --< �i�ٲ� nonclustered 
  col2 varchar(10) not null);
go

-- �ާ@ 1�G�յۦb col1 int ��令 not null �æA������ (���\)

/******************** Table-Level ********************/
-- �ϥιw�]���u�D�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int null,
  col2 varchar(10) not null,
  constraint uq_tbl1_col1 UNIQUE (col1) );
go
-- END�GColumn-Level�BTable-Leve �ܤ@����



/* Column-Level ���P�ϥΤ覡���ѦҡATable-Level ���Ϊk�]�i�H�ѦҥH�U���e
-- �ϥιw�]���u�D�O�����ޡv�B�����w�u��������v�W�� (�۰ʲ���)
drop table if exists tbl1
create table tbl1
( col1 int null UNIQUE,
  col2 varchar(10) not null);
go

-- �ϥΫ��w���u�D�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int null constraint uq_tbl1_col1 UNIQUE nonclustered,
  col2 varchar(10) not null);
go

-- �ϥΫ��w���u�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int null constraint uq_tbl1_col1 UNIQUE clustered,
  col2 varchar(10) not null);
go

-- Composite UNIQUE
-- �ƦX�� UNIQUE �ϥιw�]���u�D�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int null constraint uq_tbl1_col1_col2 UNIQUE (col1, col2),
  col2 varchar(10) not null);
go

-- Composite UNIQUE
-- �ƦX�� UNIQUE �ϥΫ��w���u�D�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int null constraint uq_tbl1_col1_col2 UNIQUE nonclustered (col1, col2),
  col2 varchar(10) not null);
go

-- Composite UNIQUE
-- �ƦX�� UNIQUE �ϥΫ��w���u�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int null constraint uq_tbl1_col1_col2 UNIQUE clustered (col1, col2),
  col2 varchar(10) not null);
go
*/



-- �H�U�����ժ��γ~
select * from tbl1;

insert into tbl1(col1, col2) values (null, 'gjun');
insert into tbl1(col1, col2) values (1, 'gjun');
insert into tbl1(col1, col2) values (1, 'gjun');
--�T���G�H�� UNIQUE KEY ������� 'uq_tbl1_col1'�C�L�k�b���� 'dbo.tbl1' �����J���ƪ�������C���ƪ�������ȬO (1)�C

select * from tbl1;

-- �A���s�W�@���t�ŭȸ�ƦC
insert into tbl1(col1, col2) values (null, 'gjun');
--�T���G�H�� UNIQUE KEY ������� 'uq_tbl1_col1'�C�L�k�b���� 'dbo.tbl1' �����J���ƪ�������C���ƪ�������ȬO (<NULL>)�C

-- �H�U�u���_��]�w�A�P���D�D�L��
drop table if exists tbl1