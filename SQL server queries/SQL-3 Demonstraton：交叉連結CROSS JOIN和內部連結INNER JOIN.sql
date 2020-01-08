交叉聯結
查詢多重資料表是基於 Cartesian Product 的基礎 (交叉聯結)，先融合 (交叉聯結) 再篩選 （內部或外部）
傳回兩個來源表格(Sets，集)交叉乘積的結果，兩表欄位數相加(左右合併)，兩表筆數相乘

簡單案例

-- ANSI SQL-89
select *
from r1, r2;

-- ANSI SQL-92
select *
from r1 cross join r2;

-------------------------------------------------------------------------
內部聯結 INNER JOIN
最主要用於找出相符的資料，不相符的資料會被排除
簡單案例 (關聯條件 + 篩選條件

/* 僅有關聯條件 */
-- ANSI SQL-89
select *
from r1, r2
where r1.a = r2.x;

-- ANSI SQL-92
select *
from r1 join r2 on r1.a = r2.x;


/* 關聯條件 + 篩選條件 */
-- ANSI SQL-89
select *
from r1, r2
where r1.a = r2.x and r1.b <> 'b1';

-- ANSI SQL-92
select *
from r1 join r2 on r1.a = r2.x
where r1.b <> 'b1';



Demonstration：INNER JOIN
試編寫 INNER JOIN ，用在 stats.scores 資料表，在資料行為 testid ，
以「國文」取代欄值為「Test ABC」，以「英文」取代欄值為「Test XYZ」

select	t.name,
        s.studentid,
        s.score
from stats.scores s
    join stats.Tests t on t.testid = s.testid;


