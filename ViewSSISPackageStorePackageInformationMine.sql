IF(OBJECT_ID('tempdb..#SSISPackagesList') IS NOT NULL)
BEGIN
    EXEC sp_executesql N'DROP TABLE #SSISPackagesList';
END;

declare @rootlabel as varchar(10);
declare @separatorchar as varchar(10);

set @rootlabel = '\'
set @separatorchar = '\'
 

CREATE TABLE #SSISPackagesList (
    PackageUniqifier        BIGINT IDENTITY(1,1) NOT NULL,
    PackageRunningId        NVARCHAR(50)   NOT NULL,
    RootFolderName          VARCHAR(256)   NOT NULL,
    ParentFolderFullPath    VARCHAR(4000)  NOT NULL,
    PackageOwner            VARCHAR(256)   NOT NULL,
    PackageName             VARCHAR(256)   NOT NULL,
    PackageDescription      VARCHAR(4000)      NULL,
    isEncrypted             BIT            NOT NULL,
    PackageFormat4Version   CHAR(4)        NOT NULL,
    PackageType             VARCHAR(128)   NOT NULL,
    CreationDate            DATETIME       NULL,
    PackageVersionMajor     TINYINT        NOT NULL,
    PackageVersionMinor     TINYINT        NOT NULL,
    PackageVersionBuild     INT            NOT NULL,
    PackageVersionComments  VARCHAR(4000)  NOT NULL,
    PackageSizeKb           BIGINT             NULL,
    PackageXmlContent       XML                NULL
);





with ChildFolders
as (
    select 
        PARENT.parentfolderid, 
        PARENT.folderid,
        PARENT.foldername,
        cast(@RootLabel as sysname) as RootFolder,
        cast(CASE 
            WHEN (LEN(PARENT.foldername) = 0) THEN @SeparatorChar 
            ELSE PARENT.foldername 
        END as varchar(max)) as FullPath,
        0 as Lvl
    from msdb.dbo.sysssispackagefolders PARENT
    where PARENT.parentfolderid is null
    UNION ALL
    select 
        CHILD.parentfolderid, CHILD.folderid, CHILD.foldername,
        case ChildFolders.Lvl
            when 0 then CHILD.foldername
            else ChildFolders.RootFolder
        end as RootFolder,
        cast(
            CASE WHEN (ChildFolders.FullPath = @SeparatorChar) THEN '' 
                ELSE ChildFolders.FullPath 
            END + @SeparatorChar + CHILD.foldername as varchar(max)
        ) as FullPath,
        ChildFolders.Lvl + 1 as Lvl
    from msdb.dbo.sysssispackagefolders CHILD
    inner join ChildFolders 
    on ChildFolders.folderid = CHILD.parentfolderid
)
INSERT INTO #SSISPackagesList (
    PackageRunningId,RootFolderName,ParentFolderFullPath,PackageOwner,
    PackageName,PackageDescription,isEncrypted,PackageFormat4Version,
    PackageType,CreationDate,PackageVersionMajor,PackageVersionMinor,
    PackageVersionBuild,PackageVersionComments,
    PackageSizeKb,PackageXmlContent
)
Select
    CONVERT(NVARCHAR(50),P.id) As PackageId,
    F.RootFolder,
    F.FullPath,
    SUSER_SNAME(ownersid) as PackageOwner,
    P.name as PackageName,
    P.[description] as PackageDescription,
    P.isencrypted as isEncrypted,
    CASE P.packageformat
        WHEN 0 THEN '2005'
        WHEN 1 THEN '2008'
        ELSE 'N/A'
    END AS PackageFormat,
    CASE P.packagetype
        WHEN 0 THEN 'Default Client'
        WHEN 1 THEN 'SQL Server Import and Export Wizard'
        WHEN 2 THEN 'DTS Designer in SQL Server 2000'
        WHEN 3 THEN 'SQL Server Replication'
        WHEN 5 THEN 'SSIS Designer'
        WHEN 6 THEN 'Maintenance Plan Designer or Wizard'
        ELSE 'Unknown'
    END as PackageType,
    P.createdate as CreationDate,
    P.vermajor,
    P.verminor,
    P.verbuild,
    P.vercomments,
    DATALENGTH(P.packagedata) /1024 AS PackageSizeKb,
    cast(cast(P.packagedata as varbinary(max)) as xml) as PackageData
from ChildFolders F
inner join msdb.dbo.sysssispackages P 
on P.folderid = F.folderid
order by F.FullPath asc, P.name asc
; 


select *
from #SSISPackagesList


CREATE TABLE #StagingPackageConnStrs (
        PackageUniqifier    BIGINT NOT NULL,
        DelayValidation     VARCHAR(100),
        ObjectName          VARCHAR(256),
        ObjectDescription   VARCHAR(4000),
        Retain              VARCHAR(100),
        ConnectionString    VARCHAR(MAX)
    );


WITH XMLNAMESPACES (
    'www.microsoft.com/SqlServer/Dts' AS pNS1, 
    'www.microsoft.com/SqlServer/Dts' AS DTS
) -- declare XML namespaces
--INSERT INTO #StagingPackageConnStrs (
    --PackageUniqifier,
    --DelayValidation,
    --ObjectName,
    --ObjectDescription,
    --Retain,
    --ConnectionString
--)   
SELECT PackageUniqifier,
SSIS_XML.value('Name="ConnectionString"[1]'
, 'varchar(MAX)') AS ConnectionString
FROM #SSISPackagesList PackageXML 
CROSS APPLY 
    PackageXMLContent.nodes (
        '/DTS:Executable/DTS:ConnectionManagers/DTS:ConnectionManager/DTS:ObjectData/DTS:ConnectionManager'
    ) AS SSIS_XML(SSIS_XML)    
;
 

--select *
--from #StagingPackageConnStrs

drop table #SSISPackagesList
drop table #StagingPackageConnStrs