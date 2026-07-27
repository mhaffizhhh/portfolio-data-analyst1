-- Task 7: Persentase repeat customer dan rata-rata jarak waktu antar order
-- Tujuan: Mengukur loyalitas customer dan pola pembelian ulang
-- Tabel: orders, customers

with cust as (select customer_unique_id, o.customer_id, order_purchase_timestamp  
from orders o
inner join customers c
on o.customer_id=c.customer_id
where order_status = 'delivered'), 
new as (
select customer_unique_id, order_purchase_timestamp, 
	lead(order_purchase_timestamp) over(partition by customer_unique_id order by order_purchase_timestamp) as l
from cust
order by 1,2), repeat_order as (
select * 
from new
where l is not null
order by 1)
select round((select count(distinct customer_unique_id) from repeat_order)*1.0/
	(select count(distinct customer_unique_id) from cust)*1.0,4) as rasio_repeat_order, 
	(select avg(l-order_purchase_timestamp) from repeat_order) as rata2_jarak_repeat_order