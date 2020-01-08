--Demonstration�G²��רҡA�p��إ߯���

drop table if exists hr.emp;
select
		empid + 0 as empid,
		lastname,
		birthdate	into hr.emp
from hr.Employees;

select * from hr.emp;

--------------------- �ڬO���j�u ---------------------

-- �D�ߤ@�ʡA���ݫ��w unique ����r�y
-- �إ߫D�ߤ@�D�O������(�Ĺw�]��)
create index idx_empid1 on hr.emp(empid);
-- drop index idx_empid1 on hr.emp;

-- �إ߫D�ߤ@�O������
create clustered index idx_empid2 on hr.emp(empid);
-- drop index idx_empid2 on hr.emp;

-- -- �إ߫D�ߤ@�D�O������
create nonclustered index idx_empid3 on hr.emp(empid);
-- drop index idx_empid3 on hr.emp;


--------------------- �ڬO���j�u ---------------------

-- �ߤ@�ʡA�ݭn���w unique ����r�y
-- �إ߰ߤ@�O������
create unique clustered index idx_empid4 on hr.emp(empid);
-- drop index idx_empid4 on hr.emp;

-- �إ߰ߤ@�D�O������
create unique nonclustered index idx_empid5 on hr.emp(empid);
-- drop index idx_empid5 on hr.emp;


--------------------- �ڬO���j�u ---------------------

-- Clean Up
drop table hr.emp;