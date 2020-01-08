�d�� C�G CHECK�A���O���� Column-Level�BTable-Level ����ذ��k
/*
 col1 �u���� 1 �� 10 ���
 col2 �u���� 9 �Ӧr�����סA�� 1 �Ӧr���� A �� B
*/
USE TSQL2;
GO

-- START�GColumn-Level�BTable-Leve �ܤ@����
/******************** Column-Level ********************/
-- ���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null constraint ck_tbl1_col1 check(col1 between 1 and 10),
  col2 varchar(10) not null constraint ck_tbl1_col2 check( col2 like '[AB]________') );   --< �`�N�G����̦h 9 �Ӧr������
go

/******************** Table-Level ********************/
-- ���w�u��������v�W��
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  constraint ck_tbl1_col1 check(col1 between 1 and 10),
  constraint ck_tbl1_col2 check( col2 like '[AB]________') );   --< �`�N�G����̦h 9 �Ӧr������
go
-- END�GColumn-Level�BTable-Leve �ܤ@����



/* Column-Level ���P�ϥΤ覡���ѦҡATable-Level ���Ϊk�]�i�H�ѦҥH�U���e
-- �����w�u��������v�W�� (�۰ʲ���)
drop table if exists tbl1
create table tbl1
( col1 int not null check(col1 between 1 and 10),
  col2 varchar(10) not null check( col2 like '[AB]________') );   --< �`�N�G����̦h 9 �Ӧr������
go
*/



-- �H�U�����ժ��γ~
select * from tbl1;

insert into tbl1(col1, col2) values (1, 'a        ');   --< 8 �Ӧr�����ת��ť�
insert into tbl1(col1, col2) values (2, 'a       ');   --< 7 �Ӧr�����ת��ť�
-- �T���GINSERT ���z���P CHECK ������� "ck_tbl1_col2" �Ĭ�C�Ĭ�o�ͦb��Ʈw "TSQL2"�A��ƪ� "dbo.tbl1", column 'col2'�C

select * from tbl1;

update tbl1
set col1 += 100
where col1 = 1
-- �T���GUPDATE ���z���P CHECK ������� "ck_tbl1_col1" �Ĭ�C�Ĭ�o�ͦb��Ʈw "TSQL2"�A��ƪ� "dbo.tbl1", column 'col1'�C

-- �H�U�u���_��]�w�A�P���D�D�L��
drop table if exists tbl1