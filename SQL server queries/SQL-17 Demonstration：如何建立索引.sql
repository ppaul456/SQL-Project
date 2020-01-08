--Demonstration：簡單案例，如何建立索引

drop table if exists hr.emp;
select
		empid + 0 as empid,
		lastname,
		birthdate	into hr.emp
from hr.Employees;

select * from hr.emp;

--------------------- 我是分隔線 ---------------------

-- 非唯一性，不需指定 unique 關鍵字句
-- 建立非唯一非叢集索引(採預設值)
create index idx_empid1 on hr.emp(empid);
-- drop index idx_empid1 on hr.emp;

-- 建立非唯一叢集索引
create clustered index idx_empid2 on hr.emp(empid);
-- drop index idx_empid2 on hr.emp;

-- -- 建立非唯一非叢集索引
create nonclustered index idx_empid3 on hr.emp(empid);
-- drop index idx_empid3 on hr.emp;


--------------------- 我是分隔線 ---------------------

-- 唯一性，需要指定 unique 關鍵字句
-- 建立唯一叢集索引
create unique clustered index idx_empid4 on hr.emp(empid);
-- drop index idx_empid4 on hr.emp;

-- 建立唯一非叢集索引
create unique nonclustered index idx_empid5 on hr.emp(empid);
-- drop index idx_empid5 on hr.emp;


--------------------- 我是分隔線 ---------------------

-- Clean Up
drop table hr.emp;