-- 查詢鎖定模式
--use tsql2;
select	
		trnl.resource_type,
		ROW_NUMBER() over(	partition by trnl.request_session_id, 
										 trnl.resource_type, 
										 trnl.resource_associated_entity_id, 
										 trnl.request_mode 
							order by trnl.request_mode) 模式計數,
		concat(
				'(', trnl.request_mode, ') ',
				case trnl.request_mode
					when 'S' then '共用'
					when 'U' then '更新'
					when 'X' then '獨佔'
					when 'IS' then '意圖共用'
					when 'IX' then '意圖獨佔'
					when 'SIX' then '共用意圖獨佔'
					when 'UIX' then '更新意圖獨佔'
					when 'Sch-M' then '結構描述修改'
					when 'Sch-S' then '結構描述穩定性'
					when 'RangeS-S' then '共用範圍，共用資源鎖定；可序列化範圍掃描，n+1'
					when 'RangeS-U' then '共用範圍，更新資源鎖定；可序列化更新掃描'
					when 'RangeI-N' then '插入範圍，Null 資源鎖定；在插入新的索引鍵到索引之前用來測試範圍'
					when 'RangeX-X' then '獨占範圍，獨占資源鎖定；在範圍內更新索引鍵時使用'
					else trnl.request_mode
				end
			  ) [鎖定模式],
		trnl.request_status 鎖定狀態,
		db_name(trnl.resource_database_id) 資料庫,
		case
			when trnl.resource_type IN ( 'OBJECT' )
				then	(
								 SELECT distinct concat(object_name(object_id), '：', rows, ' 個資料列')
								 FROM sys.partitions 
								 WHERE object_id = trnl.resource_associated_entity_id
						)
			when trnl.resource_type IN ( 'ALLOCATION_UNIT', 'KEY', 'PAGE' )
				then	(
							 SELECT concat(object_name(object_id), '：', rows, ' 個資料列')
							 FROM sys.partitions 
							 WHERE hobt_id = trnl.resource_associated_entity_id
						)
		end [物件],
		trnl.resource_associated_entity_id,
		trv.version_sequence_num [(快照)版本序號],
		trnl.resource_lock_partition 分割區,
		trnl.request_session_id 工作階段,
		ses.original_login_name [登入名稱],
		case ses.transaction_isolation_level 
			when 0 then 'Unspecified'
			when 1 then 'Read Uncommitted' 
			when 2 then 'Read Committed'
			when 3 then 'Repeatable'
			when 4 then 'Serializable'
			when 5 then 'Snapshot'
			else convert(varchar(2), ses.transaction_isolation_level)
		end [工作階段交易隔離],

		-- ALLOW_SNAPSHOT_ISOLATION
		-- 'ON。使用「資料列版本控制」提供【交易層級】的讀取一致性，讀取作業只需要 SCH-S 鎖定，當讀取其他交易所修改的資料列時，會擷取在啟動交易時就已經存在的資料列版本'
		-- 'OFF。不使用「資料列版本控制」提供【交易層級】的讀取一致性'
		db.snapshot_isolation_state_desc [(快照)允許快照集隔離],

		-- READ_COMMITTED_SNAPSHOT
		-- 'ON。 使用「資料列版本控制」提供【陳述式層級】的讀取一致性，讀取作業只需要 SCH-S 鎖定，當讀取其他交易所修改的資料列時，會依照資料在陳述式開始時的存在狀態'
		-- 'OFF。在讀取作業的期間是利用共用鎖定來防止讀取其他交易所修改的資料列'
		case db.is_read_committed_snapshot_on
			when 0 then 'OFF'
			when 1 then 'ON'
		end [(快照)讀取認可快照],

		rtrim(ltrim(str(trsn.elapsed_time_seconds / 3600))) + ' 時 ' 
			+ rtrim(ltrim(str((trsn.elapsed_time_seconds / 60) % 60))) + ' 分'
			+ rtrim(ltrim(str((trsn.elapsed_time_seconds % 60) ))) + ' 秒' as [(快照)資料列版本歷時],
		--trvsu.reserved_page_count,
		trvsu.reserved_space_kb [(快照)TempDB 版本存放區KB],
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
		end, trnl.request_session_id, [物件]