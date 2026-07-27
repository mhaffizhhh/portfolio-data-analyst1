-- Task 13: Korelasi keterlambatan pengiriman dengan review score rendah
-- Tujuan: Mengukur dampak keterlambatan terhadap kepuasan customer
-- Tabel: orders, order_reviews

with review_score as (
select review_score, 
	case
	when order_delivered_customer_date > order_estimated_delivery_date then 'Late'
	else 'On Time'
	end as kriteria
from orders o
inner join order_reviews ore
on o.order_id = ore.order_id
where order_status = 'delivered')
select kriteria, round(avg(review_score),2) as avg_review_score
from review_score
group by 1