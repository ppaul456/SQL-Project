create table #tbl
(
  [���u�s��] int,
  [����] nvarchar(3),
  [�l���ϸ�] nvarchar(5),
  [��(��)] nvarchar(20),
  [�a�}] as ([����] + [�l���ϸ�] + [��(��)])    ----�p���Ʀ�
);

insert into #tbl ([���u�s��], [����] ,[�l���ϸ�],[��(��)]) values (1, '������', '80002', '���s�@��')
select * from #tbl