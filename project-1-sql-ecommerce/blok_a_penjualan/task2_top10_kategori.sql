-- Task 2: Top 10 kategori produk berdasarkan total revenue
-- Tujuan: Identifikasi kategori paling menguntungkan beserta AOV dan jumlah ordernya
-- Tabel: orders, order_items, products

with revenue as (
select oi.order_id, product_id, price+freight_value revenue from order_items oi
inner join orders o
on oi.order_id=o.order_id
where order_status = 'delivered'
)
, top10_category as 
(select product_category_name, round(sum(revenue)::NUMERIC,2) as total_revenue, 
	count(distinct order_id) as total_penjualan
from revenue r
inner join products p
on r.product_id=p.product_id
where product_category_name is not NULL
group by 1
order by 2 desc
limit 10)
select *,round(total_revenue/total_penjualan,2) as rata2_harga_tiap_penjualan
from top10_category

