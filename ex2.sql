/*Employee ID
? Job ID
? Salary
? Department ID
? Average salary by Job ID
? Average salary by Department ID
? Average salary of all employees
*/
select * from employees order by job_id

select job_id, salary, department_id, 
avg(nvl(salary,0)) over(partition by job_id) as avg_salary_job_id,
avg(nvl(salary,0)) over(partition by department_id) as avg_salary_department_id,
avg(nvl(salary,0)) over() as avg_salary
from employees
order by job_id

/*? Employee ID
? Job ID
? Department ID
? Salary
? Average salary by Department ID
? Difference between employee salary and Average salary by Department ID
*/
select job_id, salary, department_id, (salary - avg_salary_department_id) as salary_difference
from
(
select job_id, salary, department_id, 
avg(nvl(salary,0)) over(partition by department_id) as avg_salary_department_id
from employees
order by job_id
) a

select job_id, salary, department_id, 
avg(nvl(salary,0)) over(partition by department_id) as avg_salary_department_id,
(salary - avg(nvl(salary,0)) over(partition by department_id)) as salary_difference
from employees
order by job_id


/*Job ID
? Department ID
? Number of managers by Job ID
? Number of managers by Department ID
? Total number of managers*/

select job_id, department_id, 
count(distinct manager_id) over(partition by job_id) as num_of_mgrs_job,
count(distinct manager_id) over(partition by department_id) as num_of_mgrs_department,
count(distinct manager_id) over() as num_of_mgrs
from employees
order by job_id

/*Employee ID
? Department ID
? Salary
? Salary Ranking*/

select employee_id, department_id, salary, row_number() over(order by salary desc) as salary_rank
from employees
--rank, dense_rank, row_number are same

/*Employee ID
? Department ID
? Salary
? Salary Ranking by Department ID
*/
select employee_id, department_id, salary, row_number() over(partition by department_id order by salary desc) as salary_rank
from employees

/*Employee ID
? Department ID
? Salary
? Top Salary Ranking by Department ID
? Bottom Salary Ranking by Department ID*/
select employee_id, salary, 
rank() over(partition by department_id order by salary desc) as top_salary,
rank() over(partition by department_id order by salary asc) as bottom_salary
from employees


/*Write a query to display the following information, but display only top 3 and bottom 3 salaries.
? Employee ID
? Department ID
? Salary
? Top Salary Ranking by Department ID
? Bottom Salary Ranking by Department ID*/
select *
from
(
select employee_id, salary, 
rank() over(partition by department_id order by salary desc) as top_salary,
rank() over(partition by department_id order by salary asc) as bottom_salary
from employees
)
where top_salary <= 3 or bottom_salary <= 3

/*Write a query to display the following information for the Department ID 30
? Employee ID
? Salary
? Next lowest salary (You need to use LEAD)
? Previous highest salary (You need to use LAG)*/
select employee_id, salary, 
lead(salary,1,0) over (order by salary desc) next_lowest_sal,
lag(salary,1,0) over (order by salary desc) previous_lowest_sal
from employees
where department_id = 30
order by salary desc
--