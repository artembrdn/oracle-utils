-- returns 1 if the string consists of only digits, 0 if string is null or string length = 0
create or replace function is_number(a_string in varchar2)
    return number
is
    v_new_num number;
    pragma udf;
begin
    if a_string is null then
        return 0;
    end if;
    -- TO_NUMBER implicit does trim
    v_new_num := TO_NUMBER(a_string);
    return 1;
exception
    when VALUE_ERROR then
    return 0;
end;