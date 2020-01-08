--範例 A：引發一個發生錯誤來實驗 TRY…CATCH… 建構式
BEGIN TRY
   SELECT 1/0   -- 除以零的錯誤
END TRY
BEGIN CATCH
   -- 顯示錯誤資訊
	SELECT ERROR_NUMBER() AS ErrorNumber,
	       ERROR_SEVERITY() AS ErrorSeverity, 
	       ERROR_STATE() AS ErrorState,
	       ERROR_PROCEDURE() AS ErrorProcedure,
	       ERROR_LINE() AS ErrorLine, 
	       ERROR_MESSAGE() AS ErrorMessage
END CATCH;




--範例 B：顯示包含錯誤處理函數的預存程序。在 CATCH 區塊中，會呼叫預存程序，並傳回錯誤的相關資訊。
USE tempdb;

-- 驗證預存程序是否存在
IF OBJECT_ID ( 'usp_GetErrorInfo', 'P' ) IS NOT NULL   
    DROP PROCEDURE usp_GetErrorInfo;  
GO  
  
-- 建立擷取錯誤資訊的預存程序
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
    -- 產生 1/0 錯誤
    SELECT 1/0;  
END TRY  
BEGIN CATCH  
    -- 執行擷取錯誤資訊的預存程序
    EXECUTE usp_GetErrorInfo;  
END CATCH;   