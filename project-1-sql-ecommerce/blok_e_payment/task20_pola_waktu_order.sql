-- Task 20: Pola waktu order — hari dalam seminggu dan jam dalam sehari
-- Tujuan: Identifikasi peak hours dan peak days untuk optimasi kampanye marketing dan operasional
-- Tabel: orders

with ekstrak_hari_jam as (
select to_char(order_purchase_timestamp, 'Day') as hari,
extract(hour from order_purchase_timestamp)::int::text || ':00' as jam
from orders
where order_status = 'delivered')
select hari, jam, count(*) jumlah_order
from ekstrak_hari_jam
group by 1,2
order by 3 desc
limit 10