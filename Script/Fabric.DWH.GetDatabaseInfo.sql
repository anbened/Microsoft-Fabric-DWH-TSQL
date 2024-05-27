
/*
Author: Andrea Benedetti

Date: 2024.05.27
Name: Fabric.DWH.GetDatabaseInfo.sql

Description: This script retrieves various properties and information about the current Microsoft Fabric database. 
It gathers details such as version, server name, current session ID, database name, edition, version, collation, 
updateability, database status, recovery model, user access, and various database options.

Purpose: To provide an overview of database properties and settings for the current Microsoft Fabric database.

Notes: 
- Adjust the database context if necessary before running this script.
- Some properties may not be applicable to all databases or may return 'Input not valid' for certain configurations.
*/

SELECT
	@@VERSION as FabricVersion,
    @@SERVERNAME AS ServerName,
	@@SPID AS CurrentSPID,
    DB_NAME() AS DatabaseName,
	DATABASEPROPERTYEX(DB_NAME(), 'Edition') AS Edition,
	DATABASEPROPERTYEX(DB_NAME(), 'Version') AS Version,
	/*
	Currently, Latin1_General_100_BIN2_UTF8 is the default and only supported collation for both tables and metadata.

	UTF8 ensures that utf8 characters are properly interpreted as varchar columns
	BIN2 collation is compatible with parquet string sorting rules so we are able 
	 to eliminate some parts of parquet files that will not contain data needed in the queries (file/column-segment pruning)
	*/
	DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS Collation, 
	DATABASEPROPERTYEX(DB_NAME(), 'Updateability') AS Updateability,
	DATABASEPROPERTYEX(DB_NAME(), 'Status') AS DBStatus,
    DATABASEPROPERTYEX(DB_NAME(), 'Status') AS Status,    
    DATABASEPROPERTYEX(DB_NAME(), 'Recovery') AS RecoveryModel,
    DATABASEPROPERTYEX(DB_NAME(), 'UserAccess') AS UserAccess,
    CASE DATABASEPROPERTYEX(DB_NAME(), 'IsAutoClose') WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' ELSE 'Input not valid' END AS IsAutoClose ,
    CASE DATABASEPROPERTYEX(DB_NAME(), 'IsAutoShrink') WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' ELSE 'Input not valid' END  AS IsAutoShrink,
    CASE DATABASEPROPERTYEX(DB_NAME(), 'IsFulltextEnabled') WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' ELSE 'Input not valid' END  AS IsFulltextEnabled,
    CASE DATABASEPROPERTYEX(DB_NAME(), 'IsInStandBy') WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' ELSE 'Input not valid' END  AS IsInStandBy,
    DATABASEPROPERTYEX(DB_NAME(), 'LastGoodCheckDbTime') AS LastGoodCheckDbTime
	

