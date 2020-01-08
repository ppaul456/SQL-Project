---請為 Sales.OrderDetails 資料表，使用 ALTER TABLE 陳述式加入一個 SubTotal 計算資料行，計算其單價(UnitPrice)、數量(QTY)、折扣(DisCount) 的計算結果。
---並觀察計算資料行的資料類型為何？


---ANSWER1:
alter table [Sales].[OrderDetails]
add SubTotal as [unitprice] * [qty] * (1 - [discount])

select * from [Sales].[OrderDetails]

---ANSWER2: (適合做法)
alter table [Sales].[OrderDetails]
drop column subtotal

alter table [Sales].[OrderDetails]
add SubTotal as cast([unitprice] * [qty] * (1 - [discount]) as numeric(10, 2)) persisted not null
