-- Task 5: Average Order Value (AOV) per bulan
-- Tujuan: Mengukur tren rata-rata nilai belanja customer per transaksi dari waktu ke waktu
-- Tabel: orders, order_items

with revenue as (
select oi.order_id, extract(year from order_purchase_timestamp) as year,
extract(month from order_purchase_timestamp) as month, price+freight_value revenue
from order_items oi
inner join orders o
on o.order_id=oi.order_id
where order_status = 'delivered'
)
, tren as (select year, month, round(sum(revenue)::NUMERIC,2) as total_revenue, count(distinct order_id) as total_order
from revenue
group by 1,2)
select year, month, round(total_revenue/total_order,2) as rata2_nilai_order
from tren