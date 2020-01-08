--Demonstration：如何使用 Database Engine Tuning Advisor, DETA 分析索引
--使用 DETA 分析下列指令檔提供索引建議，操作前須確認這些資料表未建立過索引，以免影響分析結果

select od.OrderID,
        sum(p.listprice * od.QTY) SubTotal 
from sales2.OrderDetails od
    join Production2.Products p on p.productid = od.productid
    join Production2.Suppliers s on s.supplierid = p.supplierid
where s.country = 'Japan'
    and od.unitprice < p.listprice
group by od.orderid