--1. rollup
select department_name,job_id, sum(salary) as salary
from employees a inner join departments b
on a.department_id = b.department_id
group by rollup(department_name, job_id)
order by department_name;
--pay attention to two element in the group by clause



--2.cube
select department_name,job_id, sum(salary) as salary
from employees a inner join departments b
on a.department_id = b.department_id
group by cube(job_id,department_name)
order by department_name;
--pay attention to the sequence of the content in the cube


--3.Grouping
select department_name,job_id,
grouping(department_name) as FLAG1,
grouping(job_id) as FLAG2, 
sum(salary) as salary
from employees a inner join departments b
on a.department_id = b.department_id
group by cube(job_id,department_name)
order by department_name;


--4.Grouping_ID
select department_name,job_id,
grouping_ID(department_name, job_id) as FLAG_ID, 
sum(salary) as salary
from employees a inner join departments b
on a.department_id = b.department_id
group by cube(job_id,department_name)
order by department_name;
