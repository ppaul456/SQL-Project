範例 F： FOREIGN KEY (ON DELETE CASCADE) 或 FOREIGN KEY (ON UPDATE CASCADE) 僅介紹 Column-Level 用法，Table-Level 請參考前面做法
USE TSQL2;
GO

-- START：Column-Level
/******************** Column-Level ********************/
-- 為配合 FOREIGN KEY 建立擁有主鍵的資料表
-- 指定「條件約束」名稱
drop table if exists tbl_Child
drop table if exists tbl_Parent
create table tbl_Parent
( col1 int not null constraint PK_tbl_Parent_col1 PRIMARY KEY,
  col2 varchar(10) not null )
go

-- 指定「條件約束」名稱
drop table if exists tbl_Child
create table tbl_Child
( col1 int not null constraint FK_tbl_Child_tbl_Parent REFERENCES tbl_Parent ON DELETE CASCADE ,   --< 可在後面自行再加入 ON UPDATE CASCADE
  col2 varchar(10) not null )
go
-- END：Column-Level



-- 以下為測試的用途
-- 先為「父項」新增一筆資料列，再為「子項」新增兩筆資料列
insert into tbl_Parent(col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (1, 'gjun')
insert into tbl_Child (col1, col2) values (1, 'gjun')

-- 刪除「父項」資料列
delete from tbl_Parent where col1 = 1
-- (1 個資料列受到影響)：因為「子項」資料表的 FOREIGN KEY 已設定為 ON DELETE CASCADE

/* 若 FOREIGN KEY 有指定 ON UPDATE CASCADE
-- 更新「父項」資料列
update tbl_Parent set col1 = 10 where col1 = 1
-- (1 個資料列受到影響)：雖更新「父項」新增資料列，但「子項」相關資料列也受影響
-- 因為「子項」資料表的 FOREIGN KEY 已設定為 ON UPDATE CASCADE
*/

-- 查詢並觀察結果，會發現「父項」一筆資料列和「子項」兩筆資料列全部都刪除
select * from tbl_Parent;
select * from tbl_Child;

-- 以下只為復原設定，與本主題無關
drop table if exists tbl_Child;
drop table if exists tbl_Parent;