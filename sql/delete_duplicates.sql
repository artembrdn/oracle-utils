--Initialization
create table duplicates (col1 number, col2 number);

insert into duplicates
select trunc(dbms_random.value(1,4000)),trunc(dbms_random.value(1,200)) from dual connect by level<1000000;

insert into duplicates
select null,null from dual union all
select null,null from dual union all
select 1,null from dual union all
select 1,null from dual;

--Checking how many duplicates
select sum(count_per_group - 1) from (
    select col1, col2, count(1) count_per_group from duplicates group by col1,col2 having count(1) > 1
)
--430566 in my case

--=== FIRST method ===--
delete from duplicates t where rowid not in(
    select max(rowid) from duplicates group by col1,col2
)
--430566 rows deleted
--Checking that NULL duplicates was deleted
select * from duplicates where col2 is null
-- null, null
-- 1,    null
-- well!

--=== SECOND method ===--
delete from duplicates t where t.rowid > ANY(
    select t2.rowid from duplicates t2 where t.col1=t2.col1 and t.col2=t2.col2
)
--430564 rows deleted
--Checking that NULL duplicates was deleted
select * from duplicates where col2 is null
-- null, null
-- null, null
-- 1,    null
-- 1,    null
-- Ooops! 

-- This happened due to the fact that when comparing columns, 
-- NULL values are not compared correctly, for a correct comparison 
-- it is necessary to add NVL functions with obviously non-existent values.
-- where nvl(t.col1,-1)=nvl(t2.col1,-1) and nvl(t.col2,-1)=nvl(t2.col2,-1)

--With a large number of columns, this is inconvenient.
--The first method is preferable.