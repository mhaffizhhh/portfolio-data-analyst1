-- Task 1: Total revenue per bulan (2016-2018)
-- Tujuan: Identifikasi tren revenue dan bulan dengan performa tertinggi/terendah
-- Tabel: orders, order_items

with revenue as (
select order_id, price+freight_value revenue from order_items
),
merged as (select r.order_id,revenue,extract(month from order_purchase_timestamp) as month,
extract(year from order_purchase_timestamp) as year
from revenue r
inner join orders o
on r.order_id = o.order_id
where order_status NOT IN ('cancelled', 'unavailable') and 
	extract(year from order_purchase_timestamp) between 2016 and 2018 )
select year, month, round(sum(revenue)::NUMERIC,2) as total
from merged
group by 1, 2
order by 3 desc
