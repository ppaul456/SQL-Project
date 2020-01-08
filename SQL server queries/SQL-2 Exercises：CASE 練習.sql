--Exercises�GCASE �m��

--1.�սs�g Simple CASE �A�Φb stats.scores ��ƪ�A�b��Ʀ欰 testid �A�H�u���v���N��Ȭ��uTest ABC�v�A�H�u�^��v���N��Ȭ��uTest XYZ�v

--ANSWER:
select  case [testid]
			when 'Test ABC' then '���'
			when 'Test XYZ' then '�^��'
		end as ���,
		[studentid], 
		[score], 
		[testdate]
from [Stats].[Scores];



--2.�սs�g Searched CASE�A�ھ� stats.grades ��ƪ����Ƶ��Ť��e�A�b SELECT �Ǧ^ stats.scores ��ƪ�Ҧ��O���ɡA�B�~�[�J�@�ӡu���šv��Ʀ�

--ANSWER:
select  case [testid]
			when 'Test ABC' then '���'
			when 'Test XYZ' then '�^��'
		end as ���,
		[studentid], 
		[score], 
		[testdate],
		case
			when score >= 90 then 'A'
			when score >= 80 then 'B'
			when score >= 70 then 'C'
			when score >= 60 then 'D'
			when score >= 50 then 'E'
			else 'F'
		end ����
from [Stats].[Scores];

-- IIF()
select  case [testid]
			when 'Test ABC' then '���'
			when 'Test XYZ' then '�^��'
		end as ���,
		[studentid], 
		[score], 
		[testdate],
		case
			when score >= 90 then 'A'
			when score >= 80 then 'B'
			when score >= 70 then 'C'
			when score >= 60 then 'D'
			when score >= 50 then 'E'
			else 'F'
		end ����,
		iif( score >= 90, 'A', 
			iif( score >= 80, 'B', 
				iif(score >= 70, 'C',
					iif(score >=60, 'D',
						iif(score >= 50, 'E', 'F')
					)
				)
			)
		) ����2
from [Stats].[Scores];