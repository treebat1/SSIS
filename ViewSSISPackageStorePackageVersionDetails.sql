select p.name, p.createdate, p.verid, p.[vermajor], p.[verminor], p.[verbuild], p.verid
from msdb.[dbo].[sysssispackages] p
order by name