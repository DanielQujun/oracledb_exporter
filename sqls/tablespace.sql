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


SPOOL tablespace.csv
SELECT
    df.tablespace_name       as tablespace,
    df.type                  as type,
    nvl(sum(df.bytes),0)     as bytes,
    nvl(sum(df.max_bytes),0) as max_bytes,
    nvl(sum(f.free),0)       as free
FROM
    (
        SELECT
            ddf.file_id,
            dt.contents as type,
            ddf.file_name,
            ddf.tablespace_name,
            TRUNC(ddf.bytes) as bytes,
            TRUNC(GREATEST(ddf.bytes,ddf.maxbytes)) as max_bytes
        FROM
            dba_data_files ddf,
            dba_tablespaces dt
        WHERE ddf.tablespace_name = dt.tablespace_name
    ) df,
    (
        SELECT
            TRUNC(SUM(bytes)) AS free,
            file_id
        FROM dba_free_space
        GROUP BY file_id
    ) f
WHERE df.file_id = f.file_id (+)
GROUP BY df.tablespace_name, df.type
UNION ALL
SELECT
    Y.name                   as tablespace_name,
    Y.type                   as type,
    SUM(Y.bytes)             as bytes,
    SUM(Y.max_bytes)         as max_bytes,
    MAX(nvl(Y.free_bytes,0)) as free
FROM
    (
        SELECT
            dtf.tablespace_name as name,
            dt.contents as type,
            dtf.status as status,
            dtf.bytes as bytes,
            (
                SELECT
                    ((f.total_blocks - s.tot_used_blocks)*vp.value)
                FROM
                    (SELECT tablespace_name, sum(used_blocks) tot_used_blocks FROM gv$sort_segment WHERE  tablespace_name!='DUMMY' GROUP BY tablespace_name) s,
                    (SELECT tablespace_name, sum(blocks) total_blocks FROM dba_temp_files where tablespace_name !='DUMMY' GROUP BY tablespace_name) f,
                    (SELECT value FROM v$parameter WHERE name = 'db_block_size') vp
                WHERE f.tablespace_name=s.tablespace_name AND f.tablespace_name = dtf.tablespace_name
            ) as free_bytes,
            CASE
                WHEN dtf.maxbytes = 0 THEN dtf.bytes
                ELSE dtf.maxbytes
                END as max_bytes
        FROM
            sys.dba_temp_files dtf,
            sys.dba_tablespaces dt
        WHERE dtf.tablespace_name = dt.tablespace_name
    ) Y
GROUP BY Y.name, Y.type
ORDER BY tablespace;
SPOOL OFF
EXIT