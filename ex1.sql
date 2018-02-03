/*Create a virtual column named SALARY_RANGE in the table EMPLOYEES with the below logic.
If salary is greater than 10000 then value should be displayed as ‘Good’ else the value should be displayed as ‘Average’
*/

alter table employees
add salary_range as
(case when salary >=10000 then 'Good' else 'Average' end)
--how to add columns under certain condition
select * from employees where rownum = 1

/*Create a default column named COMPANY in the table EMPLOYEES with the default value ‘Udemy’*/

alter table employees
add company varchar2(20) default 'Udemy'


--Insert 2 rows into EMPLOYEES table using the INSERT ALL statement.
insert all
into employees(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values(999, 'kay', 'k', 'k@gmail.com','432.432.5432', '05-May-2018','AD_PRES', 98000, null, null,90)
select * from dual

select * from employees where rownum = 1
select * from jobs where rownum = 1
--pay attention to the job primary key in Job

--Write a SQL statement to display the average of MANAGER_ID column in the EMPLOYEES table.
select avg(nvl(manager_id,0))
from employees
