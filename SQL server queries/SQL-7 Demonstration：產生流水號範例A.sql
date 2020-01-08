�d�� A�G��Ʀ�h�Ū� IDENTITY (�۰ʨ����M�H�u����)

-- �إߴ��եΪ���ƪ�
CREATE TABLE #Tbl
( col1 int IDENTITY(1, 1) NOT NULL, --< (1, 1) �i�ٲ�
  col2 varchar(20) NOT NULL);
GO

-- �w�]���i�b INSERT ���w��W
INSERT INTO #Tbl (col2) VALUES ('Identity Test');
SELECT * FROM #Tbl;

-- �b INSERT ���w��W�M���
INSERT INTO #Tbl (col1, col2) VALUES (20, 'Identity Test');
SELECT * FROM #Tbl;
-- ERROR�G�� IDENTITY_INSERT �]�� OFF �ɡA�L�k�N�~��ȴ��J��ƪ� '#Tbl' ���ѧO��줤

-- �Ǧ^�ثe�u�@���q�̫Უ�ͪ��ѧO��
SELECT @@IDENTITY

-- ���m�u�ؤl�ѧO�ȡv�� 100 --> �|�Ǧ^�ثe�̫᪺�ѧO��
DBCC CHECKIDENT ('#Tbl', RESEED, 100);

-- �A���Ǧ^�ثe�u�@���q�̫Უ�ͪ��ѧO�� --> ��Ȥ��ܡA���O���m�e�����X
SELECT @@IDENTITY

-- ��� INSERT ���լݬ� --> ��Ȥw���� (�q 101 �}�l)
INSERT INTO #Tbl (col2) VALUES ('Identity Test');
SELECT * FROM #Tbl;

-- �A���Ǧ^�ثe�u�@���q�̫Უ�ͪ��ѧO�� (���O 101 �H�᪺���X)
SELECT @@IDENTITY

/* Question�G
 �p��b���j�Ȥ����A�H�H�u�w�Ƹ��X�H
    1. SET IDENTITY_INSERT ��ƪ� ON
    2. �b INSERT ���w��W�M���
    3. SET IDENTITY_INSERT ��ƪ� OFF --< �Χ��n�_��
*/

--	1. SET IDENTITY_INSERT ��ƪ� ON
    SET IDENTITY_INSERT #Tbl ON;

--	2. �b INSERT ���w��W�M���
    INSERT INTO #Tbl (col1, col2) VALUES (50, 'Identity Test');
    SELECT * FROM #Tbl;

--	3. SET IDENTITY_INSERT ��ƪ� OFF --< �Χ��n�_��
    SET IDENTITY_INSERT #Tbl OFF;


-- ��_�۰ʨ����ḹ�X�O�H
-- �A���Ǧ^�ثe�u�@���q�̫Უ�ͪ��ѧO�� --> ���ӷ|�O���T���סH
SELECT @@IDENTITY, IDENT_CURRENT('#Tbl'), SCOPE_IDENTITY()

-- �ϥΨ䥦�覡�d��
DBCC CHECKIDENT('#Tbl')


-- ��� INSERT ���լݬ� --> ���O���m�u�ؤl�ѧO�ȡv�� 100 �H�᪺���X
INSERT INTO #Tbl (col2) VALUES ('Identity Test');
SELECT * FROM #Tbl;