--View Jobs Using SSIS

select s.name, js.step_name, js.command, js.last_run_date
from msdb.dbo.sysjobsteps js
join msdb.dbo.sysjobs s on js.job_id = s.job_id
where subsystem = 'SSIS'
order by s.name, js.step_name