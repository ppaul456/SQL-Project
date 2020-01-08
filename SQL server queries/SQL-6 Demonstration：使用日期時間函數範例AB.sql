範例 A：取得目前的系統日期和時間
SELECT SYSDATETIME()  
    ,SYSDATETIMEOFFSET()  
    ,SYSUTCDATETIME()  
    ,CURRENT_TIMESTAMP  
    ,GETDATE()  
    ,GETUTCDATE();
範例 B： 指定你的生日到一個日期時間變數 @birthdate，並計算接下來的生日距離今天還有幾天？

DECLARE @birthdate DATETIME = '2000-05-04';
DECLARE @diff int = 0;

SET @birthdate = IIF(
                        @birthdate < GETDATE(), 
                        DATEADD(yy, YEAR(GETDATE()) - YEAR(@birthdate), @birthdate), 
                        @birthdate
                    );
SET @diff = DATEDIFF(dd, GETDATE(), @birthdate );

IF @diff > 0
    PRINT CONCAT( '再過 ', @diff, ' 天就是你的生日了' );
IF @diff < 0
    PRINT CONCAT( '真可惜！你的生日已過 ', ABS(@diff), ' 天了 :-(' );
ELSE
    PRINT '不會吧！今天是你的生日，祝你生日快樂~~~';