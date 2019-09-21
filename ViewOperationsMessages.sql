/****** Script for SelectTopNRows command from SSMS  ******/
use ssisdb
go

SELECT *
FROM [catalog].[operations] 
where operation_id = 57742
order by end_time desc


SELECT *
FROM internal.[operation_messages]
where message_time >= '2019-07-05 17:00:00'
--operation_id = 57736
order by message_time desc

select top 100 *
from internal.operations
order by created_time desc

select * 
from internal.packages a 
inner join internal.projects b 
on a.project_id = b.project_id
order by last_deployed_time desc







select *
from [internal].[operation_permissions]

select *
from [internal].[operation_os_sys_info]
order by operation_id desc

SELECT TOP (1000) [operation_message_id]
      ,[operation_id]
      ,[message_time]
      ,[message_type]
      ,[message_source_type]
      ,[message]
      ,[extended_info_id]
--select *
FROM [SSISDB].[catalog].[operation_messages]
where operation_id = 72039
  --order by message_time desc
  order by operation_id desc