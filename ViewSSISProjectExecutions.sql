--View History of SSIS Project Package Executions


select [start_time], [folder_name], [project_name], [package_name], [executed_as_name], [caller_name], [status]
from SSISDB.catalog.executions
where datediff(day, start_time, getdate()) < 365
and folder_name = 'Test'
order by start_time desc



select [folder_name], [project_name], [package_name], count(1) NumberOfExecutions
from SSISDB.catalog.executions
where datediff(day, start_time, getdate()) <= 365
group by [folder_name], [project_name], [package_name]
order by [folder_name], [project_name], [package_name]

--DataMart, PurePoint, Servicing_Datamart_Projects