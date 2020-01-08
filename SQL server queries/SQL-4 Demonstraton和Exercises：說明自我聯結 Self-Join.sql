Demonstration：以 BOM 表的階層特性，說明「自我聯結 Self-Join」

---以下為說明的範例，SELECT INTO 可將結果集建立資料表 (單價資料行暫不產生)

select 物料編號, 物料名稱, 數量, 組裝代號 -- into BOM
from
(
    values	('A1', '電腦', NULL, 1, 'A0'),

            ('B1', '顯示器', 3000, 1, 'A1'),
            ('D1-1', '電源線', 50, 2, 'A1'),
            ('D1-2', 'D-SUB連接線', 100, 1, 'A1'),
            ('D1-3', '鍵盤', 450, 1, 'A1'),
            ('D1-4', '滑鼠', 120, 1, 'A1'),

            ('C1', '主機', NULL, 1, 'A1'),

            ('E1-1', '電源供應器', 1250, 1, 'C1'),
            ('E1-2', '機殼', 1100, 1, 'C1'),

            ('F1-1', '主機板', 3800, 1, 'C1'),
            ('F1-2', 'CPU', 9500, 1, 'C1'),
            ('F1-3', 'DRAM', 1800, 4, 'C1'),
            ('F1-4', '顯示模組', 1800, 1, 'C1'),
            ('F1-5', '網路模組', 500, 1, 'C1'),

            ('G1-1', 'HDD', 2500, 1, 'C1')

) dt (物料編號, 物料名稱, 單價, 數量, 組裝代號);


---查詢 BOM 表，傳回依附於第一層 Level 1 下的零組件清單

select 
        Parent.物料名稱,
        Child.組裝代號,
        Child.物料編號,
        Child.物料名稱,
        Child.數量
from BOM Child
    join BOM Parent on Parent.物料編號 = Child.組裝代號
where Parent.物料編號 = 'A1';


-------------------------------------------------------------------------------------
Exercises：以「自我聯結 Self-Join」，從指定的父系階層中找出子系階層隸屬資料

1.找出 5 號主管的所屬員工，傳回下列資料：(以 HR.Employees 為例)
empid 主管ID
lastname 主管名字
empid 員工ID
lastname 員工名字

--ANSWER：
select	m.empid 主管ID,
		m.lastname 主管名字,
		e.empid 員工ID,
		e.lastname 員工名字
from hr.Employees e
	join hr.Employees m on e.mgrid = m.empid
where m.empid = 5