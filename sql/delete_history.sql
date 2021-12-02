--Removing historical data from a table without temporary tables

--Initialization
create table duplicates (col1 number, col2 number, date1 date);
insert into duplicates ...

--
delete from dublicates t where rowid not in(
    select ri from (
        select rowid ri, row_number() over(partition by col1, col2, date1 order by date1 desc) rn 
        from dublicates
    ) where rn=1
);