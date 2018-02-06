select * from employees

/*Using a CASE statement, Write a query to display the number of employees in department ID 10, 20, 30 and 40. (Each department ID should have its own column with the number of employees displayed like below).*/
select count(case when department_id = 10 then employee_id else null end) as total_10,
count(case when department_id = 20 then employee_id else null end) as total_20,
count(case when department_id = 30 then employee_id else null end) as total_30,
count(case when department_id = 40 then employee_id else null end) as total_40
from employees


/*Perform the same as mentioned in question 1, but this time using PIVOT function.*/

select *
from
(
select employee_id, department_id
from employees
)
pivot( count(employee_id) for department_id in(10 as total_10, 20 as total_20, 30 as total_30, 40 as total_40)) 

/*Write a query to display the following information
? Department ID
? Manger ID list separated by |*/
select department_id, listagg(manager_id,'|') within group (order by department_id)
from 
(
select distinct department_id, manager_id
from employees
order by department_id
)
group by department_id


/*create a table 'dept_count' based out of the query written in the question2*/

create table dept_count as 
select *
from
(
select employee_id, department_id
from employees
)
pivot( count(employee_id) for department_id in(10 as total_10, 20 as total_20, 30 as total_30, 40 as total_40)) 


/*Using UNION ALL, Write a Query to display the column values into rows from the table DEPT_COUNT*/
select 10 as department_id, total_10 as Employee_cnt
from dept_count
union all
select 20 as department_id, total_20 as Employee_cnt
from dept_count
union all
select 30 as department_id, total_30 as Employee_cnt
from dept_count
union all
select 40 as department_id, total_40 as Employee_cnt
from dept_count

/*UNPIVOT function.*/
select * from dept_count
unpivot(Employee_cnt for department_id in(total_10 as 10, total_20 as 20, total_30 as 30, total_40 as 40))
