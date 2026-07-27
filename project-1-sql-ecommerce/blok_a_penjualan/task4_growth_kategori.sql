-- Task 4: Kategori produk dengan pertumbuhan revenue positif (2017 vs 2018)
-- Tujuan: Identifikasi kategori yang sedang tumbuh sebagai sinyal ekspansi bisnis
-- Tabel: orders, order_items, products

with revenue as (
select oi.order_id, product_id, extract(year from order_purchase_timestamp) as year, price+freight_value revenue
from order_items oi
inner join orders o
on oi.order_id=o.order_id
where order_status='delivered'
)
,
selisih as (
select product_category_name, year, round(sum(revenue)::NUMERIC,2) as total_revenue
from revenue r 
inner join products p
on r.product_id=p.product_id
where year in (2017,2018)
group by 1,2
)
, revenue1718 as (SELECT 
    product_category_name,
    MAX(CASE WHEN year = 2017 THEN total_revenue END) as revenue_2017,
    MAX(CASE WHEN year = 2018 THEN total_revenue END) as revenue_2018
FROM selisih
GROUP BY 1), grwth as (
select product_category_name, round((revenue_2018-revenue_2017)*100/revenue_2017,2) as growth
from revenue1718
where revenue_2017 is not null and revenue_2018 is not null)
select * from grwth where growth > 0 