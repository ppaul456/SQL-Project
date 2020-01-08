1. 請問，若變更目前 MS-SQL Server 中文版的定序 (從筆劃改為注音) ，例如在運算式上改變定序，對 Predicate 是否有影響？
例如要找出 HR.Employess 的 10 號員工，Predicate 為 Lastname = N’大中’

請自行以 T-SQL 實作

--ANSWER：
select *
from hr.Employees
where Lastname = N'大中' collate Chinese_Taiwan_Bopomofo_CI_AS



2.請問，目前 MS-SQL Server 中文版的定序，是否可以在 Predicate 使用中文全形的阿拉伯數字的資料？
例如要找出 HR.Employess 的 10 號員工，Predicate 必須使用全形的阿拉伯數字 １０，例如：EmpID = ‘１０’

請自行以 T-SQL 實作

--ANSWER：
select *
from hr.Employees
where cast(empid as varchar(2)) = '１０'