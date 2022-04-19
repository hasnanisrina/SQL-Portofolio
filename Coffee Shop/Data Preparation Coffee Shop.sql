/*Data Preparation for Tableau
Dataset: https://tinyurl.com/CoffeeShopData */

--Change N to Existing and Y to New in "New Product" Field
select new_product_yn, 
case when new_product_yn = 'N' then 'Existing'
when new_product_yn = 'Y' then 'New'
END
from product_data
 
Update product_data
Set new_product_yn = case when new_product_yn = 'N' then 'Existing'
when new_product_yn = 'Y' then 'New'
END

select *
from product_data

--Change trasaction_time to hour
select extract(hour from transaction_time) as hour
from transaction_data

alter table transaction_data
add hour int

Update transaction_data
Set hour = extract(hour from transaction_time)

select *
from transaction_data

--Define The Age and Make Range of Age customer
select date_part('year', age('2019-05-01',birthdate)) as age
from customer_data

alter table customer_data
add age int

Update customer_data
Set age =date_part('year', age('2019-05-01',birthdate))

select age,
case when age <25 then '<25'
when age between 25 and 35 then '25-35'
when age between 36 and 45 then '36-45'
when age between 46 and 55 then '46-55'
when age between 56 and 65 then '56-65'
else '>65'
end
from customer_data

alter table customer_data
add range_age varchar(50)

Update customer_data
Set range_age =case when age <25 then '<25'
when age between 25 and 35 then '25-35'
when age between 36 and 45 then '36-45'
when age between 46 and 55 then '46-55'
when age between 56 and 65 then '56-65'
else '>65'
end

--Determine How Long The Customer Subscribes
select date_part('year', age('2019-05-01',customer_since))
from customer_data

alter table customer_data
add loyalty int

Update customer_data
Set loyalty =date_part('year', age('2019-05-01',customer_since))

select loyalty,
case when loyalty = 0 then 'New Customer'
when loyalty = 1 then '1 Year'
when loyalty = 2 then '2 Year'
end
from customer_data

alter table customer_data
add loyalty_year varchar(50)

Update customer_data
Set loyalty_year =case when loyalty = 0 then 'New Customer'
when loyalty = 1 then '1 Year'
when loyalty = 2 then '2 Year'
end

select*
from customer_data