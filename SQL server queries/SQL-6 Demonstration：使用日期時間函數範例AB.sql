�d�� A�G���o�ثe���t�Τ���M�ɶ�
SELECT SYSDATETIME()  
    ,SYSDATETIMEOFFSET()  
    ,SYSUTCDATETIME()  
    ,CURRENT_TIMESTAMP  
    ,GETDATE()  
    ,GETUTCDATE();
�d�� B�G ���w�A���ͤ��@�Ӥ���ɶ��ܼ� @birthdate�A�íp�Ⱶ�U�Ӫ��ͤ�Z�������٦��X�ѡH

DECLARE @birthdate DATETIME = '2000-05-04';
DECLARE @diff int = 0;

SET @birthdate = IIF(
                        @birthdate < GETDATE(), 
                        DATEADD(yy, YEAR(GETDATE()) - YEAR(@birthdate), @birthdate), 
                        @birthdate
                    );
SET @diff = DATEDIFF(dd, GETDATE(), @birthdate );

IF @diff > 0
    PRINT CONCAT( '�A�L ', @diff, ' �ѴN�O�A���ͤ�F' );
IF @diff < 0
    PRINT CONCAT( '�u�i���I�A���ͤ�w�L ', ABS(@diff), ' �ѤF :-(' );
ELSE
    PRINT '���|�a�I���ѬO�A���ͤ�A���A�ͤ�ּ�~~~';