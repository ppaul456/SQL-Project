LIKE �䴩 ASCII �Ҧ���� (char �M varchar) �M Unicode �Ҧ���� (nchar �M nvarchar)

��Ҧ��u�޼ơv�������O ASCII �r����������ɡA�N�|���� ASCII �Ҧ����
�p�G������u�޼ơv���@�O Unicode ��������A�Ҧ��u�޼ơv���|�ഫ�� Unicode�A�B�|���� Unicode �Ҧ����
��z�f�t LIKE �ϥ� Unicode ��� (nchar �� nvarchar �������) �ɡA���ݪťիܭ��n�F
���L�A�w��D Unicode ��ơA���ݪťմN�����n

-- �� 1 ��
-- ASCII pattern matching with char column  
CREATE TABLE #t1 (col1 char(30));  
INSERT INTO #t1 VALUES ('Robert King');
GO
SELECT *   
FROM #t1   
WHERE col1 LIKE '% King';   -- returns 1 row  

-- �� 2 ��
-- Unicode pattern matching with nchar column  
CREATE TABLE #t2 (col1 nchar(30));  
INSERT INTO #t2 VALUES ('Robert King');  -- ���S���[ N ���@��
GO
SELECT *   
FROM #t2
WHERE col1 LIKE '% King';   -- no rows returned (���S���[ N ���@��)

-- �� 3 ��
-- Unicode pattern matching with nchar column and RTRIM  
CREATE TABLE #t3 (col1 nchar (30));  
INSERT INTO #t3 VALUES ('Robert King');  -- ���S���[ N ���@��
GO
SELECT *   
FROM #t3   
WHERE RTRIM(col1) LIKE '% King';   -- returns 1 row (���S���[ N ���@��)