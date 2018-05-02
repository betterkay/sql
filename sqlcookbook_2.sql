--Chapter2
--sort by substrings
select ename, job
from emp
order by substr(job,length(job)-1);

--Sorting Mixed Alphanumberic Data
create view V 
as
select ename||' '||deptno as data
from emp;

select * from V;
--order by ename
select *
from V
order by replace(translate(data,'1234567890','##########'),'#','');
--order by deptno
select * 
from V
order by replace(data,replace(translate(data,'1234567890','##########'),'#',''),'');

--Dealing with Nulls when Sorting
select ename, sal, comm
from emp
order by 3

select ename, sal, comm, case when comm is null then 0 else 1 end as is_null
from emp
order by is_null desc, comm

--sorting on a data dependent key
