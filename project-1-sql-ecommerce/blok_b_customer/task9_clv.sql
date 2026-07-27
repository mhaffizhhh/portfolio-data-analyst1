-- Task 9: Customer Lifetime Value (CLV) dan distribusinya
-- Tujuan: Mengukur total nilai yang dihasilkan tiap customer dan segmentasi berdasarkan CLV
-- Tabel: orders, order_items, customers

with revenue as (
select oi.order_id, customer_id, price+freight_value as revenue 
from order_items oi
inner join orders o
on oi.order_id=o.order_id
where order_status='delivered'
)
, revenue_per_cust as (
select customer_unique_id, revenue
from revenue r
inner join customers c
on r.customer_id=c.customer_id
), total_revenue_per_cust as (
select customer_unique_id, round(sum(revenue)::NUMERIC,2) as total_revenue
from revenue_per_cust
group by 1
), summary as (
select *, round(avg(total_revenue) over(),2) as rata2_revenue
from total_revenue_per_cust)
select 
(select count(*)
from summary
where rata2_revenue-total_revenue < 0) as above_avg,
(select count(*)
from summary
where rata2_revenue-total_revenue > 0) as under_avg