
/*
Author: Andrea Benedetti

Date: 2024.05.27
Name: Fabric.DWH.BenchmarkSQLExecutionTime.sql

Description: This script measures the execution time of a specific SQL statement. 
It captures the start and end timestamps, calculates the duration in seconds 
(including nanoseconds for high precision), and prints the start time, end time, 
and duration in a human-readable format.

Purpose: To benchmark the performance of SQL operations and understand how long 
they take to execute.

Example Result:
Start Time: 2024-05-25T15:45:32.1234567
End Time: 2024-05-25T15:45:32.2234567
Duration: 0 hours, 0 minutes, 0.1000000 seconds

Notes: 
- Ensure that SYSDATETIME() is used to capture the precise datetime with 
  nanosecond accuracy.
- Adjust the SQL operation between the START STATEMENT and END STATEMENT 
  comments as needed for your use case.
*/

SET NOCOUNT ON

-- Declare variables to store the start and end date and time
DECLARE @DateTimeStart DATETIME2;
DECLARE @DateTimeEnd DATETIME2;

-- Declare variables to store the formatted start and end time
DECLARE @StartTime VARCHAR(30);
DECLARE @EndTime VARCHAR(30);

-- Declare a variable to store the duration in seconds
DECLARE @DurationSeconds DECIMAL(18,7);

-- Get the current date and time and assign it to @DateTimeStart
SET @DateTimeStart = SYSDATETIME();

-- Format the start time as a string in the ISO 8601 format
-- and store it in @StartTime
SET @StartTime = CONVERT(VARCHAR(30), @DateTimeStart, 126) + '.' + 
    RIGHT(CONVERT(VARCHAR(30), @DateTimeStart, 121), 7);

-- Print the start time
PRINT 'Start Time: ' + @StartTime;
PRINT ''

/* *** *** *** */
/* *** START STATEMENT *** */

-- Create a new table called myTableCETAS and populate it
-- with the selected columns from myTable
CREATE TABLE my_CETAS_Table AS
SELECT 
    col1, col2, col3 
FROM 
    myTable ;

/* *** END STATEMENT *** */
/* *** *** *** */

-- Get the current date and time and assign it to @DateTimeEnd
SET @DateTimeEnd = SYSDATETIME();

-- Format the end time as a string in the ISO 8601 format
-- and store it in @EndTime
SET @EndTime = CONVERT(VARCHAR(30), @DateTimeEnd, 126) + '.' + 
    RIGHT(CONVERT(VARCHAR(30), @DateTimeEnd, 121), 7);

-- Print the end time
PRINT 'End Time: ' + @EndTime;

-- Calculate the duration in seconds by subtracting the start time
-- from the end time and converting the result to decimal
SET @DurationSeconds = DATEDIFF_BIG(SECOND, @DateTimeStart, @DateTimeEnd) 
    + (CAST(DATEPART(NANOSECOND, @DateTimeEnd) AS DECIMAL(18,7)) - 
    CAST(DATEPART(NANOSECOND, @DateTimeStart) AS DECIMAL(18,7))) / 1000000000.0;

-- Print the duration in hours, minutes, and seconds
PRINT 'Duration: ' 
    + CAST(FLOOR(@DurationSeconds / 3600) AS VARCHAR(10)) + ' hours, '
    + CAST(FLOOR((@DurationSeconds % 3600) / 60) AS VARCHAR(10)) + ' minutes, '
    + CAST(@DurationSeconds % 60 AS VARCHAR(20)) + ' seconds';
