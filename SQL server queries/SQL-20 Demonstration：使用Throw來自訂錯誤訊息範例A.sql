--�d�� A�GTHROW �޵o�ҥ~���p�A���s�Y�^�ø���� CATCH ������l���~�����~��T�C

BEGIN TRY
    -- �Y���{�׬� 16 �� THROW �N�ɭP�������� CATCH �϶�
    THROW 50000, 'Error raised in TRY block.', 1;
	SELECT * FROM sys.objects;  --< ���|����
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();

	-- �ϥ� CATCH �϶����� RAISERROR �Ǧ^�����ɭP�������� CATCH ������l���~�����~��T�C
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;