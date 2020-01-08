範例 A： PRIMARY KEY，分別介紹 Column-Level、Table-Level 等兩種做法
/*
 col1 指定 PRIMARY KEY，只接受唯一值
*/
USE TSQL2;
GO

-- START：Column-Level、Table-Leve 擇一執行
/******************** Column-Level ********************/
-- 使用預設的「叢集索引」、指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key , --< 可省略 clustered 
  col2 varchar(10) not null);
go

-- 操作 1：試著在 col1 int 後移除 not null 並再次執行 (自動改回 null)
-- 操作 2：試著在 col1 int 後改成 null 後並再次執行 (失敗)

/******************** Table-Level ********************/
-- 使用預設的「叢集索引」、指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null,
  col2 varchar(10) not null,
  constraint pk_tbl1_col1 primary key(col1) );
go
-- END：Column-Level、Table-Leve 擇一執行



/* Column-Level 不同使用方式的參考，Table-Level 的用法也可以參考以下內容
-- 使用預設的「叢集索引」、不指定「條件約束」名稱 (自動產生)
drop table if exists tbl1
create table tbl1
( col1 int not null primary key,
  col2 varchar(10) not null);
go

-- 使用指定的「叢集索引」、指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key clustered,
  col2 varchar(10) not null);
go

-- 使用指定的「非叢集索引」、指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key nonclustered,
  col2 varchar(10) not null);
go

-- Composite Primary Key
-- 複合式主鍵使用預設的「叢集索引」、指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1_col2 primary key (col1, col2),
  col2 varchar(10) not null);
go

-- Composite Primary Key
-- 複合式主鍵使用指定的「叢集索引」、指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1_col2 primary key clustered (col1, col2),
  col2 varchar(10) not null);
go

-- Composite Primary Key
-- 複合式主鍵使用指定的「非叢集索引」、指定「條件約束」名稱
drop table if exists tbl1
create table tbl1
( col1 int not null constraint pk_tbl1_col1 primary key nonclustered (col1, col2),
  col2 varchar(10) not null);
go
*/



-- 以下為測試的用途
select * from tbl1;

insert into tbl1(col1, col2) values (1, 'gjun');
insert into tbl1(col1, col2) values (1, 'gjun');
--訊息：違反 PRIMARY KEY 條件約束 'pk_tbl1_col1'。無法在物件 'dbo.tbl1' 中插入重複的索引鍵。重複的索引鍵值是 (1)。

select * from tbl1;

-- 以下只為復原設定，與本主題無關
drop table if exists tbl1