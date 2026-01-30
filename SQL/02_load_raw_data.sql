load data infile
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce_raw.csv'
into table
	portofolio.e_commerce_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
;
