CASE �B�⦡
�i�m�� SELECT ����M�椤�A�õ����@������M��A�öǦ^�h�ӥi�઺���G�B�⦡���@
�Y�ݮھ���ȡA�Ǧ^���P��ȵ��G�A�i�ϥ� CASE �B�⦡
CASE �B�⦡����خ榡�G

²�� CASE �B�⦡�G
�@�ӭȩM�@�խȥh������o�쪺���G
�u�|�Ǧ^�Ĥ@�ӲŦX����
�Y���ŦX�A�h�Ǧ^ ELSE �l�y����
�P�W�A�Y�L ELSE �l�y�A�h�Ǧ^ NULL

SELECT	empid,
        lastname,
        case [titleofcourtesy] 
            when 'Mr.' then '����' 
            when 'Dr.' then '�դh'
            else '�k�h'
        end as �ٿ�
FROM [TSQL2].[HR].[Employees]


----------------------------------------------------------------------------
�j�M CASE �B�⦡ :
�����@�� Predicates �� �޿�B�⦡
�u�|�Ǧ^�Ĥ@�ӲŦX����
�Y���ŦX�A�h�Ǧ^ ELSE �l�y����
�P�W�A�Y�L ELSE �l�y�A�h�Ǧ^ NULL

select	empid ���u�s��,
        lastname �W�r,
        CASE 
            when salary > 100000 then '�Q�U���H�W'
            when salary > 50000 then '���U���H�W'
            else '���U���H�U'
        end '�~��'
from HR.Employees
