-- Task 19: Pola penggunaan cicilan — jumlah cicilan vs nilai order
-- Tujuan: Menganalisis apakah customer yang memilih cicilan lebih banyak cenderung belanja lebih besar
-- Tabel: order_payments, orders

select floor(avg(payment_installments)) avg_payment_installments 
from order_payments op
inner join orders o
on op.order_id = o.order_id
where order_status = 'delivered';

with cicilan as (
select op.order_id,
case
when payment_installments = 1 then '1x'
when payment_installments between 2 and 6 then '2-6x'
when payment_installments between 7 and 12 then '7-12x'
else '>12' end as kelompok_cicilan,
payment_value
from order_payments op
inner join orders o
on op.order_id = o.order_id
where order_status = 'delivered' and payment_type = 'credit_card')
select kelompok_cicilan, count(distinct order_id) as jumlah_cicilan, 
	round((sum(payment_value)/count(distinct order_id))::NUMERIC,2) as avg_nilai_order
from cicilan
group by 1
