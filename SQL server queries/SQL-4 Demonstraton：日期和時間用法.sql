declare @dt datetime = '1998/01/31 23:59:59.991'
select @dt

----------------------------------------------------------------------------------------------------
--���� datetime2
datetime2 �p�ƥH�U���i�F 7 ��� (100 �`��A10-9��)
�D�T�w�x�s��j�p�A�q 3 ~ 8 Bytes ����
���Ħ�ơA�p�Ʀ�ơG0 �� 7 ��ơA��T�׬� 100ns�A�w�]���Ħ�ƬO 7 ���
�x�s��j�p�G���� 3 �Ӧ��Ħ�Ƭ� 6 �Ӧ줸�աA3 ��4 �Ӧ��Ħ�Ƭ� 7 �Ӧ줸�աA
�Ҧ���L���Ħ�Ƨ��ݭn 8 �Ӧ줸�աA���Ĥ@�Ӧ줸�շ|�x�s�Ȫ����Ħ�ơA�ҥH�O 4 ~ 9 Bytes ����
�Y datetime ��� datetime2�A�i�ϥ� datetime2(3) �]���|���|�ˤ��J�����D
--�H�ܼƬ��ҡG

DECLARE @var datetime2 = '2018-06-10 23:59:59.999'
SELECT DATEADD(dd, 1, @var)

----------------------------------------------------------------------------------------------------
--���� datetimeoffset
datetimeoffset ���ѮɰϤ䴩�M�ɰϦ첾
�T�w�x�s��j�p 10 Bytes�A�ϥήɤ��ݭn���w����
�ɰϦ첾���w time �� datetime �ȱq UTC ��_���ɰϦ첾�C �ɰϦ첾�i��ܦ� [+|-] hh:mm
--�H�ܼƬ��ҡG

DECLARE @var datetimeoffset = '2018-06-10 23:59:59.999 +08:00'
SELECT DATEADD(dd, 1, @var)


----------------------------------------------------------------------------------------------------
�U�C�d�ҷ|����N�r���ഫ���U�� date �P time ������������G

SELECT   
     CAST('2018-05-08 12:35:29.1234567 +08:00' AS time(7)) AS 'time'   
    ,CAST('2018-05-08 12:35:29.1234567 +08:00' AS date) AS 'date'   
    ,CAST('2018-05-08 12:35:29.123' AS smalldatetime) AS   
        'smalldatetime'   
    ,CAST('2018-05-08 12:35:29.123' AS datetime) AS 'datetime'   
    ,CAST('2018-05-08 12:35:29. 1234567 +08:00' AS datetime2(7)) AS   
        'datetime2'  
    ,CAST('2018-05-08 12:35:29.1234567 +08:00' AS datetimeoffset(7)) AS   
        'datetimeoffset';