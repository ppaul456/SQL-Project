��e�p��
�d�ߦh����ƪ�O��� Cartesian Product ����¦ (��e�p��)�A���ĦX (��e�p��) �A�z�� �]�����Υ~���^
�Ǧ^��Өӷ����(Sets�A��)��e���n�����G�A������Ƭۥ[(���k�X��)�A����Ƭۭ�

²��ר�

-- ANSI SQL-89
select *
from r1, r2;

-- ANSI SQL-92
select *
from r1 cross join r2;

-------------------------------------------------------------------------
�����p�� INNER JOIN
�̥D�n�Ω��X�۲Ū���ơA���۲Ū���Ʒ|�Q�ư�
²��ר� (���p���� + �z�����

/* �Ȧ����p���� */
-- ANSI SQL-89
select *
from r1, r2
where r1.a = r2.x;

-- ANSI SQL-92
select *
from r1 join r2 on r1.a = r2.x;


/* ���p���� + �z����� */
-- ANSI SQL-89
select *
from r1, r2
where r1.a = r2.x and r1.b <> 'b1';

-- ANSI SQL-92
select *
from r1 join r2 on r1.a = r2.x
where r1.b <> 'b1';



Demonstration�GINNER JOIN
�սs�g INNER JOIN �A�Φb stats.scores ��ƪ�A�b��Ʀ欰 testid �A
�H�u���v���N��Ȭ��uTest ABC�v�A�H�u�^��v���N��Ȭ��uTest XYZ�v

select	t.name,
        s.studentid,
        s.score
from stats.scores s
    join stats.Tests t on t.testid = s.testid;


