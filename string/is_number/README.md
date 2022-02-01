# Oracle - IS NUMBER FUNCTION

📝 The function takes a string and returns 1 or 0 depending on whether the number is there or not.
 
***

##### There are several ways to write this function. Below is their comparison and code
##### OPTIONS:
* Using  to_number function whith exception :
  * [is_number.sql(to_number)](/string/is_number/is_number_to_number.ddl)
    >     begin
    >       v_new_num := TO_NUMBER(a_string);
    >       return 1;
    >     exception
    >       when VALUE_ERROR then
    >       return 0;
    >     end;
* Using  asci code of characters :
  * [is_number.sql(asci code)](/string/is_number/is_number_asci.ddl)
    >     loop
    >       char_ := ascii( substr( a_string, k, 1 ) );
    >       if(char_ >= 48 and char_ <= 57) then --ASCII NUMBER CHAR CODE
    >           k := k + step_offset;
    >       else
    >           return 0;
    >       end if;
    >     end loop;
* Using  regexp_like :
  * [is_number.sql(regexp_like)](/string/is_number/is_number_regexp_like.ddl)
    >     return case when regexp_like(a_string, '^[[:digit:]]+$') then 1 else 0 end;
* Using  translate :
  * [is_number.sql(translate)](/string/is_number/is_number_translate.ddl)
    >     return  case when TRANSLATE(a_string,'X0123456789','X') is null then 1 else 0 end;

##### COMPARE:
* Compare features in a 300,000 row table with different datasets 
     >     create table number_check (col1 varchar2(200))
    Two select statements to compare execution time:
     >     select sum(ccc) from( select col1, is_number(col1) ccc from number_check );
     >     select sum(ccc) from( select /*+ parallel(4)*/col1, is_number(col1) ccc from number_check );
    Dataset creation template :
     >     insert into number_check select CONSTANT_VALUE||level from dual connect by level <= 300000;
  * **CONSTANT_VALUE := 'Q124214Q2145'**
    
      Function name  | Execution time  | Execution time parallel 4
      -------------  | -------------   | -----------------------
      is_number(to_number)    | 2.2 sec  | 2.4 sec
      is_number(asci)  | 0.3 sec  | 0.1 sec
      is_number(regexp_like)  | 1.2 sec  | 0.35 sec
      is_number(translate)  | 1.5 sec | 0.5 sec
  * **CONSTANT_VALUE := '124214Q2145'**

      Function name  | Execution time | Execution time parallel 4
      -------------  | -------------  | ------------
      is_number(to_number)    | 2.2 sec | 2.4 sec
      is_number(asci)  | 1.4 sec | 0.5 sec
      is_number(regexp_like)  | 1.8 sec | 0.55 sec
      is_number(translate)  | 1.6 sec | 0.45 sec
      
  * **CONSTANT_VALUE := '1242142145'**

      Function name  | Execution time  | Execution time parallel 4
      -------------  | -------------   | -----------------------
      is_number(to_number)    | 0.2 sec  | 0.07 sec
      is_number(asci)  | 2.9 sec  | 0.8 sec
      is_number(regexp_like)  | 1.9 sec | 0.55 sec
      is_number(translate)  | 1.5 sec | 0.45 sec
      
  * Mixed dataset
  **CONSTANT_VALUE := '1242142145'** 200,000 rows
  **CONSTANT_VALUE := '124214Q2145'** 50,000 rows
  **CONSTANT_VALUE := 'Q124214Q2145'** 50,000 rows

      Function name  | Execution time  | Execution time parallel 4
      -------------  | -------------   | -----------------------
      is_number(to_number)    | 0.85 sec  | 1.2 sec
      is_number(asci)  | 2.4 sec  | 0.65 sec
      is_number(regexp_like)  | 1.8 sec | 0.55 sec
      is_number(translate)  | 1.5 sec | 0.45 sec
##### CONCLUSION:     

>    If the function will be used from **PLSQL or SQL (without parallelism)**,then the [is_number.sql(to_number)](/string/is_number/is_number_to_number.ddl)
option should be unambiguously chosen if the number is expected to be valid in most cases.

> If you plan to call from **SQL with parallelism** 🚀, then the best option for the [is_number.sql(translate)](/string/is_number/is_number_translate.ddl) function.

> ❗ However, remember that when calling functions from SQL, a context switch occurs 
and the fastest way to select rows with a check for a number is to use translate directly in the SQL statement (0.07 sec vs 0.45 sec). 
    
>     select /*+ parallel(n)*/ col1, DECODE(TRANSLATE(col1,'X0123456789','X'), NULL,1,0) ccc from number_check
