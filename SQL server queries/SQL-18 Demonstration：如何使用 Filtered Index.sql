--範例 A：下列僅針對使用率最頻繁的日期範圍建立 Filtered Index

CREATE NONCLUSTERED INDEX nonIdx1 ON [Sales2].[Orders]
(
	[orderdate] ASC
)
WHERE orderdate >= '20070101' and orderdate < '20080101'



--範例 B：下列僅針對使用率最頻繁的訂單編號範圍建立 Filtered Index
CREATE NONCLUSTERED INDEX nonIdx2 ON [Sales2].[Orders]
(
	[orderid] ASC
)
WHERE orderid >= 10500 and orderid <= 10599