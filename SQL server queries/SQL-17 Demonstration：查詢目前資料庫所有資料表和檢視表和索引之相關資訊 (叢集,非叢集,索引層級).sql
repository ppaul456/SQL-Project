--Demonstration：如何查詢 目前資料庫所有資料表和檢視表和索引之相關資訊 (叢集/非叢集/索引層級)

-- 查詢目前資料庫所有資料表和檢視表相關的索引
select	db_name(database_id) [資料庫],
		object_name(object_id) [資料表和檢視表],
		partition_number [分割區],
		index_id [索引編號],
		(
			select name
			from sys.indexes i
			where i.object_id = d.object_id
				and i.index_id = d.index_id
		) [索引名稱],
		index_type_desc [索引種類],
		index_depth [索引層級數目],
		index_level [索引目前層級],
		avg_fragmentation_in_percent [片段總計],
		fragment_count [分葉層級的片段數目],
		avg_fragment_size_in_pages [分葉層級的一個片段平均頁數],
		page_count [索引或資料頁總數],
        avg_page_space_used_in_percent [頁面飽合度]
from sys.dm_db_index_physical_stats(db_id(), null, null, null, N'DETAILED') d
order by [資料表和檢視表], [索引名稱], [分葉層級的片段數目], [索引編號], [索引目前層級] desc;