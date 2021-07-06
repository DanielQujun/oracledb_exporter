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


SPOOL wait_time.csv
SELECT
  n.wait_class as WAIT_CLASS,
  round(m.time_waited/m.INTSIZE_CSEC,3) as VALUE
FROM
  v$waitclassmetric  m, v$system_wait_class n
WHERE
  m.wait_class_id=n.wait_class_id AND n.wait_class != 'Idle';

SPOOL OFF
exit
