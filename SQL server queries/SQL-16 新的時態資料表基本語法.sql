--CREATE TABLE 可建立一個新的時態表

CREATE TABLE 資料表名稱
(    
  資料行名稱 資料類型 是否空值 PRIMARY KEY, 
  開始 datetime2(0) GENERATED ALWAYS AS ROW START [HIDDEN] [NOT NULL] [條件約束定義],
  結束 datetime2(0) GENERATED ALWAYS AS ROW END [HIDDEN] [NOT NULL] [條件約束定義],
  PERIOD FOR SYSTEM_TIME (開始, 結束)  
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = 結構描述.自訂歷程記錄資料表名稱));

--------------------------------------------------------------------------------------------------------------
--ALTER TABLE 可對現有資料表加入開始和結束的日期時間之「期間資料行」，使其可成為時態表

ALTER TABLE 資料表名稱
ADD [開始] datetime2(0) GENERATED ALWAYS AS ROW START [HIDDEN] [NOT NULL] [條件約束定義],
    [結束] datetime2(0) GENERATED ALWAYS AS ROW END [HIDDEN] [NOT NULL] [條件約束定義],
    PERIOD FOR SYSTEM_TIME (開始, 結束);

-----------------------------------------------------------------------------------------------------------------
--停用系統控制版本

ALTER TABLE 資料表名稱
SET (SYSTEM_VERSIONING = OFF);
GO