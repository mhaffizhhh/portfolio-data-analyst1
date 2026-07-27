-- Task 11: Rata-rata waktu pengiriman per kota — 5 tercepat dan 5 terlambat
-- Tujuan: Mengidentifikasi kesenjangan performa logistik antar wilayah
-- Tabel: orders, customers

with waktu_kirim as (
select customer_city, customer_state, order_delivered_customer_date - order_purchase_timestamp as waktu_kirim
from orders o
inner join customers c
on o.customer_id = c.customer_id
where order_status='delivered'), 
top5 as (
select customer_state, customer_city, avg(waktu_kirim) rata2_waktu_kirim
from waktu_kirim
group by 1,2
order by 3 desc
limit 5),
terbawah5 as (
select customer_state, customer_city, avg(waktu_kirim) rata2_waktu_kirim
from waktu_kirim
group by 1,2
order by 3 asc
limit 5
)
select * from top5
union all
select * from terbawah5
order by rata2_waktu_kirim desc