SET PAGESIZE 50000
SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 5000
SET FEEDBACK OFF
set echo off
SET VERIFY OFF
SET MARKUP HTML OFF SPOOL OFF
set headsep off
set wrap off
SET COLSEP ","

SPOOL resource.csv
SELECT resource_name,current_utilization,CASE WHEN TRIM(limit_value) LIKE 'UNLIMITED' THEN '-1' ELSE TRIM(limit_value) END as limit_value FROM v$resource_limit;
SPOOL OFF
exit
