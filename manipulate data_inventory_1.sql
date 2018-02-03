--create table
create table customer1
(customer_id number,
customer_name varchar2(20),
expiry_data date default to_date('31-dec-2099','dd-mon-yyyy')
)
--insert rows
insert into customer1 (customer_id, customer_name) values (3, 'P')

--create virtual column
/*advantages of virtual
1.save disk space
2.no need to update data when formula change
*/
create table sales1
(
sales_data date,
order_id number,
total_amount number,
commission number generated always as (total_amount * 0.01) virtual
)

alter table sales1
drop column sales_data

select * from sales1
alter table sales1 add sales_date date

delete from sales1
insert into sales1(sales_date, order_id, total_amount) values ('20-Feb-2018',3,100)
select * from sales1

drop table sales1

create table sales1
(sales_date date,
sales_id number,
total_amount number,
commission  as (total_amount * 0.01) 
)

insert into sales1(sales_date, sales_id, total_amount) values('01-Feb-2018', 3, 300)
select * from sales1

select 10-null from dual
select 10+null from dual
select 10*null from dual
select 10/null from dual


--use (nvl,0) when null value
select * from sales
select avg(tax_amount) from sales
select avg(nvl(tax_amount,0)) from sales

--insert multi records
select * from customer1;
insert all
into customer1(customer_id, customer_name) values ( 5,'we')
into sales1(sales_date, sales_id, total_amount) values ('31-Jan-2018', 9, 800)
select * from dual

select * from customer1
select * from sales1

--merge statement
/*when find the matched key: update data
  when find the keys are not matched: insert value
*/

--to find same value in both sales and sales_history
select * from sales
intersect
select * from sales_history

select count(1) from sales
select count(1) from sales_history

select * from sales_history

merge into sales_history dest
           using sales src
           on (dest.sales_date = src.sales_date
           and dest.order_id = src.order_id
           and dest.product_id = src.product_id
           and dest.customer_id = src.customer_id)
when matched then
           update set dest.quantity = src.quantity,
                      dest.unit_price = src.unit_price,
                      dest.sales_amount = src.sales_amount,
                      dest.tax_amount = src.tax_amount,
                      dest.total_amount = src.total_amount
when not matched then
           insert (sales_date, order_id, product_id, customer_id, salesperson_id, quantity, unit_price, sales_amount, tax_amount, total_amount)
           values  (src.sales_date, src.order_id, src.product_id, src.customer_id, src.salesperson_id, src.quantity, src.unit_price, src.sales_amount, src.tax_amount,src.total_amount)

create table sales_history1 as
select * from sales_history where 1 <> 1--where 1<>1 --> copy nothing but sales_history column

select * from sales_history1

merge into sales_history1 dest
           using sales src
           on (dest.sales_date = src.sales_date
           and dest.order_id = src.order_id
           and dest.product_id = src.product_id
           and dest.customer_id = src.customer_id)
when matched then
           update set dest.quantity = src.quantity,
                      dest.unit_price = src.unit_price,
                      dest.sales_amount = src.sales_amount,
                      dest.tax_amount = src.tax_amount,
                      dest.total_amount = src.total_amount
            where src.total_amount > 1000
when not matched then
           insert (sales_date, order_id, product_id, customer_id, salesperson_id, quantity, unit_price, sales_amount, tax_amount, total_amount)
           values  (src.sales_date, src.order_id, src.product_id, src.customer_id, src.salesperson_id, src.quantity, src.unit_price, src.sales_amount, src.tax_amount,src.total_amount)
           where src.total_amount > 1000

create table sales_history2 as 
select * from sales_history where total_amount between 1 and 100

select * from sales_history2

merge into sales_history2 dest
           using sales src
           on (dest.sales_date = src.sales_date
           and dest.order_id = src.order_id
           and dest.product_id = src.product_id
           and dest.customer_id = src.customer_id)
when matched then
           update set dest.quantity = src.quantity,
                      dest.unit_price = src.unit_price,
                      dest.sales_amount = src.sales_amount,
                      dest.tax_amount = src.tax_amount,
                      dest.total_amount = src.total_amount
            delete where dest.total_amount < 50