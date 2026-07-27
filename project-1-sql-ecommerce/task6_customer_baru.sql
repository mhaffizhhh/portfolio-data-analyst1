-- Task 6: Jumlah customer baru per bulan
-- Tujuan: Mengukur laju akuisisi customer baru sebagai indikator pertumbuhan platform
-- Tabel: orders, customers

with cust as (select customer_unique_id, o.customer_id, order_purchase_timestamp  
from orders o
inner join customers c
on o.customer_id=c.customer_id
where order_status = 'delivered'), 
new as (
select customer_unique_id, order_purchase_timestamp, 
	row_number() over(partition by customer_unique_id order by order_purchase_timestamp) as r
from cust
order by 1,2), 
new_cust as (
select customer_unique_id, extract(year from order_purchase_timestamp) as year, 
	extract(month from order_purchase_timestamp) as month
from new
where r = 1)
select year, month, count(customer_unique_id)
from new_cust
group by 1,2