-- Task 14: SLA compliance rate per bulan
-- Tujuan: Mengukur tren ketepatan pengiriman dari waktu ke waktu
-- Tabel: orders

with status_pengiriman as (
select 
	extract(year from order_purchase_timestamp) as y,
	extract(month from order_purchase_timestamp) as m,
	case
	when order_delivered_customer_date > order_estimated_delivery_date then 'Late'
	else 'On Time'
	end as kriteria
from orders
where order_status = 'delivered'
),
jumlah_on_time as (
select y, m, count(*) as on_time
from status_pengiriman
where kriteria = 'On Time'
group by 1,2),
jumlah as (
select y, m, count(*) as jumlah_per_bulan
from status_pengiriman
group by 1,2)
select j.y, j.m, coalesce(round(on_time*100.0/jumlah_per_bulan,2),0) as rate_on_time
from jumlah j
left join jumlah_on_time jot
on j.y = jot.y and j.m = jot.m
order by 1,2