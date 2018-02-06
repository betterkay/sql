--hierarchical queries

--connect by clause
select first_name, job_title, manager, level
from salesperson
connect by prior first_name = manager
start with manager is null
order by 4

select * from salesperson

select first_name, manager
from salesperson a, salesperson b
where 

--creating the hierachy tree
select concat( LPAD (' ',level*3 - 3), first_name) as hier_first, level
from salesperson
connect by prior first_name = manager
start with manager is null

--order siblings by 
select concat( LPAD (' ',level*3 - 3), first_name) as hier_first, level
from salesperson
connect by prior first_name = manager
start with manager is null
order siblings by salesperson.first_name 

--connect_by_root reture the root of the tree
select first_name, level, manager, connect_by_root first_name as top_boos
from salesperson
connect by prior first_name = manager
start with manager is null

--level down
select first_name, level, manager, connect_by_root first_name as top_boos
from salesperson
connect by prior first_name = manager
start with manager = 'Jeff'


--hierachy tree and group by example
select top_boss, first_name, sum(total_amount) as sales
from
(
select  manager, connect_by_root first_name as top_boss, first_name, salesperson_id
from salesperson
connect by prior first_name = manager
start with manager = 'Raj') a, sales b
where a.salesperson_id = b.salesperson_id
group by top_boss, first_name
order by 1


--sys_connect_by_path displays the hierachy of the row at a column level
select
salesperson_id, first_name, level, sys_connect_by_path(first_name,'/') as hier1
from salesperson
connect by prior first_name = manager
start with manager = 'Jeff'

--connect by for number generation
select level as c_number
from dual
connect by level <= 1000