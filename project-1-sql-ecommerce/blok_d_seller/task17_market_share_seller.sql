-- Task 17: Market share revenue per seller
-- Tujuan: Mengukur konsentrasi revenue — apakah platform bergantung pada segelintir seller
-- Tabel: order_items, orders, sellers


-- Task 17: Market share revenue per seller
-- Tujuan: Mengukur konsentrasi revenue — apakah platform bergantung pada segelintir seller
-- Tabel: order_items, orders, sellers

-- Task 17: Market share revenue per seller
-- Tujuan: Mengukur konsentrasi revenue — apakah platform bergantung pada segelintir seller
-- Tabel: order_items, orders, sellers

with revenue_per_seller as (
select seller_id, round(sum(price+freight_value)::NUMERIC,2) as revenue
from order_items oi
inner join orders o
on oi.order_id = o.order_id
where order_status = 'delivered'
group by 1),
kontribusi_per_seller as (
select seller_id, 
	round(revenue*100.0/(select sum(revenue) from revenue_per_seller),7) as kontribusi_persen
from revenue_per_seller)
select *,rank() over(order by kontribusi_persen desc) as rank_kontribusi
from kontribusi_per_seller