�d�� A�G�̫e�z Demonstration�A��ϥΪ̹��է�s Salary ��A�K�L�X��s�̸�T

-- �إߩ��ܧ� AFTER Ĳ�o�{��
create or alter trigger upd_salary
on dbo.copy_emp
after update
as
	if update(salary)                 --�ק令��update salary�N����(���)
		select SUSER_SNAME()
go

-- �D�n���檺�u�@
-- �K�� brgin tran �u���F��K����
begin tran
	update dbo.copy_emp
	set salary += 10000
	where empid = 1

	select * from dbo.copy_emp where empid = 1
rollback

select * from dbo.copy_emp where empid = 1