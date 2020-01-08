範例 D：在「明確交易」中，當發生條件約束違規錯誤時，如何處理交易無法認可的狀態

USE TSQL2;

-- 驗證預存程序是否存在
IF OBJECT_ID (N'usp_GetErrorInfo', N'P') IS NOT NULL  
    DROP PROCEDURE usp_GetErrorInfo;  
GO
  
-- 建立擷取錯誤資訊的預存程序
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

SET XACT_ABORT ON;   --< 處理執行階段錯誤
BEGIN TRY  
    BEGIN TRANSACTION;
        -- 下列會造成條件約束違規錯誤
		DELETE FROM Production.Products WHERE ProductID = 10;  
  
    COMMIT TRANSACTION;  
END TRY  
BEGIN CATCH  
    -- 執行擷取錯誤資訊的預存程序
    EXECUTE usp_GetErrorInfo;  

    IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT '目前交易在無法認可的狀態，會回復這個交易'
        ROLLBACK TRANSACTION;  
    END;  
  
    IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT '目前交易是允許認可的狀態，會認可交易並寫入資料庫'
        COMMIT TRANSACTION;     
    END;  
END CATCH;
SET XACT_ABORT OFF;
GO