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
