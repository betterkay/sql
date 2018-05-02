--Concatenating Column Values
select ename||'WORKS AS A '||job as msg
from emp 
where deptno = 10;

--Using Conditional Logic in a SELECT Statement
select ename,sal,
    case when sal <= 2000 then 'UNDERPAID'
         when sal >= 4000 then 'OVERPAID'
         else 'OK'
    end as status
from emp;

--limit the number of rows
select *
from emp
where rownum <= 5;

--find NULL value
select * 
from emp
where comm is null;

--transform NULLS into real values
select coalesce(comm,0)
from emp

select case 
       when comm is NULL then 0
       else comm
       end as comm2
from emp;

