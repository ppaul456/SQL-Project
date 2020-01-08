範例 I： 資料表已建立之後，若要加入或移除條件約束，請參考以下：
USE TSQL2;
GO



-- START：假設已有下列資料表
drop table if exists tbl1
create table tbl1
( col1 int,
  col2 varchar(10),
  col3 datetime );
go

drop table if exists tbl2
create table tbl2
( col1 int,
  col2 varchar(10) );
go
-- END：假設已有下列資料表



-- 為資料表新增 PRIMARY KEY 的資料行，指定為 NOT NULL
alter table tbl1 alter column col1 int not null;
alter table tbl2 alter column col1 int not null;
go

-- 為資料表新增 PRIMARY KEY 條件約束，不指定「條件約束」名稱 (自動產生)
alter table tbl1
add primary key (col1);
go
alter table tbl2
add primary key (col1);
go

-- 為資料表新增 FOREIGN KEY 條件約束，不指定「條件約束」名稱 (自動產生)
alter table tbl2
add foreign key (col1)
references dbo.tbl1;
go

-- 為資料表新增 CHECK 條件約束，不指定「條件約束」名稱 (自動產生)
alter table tbl1
add check(col1 between 1 and 10);
go

-- 為資料表新增 CHECK 條件約束，並指定「條件約束」名稱
alter table tbl1
add constraint ck_tbl1_col2 check( col2 like '[AB]_________');
go

-- 為資料表新增 DEFAULT 條件約束，並指定「條件約束」名稱
alter table tbl1
add constraint df_tbl1_col3 default (getdate()) for col3;
go

-- 為資料表移除 CHECK 條件約束
alter table tbl1
drop constraint ck_tbl1_col2;
go



-- 問題：如何移除自動產生名稱的「條件約束」？



-- 以下只為復原設定，與本主題無關
drop table if exists tbl2;
drop table if exists tbl1;
go