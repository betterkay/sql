select * from employees where rownum = 1

/*Write a SQL statement to display
? employee_id, last_name, job_id, manager_id, hire_date and level of the hierarchy by connecting employee_id with manager_id.
? Also make sure you start with the row where manager_id has NULL value.*/
select employee_id, last_name, job_id, manager_id, hire_date, manager_id, level
from employees
connect by prior employee_id = manager_id
start with manager_id is null

--to show only level 1 and 2
select employee_id, last_name, job_id, manager_id, hire_date, manager_id, level
from employees
where level <=2
connect by prior employee_id = manager_id
start with manager_id is null
--pay attention to the position of where clause

/*Write a SQL statement to display
? employee_id, last_name, job_id, manager_id, hire_date and level of the hierarchy by connecting employee_id with manager_id.
? Also make sure you start with the row where last_name = ‘kochhar’
? Use the SYS_CONNECT_BY_PATH with parameters LAST_NAME, separated by / to display the hierarchy*/
select employee_id,last_name,manager_id,hire_date, level, sys_connect_by_path(last_name,'/') as hierar1
from employees
connect by prior employee_id= manager_id
start with last_name = 'Kochhar'

--Sort the rows retrieved in question 3 by LAST_NAME
SELECT employee_id,
last_name,
job_id,
manager_id,
hire_date,
level,
SYS_CONNECT_BY_PATH (LAST_NAME,'/') AS HIERAR1
FROM EMPLOYEES
START WITH LAST_NAME = 'Kochhar'
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY last_name;

--Write a SQL statement using CONNECT BY to generate a series of dates between ’01-jan-2016’ to ’31-jan-2016’
SELECT to_date('01-jan-2016','dd-mon-yyyy') - 1 + level FROM DUAL
CONNECT BY LEVEL<=31;

--Write a SQL statement to return the total salary of each employee in department 110 and all employees below that employee in the hierarchy. Group the total salary by each root manager in department 110. (Hint: Use CONNECT_BY_ROOT)
SELECT emp_name, SUM(salary) AS TOTAL_SALARY
FROM
(
SELECT CONNECT_BY_ROOT last_name as emp_name, Salary, employee_id, manager_id, last_name
FROM employees
WHERE department_id = 110
CONNECT BY PRIOR employee_id = manager_id
)
GROUP BY emp_name;
