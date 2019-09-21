/*

SSIS Package Copy with DTUTIL

Run on source server where packages are stored
Set parameter @TargetServer to server name where packages are moving

Modified be Andy Galbraith @DBA_Andy from an idea at http://www.sqlservercentral.com/Forums/Topic1068518-1550-1.aspx

Tested on MSSQL 2005/2008/2008R2/2012/2014

*/


/*  
Modified by Christopher J. Riley, 8/31/2018
Changed to only copy package store packages.  Removed 2005 specific section.
Must create destination folders in advance.
Sends output to text.  Run output.
*/


SET NOCOUNT ON

DECLARE @SourceServer sysname
DECLARE @SQLVersion char(4)
DECLARE @InClause varchar(100)


SET @SQLVersion = left(cast(SERVERPROPERTY('productversion') as varchar),4)

/*PRINT @SQLVersion*/

IF LEFT(@SQLVersion,1) NOT IN ('1','9') /* Not 2005+ */
BEGIN
 PRINT 'SQL Server Version Not Supported By This Script'
END
ELSE
BEGIN
  select '"C:\Program Files\Microsoft SQL Server\100\DTS\Binn\DTUTIL.exe" /SQL "\'
  + case when f.foldername <> '' 
		then f.foldername + '\' 
		else ''
	end 
	+ name 
  +'" /SOURCESERVER "CHDC-CLS-PHSQL9\PROD" /COPY "FILE;D:\Temp\'
  + case when f.foldername <> '' 
		then f.foldername + '\' 
		else ''
 
	end 
  + name
  + '.dtsx"'
  from msdb.dbo.sysssispackages p
  inner join msdb.dbo.sysssispackagefolders f
  on p.folderid = f.folderid
  where f.FolderName not like '%Collector%'
  and f.FolderName not like '%Maintenance%'
 END