範例 C： CHECK，分別介紹 Column-Level、Table-Level 等兩種做法
/*
 col1 只接受 1 到 10 整數
 col2 只接受 9 個字元長度，第 1 個字母為 A 或 B
*/
USE TSQL2;
GO

-- START：Column-Level、Table-Leve 擇一執行
/******************** Column-Level ********************/
-- 指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null constraint ck_tbl1_col1 check(col1 between 1 and 10),
  col2 varchar(10) not null constraint ck_tbl1_col2 check( col2 like '[AB]________') );   --< 注意：限制最多 9 個字元長度
go

/******************** Table-Level ********************/
-- 指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  constraint ck_tbl1_col1 check(col1 between 1 and 10),
  constraint ck_tbl1_col2 check( col2 like '[AB]________') );   --< 注意：限制最多 9 個字元長度
go
-- END：Column-Level、Table-Leve 擇一執行



/* Column-Level 不同使用方式的參考，Table-Level 的用法也可以參考以下內容
-- 不指定「條件約束」名稱 (自動產生)
drop table if exists tbl1
create table tbl1
( col1 int not null check(col1 between 1 and 10),
  col2 varchar(10) not null check( col2 like '[AB]________') );   --< 注意：限制最多 9 個字元長度
go
*/



-- 以下為測試的用途
select * from tbl1;

insert into tbl1(col1, col2) values (1, 'a        ');   --< 8 個字元長度的空白
insert into tbl1(col1, col2) values (2, 'a       ');   --< 7 個字元長度的空白
-- 訊息：INSERT 陳述式與 CHECK 條件約束 "ck_tbl1_col2" 衝突。衝突發生在資料庫 "TSQL2"，資料表 "dbo.tbl1", column 'col2'。

select * from tbl1;

update tbl1
set col1 += 100
where col1 = 1
-- 訊息：UPDATE 陳述式與 CHECK 條件約束 "ck_tbl1_col1" 衝突。衝突發生在資料庫 "TSQL2"，資料表 "dbo.tbl1", column 'col1'。

-- 以下只為復原設定，與本主題無關
drop table if exists tbl1