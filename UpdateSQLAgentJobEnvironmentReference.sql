/* First we need to find the environment we are currently using and
   the environment we plan to use. Each of these correspond to 2 different
   servers. */

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
where p.name like '%origination%'
ORDER BY 
    ER.reference_id;


/* Make a note of your environments, current and target. We are looking for the reference ID that
   corresponds to the current server so we can pass this reference_id as a filter. We are going to update the
   command line in the agent job for all jobs that refer to this environment reference. */

/* Now that you know the environment you want to target, next you can run the query below and filter
   on that environment. We are just selecting first so we can see what we'll be changing, then we will
   update. */

SELECT DISTINCT
   SUBSTRING(js.command, (PATINDEX('%/ENVREFERENCE %', js.command) + 14),3) AS AgentEnvironmentRef
  ,job_id
  ,step_id
  ,command
FROM msdb..sysjobsteps js
WHERE SUBSTRING(js.command, (PATINDEX('%/ENVREFERENCE %', js.command) + 14),3) = '118' -- '8' is the environment reference_id, this is what we want to change.
order by command
/* If we want to update all job steps that reference the environment
   associated with reference_id 8, we could run the following. This will change
   all job steps that reference environment 8 to environment 5 */


--150 to 23
/*
UPDATE msdb..sysjobsteps
SET command = REPLACE(command, '/ENVREFERENCE 150', '/ENVREFERENCE 23' )
WHERE SUBSTRING(command, (PATINDEX('%/ENVREFERENCE %', command) + 14),3) = '150'
*/

/* All of this assumes you are comfortable updating the sysjobsteps table directly,
   which many of us are not and it is a practice that Mircosoft doesn't recommend.
   So here is another way we could implement this change using the msdb.dbo.sp_update_jobstep sp. */