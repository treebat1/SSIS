select f.name, e.name, ev.name, ev.value
FROM [SSISDB].[catalog].[folders] f        
INNER JOIN [SSISDB].[catalog].[environments] e ON f.folder_id =  e.folder_id        
INNER JOIN [SSISDB].[catalog].[environment_variables] ev ON e.environment_id = ev.environment_id     