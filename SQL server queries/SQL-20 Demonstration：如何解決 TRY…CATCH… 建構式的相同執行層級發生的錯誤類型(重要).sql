�d�� C�G�p��ѨM TRY�KCATCH�K �غc�����ۦP����h�ŵo�ͪ����~����

-- �H�U���|�^�����~�A�]�������v�|�N TRY...CATCH �غc�浹�U�@�Ӹ������h�šC
USE tempdb;
BEGIN TRY  
    -- ��ƪ��s�b�ATRY...CATCH...�����򪫥�W�ٸѪR���~
    SELECT * FROM NonexistentTable;  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO



-- SELECT ���z���Ҳ��ͪ�����W�ٸѪR���~�A�i�q�����h���^��
-- �Ҧp�b�w�s�{�Ǥ�����ۦP�� TRY...CATCH ���z���ɡA�� CATCH �϶����^��

-- -- ���ҹw�s�{�ǬO�_�s�b
USE tempdb;
IF OBJECT_ID ( N'usp_ExampleProc', N'P' ) IS NOT NULL   
    DROP PROCEDURE usp_ExampleProc;  
GO  
  
-- �إ߱N�ɭP����ѪR���~���w�s�{��
CREATE PROCEDURE usp_ExampleProc  
AS  
    SELECT * FROM NonexistentTable;  
GO  
  
BEGIN TRY  
    EXECUTE usp_ExampleProc;  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH;
GO