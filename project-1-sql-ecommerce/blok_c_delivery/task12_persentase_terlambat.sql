-- Task 12: Persentase keterlambatan pengiriman per state dan per kategori produk
-- Tujuan: Mengidentifikasi wilayah dan kategori dengan SLA pengiriman terburuk
-- Tabel: orders, order_items, products, customers

with id as (
select product_id, customer_id, order_delivered_customer_date, order_estimated_delivery_date
from orders o
inner join order_items oi
on o.order_id = oi.order_id
where order_status='delivered'),
cust_state as (
select product_id, customer_state, order_delivered_customer_date, order_estimated_delivery_date
from id
inner join customers c
on id.customer_id = c.customer_id),
cust_state_category as (
select product_category_name, customer_state, order_delivered_customer_date, order_estimated_delivery_date
from cust_state
inner join products p
on cust_state.product_id = p.product_id),
terlambat_product as (
select product_category_name, count(*) as jumlah_order_telat
from cust_state_category
where order_delivered_customer_date > order_estimated_delivery_date
group by 1),
full_order as (
select product_category_name, count(*) as jumlah_order
from cust_state_category
group by 1),
category as (
select 'kategori' as tipe,tp.product_category_name, 
	round(jumlah_order_telat*100.0/jumlah_order,2) as persentase_telat
from terlambat_product tp
left join full_order fu
on tp.product_category_name = fu.product_category_name 
where tp.product_category_name is not null),
terlambat_state as (
select customer_state, count(*) as jumlah_order_telat
from cust_state_category
where order_delivered_customer_date > order_estimated_delivery_date
group by 1),
full_order2 as (
select customer_state, count(*) as jumlah_order
from cust_state_category
group by 1),
state as (
select 'state' as tipe, ts.customer_state, 
	round(jumlah_order_telat*100.0/jumlah_order,2) as persentase_telat
from terlambat_state ts
left join full_order2 fu
on ts.customer_state = fu.customer_state 
where ts.customer_state is not null)
select * from category
union all
select * from state
order by 3 desc