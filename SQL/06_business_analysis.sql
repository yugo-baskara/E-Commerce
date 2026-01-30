-- ============================================== --
-- Returning Customer Based On Spending Behaviour --
-- ============================================== --

-- Business Question : 
-- How many loyal customer are there, and how much do they spend on average?

select
	Is_Returning_Customer,
    count(distinct Customer_ID) as total_customer,
    sum(Order_Value) as total_revenue,
    avg(Order_Value) as avg_order_value
from
	portofolio.e_commerce_clean
group by
	Is_Returning_Customer
;


-- ===================================== --
-- Platform Performance Based On Revenue --
-- ===================================== --

-- Business Question :
-- Which platform generates the highest number of users and total revenue?


select
	device_type,
    count(*) as Total_User,
    sum(Order_Value) as Total_Revenue
from
	portofolio.e_commerce_clean
group by
	Device_Type
order by
	Total_User desc
;


-- ========================================== --
-- Delivery Time and Customer Rating Analysis --
-- ========================================== --

-- Business Question :
-- Is There a Relationship Between Delivery Time and Customer Ratings?

select
    Delivery_Time_Days,
	avg(Customer_Rating) as Avg_Rating
from
	portofolio.e_commerce_clean
group by
	Delivery_Time_Days
order by
	Delivery_Time_Days
;


-- =================== --
-- Daily Revenue Trend --
-- =================== --

-- Business Question :
-- Which Dates Generate The Highest Total Revenue?

select
	Order_Date,
    sum(Order_Value) as Total_Revenue
from
	portofolio.e_commerce_clean
group by
	Order_Date
order by
	Total_Revenue desc
;


CREATE VIEW v_daily_revenue AS
SELECT order_date, SUM(order_value)
FROM portofolio.e_commerce_clean
GROUP BY order_date;


select
	*
from
	v_daily_revenue
;

-- Purpose: Provide daily aggregated revenue for reporting and dashboarding


-- ============================================= --
-- Customer Segmentation Based On Total Spending --
-- ============================================= --

-- Business Question :
-- Who Are The Most Valuable Customer Based On Total Spending?

select
	Customer_ID,
    sum(Order_Value) as Total_Spending,
case
when sum(Order_Value) > 20000 then 'Diamond'
when sum(Order_Value) > 5000 then 'Gold'
when sum(Order_Value) > 100 then 'Silver'
else 'Bronze'
end as Customer_Category
from
	portofolio.e_commerce_clean
group by
	Customer_ID
order by
	total_spending desc, customer_category
;


-- ======================= --
-- Revenue Ranking By City --
-- ======================= --

-- Business Question :
-- Which city generates the highest revenue?

select
	City,
    sum(Order_Value) as Total_Revenue,
    rank() over (order by sum(Order_Value) desc) as Revenue_Rank
from
	portofolio.e_commerce_clean
group by
	City
order by
	Total_Revenue desc
;


-- =============================== --
-- Best Selling Product Categories --
-- =============================== --

-- Business Question:
-- Which Product Categories Generate The Highest Revenue?

select
	Product_Category,
    sum(Order_Value) as Total_Selling
from
	portofolio.e_commerce_clean
group by
	Product_Category
order by
	Total_Selling desc
;


-- ===================== --
-- Key Performance Index --
-- ===================== --

create view v_kpi_summary as
select
	count(*) as total_orders,
    sum(order_value) as total_revenue,
    avg(order_value) as avg_order_value
from
	portofolio.e_commerce_clean
;

select
	*
from
	v_kpi_summary
;

-- Purpose: Provide high-level business KPIs for executive reporting
