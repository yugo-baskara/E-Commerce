-- ================== --
-- Create Clean Table --
-- ================== --

create table portofolio.e_commerce_clean (
Order_ID varchar (20) primary key,
Customer_ID varchar (20),
Order_Date date not null,
Age int,
Gender varchar (15),
City varchar (20),
Product_Category varchar (20),
Unit_Price decimal (10,2) not null,
Quantity int not null,
Discount_Amount decimal (10,2),
Total_Amount decimal (10,2),
Payment_Method varchar (20),
Device_Type varchar (20),
Session_Duration_Minutes int,
Pages_Viewed int,
Is_Returning_Customer tinyint(1),
Delivery_Time_Days int,
Customer_Rating int,
Order_Value decimal (10,2)
)
;


-- ============================= --
-- Loading Data Into Clean Table --
-- ============================= --

-- Order_Value represents net revenue per order (Unit_Price * Quality - Discount_Amount)

insert into
	portofolio.e_commerce_clean
select
	Order_Id,
	Customer_ID,
	Order_Date,
case
	when Age between 0 and 100 then Age
	else null
end,
lower(trim(Gender)),
    City,
    Product_Category,
    Unit_Price,
	Quantity,
    Discount_Amount,
    Total_Amount,
    lower(trim(Payment_Method)),
	lower(trim(Device_Type)),
    Session_Duration_Minutes,
    Pages_Viewed,
case
	when lower(trim(Is_Returning_Customer)) = 'true' then 1
	else 0
end,
	Delivery_Time_Days,
case
	when Customer_Rating between 1 and 5 then Customer_Rating
    else null
end,
	Unit_Price * Quantity - Discount_Amount
from
	portofolio.e_commerce_raw
;
