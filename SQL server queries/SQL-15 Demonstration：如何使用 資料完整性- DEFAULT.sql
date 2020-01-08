�d�� D�G DEFAULT�A�Ȥ䴩 Column-level
/* 
 col3 ���w getdate() �Ǧ^�ȡA�Y�����w��ƭȡA�h�H DEFAULT �w�q�����D
*/
USE TSQL2;
GO

-- START�GColumn-Level�ADEFAULT ���䴩 Table-Leve
/******************** Column-Level ********************/
-- ���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  col3 datetime null constraint DF_tbl1_col3 DEFAULT getdate() );   --< �L�� null / not null
go
-- END�GColumn-Level�ADEFAULT ���䴩 Table-Leve



/* Column-Level ���P�ϥΤ覡���Ѧ�
-- �����w�u��������v�W�� (�۰ʲ���)
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  col3 datetime null DEFAULT getdate() );
go
*/




-- �H�U�����ժ��γ~
select * from tbl1;

insert into tbl1(col1, col2, col3) values (1, 'PCSchool-1', NULL);
insert into tbl1(col1, col2, col3) values (2, 'PCSchool-2', '20001025');
insert into tbl1(col1, col2, col3) values (3, 'PCSchool-3', DEFAULT);
select * from tbl1;

update tbl1
set col3 = DEFAULT
where col3 is null;

select * from tbl1;

-- �H�U�u���_��]�w�A�P���D�D�L��
drop table if exists tbl1