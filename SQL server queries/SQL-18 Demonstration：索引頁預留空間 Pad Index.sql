--���ޭ��w�d�Ŷ� Pad Index
--�򥻻y�k

CREATE INDEX ���ަW   --< �����w NONCLUSTERED �ɡA�O�إ߫D�O������
ON ��ƪ�W (��Ʀ�M��)
WITH PAD_INDEX, FILLFACTOR = �ƭ�   --< ���[�p�A���A����ĳ�ϥ�

��

CREATE INDEX ���ަW   --< �����w NONCLUSTERED �ɡA�O�إ߫D�O������
ON ��ƪ�W (��Ʀ�M��)
WITH (PAD_INDEX= {ON | OFF}, FILLFACTOR = �ƭ�)

��

ALTER INDEX ���ަW
ON ��ƪ�W REBUILD   --< �������w REBUILD
WITH (PAD_INDEX = {ON | OFF}, FILLFACTOR = �ƭ�)