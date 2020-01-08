�d�� H�G FOREIGN KEY (ON DELETE SET NULL) �� FOREIGN KEY (ON UPDATE SET NULL)�A�Ȥ��� Column-Level �Ϊk�ATable-Level �аѦҫe�����k
USE TSQL2;
GO

-- START�GColumn-Level
/******************** Column-Level ********************/
-- ���t�X FOREIGN KEY �إ߾֦��D�䪺��ƪ�
-- ���w�u��������v�W��
drop table if exists tbl_Child
drop table if exists tbl_Parent
create table tbl_Parent
( col1 int not null constraint PK_tbl_Parent_col1 PRIMARY KEY,
  col2 varchar(10) not null )
go

-- ���w�u��������v�W��
drop table if exists tbl_Child
create table tbl_Child
( col1 int null constraint FK_tbl_Child_tbl_Parent REFERENCES tbl_Parent (col1) ON DELETE SET NULL,   --< �i�b�᭱�ۦ�A�[�J ON UPDATE SET NULL
  col2 varchar(10) not null )
go
-- END�GColumn-Level



-- �H�U�����ժ��γ~
-- �����u�����v�s�W�@����ƦC�A�A���u�l���v�s�W�ⵧ��ƦC
insert into tbl_Parent(col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (1, 'gjun')

-- �d�ߨ��[��G
select * from tbl_Parent;
select * from tbl_Child;

-- �R���u�����v��ƦC
delete tbl_Parent where col1 = 1
-- (1 �Ӹ�ƦC����v�T)�G���R���u�����v�s�W��ƦC�A���u�l���v������ƦC�]���v�T
-- �]���u�l���v��ƪ� FOREIGN KEY �w�]�w�� ON DELETE SET NULL

/* �Y FOREIGN KEY �����w ON UPDATE SET NULL
-- ��s�u�����v��ƦC
update tbl_Parent set col1 = 10 where col1 = 1
-- (1 �Ӹ�ƦC����v�T)�G����s�u�����v�s�W��ƦC�A���u�l���v������ƦC�]���v�T
-- �]���u�l���v��ƪ� FOREIGN KEY �w�]�w�� ON UPDATE SET NULL
*/

-- �d�ߨ��[��G
select * from tbl_Parent;
select * from tbl_Child;

-- �H�U�u���_��]�w�A�P���D�D�L��
drop table if exists tbl_Child;
drop table if exists tbl_Parent;