char，varchar
用在中文字，最多只能存 4000 個字
用在英文字，最多只能存 8000 個字

varchar(max) 可存 1G 個中文字或 2G 個英文字

char
固定儲存體大小，使用時依指定長度決定儲存體的大小

--以變數為例：
DECLARE @var CHAR(20) = 'SQL資料庫窭';
SELECT @var, LEN(@var), DATALENGTH(@var);


varchar

非固定儲存體大小，使用時依指定長度決定儲存體最大的大小，但實際以存入的資料長度為主

--以變數為例：
DECLARE @var VARCHAR(20) = 'SQL資料庫窭';
SELECT @var, LEN(@var), DATALENGTH(@var);


