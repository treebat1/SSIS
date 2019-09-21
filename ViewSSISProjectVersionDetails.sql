select p.name, deployed_by_name, created_time, last_deployed_time
from ssisdb.[catalog].[projects] p
where last_deployed_time > '8/7/2018'
order by p.last_deployed_time desc

select p.name, p.version_major, version_minor, version_build, version_guid
from ssisdb.catalog.packages p
order by p.name