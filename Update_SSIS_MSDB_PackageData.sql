use msdb
go

declare 
	@servername varchar(50)
	,@oldname	varchar(50)
	,@newname	varchar(50)

set @servername = @@servername

--select @servername

select 
	@oldname = case 
						when @servername like '%Dev%' then 'CHDC-CAR-THSQL1'
						when @servername like '%Test%' then 'CHDC-CAR-THSQL1'
						when @servername like '%Prod%' then 'CHDC-CAR-PHSQL1'
						end
	,@newname = case
						when @servername like '%Dev%' then 'CAR-DMSQL-DEV'
						when @servername like '%Test%' then 'CAR-DMSQL-TST'
						when @servername like '%Prod%' then 'CAR-DMSQL-PRD'
						end

--select @servername, @oldname, @newname

--select packagedata,
update s
set
	packagedata = CONVERT(IMAGE, CONVERT(VARBINARY(MAX), REPLACE(CONVERT(VARCHAR(MAX), CONVERT(VARBINARY(MAX), s.packagedata)), @oldname, @newname)))
from
	msdb.dbo.sysssispackages s
  join msdb.dbo.sysssispackagefolders f
	on s.folderid = f.folderid
	where f.parentfolderid is null