# Oracle - JAVA - READ DIRECTORY

📝 Procedure reads the list of files in the directory and puts it in a temporary table.
***

##### STEPS:
* Create JAVA class DirList_ext from :
  * [DirList_ext.java (Oracle < 12.1.0.2)](/utils/read_dir/DirList_ext.java).
  * [DirListNoSQLJ.java (Oracle >= 12.1.0.2)](/utils/read_dir/DirListNoSQLJ.java).
  * [DirListStreamNoSQLJ.java (Oracle >= 12.1.0.2 and JAVA version >= 1.7)](/utils/read_dir/DirListStreamNoSQLJ.java).
    >     $ javac DirList_ext.java
    >     $ loadjava -user user/passwd DirList_ext.class
    OR 
    >     CREATE JAVA CLASS USING BFILE (java_dir, 'DirList_ext.class')
    OR 
    >     CREATE JAVA SOURCE NAMED "Welcome" AS
   	>     public class DirList_ext {class cource...}
 * Create temporary table, PL/SQL procedure to bind JAVA procedure - [Initialization](/utils/read_dir/initialization.ddl). 

##### NOTES:
* Compare JAVA functions on directory whith 100 000 files

  Function name  | Execution time | Faster by
  -------------  | -------------  | ------------
  DirList_ext    | 26 sec | 0%
  DirListNoSQLJ  | 17 sec | 35%
  DirListStreamNoSQLJ  | 10 sec |62%

##### EXAMPLE:
*     CALL get_dir_list_ext('/mnt/directory');
      --DirListStreamNoSQLJ version
      CALL get_dir_list_ext('/mnt/directory', 0); 
      CALL get_dir_list_ext('/mnt/directory', 32000);
      
      SELECT FD, FILENAME, FSIZE, FPATH FROM DIR_LIST_EXT;


