-- Task 10: Persentase churned customer (tidak order > 6 bulan)
-- Tujuan: Mengidentifikasi proporsi customer yang sudah tidak aktif sebagai sinyal risiko bisnis
-- Tabel: orders, customers

with cust as (select customer_unique_id, max(order_purchase_timestamp) last_order
from orders o
inner join customers c
on o.customer_id=c.customer_id
where order_status = 'delivered'
group by 1),
last_order_cust as (
select *, max(last_order) over() last_data
from cust)
select round(count(*)*100.0/(select count(*) from cust),2) persentase_churned
from last_order_cust
where last_order < last_data - INTERVAL '6 months'