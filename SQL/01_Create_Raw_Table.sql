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
