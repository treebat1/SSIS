use ssisdb
go


select property_name, property_value
from catalog.catalog_properties


exec catalog.configure_catalog 
@property_name = 'RETENTION_WINDOW'
, @property_value = 150


EXEC [SSISDB].[catalog].[configure_catalog] 
@property_name=N'SERVER_LOGGING_LEVEL'
, @property_value=3  --Verbose


EXEC [SSISDB].[catalog].[configure_catalog] 
@property_name=N'SERVER_LOGGING_LEVEL'
, @property_value=1  --Basic