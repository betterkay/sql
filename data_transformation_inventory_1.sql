--convert row level data to column level data

select * from sales

select trunc(sales_date,'mon') as sales_month,
product_id, sum(total_amount) as total_amount
from sales
group by trunc(sales_date,'mon'), product_id
order by trunc(sales_date,'mon')


select trunc(sales_date,'mon') as sales_month,
sum(case when product_id = 100 then total_amount else 0 end) as total_100,
sum(case when product_id = 101 then total_amount else 0 end) as total_101,
sum(case when product_id = 105 then total_amount else 0 end) as total_105,
sum(case when product_id = 106 then total_amount else 0 end) as total_106,
sum(case when product_id = 200 then total_amount else 0 end) as total_200
from sales
group by trunc(sales_date,'mon')
order by trunc(sales_date,'mon')

select trunc(sales_date,'mon') as sales_month,
case when product_id = 100 then total_amount else 0 end as total_100,
case when product_id = 101 then total_amount else 0 end as total_100,
case when product_id = 105 then total_amount else 0 end as total_100,
case when product_id = 106 then total_amount else 0 end as total_100,
case when product_id = 200 then total_amount else 0 end as total_100
from
(
select trunc(sales_date, 'mon') as sales_month, product_id, total_amount fro
from sales

--pivot
SELECT *
FROM
(
SELECT TRUNC (SALES_DATE,'MON') AS SALES_MONTH, PRODUCT_ID,
TOTAL_AMOUNT
FROM SALES
)
PIVOT (SUM (TOTAL_AMOUNT) FOR (PRODUCT_ID) IN (100, 101, 105, 106, 200)
)
ORDER BY SALES_MONTH


--listagg-->list all same level value into one column level
select * from customer

select region,
listagg(last_name,', ') within group (order by last_name) as customer_names
from customer
group by region


--convert column level to row level
create table sales_pivot as
select trunc(sales_date,'mon') as sales_month,
sum(case when product_id = 100 then total_amount else 0 end) as total_100,
sum(case when product_id = 101 then total_amount else 0 end) as total_101,
sum(case when product_id = 105 then total_amount else 0 end) as total_105,
sum(case when product_id = 106 then total_amount else 0 end) as total_106,
sum(case when product_id = 200 then total_amount else 0 end) as total_200
from sales
group by trunc(sales_date,'mon')
order by trunc(sales_date,'mon')

select * from sales_pivot

--union all
select sales_month, 100, total_100 as total_amount
from sales_pivot
union all
select sales_month, 101, total_101 as total_amount
from sales_pivot
union all
select sales_month, 105, total_105 as total_amount
from sales_pivot
union all
select sales_month, 106, total_106 as total_amount
from sales_pivot
union all
select sales_month, 200, total_200 as total_amount
from sales_pivot

--unpivot
select sales_month, product_id, total_amount 
from sales_pivot
unpivot
( total_amount for product_id in (
total_100 as '100',
total_101 as '101',
total_105 as '105',
total_106 as '106',
total_200 as '200')
)