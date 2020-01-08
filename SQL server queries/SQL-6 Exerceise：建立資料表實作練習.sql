1.使用 CREATE TABLE ，新增資料表 HR.Emp，並根據下列內容建立資料行、資料類型、是否NULL
身份證字號,姓名,城市,街道,到職日,薪水
A123456789,陳新富,台北,信義路,1998-05-29,80000.00
B221304680,郭台城,台北,忠孝東路,2013-10-05,35000.00
F332213046,張冠車,台北,仁愛路,2010-07-01,50000.00


--ANSWER：
-- drop table if exists hr.emp
create table hr.emp
( 身份證字號 nchar(10) not null,
  姓名 nvarchar(10) not null,
  城市 nvarchar(3) not null,
  街道 nvarchar(20) not null,
  到職日 date not null,
  薪水 decimal(9, 2) not null );
go


2.更改資料表使用 ALTER TABLE，為資料表加入額外的「員工編號」(流水號)欄位，並評估適合的資料類型和是否 NULL：


--ANSWER：
alter table hr.emp
add 員工編號 int not null;
go