-- �d����w�Ҧ�
--use tsql2;
select	
		trnl.resource_type,
		ROW_NUMBER() over(	partition by trnl.request_session_id, 
										 trnl.resource_type, 
										 trnl.resource_associated_entity_id, 
										 trnl.request_mode 
							order by trnl.request_mode) �Ҧ��p��,
		concat(
				'(', trnl.request_mode, ') ',
				case trnl.request_mode
					when 'S' then '�@��'
					when 'U' then '��s'
					when 'X' then '�W��'
					when 'IS' then '�N�Ϧ@��'
					when 'IX' then '�N�ϿW��'
					when 'SIX' then '�@�ηN�ϿW��'
					when 'UIX' then '��s�N�ϿW��'
					when 'Sch-M' then '���c�y�z�ק�'
					when 'Sch-S' then '���c�y�zí�w��'
					when 'RangeS-S' then '�@�νd��A�@�θ귽��w�F�i�ǦC�ƽd�򱽴y�An+1'
					when 'RangeS-U' then '�@�νd��A��s�귽��w�F�i�ǦC�Ƨ�s���y'
					when 'RangeI-N' then '���J�d��ANull �귽��w�F�b���J�s�����������ޤ��e�ΨӴ��սd��'
					when 'RangeX-X' then '�W�e�d��A�W�e�귽��w�F�b�d�򤺧�s������ɨϥ�'
					else trnl.request_mode
				end
			  ) [��w�Ҧ�],
		trnl.request_status ��w���A,
		db_name(trnl.resource_database_id) ��Ʈw,
		case
			when trnl.resource_type IN ( 'OBJECT' )
				then	(
								 SELECT distinct concat(object_name(object_id), '�G', rows, ' �Ӹ�ƦC')
								 FROM sys.partitions 
								 WHERE object_id = trnl.resource_associated_entity_id
						)
			when trnl.resource_type IN ( 'ALLOCATION_UNIT', 'KEY', 'PAGE' )
				then	(
							 SELECT concat(object_name(object_id), '�G', rows, ' �Ӹ�ƦC')
							 FROM sys.partitions 
							 WHERE hobt_id = trnl.resource_associated_entity_id
						)
		end [����],
		trnl.resource_associated_entity_id,
		trv.version_sequence_num [(�ַ�)�����Ǹ�],
		trnl.resource_lock_partition ���ΰ�,
		trnl.request_session_id �u�@���q,
		ses.original_login_name [�n�J�W��],
		case ses.transaction_isolation_level 
			when 0 then 'Unspecified'
			when 1 then 'Read Uncommitted' 
			when 2 then 'Read Committed'
			when 3 then 'Repeatable'
			when 4 then 'Serializable'
			when 5 then 'Snapshot'
			else convert(varchar(2), ses.transaction_isolation_level)
		end [�u�@���q����j��],

		-- ALLOW_SNAPSHOT_ISOLATION
		-- 'ON�C�ϥΡu��ƦC��������v���ѡi����h�šj��Ū���@�P�ʡAŪ���@�~�u�ݭn SCH-S ��w�A��Ū����L����ҭק諸��ƦC�ɡA�|�^���b�Ұʥ���ɴN�w�g�s�b����ƦC����'
		-- 'OFF�C���ϥΡu��ƦC��������v���ѡi����h�šj��Ū���@�P��'
		db.snapshot_isolation_state_desc [(�ַ�)���\�ַӶ��j��],

		-- READ_COMMITTED_SNAPSHOT
		-- 'ON�C �ϥΡu��ƦC��������v���ѡi���z���h�šj��Ū���@�P�ʡAŪ���@�~�u�ݭn SCH-S ��w�A��Ū����L����ҭק諸��ƦC�ɡA�|�̷Ӹ�Ʀb���z���}�l�ɪ��s�b���A'
		-- 'OFF�C�bŪ���@�~�������O�Q�Φ@����w�Ө���Ū����L����ҭק諸��ƦC'
		case db.is_read_committed_snapshot_on
			when 0 then 'OFF'
			when 1 then 'ON'
		end [(�ַ�)Ū���{�i�ַ�],

		rtrim(ltrim(str(trsn.elapsed_time_seconds / 3600))) + ' �� ' 
			+ rtrim(ltrim(str((trsn.elapsed_time_seconds / 60) % 60))) + ' ��'
			+ rtrim(ltrim(str((trsn.elapsed_time_seconds % 60) ))) + ' ��' as [(�ַ�)��ƦC��������],
		--trvsu.reserved_page_count,
		trvsu.reserved_space_kb [(�ַ�)TempDB �����s���KB],
		st.[text] [T-SQL Scripts]

from sys.dm_tran_locks trnl
	left join sys.dm_exec_sessions ses on ses.session_id = trnl.request_session_id
	left join sys.databases db on db.database_id = trnl.resource_database_id
	left join sys.dm_tran_active_snapshot_database_transactions trsn on trsn.session_id = trnl.request_session_id
	left join sys.dm_exec_connections c on c.session_id = trnl.request_session_id
	left join sys.dm_tran_version_store trv on trv.rowset_id = trnl.resource_associated_entity_id
	left join sys.dm_tran_version_store_space_usage trvsu on trnl.resource_database_id = trvsu.database_id
	CROSS APPLY sys.dm_exec_sql_text (c.[most_recent_sql_handle]) AS st
where @@SPID <> trnl.request_session_id
order by case trnl.resource_type
			when 'DATABASE'			then 1
			when 'ALLOCATION_UNIT'	then 2
			when 'METADATA'			then 3
			when 'APPLICATION'		then 4
			when 'FILE'				then 5
			when 'TABLE'			then 6
			when 'OBJECT'			then 6
			when 'HoBT'				then 7
			when 'EXTENT'			then 8
			when 'PAGE'				then 9
			when 'KEY'				then 10
			when 'RID'				then 10
		end, trnl.request_session_id, [����]