�d�� C�G��Ʈw�h�Ū� SEQUENCE (�۰ʨ���)

USE TempDB;

-- �إߦW�� CountBy2 ������ (�w�]�֨��j�p�� 50)
CREATE SEQUENCE dbo.CountBy2 as INT  --< �w�]�� BigInt
    START WITH 1
    INCREMENT BY 1
GO  

-- �إߴ��եΪ���ƪ�
CREATE TABLE #Tbl3
( col1 int DEFAULT (NEXT VALUE FOR dbo.CountBy2),
  col2 varchar(20) );
GO


-- �b INSERT ���w��W�M��� --> �ϥ� DEFAULT �۰ʨ���
INSERT INTO #Tbl3 (col1, col2) VALUES (DEFAULT, 'Identity Test1');
SELECT * FROM #Tbl3;


-- Clean Up
DROP TABLE IF EXISTS #Tbl3 
DROP SEQUENCE IF EXISTS dbo.CountBy2;
GO