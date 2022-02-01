-- returns 1 if the string consists of only digits, 0 if string is null or string length = 0
create or replace function is_number(a_string in varchar2) return number DETERMINISTIC
is
  v_new_num number;
  pragma udf;
begin
  --char X is using for correct work, it can be any other char ( the third string must not be an empty string)
  --nvl using to return 0 if input is null
  return  case when TRANSLATE(nvl(a_string,'X'),'X0123456789','X') is null then 1 else 0 end;
end;