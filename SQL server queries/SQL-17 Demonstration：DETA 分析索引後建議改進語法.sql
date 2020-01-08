--DETA 分析索引後建議改進語法

CREATE NONCLUSTERED INDEX [_dta_index_OrderDetails_7_1717581157__K2_K1_3_4] ON [Sales2].[OrderDetails]
(
	[productid] ASC,
	[orderid] ASC
)
INCLUDE ( 	[unitprice],
	[qty]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
