Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'process_CreditBureau_Metro2_MSP_data.dtsx'
, @execution_id=@execution_id OUTPUT, @folder_name=N'CreditCard', @project_name=N'CreditCard_SSIS', @use32bitruntime=False
, @reference_id=14
Select @execution_id
DECLARE @var0 smallint = 3
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL'
, @parameter_value=@var0
EXEC [SSISDB].[catalog].[start_execution] @execution_id
GO

