SET PAGESIZE 50000
SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 5000
SET FEEDBACK OFF
set echo off
SET VERIFY OFF
SET HEADING OFF
SET MARKUP HTML OFF SPOOL OFF
set headsep off
set wrap off
SET COLSEP ","

SPOOL activity.csv
SELECT name, value FROM v$sysstat WHERE name IN ('parse count (total)', 'execute count', 'user commits', 'user rollbacks');
SPOOL
exit
