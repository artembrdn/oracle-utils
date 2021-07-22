# Oracle - Backup DBA_SOURCE and read from backup on the required date.

📝 A simple backup of dba_source to the dump files and a simple reading of these files on the required date, similar to using Oracle Flashback Technology (' select * from dba_source as of timestamp to_timestamp('200505 0900','rrmmdd hh24mi')').
***

##### STEPS:
 * Create DIRECTORY and TYPES - [Initialization](/utils/db_src/initialization.ddl). 
 * Create package DB_SRC.
    * [source](db_src.pks)
    * [body](db_src.pkb)

##### EXAMPLE:
* create backup as dumpfile in DIRECTORY
    >     CALL db_src.create_dump();
* list of all backup dumpfiles
    >     select * from table(db_src.get_dump_list())
* reading dba_source from backup on the required date
    >     select * from table(db_src.read_dump(SYSDATE-20))
* reading dba_source from a specific backup file
    >     select * from table(db_src.read_dump('db_src_20200505_101000.dmp'))