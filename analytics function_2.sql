--analytic function
--conbine detailed data and aggregate data

select sales_date, order_id, product_id, avg(total_amount) over(partition by sales_date) avg_sales_day,
from sales
order by 1

select sales_date, order_id, product_id, avg(total_amount) over(partition by sales_date) avg_sales_day,
avg(sales_amount) over() avg_sales,
avg(sales_amount) over(partition by trunc(sales_date, 'mon')) avg_sales_month
from sales

--sum aggregattion function
select sales_date, order_id, product_id, sales_amount, sum(sales_amount) over (order by sales_date, order_id, product_id) as cum_sum
from sales
order by 1

--ratio to report
select trunc(sales_date, 'mon') as sales_month, sum(total_amount) as total_amount, round(ratio_to_report(sum(total_amount)) over()*100,2) as ratio_perc
from sales s
group by trunc(sales_date, 'mon')
--ratio_to_report
--round( ,2)


--rank
select trunc(sales_date,'mon') as sales_month, sp.first_name, sum(sales_amount), rank() over (partition by trunc(sales_date,'mon') order by sum(sales_amount) desc)
from sales s, salesperson sp
where s.salesperson_id = sp.salesperson_id
group by trunc(sales_date,'mon'), sp.first_name
--pay attention to analytics aggregation function and group by 

--show the top 3 salesperson per each month
select *
from
(select trunc(sales_date,'mon') as sales_month, sp.first_name, sum(sales_amount), rank() over (partition by trunc(sales_date,'mon') order by sum(sales_amount) desc) as rank1
from sales s, salesperson sp
where s.salesperson_id = sp.salesperson_id
group by trunc(sales_date,'mon'), sp.first_name) a
where rank1<=3

--bottom 3 salesperson
select *
from
(select trunc(sales_date,'mon') as sales_month, sp.first_name, sum(sales_amount), rank() over (partition by trunc(sales_date,'mon') order by sum(sales_amount) asc) as rank1
from sales s, salesperson sp
where s.salesperson_id = sp.salesperson_id
group by trunc(sales_date,'mon'), sp.first_name) a
where rank1<=3

--ntile function
select sp.first_name, sum(total_amount) as total_amount, ntile(3) over(order by sum(total_amount) desc) as ngroup
from sales s, salesperson sp
where s.salesperson_id=sp.salesperson_id
group by sp.first_name

--lag,lead
select trunc(sales_date, 'mon') as sales_month, sum(sales_amount) as sales_amount, lag(sum(sales_amount),1) over(order by trunc(sales_date,'mon')) as previous_month_sales,  lead(sum(sales_amount),1) over(order by trunc(sales_date,'mon')) as next_month_sales
from sales
group by trunc(sales_date,'mon')
order by trunc(sales_date,'mon')

--sales grouth across time
select sales_month, sales_amount, round(((sales_amount-previous_month_sales)/previous_month_sales)*100,2) as growth_perc
from 
(
select trunc(sales_date, 'mon') as sales_month, 
sum(sales_amount) as sales_amount, 
lag(sum(sales_amount),1) over(order by trunc(sales_date,'mon')) as previous_month_sales,  
lead(sum(sales_amount),1) over(order by trunc(sales_date,'mon')) as next_month_sales
from sales 
group by trunc(sales_date,'mon')
order by trunc(sales_date,'mon')
)