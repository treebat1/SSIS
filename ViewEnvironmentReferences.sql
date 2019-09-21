SELECT
    ER.reference_id AS ReferenceId
,   E.name AS EnvironmentName
,   F.name AS FolderName
,   P.name AS ProjectName
FROM
    SSISDB.catalog.environments AS E
    INNER JOIN
        SSISDB.catalog.folders AS F
        ON F.folder_id = E.folder_id
    INNER JOIN 
        SSISDB.catalog.projects AS P
        ON P.folder_id = F.folder_id
    INNER JOIN
        SSISDB.catalog.environment_references AS ER
        ON ER.project_id = P.project_id
where p.name like '%servicing%'
ORDER BY 
    ER.reference_id;




select *
FROM [SSISDB].[catalog].[environment_references] 
where reference_id = 118


select *
from ssisdb.[catalog].[environments]
where folder_id = 22

select *
from ssisdb.[catalog].[folders]
where folder_id = 22

SELECT *
FROM ssisdb.[catalog].[projects]
where project_id = 26
GO

