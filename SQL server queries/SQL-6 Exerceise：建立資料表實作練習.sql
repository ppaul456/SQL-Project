1.�ϥ� CREATE TABLE �A�s�W��ƪ� HR.Emp�A�îھڤU�C���e�إ߸�Ʀ�B��������B�O�_NULL
�����Ҧr��,�m�W,����,��D,��¾��,�~��
A123456789,���s�I,�x�_,�H�q��,1998-05-29,80000.00
B221304680,���x��,�x�_,�����F��,2013-10-05,35000.00
F332213046,�i�a��,�x�_,���R��,2010-07-01,50000.00


--ANSWER�G
-- drop table if exists hr.emp
create table hr.emp
( �����Ҧr�� nchar(10) not null,
  �m�W nvarchar(10) not null,
  ���� nvarchar(3) not null,
  ��D nvarchar(20) not null,
  ��¾�� date not null,
  �~�� decimal(9, 2) not null );
go


2.����ƪ�ϥ� ALTER TABLE�A����ƪ�[�J�B�~���u���u�s���v(�y����)���A�õ����A�X����������M�O�_ NULL�G


--ANSWER�G
alter table hr.emp
add ���u�s�� int not null;
go