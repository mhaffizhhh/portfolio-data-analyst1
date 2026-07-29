-- Task 18: Distribusi metode pembayaran dan rata-rata nilai order per metode
-- Tujuan: Memahami preferensi pembayaran customer dan hubungannya dengan nilai transaksi
-- Tabel: order_payments, orders

select payment_type, count(distinct op.order_id) jumlah_order, 
	round((sum(payment_value)/count(distinct op.order_id))::NUMERIC, 2) avg_nilai_order
from order_payments op
inner join orders o
on op.order_id = o.order_id
where order_status = 'delivered'
group by 1