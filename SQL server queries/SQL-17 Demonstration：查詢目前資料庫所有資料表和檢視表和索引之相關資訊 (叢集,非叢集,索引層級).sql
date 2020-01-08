--Demonstration�G�p��d�� �ثe��Ʈw�Ҧ���ƪ�M�˵���M���ޤ�������T (�O��/�D�O��/���޼h��)

-- �d�ߥثe��Ʈw�Ҧ���ƪ�M�˵������������
select	db_name(database_id) [��Ʈw],
		object_name(object_id) [��ƪ�M�˵���],
		partition_number [���ΰ�],
		index_id [���޽s��],
		(
			select name
			from sys.indexes i
			where i.object_id = d.object_id
				and i.index_id = d.index_id
		) [���ަW��],
		index_type_desc [���޺���],
		index_depth [���޼h�żƥ�],
		index_level [���ޥثe�h��],
		avg_fragmentation_in_percent [���q�`�p],
		fragment_count [�����h�Ū����q�ƥ�],
		avg_fragment_size_in_pages [�����h�Ū��@�Ӥ��q��������],
		page_count [���ީθ�ƭ��`��],
        avg_page_space_used_in_percent [�������X��]
from sys.dm_db_index_physical_stats(db_id(), null, null, null, N'DETAILED') d
order by [��ƪ�M�˵���], [���ަW��], [�����h�Ū����q�ƥ�], [���޽s��], [���ޥثe�h��] desc;