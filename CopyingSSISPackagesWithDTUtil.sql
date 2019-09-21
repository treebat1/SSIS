/*

SSIS Package Copy with DTUTIL

Run on source server where packages are stored
Set parameter @TargetServer to server name where packages are moving

Modified be Andy Galbraith @DBA_Andy from an idea at http://www.sqlservercentral.com/Forums/Topic1068518-1550-1.aspx

Tested on MSSQL 2005/2008/2008R2/2012/2014

*/


/*  

Modified by Christopher J. Riley

Only copies package store packages for SQL Server version 2008+.  Must create destination folders in advance.

Sends output to text.  Run output.

*/


SET NOCOUNT ON

DECLARE @TargetServer sysname,  @SQLVersion char(4)

SET @TargetServer = 'CHDC-CAR-THSQL2\DATAMARTDEV' 

SET @SQLVersion = left(cast(SERVERPROPERTY('productversion') as varchar),4)

/* PRINT @SQLVersion */

IF LEFT(@SQLVersion,1) NOT IN ('1','9') /* Not 2005+ */
BEGIN
 PRINT 'SQL Server Version Not Supported By This Script'
END
ELSE
BEGIN
 IF @SQLVersion = '9.00' /* 2005 */
 BEGIN
  select 'DTUTIL /SQL "'+f.foldername+'\'+ name 
  +'" /DestServer "'+@TargetServer+'" /COPY SQL;"'+f.foldername+'\'+name+'" /QUIET' 
  from msdb.dbo.sysdtspackages90 p
  inner join msdb.dbo.sysdtspackagefolders90 f
  on p.folderid = f.folderid
 END
 ELSE /* 2008+ */
 BEGIN
  select 'DTUTIL /DTS "\MSDB\'
  + case when f.foldername <> '' 
		then f.foldername + '\' 
		else ''
	end 
	+ name 
  +'" /DestServer "'
  +@TargetServer
  +'" /COPY "SQL;'
  + case when f.foldername <> '' 
		then f.foldername + '\' 
		else ''
	end 
  + name
  +'" /QUIET' 
  from msdb.dbo.sysssispackages p
  inner join msdb.dbo.sysssispackagefolders f
  on p.folderid = f.folderid
 END
END