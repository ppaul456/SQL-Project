�ϥΫ��w�w�Ǫ��򥻻y�k�G(COLLATE �������b�B�⦡�᭱)

�r���r��B�⦡ COLLATE �w��
���w�n�Ϥ��j�p�g���w�ǡG

/* COLLATE �������b�B�⦡�᭱ */
-- �覡�@
SELECT *
FROM [TSQL2].[HR].[Employees]
WHERE lastname = 'davis' COLLATE Latin1_General_CS_AI;

-- �覡�G
SELECT *
FROM [TSQL2].[HR].[Employees]
WHERE lastname COLLATE Latin1_General_CS_AI = 'davis';
�� ORDER BY �N���G�ƧǦ����w�a�Ϫ����G�G

/* COLLATE �������b�B�⦡�᭱ */
SELECT Companyname 
FROM Sales.customers
ORDER BY Companyname COLLATE Latin1_General_CS_AI; 
�Y�n�d�� SQL Server �䴩 Taiwan �a�Ϫ��w�ǡG

SELECT Name, Description 
FROM fn_helpcollations()  
WHERE Name like '%Taiwan%';