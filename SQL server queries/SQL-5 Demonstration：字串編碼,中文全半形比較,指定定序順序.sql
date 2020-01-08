列出指定字元字串的編碼

declare @count tinyint = 0
declare @Str nvarchar(10) = N'國際趨勢国际趋势'
declare @word nchar(1)
while @count < len(@Str)
begin
    set @count += 1
    set @word = SUBSTRING(@Str, @count, 1)
    print @word + '  ' + CAST( UNICODE(@word) as char(7) ) + NCHAR(UNICODE(@word))
end

------------------------------------------------------------------------------
中文字全半形的比較

-- 定序未含 _WS 表示不區分全形與半形，反之亦然
if '1' = '１' collate Chinese_Taiwan_Stroke_CI_AS   --< 自行加入 _WS
    print 'True'
else
    print 'Flase'


------------------------------------------------------------------------------
以指定定序改排序順序

-- 繁體中文預設定序為 Chinese_Taiwan_Stroke_CI_AS
select *
from (values(N'國'), (N'際'), (N'趨'), (N'勢'))  as tbl (col1)
order by col1 -- collate Chinese_Taiwan_Bopomofo_CI_AS