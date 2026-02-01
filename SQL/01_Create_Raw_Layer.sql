-- ================ --
-- Create Raw Table --
-- ================ --

create table if not exists portofolio.e_commerce_raw
(Order_ID varchar (20),
Customer_ID varchar (20),
Order_Date date,
Age int,
Gender varchar (15),
City varchar (20),
Product_Category varchar (20),
Unit_Price decimal (10,2),
Quantity int,
Discount_Amount decimal (10,2),
Total_Amount decimal (10,2),
Payment_Method varchar (20),
Device_Type varchar (20),
Session_Duration_Minutes int,
Pages_Viewed int,
Is_Returning_Customer varchar (10),
Delivery_Time_Days int,
Customer_Rating int
)
;


-- ======================= --
-- Loading Data Into Table --
-- ======================= --

load data infile
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce_raw.csv'
into table
	portofolio.e_commerce_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
;


