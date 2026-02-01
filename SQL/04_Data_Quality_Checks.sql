-- ================================ --
-- Comparing Raw Rows VS Clean Rows --
-- ================================ --

select
	(select count(*) from portofolio.e_commerce_raw) as raw_rows,
    (select count(*) from portofolio.e_commerce_clean) as clean_rows;


-- ==================== --
-- Check Invalid Values --
-- ==================== --

select
	min(Order_Value),
    max(Order_Value),
    min(Quantity),
    max(Quantity),
    min(Delivery_Time_Days),
	max(Delivery_Time_Days)
from
	portofolio.e_commerce_clean
;


-- =========================== --
-- Total Amount VS Order Value --
-- =========================== --

select
	count(*) as total_orders,
	sum(case
		when abs(total_amount - order_value) > 0.01 then 1 else 0
    end) as mismatch_orders
from
	portofolio.e_commerce_clean
;


-- Purpose: Identify data inconsistency between system total and calculated order value --

