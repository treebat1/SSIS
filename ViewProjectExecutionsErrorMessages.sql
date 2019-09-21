
SELECT
    O.object_name AS FailingPackageName
,   O.object_id
,   O.caller_name
,   O.server_name
,   O.operation_id
,   OM.message_time
,   EM.message_desc
,   D.message_source_desc
,   OM.message
FROM
    SSISDB.catalog.operation_messages AS OM
    INNER JOIN
        SSISDB.catalog.operations AS O
        ON O.operation_id = OM.operation_id
    INNER JOIN
    (
        VALUES
            (-1,'Unknown')
        ,   (120,'Error')
        ,   (110,'Warning')
        ,   (70,'Information')
        ,   (10,'Pre-validate')
        ,   (20,'Post-validate')
        ,   (30,'Pre-execute')
        ,   (40,'Post-execute')
        ,   (60,'Progress')
        ,   (50,'StatusChange')
        ,   (100,'QueryCancel')
        ,   (130,'TaskFailed')
        ,   (90,'Diagnostic')
        ,   (200,'Custom')
        ,   (140,'DiagnosticEx Whenever an Execute Package task executes a child package, it logs this event. The event message consists of the parameter values passed to child packages.  The value of the message column for DiagnosticEx is XML text.')
        ,   (400,'NonDiagnostic')
        ,   (80,'VariableValueChanged')
    ) EM (message_type, message_desc)
        ON EM.message_type = OM.message_type
    INNER JOIN
    (
        VALUES
            (10,'Entry APIs, such as T-SQL and CLR Stored procedures')
        ,   (20,'External process used to run package (ISServerExec.exe)')
        ,   (30,'Package-level objects')
        ,   (40,'Control Flow tasks')
        ,   (50,'Control Flow containers')
        ,   (60,'Data Flow task')
    ) D (message_source_type, message_source_desc)
        ON D.message_source_type = OM.message_source_type
WHERE
    OM.operation_id = 
    (  
        SELECT 
            MAX(OM.operation_id)
        FROM
            SSISDB.catalog.operation_messages AS OM
        WHERE
            OM.message_type = 120
    )
    AND OM.message_type IN (120, 130);