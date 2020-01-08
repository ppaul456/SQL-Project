�d�� A�G PRIMARY KEY�A���O���� Column-Level�BTable-Level ����ذ��k
/*
 col1 ���w PRIMARY KEY�A�u�����ߤ@��
*/
USE TSQL2;
GO

-- START�GColumn-Level�BTable-Leve �ܤ@����
/******************** Column-Level ********************/
-- �ϥιw�]���u�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key , --< �i�ٲ� clustered 
  col2 varchar(10) not null);
go

-- �ާ@ 1�G�յۦb col1 int �Ჾ�� not null �æA������ (�۰ʧ�^ null)
-- �ާ@ 2�G�յۦb col1 int ��令 null ��æA������ (����)

/******************** Table-Level ********************/
-- �ϥιw�]���u�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  constraint pk_tbl1_col1 primary key(col1) );
go
-- END�GColumn-Level�BTable-Leve �ܤ@����



/* Column-Level ���P�ϥΤ覡���ѦҡATable-Level ���Ϊk�]�i�H�ѦҥH�U���e
-- �ϥιw�]���u�O�����ޡv�B�����w�u��������v�W�� (�۰ʲ���)
drop table if exists tbl1
create table tbl1
( col1 int not null primary key,
  col2 varchar(10) not null);
go

-- �ϥΫ��w���u�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key clustered,
  col2 varchar(10) not null);
go

-- �ϥΫ��w���u�D�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key nonclustered,
  col2 varchar(10) not null);
go

-- Composite Primary Key
-- �ƦX���D��ϥιw�]���u�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1_col2 primary key (col1, col2),
  col2 varchar(10) not null);
go

-- Composite Primary Key
-- �ƦX���D��ϥΫ��w���u�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1_col2 primary key clustered (col1, col2),
  col2 varchar(10) not null);
go

-- Composite Primary Key
-- �ƦX���D��ϥΫ��w���u�D�O�����ޡv�B���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key nonclustered (col1, col2),
  col2 varchar(10) not null);
go
*/



-- �H�U�����ժ��γ~
select * from tbl1;

insert into tbl1(col1, col2) values (1, 'gjun');
insert into tbl1(col1, col2) values (1, 'gjun');
--�T���G�H�� PRIMARY KEY ������� 'pk_tbl1_col1'�C�L�k�b���� 'dbo.tbl1' �����J���ƪ�������C���ƪ�������ȬO (1)�C

select * from tbl1;

-- �H�U�u���_��]�w�A�P���D�D�L��
drop table if exists tbl1