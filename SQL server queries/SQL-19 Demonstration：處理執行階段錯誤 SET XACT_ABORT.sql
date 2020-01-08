drop table if exists #tbl;
create table #tbl
(	pid int primary key,
	pname varchar(20),
	price numeric(6, 1)	);
go

insert into #tbl values (1, 'Product 1', 100.5);
insert into #tbl values (2, 'Product 2', 20000.5);
insert into #tbl value  (3, 'Product 3', 30000.5);   --< 產生剖析階段錯誤，可試著註解本列再次執行
insert into #tbl values (4, 'Product 4', 400000.5);   --< 產生執行階段錯誤
insert into #tbl values (5, 'Product 5', 50000.5);   --< 這筆在執行階段錯誤還是會寫入
go

select * from #tbl;
go




--------------------------------------------------------------------------------

--處理執行階段錯誤 SET XACT_ABORT--

drop table if exists #tbl;
create table #tbl
(	pid int primary key,
	pname varchar(20),
	price numeric(6, 1)	);
go

SET XACT_ABORT ON;
insert into #tbl values (1, 'Product 1', 100.5);
insert into #tbl values (2, 'Product 2', 20000.5);
--insert into #tbl value  (3, 'Product 3', 30000.5);   --< 產生剖析階段錯誤，可試著註解本列再次執行
insert into #tbl values (4, 'Product 4', 400000.5);   --< 產生執行階段錯誤
insert into #tbl values (5, 'Product 5', 50000.5);   --< SET XACT_ABORT ON 後，這筆在執行階段錯誤就不會寫入
SET XACT_ABORT OFF;  --< 恢復到預設值
go

select * from #tbl;
go