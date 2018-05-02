--Chapter3 working with multiple talbes
--3.1 staking one rowset atop another
select ename as ename_and_dname, deptno
from emp 
where deptno = 10
union all
select '---------', null
from t1
union all
select dname, deptno
from dept;

--3.2Combining Related Rows
select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno
and e.deptno = 10;

--Cartisian product, cross join
select e.ename, d.loc, e.deptno as emp_deptno, d.deptno as dept_deptno
from emp e, dept d
where e.deptno = 10;

--inner join
select e.ename, d.loc, e.deptno as emp_deptno, d.deptno as dept_deptno
from emp e, dept d
where de.deptno = d.deptno and e.deptno = 10;

select e.ename, d.loc
from emp e inner join dept d
on (e.deptno = d.deptno)
where e.deptno = 10;

--3.3 finding rows in common betweeen two tables
create view V1
as 
select ename, job, sal
from emp
where job = 'CLERK';

select *
from V1;

select e.ename, e.job, e.sal
from emp e, V1
where e.ename = V1.ename
  and e.job = V1.job
  and e.sal = V1.sal;
  
select ename, job, sal
from emp
intersect
select ename, job, sal
from V1;

--3.4 Retrieving Values from One Table That Do Not Exist in Another
select deptno from dept
minus
select deptno from emp;

select distinct deptno
from dept
where deptno not in (select deptno from emp);

--be mindful of NULLS when using NOT IN. Consider the following table, NEW_ DEPT:
create table new_dept(deptno integer)
insert into new_dept values (10)
insert into new_dept values (50)
insert into new_dept values (null)

select *
from dept
where deptno not in (select deptno from new_dept);

select deptno
from dept
where deptno in (10, 50, NULL)?

select deptno
from dept
where deptno not in (10, 50, NULL);

select d.deptno
from dept d
where not exists(
 select 1
 from emp e
 where d.deptno = e.deptno);
 
 select d.deptno
  from dept d
 where not exists (
   select 1
     from new_dept nd
    where d.deptno = nd.deptno
)

select d.deptno
from dept d
where not exists(
select e.deptno
from emp e
where d.deptno = e.deptno);

--3.5. Retrieving Rows from One Table That Do Not Correspond to Rows in Another
select d.*
from dept d left outer join emp e
on (d.deptno = e.deptno)
where e.deptno is null

select *
from emp

select * 
from dept;

--3.6 Adding Joins to a Query Without Interfering with Other Joins
CREATE TABLE EMP_BONUS(
 EMPNO NUMBER , 
 RECEIVED DATE , 
 TYPE NUMBER  
 )
 
INSERT INTO emp_bonus VALUES (7369, to_date('2005-03-14','YYYY-MM-DD'),1)
INSERT INTO emp_bonus VALUES (7900, to_date('2005-03-14','YYYY-MM-DD'),2)
INSERT INTO emp_bonus VALUES (7788, to_date('2005-03-14','YYYY-MM-DD'),3)

select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno

select *
from emp

select *
from dept

select e.ename, d.loc,eb.received	 
from emp edept d, emp_bonus eb	 
where e.deptno=d.deptno	   
and e.empno=eb.empno

--one department has zero or more than one employee
--one employee has only one department
--Pay attention to the cardinality
select *
from dept d left join emp e
on (d.deptno = e.deptno)


select *
from dept d left join emp e
on (d.deptno = e.deptno)
left join emp_bonus eb
on(e.empno = eb.empno)

select ename, loc, received
from dept d left join emp e
on (d.deptno = e.deptno)
left join emp_bonus eb
on(e.empno = eb.empno)
order by loc


--3.7 Determining Whether Two Tables Have the Same Data(Duplicate)
create view V2
as 
select * from emp where deptno != 10
union all
select * from emp where ename = 'WARD'


(
select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
from emp
group by empno,ename,job,mgr,hiredate,sal,comm,deptno)
minus
select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
from V2
group by empno,ename,job,mgr,hiredate,sal,comm,deptno
union all
(select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
from V2
group by empno,ename,job,mgr,hiredate,sal,comm,deptno
minus
select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
from emp
group by empno,ename,job,mgr,hiredate,sal,comm,deptno)

(	select *
	   from (
	 select e.empno,e.ename,e.job,e.mgr,e.hiredate, e.sal,e.comm,e.deptno, count(*) as cnt
	   from emp e
	  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
	        ) e
	  where not exists (
	select null
	  from (
	select v2.empno,v2.ename,v2.job,v2.mgr,v2.hiredate,v2.sal,v2.comm,v2.deptno, count(*) as cnt
	  from v2
	 group by empno,ename,job,mgr,hiredate,sal,comm,deptno
	       ) v2
	  where v2.empno    = e.empno
	    and v2.ename    = e.ename
	    and v2.job      = e.job
	    and v2.mgr      = e.mgr
	    and v2.hiredate = e.hiredate
	    and v2.sal      = e.sal
	    and v2.deptno   = e.deptno
	    and v2.cnt      = e.cnt
	    and coalesce(v2.comm,0) = coalesce(e.comm,0)
	 )
 )    
 union all    
(   
	select *
	  from (
	select v2.empno,v2.ename,v2.job,v2.mgr,v2.hiredate,v2.sal,v2.comm,v2.deptno, count(*) as cnt
	  from v2
	 group by empno,ename,job,mgr,hiredate,sal,comm,deptno
	       ) v2
	  where not exists (
	select null
	  from (
	 select e.empno,e.ename,e.job,e.mgr,e.hiredate, e.sal,e.comm,e.deptno, count(*) as cnt
	   from emp e
	  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
	       ) e
	  where v2.empno    = e.empno
	    and v2.ename    = e.ename
	    and v2.job      = e.job
	    and v2.mgr      = e.mgr
	    and v2.hiredate = e.hiredate
	    and v2.sal      = e.sal
	    and v2.deptno   = e.deptno
	    and v2.cnt      = e.cnt
	    and coalesce(v2.comm,0) = coalesce(e.comm,0)
	)
)

--3.9 Performing Joins when Using Aggregates
select e.ename, d.loc
from emp e, dept d
where e.deptno = 10


select e.ename, d.loc
from emp e, dept d
where e.deptno = 10
and d.deptno = e.deptno

--3.10 Performing Joins when Using Aggregates
select *
from emp_bonus

drop table emp_bonus
CREATE TABLE EMP_BONUS(
 EMPNO NUMBER , 
 RECEIVED DATE , 
 TYPE NUMBER  
 )
 
INSERT INTO emp_bonus VALUES (7934, to_date('2005-03-17','YYYY-MM-DD'),1)
INSERT INTO emp_bonus VALUES (7934, to_date('2005-03-15','YYYY-MM-DD'),2)
INSERT INTO emp_bonus VALUES (7839, to_date('2005-03-15','YYYY-MM-DD'),3)
INSERT INTO emp_bonus VALUES (7782, to_date('2005-03-15','YYYY-MM-DD'),1)

select e.empno, e.ename, e.sal, e.deptno, e.sal*case when eb.type = 1 then .1 when eb.type = 2 then .2 else .3 end as bonus
from emp e, emp_bonus eb
where e.empno = eb.empno
and e.deptno = 10;

select e.empno, e.ename, e.sal, e.deptno, e.sal*type*0.1 bonus
from emp e, emp_bonus eb
where e.empno = eb.empno
and e.deptno = 10;

--wrong way to aggregate and join 
select deptno, sum(sal) as total_sal, sum(bonus) as total_bonus
from (
    select e.empno, e.ename, e.sal, e.deptno, e.sal*case when eb.type = 1 then .1 when eb.type = 2 then .2 else .3 end as bonus
    from emp e, emp_bonus eb
    where e.empno = eb.empno
    and e.deptno = 10
    )
group by deptno

--Right way to aggregate and join 
select deptno, sum(distinct sal) as total_sal, sum(bonus) as total_bonus
from (
    select e.empno, e.ename, e.sal, e.deptno, e.sal*case when eb.type = 1 then .1 when eb.type = 2 then .2 else .3 end as bonus
    from emp e, emp_bonus eb
    where e.empno = eb.empno
    and e.deptno = 10
    )
group by deptno

--Or:
select distinct deptno, sum(distinct sal)over(partition by deptno) as total_sal, sum(bonus)over(partition by deptno) as total_bonus
from (
    select e.empno, e.ename, e.sal, e.deptno, e.sal*case when eb.type = 1 then .1 when eb.type = 2 then .2 else .3 end as bonus
    from emp e, emp_bonus eb
    where e.empno = eb.empno
    and e.deptno = 10
    )


--3.12 Using NULLs in Operations and Comparisions
select ename, comm
from emp
where coalesce(comm,0) < (select comm from emp where ename = 'WARD')