CREATE VIEW
  v_daily_revenue AS
SELECT
  order_date, SUM(order_value)
FROM
  portofolio.e_commerce_clean
GROUP BY
  order_date;


create view v_kpi_summary as
select
	count(*) as total_orders,
    sum(order_value) as total_revenue,
    avg(order_value) as avg_order_value
from
	portofolio.e_commerce_clean
;

