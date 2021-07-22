CREATE OR REPLACE PACKAGE BODY DB_SRC AS
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE create_dump is
    res clob;
    res_pre varchar2(6000);
    fpath varchar2(4000);
    i number;
    sel varchar2(32000);
  BEGIN
    
    select count(1) into i from user_tables t where t.table_name = 'EXT_DB_SRC_DUMP';
    if i != 0 then
      execute immediate 'drop table EXT_DB_SRC_DUMP';
    end if;
    fpath := 'db_src_'||to_char(sysdate,'yyyymmdd_hh24miss')||'.dmp';
    
    sel := 'CREATE TABLE EXT_DB_SRC_DUMP 
       organization external (
      type oracle_datapump
      default directory db_src
      access parameters (nologfile version ''11.1'')
      location('''||fpath||''')
       ) as select owner,name,type,line,text,origin_con_id from dba_source';
    execute immediate sel;
     
  END create_dump;
----------------------------------------------------------------------------------------------------------------------------------------------------------------  
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  FUNCTION get_dump_list return db_src_dump_list_table pipelined is
  
    procedure create_list is
      PRAGMA AUTONOMOUS_TRANSACTION;
    begin
      get_dir_list_ext('/mnt/db_src');
      commit; 
    end;
    procedure truncate_list is
      PRAGMA AUTONOMOUS_TRANSACTION;
    begin
      execute immediate 'truncate table DIR_LIST_EXT';
      commit; 
    end;
    
  BEGIN
    
    create_list();
    
    for l_row in ( select * from DIR_LIST_EXT ) loop
        pipe row(  db_src_dump_list_format( l_row.FILENAME , to_date( substr( l_row.FILENAME , 11, 15 ), 'yyyymmdd_hh24miss' ) )  );
    end loop;
    
    truncate_list();
  END;
----------------------------------------------------------------------------------------------------------------------------------------------------------------  
  FUNCTION read_dump(date_dump in date) return dba_src_type pipelined is
    l_file_name varchar2(255);
    res dba_src_format;
    cv SYS_REFCURSOR;
  BEGIN
    
    select filename into l_file_name  from( select * from table(get_dump_list) t where t.create_date < read_dump.date_dump order by t.create_date desc ) where rownum=1;
     
    OPEN cv FOR
      'select dba_src_format(owner,name,type,line,text,origin_con_id)  from table(db_src.read_dump('''||l_file_name||'''))' ;
    LOOP
      FETCH cv INTO res;
      EXIT WHEN cv%NOTFOUND;
      pipe row(res);
    END LOOP;
    CLOSE cv; 
      
  EXCEPTION WHEN no_data_found THEN
    return;
  END;
  
  
----------------------------------------------------------------------------------------------------------------------------------------------------------------  
  FUNCTION read_dump(file_name in varchar2) return dba_src_type pipelined is
    i number;
    res dba_src_format;
    sel varchar2(32000);
    cv SYS_REFCURSOR;

    procedure open_dump_ext is
      PRAGMA AUTONOMOUS_TRANSACTION;
    begin
      select count(1) into i from user_tables t where t.table_name = 'EXT_DB_SRC_DUMP_OPEN';
      if i != 0 then
        execute immediate 'drop table EXT_DB_SRC_DUMP_OPEN';
      end if;
      sel := 'CREATE TABLE EXT_DB_SRC_DUMP_OPEN 
        (
            OWNER VARCHAR2(128 BYTE) 
          , NAME VARCHAR2(128 BYTE) 
          , TYPE VARCHAR2(12 BYTE) 
          , LINE NUMBER 
          , TEXT VARCHAR2(4000 BYTE) 
          , ORIGIN_CON_ID NUMBER 
        ) organization external(
          type oracle_datapump
          default directory db_src
          access parameters (nologfile)
          location('''||file_name||''')
        )';
      execute immediate sel;
    end;
  BEGIN
    open_dump_ext();
    
    OPEN cv FOR
      'select dba_src_format(owner,name,type,line,text,origin_con_id) from EXT_DB_SRC_DUMP_OPEN' ;
    LOOP
      FETCH cv INTO res;
      EXIT WHEN cv%NOTFOUND;
      pipe row(res);
    END LOOP;
    CLOSE cv;
  END;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
END DB_SRC;
