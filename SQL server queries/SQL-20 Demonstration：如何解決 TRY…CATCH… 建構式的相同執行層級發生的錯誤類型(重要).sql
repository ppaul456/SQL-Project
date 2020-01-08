範例 C：如何解決 TRY…CATCH… 建構式的相同執行層級發生的錯誤類型

-- 以下不會擷取錯誤，因為控制權會將 TRY...CATCH 建構交給下一個較高的層級。
USE tempdb;
BEGIN TRY  
    -- 資料表不存在，TRY...CATCH...未捕獲物件名稱解析錯誤
    SELECT * FROM NonexistentTable;  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
GO



-- SELECT 陳述式所產生的物件名稱解析錯誤，可從較高層級擷取
-- 例如在預存程序內執行相同的 TRY...CATCH 陳述式時，由 CATCH 區塊來擷取

-- -- 驗證預存程序是否存在
USE tempdb;
IF OBJECT_ID ( N'usp_ExampleProc', N'P' ) IS NOT NULL   
    DROP PROCEDURE usp_ExampleProc;  
GO  
  
-- 建立將導致物件解析錯誤的預存程序
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