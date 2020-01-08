--範例 A：THROW 引發例外狀況，重新擲回並跳轉到 CATCH 塊的原始錯誤之錯誤資訊。

BEGIN TRY
    -- 嚴重程度為 16 的 THROW 將導致執行跳轉到 CATCH 區塊
    THROW 50000, 'Error raised in TRY block.', 1;
	SELECT * FROM sys.objects;  --< 不會執行
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();

	-- 使用 CATCH 區塊中的 RAISERROR 傳回有關導致執行跳轉到 CATCH 塊的原始錯誤之錯誤資訊。
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;