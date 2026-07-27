-- Task 3: Kontribusi revenue per kategori produk
-- Tujuan: Mengukur porsi tiap kategori terhadap total revenue platform (dalam %)
-- Tabel: orders, order_items, products

with revenue as (
select oi.order_id, product_id, price+freight_value revenue 
from order_items oi
inner join orders o
on oi.order_id=o.order_id
where order_status = 'delivered'
),
kumulatif as (
select distinct product_category_name, 
	round(sum(revenue)::NUMERIC,2) as total_revenue
from revenue r
inner join products p
on r.product_id=p.product_id
group by 1
order by 2
)
select product_category_name, round(total_revenue*100/(select (sum(revenue)::NUMERIC) from revenue),2) as kontribusi
from kumulatif
