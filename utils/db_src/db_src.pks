CREATE OR REPLACE PACKAGE DB_SRC  AS 
  procedure create_dump;
  function get_dump_list return db_src_dump_list_table pipelined;
  function read_dump(date_dump in date) return dba_src_type pipelined;
  function read_dump(file_name in varchar2) return dba_src_type pipelined;
END DB_SRC; 
