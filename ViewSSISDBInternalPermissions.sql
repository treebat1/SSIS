/*  Found from https://blog.dbi-services.com/delete-an-orphan-user-database-under-ssisdb/ */


use ssisdb
go

select op.*
from internal.operation_permissions op
inner join sys.database_principals p 
on op.[sid] = p.[sid]
where p.name = 'uboc-ad\svc_cl_dm'

select op.*
from internal.operation_permissions op
where op.sid = 0x0105000000000005150000002014D53B7C6F8C40FD4F0F1285970400

/*
delete 
from internal.operation_permissions
where sid = 0x0105000000000005150000002014D53B7C6F8C40FD4F0F1285970400
*/