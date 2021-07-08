create or replace type split_format is object (
  str VARCHAR2(20000)
);
create or replace type split_type  is table of split_format;

--The function splits the input string (varchar2 or clob) by pattern and outputs each substring in a separate line.
--For the CLOB type, optimization is applied - division by chuncks, so that intermediate calculations do not create temporary CLOB.
--The function has a limitation - it is expected that when the string length is greater than max_chunk_size, there will be no overflow of previous_chunk_remains, 
--i.e. there are occurrences of pattern in the string and the last substring of each chunk is less than previous_chunk_remains.
--You can set the size of previous_chunk_remains yourself, previous_chunk_remains = 32767 - max_chunck_size.
create or replace function split_ (str IN clob, pattern IN varchar2) RETURN  split_type pipelined
IS
    max_chunck_size number := 30000;
    --it is possible to overflow previous_chunk_remains and form an exception, the solution is to reduce max_chunk_size, increase previous_chunk_remains
    previous_chunk_remains varchar2(2767) := '';
    
    position number;
    next_position number;
    split_length number := length( pattern );
    current_chunck_str varchar2(32767);
    current_chunck_length number;
    chunck_piped_size number;
    chunck_count number;
    chunck_counter number;
     
    res split_format:=split_format(null);
BEGIN
  IF (str is not null) THEN
    --we first divide the CLOB into blocks by max_chunk_size to get around the problem of low performance substr/instr with the input CLOB.
    chunck_count := ceil( length( str ) / max_chunck_size );

    chunck_counter := 1; 
    WHILE (chunck_counter <= chunck_count) LOOP
      current_chunck_str := substr( str, max_chunck_size * (chunck_counter - 1) + 1, max_chunck_size );
      --concatenate with the remaining remainder of the chunck from the previous iteration
      current_chunck_str := previous_chunk_remains || current_chunck_str;
      current_chunck_length := length( current_chunck_str );

      chunck_piped_size := 1;
      next_position := 1;

      LOOP
        position := instr(current_chunck_str, pattern, next_position, 1);

        --if the pattern is not found, we copy the remaining string to the temporary string to concatenate it in the next iteration,
        --the condition >= is to reset the temporary string if the original one is empty
        IF (position = 0 AND current_chunck_length >= (chunck_piped_size - split_length)) THEN
           previous_chunk_remains := substr( current_chunck_str, chunck_piped_size, ( current_chunck_length + 1 - chunck_piped_size ) );
           
           IF (chunck_counter = chunck_count) THEN
            position := current_chunck_length + 1;
            res.str := substr(current_chunck_str, chunck_piped_size, (position - chunck_piped_size));
            pipe row(res);
            position := 0;
           END IF;
        --if the pattern is not found and the end of the CLOB is reached and there is no remainder of the chunk (i.e. when split_('123;', ';') => 123 and null)
        ELSIF (position = 0 AND chunck_counter = chunck_count) THEN
          res.str := null;
          pipe row(res);
        END IF;

        EXIT WHEN ( position = 0 );

        res.str := substr(current_chunck_str, chunck_piped_size, (position - chunck_piped_size));
        next_position := position + 1;
        pipe row(res);

        chunck_piped_size := position + split_length;
      END LOOP;
      chunck_counter :=  chunck_counter + 1;  
    END LOOP;
  END IF;
END split_;
