
/*
Author: Andrea Benedetti

Date: 2024.05.27
Name: Fabric.DWH.MonitorActiveSessions.sql

Description: This script retrieves information about active sessions and requests from the Microsoft Fabric data warehouse. 
It provides details such as login name, host name, program name, start time (in UTC), command, database name, 
user name, wait type, wait time, reads, writes, logical reads, transaction isolation level, row count, and granted query memory.

Purpose: To monitor and analyze active sessions and requests within the Microsoft Fabric data warehouse.

Notes: 
- Adjust the database context if necessary before running this script.
- Some columns may return 'Unknown' or 'NULL' values based on the current state of the system.
- ORDER BY ER.total_elapsed_time DESC

[!!!] PERMISSIONS [!!!]
1. An Admin has permissions to execute all DMVs (sys.dm_exec_sessions, sys.dm_exec_requests) to see their own and others' information within a workspace
2. A Member, Contributor, and Viewer can execute sys.dm_exec_sessions and sys.dm_exec_requests and see their own results within the warehouse
*/

SELECT 
	ES.login_name,
    ES.host_name,
    ES.program_name,
	ER.start_time as start_time_UTC, 
	ER.command,
	db_name(ER.database_id) as databaseName,
	user_name(user_id) as userName,
	ER.wait_type,
	ER.wait_time,
	ER.reads,
	ER.writes,
	ER.logical_reads,
	CASE ER.transaction_isolation_level
        WHEN 0 THEN 'Unspecified'
        WHEN 1 THEN 'ReadUncomitted'
        WHEN 2 THEN 'ReadCommitted'
        WHEN 3 THEN 'Repeatable'
        WHEN 4 THEN 'Serializable'
        WHEN 5 THEN 'Snapshot'
        ELSE 'Unknown'
    END AS transaction_isolation_level,
	ER.row_count, 
	ER.granted_query_memory
FROM sys.dm_exec_requests ER
JOIN sys.dm_exec_sessions ES on ER.session_id = ES.session_id
WHERE ER.status = 'running'
ORDER BY ER.total_elapsed_time DESC;

