�d�� I�G ��ƪ�w�إߤ���A�Y�n�[�J�β�����������A�аѦҥH�U�G
USE TSQL2;
GO



-- START�G���]�w���U�C��ƪ�
drop table if exists tbl1
create table tbl1
( col1 int,
  col2 varchar(10),
  col3 datetime );
go

drop table if exists tbl2
create table tbl2
( col1 int,
  col2 varchar(10) );
go
-- END�G���]�w���U�C��ƪ�



-- ����ƪ�s�W PRIMARY KEY ����Ʀ�A���w�� NOT NULL
alter table tbl1 alter column col1 int not null;
alter table tbl2 alter column col1 int not null;
go

-- ����ƪ�s�W PRIMARY KEY ��������A�����w�u��������v�W�� (�۰ʲ���)
alter table tbl1
add primary key (col1);
go
alter table tbl2
add primary key (col1);
go

-- ����ƪ�s�W FOREIGN KEY ��������A�����w�u��������v�W�� (�۰ʲ���)
alter table tbl2
add foreign key (col1)
references dbo.tbl1;
go

-- ����ƪ�s�W CHECK ��������A�����w�u��������v�W�� (�۰ʲ���)
alter table tbl1
add check(col1 between 1 and 10);
go

-- ����ƪ�s�W CHECK ��������A�ë��w�u��������v�W��
alter table tbl1
add constraint ck_tbl1_col2 check( col2 like '[AB]_________');
go

-- ����ƪ�s�W DEFAULT ��������A�ë��w�u��������v�W��
alter table tbl1
add constraint df_tbl1_col3 default (getdate()) for col3;
go

-- ����ƪ��� CHECK �������
alter table tbl1
drop constraint ck_tbl1_col2;
go



-- ���D�G�p�󲾰��۰ʲ��ͦW�٪��u��������v�H



-- �H�U�u���_��]�w�A�P���D�D�L��
drop table if exists tbl2;
drop table if exists tbl1;
go