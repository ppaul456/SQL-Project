Demonstraton�GOUTER JOIN

--�d�� A�G ��X���ǭ��u�٥������q��~�Z�A�Ǧ^���u�s���M�W�r
EmpID ���u�s��
LastName �W�r
select e.EmpID ���u�s��,
		e.LastName �W�r
from hr.Employees e
	LEFT OUTER JOIN sales.orders o ON e.empid = o.empid
where o.empid is null;

-------------------------------------------------------------------------------------
Exercises�GOUTER JOIN �m��

��X���ǫȤ��٥����U�q��A�Ǧ^�U�C���
custid �Ȥ�s��
companyname ���q�W��

--ANSWER�G
select	c.custid �Ȥ�s��,
		c.companyname ���q�W��
from sales.Customers c
	left join sales.orders o on o.custid = c.custid
where o.custid is null;
��X 2007 �~ 5 ������q�椤�A�����q�ʹL�����~�A�Ǧ^�U�C���
ProductID ���~�s��
ProductName ���~�W��
ANSWER�G
select	p.ProductID ���~�s��,
		p.ProductName ���~�W��
from sales.orders o
	inner join sales.OrderDetails od 
		on od.orderid = o.orderid 
			and year(o.orderdate) = 2007
			and month(o.orderdate) = 5
	right outer join Production.Products p on p.productid = od.productid
where od.productid is null;


select	p.ProductID ���~�s��,
		p.ProductName ���~�W��
from sales.orders o
	inner join sales.OrderDetails od 
		on od.orderid = o.orderid 
			and o.orderdate between '20070501' and '20070531'
	right outer join Production.Products p on p.productid = od.productid
where od.productid is null;