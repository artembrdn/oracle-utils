# Oracle PLSQL algorithms, useful functions and procedures

This repository contains algorithms, useful functions and procedures 
based on PLSQL and Java in Oracle Database.

## GEO

* **Functions**
  * [Distance Between](geo/distance_between.ddl) - returns the ditance between two coordinates in meters, taking into account the radius of the Earth.


## STRING / CLOB

* **Functions**
  * [SPLIT](string/split_.ddl) - splits the input string (varchar2 or clob) by pattern and outputs each substring in a separate line. Optimized for CLOB type inputs.