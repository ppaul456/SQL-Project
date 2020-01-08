範例 E： FOREIGN KEY (ON DELETE NO ACTION) 或 FOREIGN KEY (ON UPDATE NO ACTION)，預設行為模式，分別介紹 Column-Level、Table-Level 等兩種做法
/*
 資料表 tbl_Parent 的 Primary key 為 col1
 資料表 tbl_Child 的 Foreign key 為 col1
 因為預設就是 NO ACTION，所以可省略 ON DELETE NO ACTION 或 ON UPDATE NO ACTION
*/
USE TSQL2;
GO

-- START：Column-Level、Table-Leve 擇一執行
/******************** Column-Level ********************/
-- 指定「條件約束」名稱
drop table if exists tbl_Child
drop table if exists tbl_Parent;
create table tbl_Parent
( col1 int not null constraint pk_tbl_Parent_col1 PRIMARY KEY,
  col2 varchar(10) not null);
go

create table tbl_Child
( col1 int not null constraint FK_tbl_Child_col1 REFERENCES tbl_Parent ON DELETE NO ACTION,   --< 可在後面自行再加入 ON UPDATE NO ACTION
  col2 varchar(10) not null);
go

/******************** Table-Level ********************/
-- 指定「條件約束」名稱
drop table if exists tbl_Child
drop table if exists tbl_Parent;
create table tbl_Parent
( col1 int not null,
  col2 varchar(10) not null,
  constraint pk_tbl_Parent_col1 PRIMARY KEY(col1)
);
go

create table tbl_Child
( col1 int not null,
  col2 varchar(10) not null,
  constraint FK_tbl_Child_col1 FOREIGN KEY(col1) REFERENCES tbl_Parent ON DELETE NO ACTION,   --< 可在後面自行再加入 ON UPDATE NO ACTION
);
go
-- END：Column-Level、Table-Leve 擇一執行



/* Column-Level 不同使用方式的參考，Table-Level 的用法也可以參考以下內容
-- 不指定「條件約束」名稱 (自動產生)
drop table if exists tbl_Child
drop table if exists tbl_Parent;
create table tbl_Parent
( col1 int not null PRIMARY KEY,
  col2 varchar(10) not null);
go

create table tbl_Child
( col1 int not null REFERENCES tbl_Parent ON DELETE NO ACTION,   --< 可在後面自行再加入 ON UPDATE NO ACTION
  col2 varchar(10) not null);
go
*/



-- 以下為測試的用途
select * from tbl_Parent;
select * from tbl_Child;
GO

-- 先為「父項」新增資料列
insert into tbl_Parent(col1, col2) values (1, 'gjun')
select * from tbl_Parent;
GO

-- 再為「子項」新增資料列 (共新增 3 筆資料列)
insert into tbl_Child (col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (2, 'gjun')   -- 失敗，與 NO ACTION 無關
-- 訊息：INSERT 陳述式與 FOREIGN KEY 條件約束 "FK_tbl_Child_col1" 衝突。衝突發生在資料庫 "TSQL2"，資料表 "dbo.tbl_Parent", column 'col1'。
select * from tbl_Child;
GO

-- 刪除「父項」資料列
delete from tbl_Parent where col1 = 1   -- 因為「子項」資料表的 FOREIGN KEY 已設定為 NO ACTION
-- 訊息：DELETE 陳述式與 REFERENCE 條件約束 "FK_tbl_Child_col1" 衝突。衝突發生在資料庫 "TSQL2"，資料表 "dbo.tbl_Child", column 'col1'。
select * from tbl_Parent;
GO

-- 更新「父項」資料行為 PRIMARY KEY 的值
update tbl_Parent
set col1 = 100
where col1 = 1;
-- 訊息：UPDATE 陳述式與 REFERENCE 條件約束 "FK_tbl_Child_col1" 衝突。衝突發生在資料庫 "TSQL2"，資料表 "dbo.tbl_Child", column 'col1'。
select * from tbl_Parent;
GO

-- 更新「子項」資料行為 FOREIGN KEY 的值
update tbl_Child
set col1 = 100
where col1 = 1;
-- 訊息：UPDATE 陳述式與 FOREIGN KEY 條件約束 "FK_tbl_Child_col1" 衝突。衝突發生在資料庫 "TSQL2"，資料表 "dbo.tbl_Parent", column 'col1'。
select * from tbl_Child;
GO

-- 先刪除「子項」資料列，以解除該資料列的參考關係，再刪除「父項」資料列
delete from tbl_Child where col1 = 1
delete from tbl_Parent where col1 = 1
GO

-- 查詢並觀察結果
select * from tbl_Parent;
select * from tbl_Child;
GO

-- 以下只為復原設定，與本主題無關
drop table if exists tbl_Child;
drop table if exists tbl_Parent;
GO