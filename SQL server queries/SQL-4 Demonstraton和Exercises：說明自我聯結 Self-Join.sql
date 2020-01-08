Demonstration�G�H BOM �����h�S�ʡA�����u�ۧ��p�� Self-Join�v

---�H�U���������d�ҡASELECT INTO �i�N���G���إ߸�ƪ� (�����Ʀ�Ȥ�����)

select ���ƽs��, ���ƦW��, �ƶq, �ո˥N�� -- into BOM
from
(
    values	('A1', '�q��', NULL, 1, 'A0'),

            ('B1', '��ܾ�', 3000, 1, 'A1'),
            ('D1-1', '�q���u', 50, 2, 'A1'),
            ('D1-2', 'D-SUB�s���u', 100, 1, 'A1'),
            ('D1-3', '��L', 450, 1, 'A1'),
            ('D1-4', '�ƹ�', 120, 1, 'A1'),

            ('C1', '�D��', NULL, 1, 'A1'),

            ('E1-1', '�q��������', 1250, 1, 'C1'),
            ('E1-2', '����', 1100, 1, 'C1'),

            ('F1-1', '�D���O', 3800, 1, 'C1'),
            ('F1-2', 'CPU', 9500, 1, 'C1'),
            ('F1-3', 'DRAM', 1800, 4, 'C1'),
            ('F1-4', '��ܼҲ�', 1800, 1, 'C1'),
            ('F1-5', '�����Ҳ�', 500, 1, 'C1'),

            ('G1-1', 'HDD', 2500, 1, 'C1')

) dt (���ƽs��, ���ƦW��, ���, �ƶq, �ո˥N��);


---�d�� BOM ��A�Ǧ^�̪���Ĥ@�h Level 1 �U���s�ե�M��

select 
        Parent.���ƦW��,
        Child.�ո˥N��,
        Child.���ƽs��,
        Child.���ƦW��,
        Child.�ƶq
from BOM Child
    join BOM Parent on Parent.���ƽs�� = Child.�ո˥N��
where Parent.���ƽs�� = 'A1';


-------------------------------------------------------------------------------------
Exercises�G�H�u�ۧ��p�� Self-Join�v�A�q���w�����t���h����X�l�t���h���ݸ��

1.��X 5 ���D�ު����ݭ��u�A�Ǧ^�U�C��ơG(�H HR.Employees ����)
empid �D��ID
lastname �D�ަW�r
empid ���uID
lastname ���u�W�r

--ANSWER�G
select	m.empid �D��ID,
		m.lastname �D�ަW�r,
		e.empid ���uID,
		e.lastname ���u�W�r
from hr.Employees e
	join hr.Employees m on e.mgrid = m.empid
where m.empid = 5