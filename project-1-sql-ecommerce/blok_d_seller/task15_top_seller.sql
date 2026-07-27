-- Task 15: Top 10 seller berdasarkan total revenue
-- Tujuan: Identifikasi seller terbaik dari sisi revenue, variasi produk, dan kepuasan customer
-- Tabel: order_items, orders, sellers, order_reviews

with revenue as (
select oi.order_id, seller_id, product_id, price+freight_value as revenue
from order_items oi
inner join orders o
on oi.order_id = o.order_id
where order_status = 'delivered'),
data_seller as (
select r.order_id, r.seller_id, product_id, revenue, review_score
from revenue r
inner join order_reviews ore
on r.order_id = ore.order_id)
select seller_id, count(distinct product_id) as jumlah_produk_unik, 
	round(sum(revenue)::NUMERIC,2) as total_revenue, round(avg(review_score),2) as avg_review_skor
from data_seller
group by 1
order by 3 desc
limit 10