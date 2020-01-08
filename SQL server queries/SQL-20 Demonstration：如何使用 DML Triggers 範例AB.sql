範例 A：模擬異動資料表，當執行 UPDATE 去更新 Salary 後，便印出更新者資訊

-- 產生測試用的資料表
drop table if exists copy_emp
select	empid,
		lastname,
		salary  into copy_emp   --< 自行移除註解建立副本
from hr.Employees

select * from copy_emp
go

-- 建立 AFTER 觸發程式
create trigger upd_salary
on dbo.copy_emp
after update
as
	select SUSER_SNAME()
go

-- 主要執行的工作
-- 便用 brgin tran (交易控制)只為了方便說明
begin tran
	update dbo.copy_emp
	set salary += 10000
	where empid = 1

	select * from dbo.copy_emp where empid = 1
rollback

select * from dbo.copy_emp where empid = 1



--------------------------------------------------------------------------
範例 B：當使用者嘗試更新 dbo.copy_emp 時，撤銷它的敘述

-- 建立或變更 AFTER 觸發程式
create or alter trigger upd_lastname
on dbo.copy_emp
instead of update
as
	rollback
go

-- 主要執行的工作
-- 便用 brgin tran 只為了方便說明
begin tran
	update dbo.copy_emp
	set lastname += '  a'
	where empid = 1

	select * from dbo.copy_emp where empid = 1
rollback

select * from dbo.copy_emp where empid = 1