-- 建立用來登錄已上班簽到的員工資料
drop table if exists SingIntbl
create table SingIntbl
( [accont name] varchar(50),
  [LoginTime]  datetime )
go

-- 設計可傳回上班簽到的員工資料 (只傳回還未簽到的)
-- 並直接新增到　SingIntbl　資料表
create or alter proc usp_p1 as
begin
	set nocount on
	declare @tbl table
	( [accont name] varchar(50) )
	
	insert into @tbl
	SELECT login_name [accont name]
	FROM sys.dm_exec_sessions   
	GROUP BY login_name;  

	merge into SingIntbl t
	using @tbl s
	on t.[accont name] = s.[accont name]
	when not matched by target and s.[accont name] not like 'NT %' and s.[accont name] <> 'sa'
        then insert ([accont name], [LoginTime]) values ([accont name], getdate())
	;
	set nocount off
end
go


-- 執行成果
exec usp_p1
select * from SingIntbl

--測試其它員工登入 (命令提示字元)
sqlcmd -U LoginUser1 -P Pa$$w0rd


EXECUTE AS 指定執行模組的內容，來控制 Database Engine 是使用哪一個使用者帳戶，以驗證該模組參考之物件的權限
-- EXECUTE AS  (切換身份)
select SUSER_SNAME()
execute as login = 'Loginuser1'
select * from hr.Employees
revert
select * from hr.Employees
