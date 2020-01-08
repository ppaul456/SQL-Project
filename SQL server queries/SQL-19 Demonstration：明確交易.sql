--基本語法


-- 起始交易
BEGIN { TRAN | TRANSACTION }   
      [ 
          { transaction_name | @tran_name_variable }  
          [ WITH MARK [ '文字描述' ] ]  
      ]  
[ ; ]


-- 提交交易
COMMIT [ 
         { TRAN | TRANSACTION }  
         [ transaction_name | @tran_name_variable ] 
       ]
[ ; ]


-- 回復交易
ROLLBACK [
            { TRAN | TRANSACTION }
            [ transaction_name | @tran_name_variable | savepoint_name | @savepoint_variable ]
         ]
[ ; ]  