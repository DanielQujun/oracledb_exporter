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

SPOOL sessions.csv
SELECT status, type, COUNT(*) as value FROM v$session GROUP BY status, type;
SPOOL OFF
exit
