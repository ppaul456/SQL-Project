�d�� B�G��Ʈw�h�Ū� SEQUENCE (�H�u����)

USE TempDB;

-- �إߦW�� CountBy1 ������ (�w�]�֨��j�p�� 50)
CREATE SEQUENCE dbo.CountBy1 as INT  --< �w�]�� BigInt
    START WITH 10  --< ���i�C�� MINVALUE
    INCREMENT BY 10
    MINVALUE 1   --< �i�ٲ��A�w�]�̤p�ȬO�ǦC���󤧸���������̤p��
    MAXVALUE 100; --< �i�ٲ��A�w�]�̤j�ȬO�ǦC���󤧸���������̤j��
GO  

-- �إߴ��եΪ���ƪ�
CREATE TABLE #Tbl1
( col1 int,
  col2 varchar(20) );
GO
CREATE TABLE #Tbl2
( col1 int,
  col2 varchar(20) );
GO


-- �b INSERT ���w��W�M���
INSERT INTO #Tbl1 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test1');
SELECT * FROM #Tbl1;
INSERT INTO #Tbl2 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test2');
SELECT * FROM #Tbl2;

-- �Ǧ^�ثe�u�@���q�̫Უ�ͪ��ѧO��
SELECT current_value FROM sys.sequences WHERE name = 'CountBy1';

/* Question�G
 �Y�N���X�Χ��|�p��H --> �w�]�����ƨϥθ��X
*/

-- �ܧ󶶧Ǫ���A�i���ƨϥθ��X --> �w�]�����ƨϥθ��X
ALTER SEQUENCE dbo.CountBy1
START WITH 1
INCREMENT BY 1
MAXVALUE 1000;
GO
-- ERROR�G�޼� 'START WITH' ���i�ϥΦb ALTER SEQUENCE ���z����


-- �A���ܧ󶶧Ǫ���A�i���ƨϥθ��X --> �w�]�����ƨϥθ��X
-- �]�i�H�յۥ[�J RESTART WITH 1 �ݬ�
ALTER SEQUENCE dbo.CountBy1
INCREMENT BY 1
MAXVALUE 1000;
GO

-- �d�߲{�b���]�w
SELECT * FROM sys.sequences WHERE name = 'CountBy1';


-- �A�� INSERT ���w��W�M��� --> �|�o�{�w�ϥηs���]�w
INSERT INTO #Tbl1 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test1');
SELECT * FROM #Tbl1;
INSERT INTO #Tbl2 (col1, col2) VALUES (NEXT VALUE FOR dbo.CountBy1, 'Identity Test2');
SELECT * FROM #Tbl2;

-- Clean Up
DROP SEQUENCE dbo.CountBy1;
GO