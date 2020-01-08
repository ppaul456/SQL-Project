範例 D： DEFAULT，僅支援 Column-level
/* 
 col3 指定 getdate() 傳回值，若不指定資料值，則以 DEFAULT 定義的為主
*/
USE TSQL2;
GO

-- START：Column-Level，DEFAULT 不支援 Table-Leve
/******************** Column-Level ********************/
-- 指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  col3 datetime null constraint DF_tbl1_col3 DEFAULT getdate() );   --< 無關 null / not null
go
-- END：Column-Level，DEFAULT 不支援 Table-Leve



/* Column-Level 不同使用方式的參考
-- 不指定「條件約束」名稱 (自動產生)
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  col3 datetime null DEFAULT getdate() );
go
*/




-- 以下為測試的用途
select * from tbl1;

insert into tbl1(col1, col2, col3) values (1, 'PCSchool-1', NULL);
insert into tbl1(col1, col2, col3) values (2, 'PCSchool-2', '20001025');
insert into tbl1(col1, col2, col3) values (3, 'PCSchool-3', DEFAULT);
select * from tbl1;

update tbl1
set col3 = DEFAULT
where col3 is null;

select * from tbl1;

-- 以下只為復原設定，與本主題無關
drop table if exists tbl1