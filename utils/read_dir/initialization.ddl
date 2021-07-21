-- Create TEMPORARY table, cleaning on commit.
-- The function will write the list of files in the directory to this table.
CREATE GLOBAL TEMPORARY TABLE DIR_LIST_EXT (
  FD NUMBER 
, FILENAME VARCHAR2(255 BYTE) 
, FSIZE NUMBER 
, FPATH VARCHAR2(255 BYTE) 
) 
ON COMMIT DELETE ROWS 
NOPARALLEL;

-- Binds a PLSQL procedure to a JAVA procedure
create or replace procedure get_dir_list_ext(p_directory in varchar2)
as language java
name 'DirList_ext.getList(java.lang.String)';