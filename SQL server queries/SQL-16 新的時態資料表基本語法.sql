--CREATE TABLE �i�إߤ@�ӷs���ɺA��

CREATE TABLE ��ƪ�W��
(    
  ��Ʀ�W�� ������� �O�_�ŭ� PRIMARY KEY, 
  �}�l datetime2(0) GENERATED ALWAYS AS ROW START [HIDDEN] [NOT NULL] [��������w�q],
  ���� datetime2(0) GENERATED ALWAYS AS ROW END [HIDDEN] [NOT NULL] [��������w�q],
  PERIOD FOR SYSTEM_TIME (�}�l, ����)  
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = ���c�y�z.�ۭq���{�O����ƪ�W��));

--------------------------------------------------------------------------------------------------------------
--ALTER TABLE �i��{����ƪ�[�J�}�l�M����������ɶ����u������Ʀ�v�A�Ϩ�i�����ɺA��

ALTER TABLE ��ƪ�W��
ADD [�}�l] datetime2(0) GENERATED ALWAYS AS ROW START [HIDDEN] [NOT NULL] [��������w�q],
    [����] datetime2(0) GENERATED ALWAYS AS ROW END [HIDDEN] [NOT NULL] [��������w�q],
    PERIOD FOR SYSTEM_TIME (�}�l, ����);

-----------------------------------------------------------------------------------------------------------------
--���Ψt�α����

ALTER TABLE ��ƪ�W��
SET (SYSTEM_VERSIONING = OFF);
GO