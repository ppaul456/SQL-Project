---�Ь� Sales.OrderDetails ��ƪ�A�ϥ� ALTER TABLE ���z���[�J�@�� SubTotal �p���Ʀ�A�p�����(UnitPrice)�B�ƶq(QTY)�B�馩(DisCount) ���p�⵲�G�C
---���[��p���Ʀ檺�����������H


---ANSWER1:
alter table [Sales].[OrderDetails]
add SubTotal as [unitprice] * [qty] * (1 - [discount])

select * from [Sales].[OrderDetails]

---ANSWER2: (�A�X���k)
alter table [Sales].[OrderDetails]
drop column subtotal

alter table [Sales].[OrderDetails]
add SubTotal as cast([unitprice] * [qty] * (1 - [discount]) as numeric(10, 2)) persisted not null
