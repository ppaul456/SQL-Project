�d�� E�G FOREIGN KEY (ON DELETE NO ACTION) �� FOREIGN KEY (ON UPDATE NO ACTION)�A�w�]�欰�Ҧ��A���O���� Column-Level�BTable-Level ����ذ��k
/*
 ��ƪ� tbl_Parent �� Primary key �� col1
 ��ƪ� tbl_Child �� Foreign key �� col1
 �]���w�]�N�O NO ACTION�A�ҥH�i�ٲ� ON DELETE NO ACTION �� ON UPDATE NO ACTION
*/
USE TSQL2;
GO

-- START�GColumn-Level�BTable-Leve �ܤ@����
/******************** Column-Level ********************/
-- ���w�u��������v�W��
drop table if exists tbl_Child
drop table if exists tbl_Parent;
create table tbl_Parent
( col1 int not null constraint pk_tbl_Parent_col1 PRIMARY KEY,
  col2 varchar(10) not null);
go

create table tbl_Child
( col1 int not null constraint FK_tbl_Child_col1 REFERENCES tbl_Parent ON DELETE NO ACTION,   --< �i�b�᭱�ۦ�A�[�J ON UPDATE NO ACTION
  col2 varchar(10) not null);
go

/******************** Table-Level ********************/
-- ���w�u��������v�W��
drop table if exists tbl_Child
drop table if exists tbl_Parent;
create table tbl_Parent
( col1 int not null,
  col2 varchar(10) not null,
  constraint pk_tbl_Parent_col1 PRIMARY KEY(col1)
);
go

create table tbl_Child
( col1 int not null,
  col2 varchar(10) not null,
  constraint FK_tbl_Child_col1 FOREIGN KEY(col1) REFERENCES tbl_Parent ON DELETE NO ACTION,   --< �i�b�᭱�ۦ�A�[�J ON UPDATE NO ACTION
);
go
-- END�GColumn-Level�BTable-Leve �ܤ@����



/* Column-Level ���P�ϥΤ覡���ѦҡATable-Level ���Ϊk�]�i�H�ѦҥH�U���e
-- �����w�u��������v�W�� (�۰ʲ���)
drop table if exists tbl_Child
drop table if exists tbl_Parent;
create table tbl_Parent
( col1 int not null PRIMARY KEY,
  col2 varchar(10) not null);
go

create table tbl_Child
( col1 int not null REFERENCES tbl_Parent ON DELETE NO ACTION,   --< �i�b�᭱�ۦ�A�[�J ON UPDATE NO ACTION
  col2 varchar(10) not null);
go
*/



-- �H�U�����ժ��γ~
select * from tbl_Parent;
select * from tbl_Child;
GO

-- �����u�����v�s�W��ƦC
insert into tbl_Parent(col1, col2) values (1, 'gjun')
select * from tbl_Parent;
GO

-- �A���u�l���v�s�W��ƦC (�@�s�W 3 ����ƦC)
insert into tbl_Child (col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (2, 'gjun')   -- ���ѡA�P NO ACTION �L��
-- �T���GINSERT ���z���P FOREIGN KEY ������� "FK_tbl_Child_col1" �Ĭ�C�Ĭ�o�ͦb��Ʈw "TSQL2"�A��ƪ� "dbo.tbl_Parent", column 'col1'�C
select * from tbl_Child;
GO

-- �R���u�����v��ƦC
delete from tbl_Parent where col1 = 1   -- �]���u�l���v��ƪ� FOREIGN KEY �w�]�w�� NO ACTION
-- �T���GDELETE ���z���P REFERENCE ������� "FK_tbl_Child_col1" �Ĭ�C�Ĭ�o�ͦb��Ʈw "TSQL2"�A��ƪ� "dbo.tbl_Child", column 'col1'�C
select * from tbl_Parent;
GO

-- ��s�u�����v��Ʀ欰 PRIMARY KEY ����
update tbl_Parent
set col1 = 100
where col1 = 1;
-- �T���GUPDATE ���z���P REFERENCE ������� "FK_tbl_Child_col1" �Ĭ�C�Ĭ�o�ͦb��Ʈw "TSQL2"�A��ƪ� "dbo.tbl_Child", column 'col1'�C
select * from tbl_Parent;
GO

-- ��s�u�l���v��Ʀ欰 FOREIGN KEY ����
update tbl_Child
set col1 = 100
where col1 = 1;
-- �T���GUPDATE ���z���P FOREIGN KEY ������� "FK_tbl_Child_col1" �Ĭ�C�Ĭ�o�ͦb��Ʈw "TSQL2"�A��ƪ� "dbo.tbl_Parent", column 'col1'�C
select * from tbl_Child;
GO

-- ���R���u�l���v��ƦC�A�H�Ѱ��Ӹ�ƦC���Ѧ����Y�A�A�R���u�����v��ƦC
delete from tbl_Child where col1 = 1
delete from tbl_Parent where col1 = 1
GO

-- �d�ߨ��[��G
select * from tbl_Parent;
select * from tbl_Child;
GO

-- �H�U�u���_��]�w�A�P���D�D�L��
drop table if exists tbl_Child;
drop table if exists tbl_Parent;
GO