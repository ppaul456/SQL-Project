TOP�������Ϊk���G

�i�Ψӭ���Ǧ^����
-- �Ǧ^�̫� 5 ���q����
SELECT TOP (5) orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;
TOP + WITH TIES (���⪺�N��)

-- �Ǧ^�̫� 5 ���q���ƥH�ΦP�@�ɶ����q��
SELECT TOP (5) WITH TIES orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;

--����ʤ��񪺵��ơA�����Ƴ��O�T�w���A�]�i�H�[�W WITH TIES
SELECT TOP (10) PERCENT orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;

�H����� (�ϥ� newid())�A����ʤ��񪺵��ơA�����Ƴ��O�T�w���A
�]�i�H�[�W WITH TIES�A�Y�Q�Ǧ^���T�w���ơA�h�i��� TABLESAMPLE
-- ���k�@
SELECT TOP (10) PERCENT orderid, custid, orderdate
FROM Sales.Orders
ORDER BY newid(), orderdate DESC;

-- ���k�G
SELECT orderid, custid, orderdate
FROM Sales.Orders TABLESAMPLE SYSTEM (10 PERCENT )
ORDER BY orderdate DESC;



----------------------------------------------------------------------------
�ϥ� OFFSET-FETCH �l�y�����ƦC
FIRST �� NEXT �l�y�N��ۦP

--�������Ϊk���G
--�Ǧ^�� 11 ����� 20 �����O��
SELECT orderid, custid, orderdate
FROM Sales.Orders
ORDER BY orderdate, orderid DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

--�Ǧ^�e 50 ���O��
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC
OFFSET 0 ROWS
FETCH FIRST 50 ROWS ONLY;
