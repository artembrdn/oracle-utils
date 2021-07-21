# Oracle - JAVA - READ DIRECTORY

📝 Procedure reads the list of files in the directory and puts it in a temporary table.
***

##### STEPS:
* Create JAVA class DirList_ext from [DirList_ext.java (Oracle < 12.1.0.2)](/utils/read_dir/DirList_ext.java).
    >     $ javac DirList_ext.java
    >     $ loadjava -user user/passwd DirList_ext.class
  OR 
    >     CREATE JAVA CLASS USING BFILE (java_dir, 'DirList_ext.class')
  OR 
    >     CREATE JAVA SOURCE NAMED "Welcome" AS
   	>     public class DirList_ext {...}
 * Create temporary table, PL/SQL procedure to bind JAVA procedure - [Initialization](/utils/read_dir/initialization.ddl). 

##### EXAMPLE:
*     CALL get_dir_list_ext('/mnt/directory');
      SELECT FD, FILENAME, FSIZE, FPATH FROM DIR_LIST_EXT;