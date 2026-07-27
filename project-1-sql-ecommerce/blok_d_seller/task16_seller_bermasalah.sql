-- Task 16: Seller dengan review score rendah tapi volume order tinggi
-- Tujuan: Identifikasi seller bermasalah yang berpotensi merusak reputasi platform
-- Tabel: order_items, orders, order_reviews

with data_id as (
select oi.order_id, seller_id
from order_items oi
inner join orders o
on oi.order_id = o.order_id
where order_status = 'delivered'),
review_score as (
select di.order_id, di.seller_id, review_score
from data_id di
inner join order_reviews ore
on di.order_id = ore.order_id)
select seller_id, count(distinct order_id) jumlah_orderan, round(avg(review_score),2) as avg_review_score
from review_score
group by 1
having avg(review_score) < 3
order by 2 desc, 3 asc
