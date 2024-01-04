-- =============================================================================================================================
-- Create SQL Login template for Azure SQL Database, Azure Synapse Analytics Database, and Azure Synapse SQL Analytics on-demand
-- =============================================================================================================================

CREATE LOGIN fhir_server_1 
	 WITH PASSWORD=N'Msd9MYLi/ySaMrgIS1oTuWXC7sIP0hepEn1jmJocd8o='
GO

-- change to descired database:

CREATE USER fhir_server_1
	FOR LOGIN fhir_server_1
	WITH DEFAULT_SCHEMA = dbo
GO


EXEC sp_addrolemember N'db_owner', fhir_server_1
GO
