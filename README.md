# Oracle PLSQL algorithms, useful functions and procedures

This repository contains algorithms, useful functions and procedures 
based on PLSQL and Java in Oracle Database.

## GEO

* **Functions**
  * [DISTANCE BETWEEN](geo/distance_between.ddl) - returns the ditance between two coordinates in meters, taking into account the radius of the Earth.


## STRING / CLOB

* **Functions**
  * [SPLIT](string/split_.ddl) - splits the input string (varchar2 or clob) by pattern and outputs each substring in a separate line. Optimized for CLOB type inputs.
  * [CLOB REPLACE](string/clob_replace_f.ddl) - returns new clob with every occurrence of search_string replaced with replacement_string.

* **Procedures**
  * [CLOB REPLACE](string/clob_replace.ddl) - returns new clob with every occurrence of search_string replaced with replacement_string.


## UTILS

* **JAVA**
  * [READ DIRECTORY](utils/read_dir) - reads the list of files in the directory and puts it in a temporary table.