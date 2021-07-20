-- Returns new clob with every occurrence of search_string replaced with replacement_string. 
-- If replacement_string is omitted or null, then all occurrences of search_string are removed. 
-- If search_string is null, then copy of the clob is returned.
CREATE OR REPLACE  function clob_replace_func (source in clob, search_string in varchar2, replacement_string in clob default  EMPTY_CLOB()) return clob  IS
    clob_out clob;
    i_c pls_integer:=1;
    source_length pls_integer:=1;

    finded_pos pls_integer;
    current_pos pls_integer;
    dest_pos pls_integer;
    search_string_length pls_integer := nvl(length(search_string), 0);
    replacement_string_length pls_integer := nvl(length(replacement_string), 0);

    type number_arr_class is table of pls_integer;
    find_res number_arr_class;
    
    function find_all return number_arr_class is
        l_pos pls_integer := 1;
        number_arr number_arr_class := number_arr_class();
    begin
        if (search_string_length = 0) then
            return number_arr;
        end if;
        loop
            l_pos := dbms_lob.instr(source, search_string, l_pos);  
            exit when l_pos = 0;
            number_arr.extend;
            number_arr(number_arr.count) := l_pos;
            l_pos := l_pos + search_string_length;
        end loop;

        return number_arr;
    end;
    
BEGIN
    find_res := find_all();
    dbms_lob.createtemporary(clob_out, true);
    dest_pos := 1;
    current_pos := 1;
    
    IF (find_res.count > 0) THEN
        FOR i IN find_res.first .. find_res.last LOOP
            finded_pos := find_res(i);

            IF(current_pos = finded_pos) THEN
                IF (replacement_string_length != 0) THEN
                    dbms_lob.append(clob_out, replacement_string);
                END IF;
                current_pos := current_pos + search_string_length;
                dest_pos := dest_pos + replacement_string_length;
            ELSE
                dbms_lob.copy(clob_out, source, amount => finded_pos - current_pos, dest_offset => dest_pos, src_offset => current_pos);
                dest_pos := dest_pos + finded_pos - current_pos;
                current_pos := finded_pos;
                IF (replacement_string_length != 0) THEN
                    dbms_lob.append(clob_out, replacement_string);
                END IF;
                current_pos := current_pos + search_string_length;
                dest_pos := dest_pos + replacement_string_length;


            END IF;


        END LOOP;
    END IF;

    IF (current_pos != dbms_lob.getlength(source) + 1) THEN
        dbms_lob.copy(clob_out, source, amount => dbms_lob.getlength(source) + 1 - current_pos, dest_offset => dest_pos, src_offset => current_pos);
    END IF;

    return clob_out;
END; 
