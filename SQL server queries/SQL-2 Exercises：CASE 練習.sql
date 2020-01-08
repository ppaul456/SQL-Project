--Exercises：CASE 練習

--1.試編寫 Simple CASE ，用在 stats.scores 資料表，在資料行為 testid ，以「國文」取代欄值為「Test ABC」，以「英文」取代欄值為「Test XYZ」

--ANSWER:
select  case [testid]
			when 'Test ABC' then '國文'
			when 'Test XYZ' then '英文'
		end as 科目,
		[studentid], 
		[score], 
		[testdate]
from [Stats].[Scores];



--2.試編寫 Searched CASE，根據 stats.grades 資料表的分數等級內容，在 SELECT 傳回 stats.scores 資料表所有記錄時，額外加入一個「等級」資料行

--ANSWER:
select  case [testid]
			when 'Test ABC' then '國文'
			when 'Test XYZ' then '英文'
		end as 科目,
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
		end 等級
from [Stats].[Scores];

-- IIF()
select  case [testid]
			when 'Test ABC' then '國文'
			when 'Test XYZ' then '英文'
		end as 科目,
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
		end 等級,
		iif( score >= 90, 'A', 
			iif( score >= 80, 'B', 
				iif(score >= 70, 'C',
					iif(score >=60, 'D',
						iif(score >= 50, 'E', 'F')
					)
				)
			)
		) 等級2
from [Stats].[Scores];