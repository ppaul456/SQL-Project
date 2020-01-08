-- �إߥΨӵn���w�W�Zñ�쪺���u���
drop table if exists SingIntbl
create table SingIntbl
( [accont name] varchar(50),
  [LoginTime]  datetime )
go

-- �]�p�i�Ǧ^�W�Zñ�쪺���u��� (�u�Ǧ^�٥�ñ�쪺)
-- �ê����s�W��@SingIntbl�@��ƪ�
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


-- ���榨�G
exec usp_p1
select * from SingIntbl

--���ը䥦���u�n�J (�R�O���ܦr��)
sqlcmd -U LoginUser1 -P Pa$$w0rd


EXECUTE AS ���w����Ҳժ����e�A�ӱ��� Database Engine �O�ϥέ��@�ӨϥΪ̱b��A�H���ҸӼҲհѦҤ������v��
-- EXECUTE AS  (��������)
select SUSER_SNAME()
execute as login = 'Loginuser1'
select * from hr.Employees
revert
select * from hr.Employees
