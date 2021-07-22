create or replace directory DB_SRC as '/mnt/db_src';

create or replace type db_src_dump_list_format as object (
  FILENAME VARCHAR2(255 BYTE),
  CREATE_DATE DATE
);
create or replace TYPE db_src_dump_list_table as table of db_src_dump_list_format;

create or replace TYPE dba_src_format as object (
  OWNER VARCHAR2(128 BYTE) 
, NAME VARCHAR2(128 BYTE) 
, TYPE VARCHAR2(12 BYTE) 
, LINE NUMBER 
, TEXT VARCHAR2(4000 BYTE) 
, ORIGIN_CON_ID NUMBER 
)
create or replace TYPE dba_src_type as table of dba_src_format
