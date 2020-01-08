---Exercises�G�ϥΩM��@ INSERT + SELECT �m��
---�ռg�X INSERT + SELECT�A�ھ� 2007 �~ 10 ����q�檺�q��s���M��A��X�o�ǾP��H����������ơA�ç����U�C�ݨD�G

----���]�v�g���@�ӹw���إߦn����ƪ� Sales.OrderEmp_200710 (����U�C T-SQL �ӧ���)�A���O�Ψ��x�s�P��H�����������
CREATE TABLE Sales.OrderEmp_200710
( EmpID tinyint,
  LastName nvarchar(20),
  SalesAmount money
);

-----�ھ� 2007 �~ 10 ����q��(�p�U)�A��X�U�C�q��s�����P��H���A�s�W���ƪ� Sales.OrderEmp_200710
--10689
--10692
--10721
--10723
--��Ʀ� SalesAmount �ݦs�J unitprice * qty ���έp���G

---ANSWER�G

insert into Sales.OrderEmp_200710
select o.empid, e.lastname, od.SubTotal
from sales.orders o
	join sales.OrderDetails od on od.orderid = o.orderid
	join hr.Employees e on e.empid = o.empid
where o.orderid in (10689, 10692, 10721, 10723)