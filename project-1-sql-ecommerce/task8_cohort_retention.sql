-- Task 8: Cohort retention analysis — customer yang kembali order bulan berikutnya
-- Tujuan: Mengukur seberapa baik platform mempertahankan customer baru di bulan pertama
-- Tabel: orders, customers

with first_order as (select customer_unique_id, o.customer_id, order_purchase_timestamp, extract(year from order_purchase_timestamp) as y,
extract(month from order_purchase_timestamp) as m,
row_number() over(partition by customer_unique_id order by order_purchase_timestamp) as rn
from orders o
inner join customers c
on o.customer_id=c.customer_id
where order_status = 'delivered'), 
second_purchase as (
select *, 
	lead(order_purchase_timestamp) 
	over(partition by customer_unique_id order by order_purchase_timestamp) as second_purchase_time
from first_order), 
jumlah_order_per_month as (
select y,m,count(order_purchase_timestamp) as jumlah_first_order
from first_order
where rn=1
group by 1,2
order by 1,2),
second_purchase_time2 as (
select customer_unique_id,rn,y,m, extract(year from second_purchase_time) as y2, extract(month from second_purchase_time) as m2
from second_purchase
where second_purchase_time is not null and rn = 1
order by 1,2,3),
retention as (
select customer_unique_id, y, m
from second_purchase_time2
where (y2*12 + m2) - (y*12 + m) = 1),
total_retention_per_bulan as (
select y,m, count(*) as jumlah_retention
from retention
group by 1,2)
select jopm.y, jopm.m, jumlah_first_order, jumlah_retention, 
	coalesce(round(jumlah_retention * 100.0 / jumlah_first_order, 2),0) as retention_rate
from jumlah_order_per_month as jopm
left join total_retention_per_bulan as trpb
on jopm.y = trpb.y and jopm.m = trpb.m