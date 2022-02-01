-- returns 1 if the string consists of only digits, 0 if string is null or string length = 0
create or replace function is_number(a_string in varchar2)
  return number
is
  v_new_num number;
  pragma udf;
begin
  return case when regexp_like(a_string, '^[[:digit:]]+$') then 1 else 0 end;
end ;