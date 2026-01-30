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
