-- returns 1 if the string consists of only digits, 0 if string is null or string length = 0
create or replace function is_number(a_string in varchar2) RETURN number DETERMINISTIC IS
    k simple_integer :=1;
    str_size pls_integer;
    step_offset simple_integer:=1;
    char_ number;
    PRAGMA UDF;
BEGIN
    str_size := length(a_string);  
    IF(str_size>0) then
        loop
            char_ := ascii( substr( a_string, k, 1 ) );
        
            if(char_ >= 48 and char_ <= 57) then --ASCII NUMBER CHAR CODE
                k := k + step_offset;
            else
                return 0;
            end if;
            exit when k > str_size;
        end loop;          
        return 1;
    else
        return 0;
    end if;
END is_number; 
