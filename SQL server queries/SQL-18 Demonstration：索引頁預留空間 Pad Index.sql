--索引頁預留空間 Pad Index
--基本語法

CREATE INDEX 索引名   --< 未指定 NONCLUSTERED 時，是建立非叢集索引
ON 資料表名 (資料行清單)
WITH PAD_INDEX, FILLFACTOR = 數值   --< 未加小括號，不建議使用

或

CREATE INDEX 索引名   --< 未指定 NONCLUSTERED 時，是建立非叢集索引
ON 資料表名 (資料行清單)
WITH (PAD_INDEX= {ON | OFF}, FILLFACTOR = 數值)

或

ALTER INDEX 索引名
ON 資料表名 REBUILD   --< 必須指定 REBUILD
WITH (PAD_INDEX = {ON | OFF}, FILLFACTOR = 數值)