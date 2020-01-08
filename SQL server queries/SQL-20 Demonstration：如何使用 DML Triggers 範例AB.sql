�d�� A�G�������ʸ�ƪ�A����� UPDATE �h��s Salary ��A�K�L�X��s�̸�T

-- ���ʹ��եΪ���ƪ�
drop table if exists copy_emp
select	empid,
		lastname,
		salary  into copy_emp   --< �ۦ沾�����ѫإ߰ƥ�
from hr.Employees

select * from copy_emp
go

-- �إ� AFTER Ĳ�o�{��
create trigger upd_salary
on dbo.copy_emp
after update
as
	select SUSER_SNAME()
go

-- �D�n���檺�u�@
-- �K�� brgin tran (�������)�u���F��K����
begin tran
	update dbo.copy_emp
	set salary += 10000
	where empid = 1

	select * from dbo.copy_emp where empid = 1
rollback

select * from dbo.copy_emp where empid = 1



--------------------------------------------------------------------------
�d�� B�G��ϥΪ̹��է�s dbo.copy_emp �ɡA�M�P�����ԭz

-- �إߩ��ܧ� AFTER Ĳ�o�{��
create or alter trigger upd_lastname
on dbo.copy_emp
instead of update
as
	rollback
go

-- �D�n���檺�u�@
-- �K�� brgin tran �u���F��K����
begin tran
	update dbo.copy_emp
	set lastname += '  a'
	where empid = 1

	select * from dbo.copy_emp where empid = 1
rollback

select * from dbo.copy_emp where empid = 1