-- ===================================== --
-- Data Normalization and Transformation --
-- ===================================== --

select
	count(*) as total_rows,
    count(distinct order_id) as unique_orders
from
	portofolio.e_commerce_raw
;


-- ========================= --
-- Numerical Data Validation --
-- ========================= --

select
	min(Age), max(Age),
    min(Quantity), max(Quantity),
    min(Unit_Price), max(Unit_Price),
    min(Customer_Rating), max(Customer_Rating)
from
	portofolio.e_commerce_raw
;


select
	count(*) as total_rows,
    sum(case 
		when total_amount != (unit_price * quantity - discount_amount)
		then 1 else 0 end) as mismatch_rows
from
	portofolio.e_commerce_raw
;
