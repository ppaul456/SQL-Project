--�򥻻y�k


-- �_�l���
BEGIN { TRAN | TRANSACTION }   
      [ 
          { transaction_name | @tran_name_variable }  
          [ WITH MARK [ '��r�y�z' ] ]  
      ]  
[ ; ]


-- ������
COMMIT [ 
         { TRAN | TRANSACTION }  
         [ transaction_name | @tran_name_variable ] 
       ]
[ ; ]


-- �^�_���
ROLLBACK [
            { TRAN | TRANSACTION }
            [ transaction_name | @tran_name_variable | savepoint_name | @savepoint_variable ]
         ]
[ ; ]  