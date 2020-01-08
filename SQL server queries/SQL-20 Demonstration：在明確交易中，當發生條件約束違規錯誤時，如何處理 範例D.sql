�d�� D�G�b�u���T����v���A��o�ͱ�������H�W���~�ɡA�p��B�z����L�k�{�i�����A

USE TSQL2;

-- ���ҹw�s�{�ǬO�_�s�b
IF OBJECT_ID (N'usp_GetErrorInfo', N'P') IS NOT NULL  
    DROP PROCEDURE usp_GetErrorInfo;  
GO
  
-- �إ��^�����~��T���w�s�{��
CREATE PROCEDURE usp_GetErrorInfo  
AS  
    SELECT   
         ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO

SET XACT_ABORT ON;   --< �B�z���涥�q���~
BEGIN TRY  
    BEGIN TRANSACTION;
        -- �U�C�|�y����������H�W���~
		DELETE FROM Production.Products WHERE ProductID = 10;  
  
    COMMIT TRANSACTION;  
END TRY  
BEGIN CATCH  
    -- �����^�����~��T���w�s�{��
    EXECUTE usp_GetErrorInfo;  

    IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT '�ثe����b�L�k�{�i�����A�A�|�^�_�o�ӥ��'
        ROLLBACK TRANSACTION;  
    END;  
  
    IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT '�ثe����O���\�{�i�����A�A�|�{�i����üg�J��Ʈw'
        COMMIT TRANSACTION;     
    END;  
END CATCH;
SET XACT_ABORT OFF;
GO