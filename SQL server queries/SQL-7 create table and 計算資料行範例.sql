create table #tbl
(
  [員工編號] int,
  [縣市] nvarchar(3),
  [郵遞區號] nvarchar(5),
  [路(街)] nvarchar(20),
  [地址] as ([縣市] + [郵遞區號] + [路(街)])    ----計算資料行
);

insert into #tbl ([員工編號], [縣市] ,[郵遞區號],[路(街)]) values (1, '高雄市', '80002', '中山一路')
select * from #tbl