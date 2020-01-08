範例 A：依前述 Demonstration，當使用者嘗試更新 Salary 後，便印出更新者資訊

-- 建立或變更 AFTER 觸發程式
create or alter trigger upd_salary
on dbo.copy_emp
after update
as
	if update(salary)                 --修改成有update salary就執行(精準)
		select SUSER_SNAME()
go

-- 主要執行的工作
-- 便用 brgin tran 只為了方便說明
begin tran
	update dbo.copy_emp
	set salary += 10000
	where empid = 1

	select * from dbo.copy_emp where empid = 1
rollback

select * from dbo.copy_emp where empid = 1