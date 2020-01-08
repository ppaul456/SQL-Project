--�d�� A�G�޵o�@�ӵo�Ϳ��~�ӹ��� TRY�KCATCH�K �غc��
BEGIN TRY
   SELECT 1/0   -- ���H�s�����~
END TRY
BEGIN CATCH
   -- ��ܿ��~��T
	SELECT ERROR_NUMBER() AS ErrorNumber,
	       ERROR_SEVERITY() AS ErrorSeverity, 
	       ERROR_STATE() AS ErrorState,
	       ERROR_PROCEDURE() AS ErrorProcedure,
	       ERROR_LINE() AS ErrorLine, 
	       ERROR_MESSAGE() AS ErrorMessage
END CATCH;




--�d�� B�G��ܥ]�t���~�B�z��ƪ��w�s�{�ǡC�b CATCH �϶����A�|�I�s�w�s�{�ǡA�öǦ^���~��������T�C
USE tempdb;

-- ���ҹw�s�{�ǬO�_�s�b
IF OBJECT_ID ( 'usp_GetErrorInfo', 'P' ) IS NOT NULL   
    DROP PROCEDURE usp_GetErrorInfo;  
GO  
  
-- �إ��^�����~��T���w�s�{��
CREATE PROCEDURE usp_GetErrorInfo  
AS  
SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  
GO  
  
BEGIN TRY  
    -- ���� 1/0 ���~
    SELECT 1/0;  
END TRY  
BEGIN CATCH  
    -- �����^�����~��T���w�s�{��
    EXECUTE usp_GetErrorInfo;  
END CATCH;   