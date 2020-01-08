--Demonstration�G�p��ϥ� Database Engine Tuning Advisor, DETA ���R����
--�ϥ� DETA ���R�U�C���O�ɴ��ѯ��ޫ�ĳ�A�ާ@�e���T�{�o�Ǹ�ƪ��إ߹L���ޡA�H�K�v�T���R���G

select od.OrderID,
        sum(p.listprice * od.QTY) SubTotal 
from sales2.OrderDetails od
    join Production2.Products p on p.productid = od.productid
    join Production2.Suppliers s on s.supplierid = p.supplierid
where s.country = 'Japan'
    and od.unitprice < p.listprice
group by od.orderid