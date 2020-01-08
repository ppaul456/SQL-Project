--查詢 sys.messages 目錄檢視，以傳回 Database Engine 中具有英文文字 (1033) 之所有系統和使用者自訂錯誤訊息的清單

SELECT  
    message_id,  
    language_id,  
    severity,  
    is_event_logged,  
    text  
  FROM sys.messages  
  WHERE language_id = 1033;   --< 繁體中文為 1028