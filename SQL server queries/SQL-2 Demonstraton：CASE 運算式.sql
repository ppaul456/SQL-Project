CASE 運算式
可置於 SELECT 選取清單中，並評估一份條件清單，並傳回多個可能的結果運算式之一
若需根據欄值，傳回不同欄值結果，可使用 CASE 運算式
CASE 運算式有兩種格式：

簡單 CASE 運算式：
一個值和一組值去做比較得到的結果
只會傳回第一個符合的值
若不符合，則傳回 ELSE 子句的值
同上，若無 ELSE 子句，則傳回 NULL

SELECT	empid,
        lastname,
        case [titleofcourtesy] 
            when 'Mr.' then '先生' 
            when 'Dr.' then '博士'
            else '女士'
        end as 稱謂
FROM [TSQL2].[HR].[Employees]


----------------------------------------------------------------------------
搜尋 CASE 運算式 :
評估一組 Predicates 或 邏輯運算式
只會傳回第一個符合的值
若不符合，則傳回 ELSE 子句的值
同上，若無 ELSE 子句，則傳回 NULL

select	empid 員工編號,
        lastname 名字,
        CASE 
            when salary > 100000 then '十萬元以上'
            when salary > 50000 then '五萬元以上'
            else '五萬元以下'
        end '薪資'
from HR.Employees
