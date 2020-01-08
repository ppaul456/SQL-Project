----Demonstration：使用 INSERT + SELECT 大量新增記錄

-- 建立用來測試的複本資料表 (只有綱要結構，沒有資料列)
SELECT EmpID, Lastname, Salary, hiredate INTO HR.Copy_Emp
FROM HR2.Employees
WHERE 1=0;
GO

-- 使用 INSERT + SELECT 大量新增記錄
INSERT INTO HR.Copy_Emp (EmpID, Lastname, Salary, hiredate)
SELECT EmpID, Lastname, Salary, hiredate 
FROM HR2.Employees;
GO

SELECT EmpID, Lastname, Salary, hiredate
FROM HR2.Employees;
