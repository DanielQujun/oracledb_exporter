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

SPOOL asm_diskgroup.csv
SELECT name,total_mb*1024*1024 as total,free_mb*1024*1024 as free FROM v$asm_diskgroup_stat where exists (select 1 from v$datafile where name like '+%');
SPOOL OFF
exit
