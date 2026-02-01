-- =============== --
-- Indexing Column --
-- =============== --

create index idx_customer_id on portofolio.e_commerce_clean(customer_id);
create index idx_order_date on portofolio.e_commerce_clean(order_date);
create index idx_category on portofolio.e_commerce_clean(product_category);


-- ===================== --
-- Check Constraint Data --
-- ===================== --

alter table portofolio.e_commerce_clean
add constraint chk_rating
check (customer_Rating between 1 and 5 or Customer_Rating is null)
;

