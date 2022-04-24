/*Data Preparation
Skills Used: Agrregate, Join, Subquery, CTE*/

--Select all data
select *
from courier

--Change Delay or Ontime from 0 to Ontime and 1 to Delay
select delay_or_ontime,
case when delay_or_ontime = '0' then 'Ontime'
when delay_or_ontime='1' then 'Delay'
end
from courier

update courier
set delay_or_ontime= case when delay_or_ontime = '0' then 'Ontime'
when delay_or_ontime='1' then 'Delay'
end

--Make Range of Price of Product
select cost_of_the_product,
case when cost_of_the_product >4000000 then '>IDR 4 Mio'
when cost_of_the_product between 3000000 and 4000000 then 'IDR 3 Mio - IDR 4 Mio'
when cost_of_the_product between 2000000 and 2999999 then 'IDR 2 Mio - IDR 3 Mio'
when cost_of_the_product <2000000 then '<IDR 2 Mio'
end
from courier

alter table courier
add price_of_product varchar(100)

update courier
set price_of_product = case when cost_of_the_product >4000000 then '>IDR 4 Mio'
when cost_of_the_product between 3000000 and 4000000 then 'IDR 3 Mio - IDR 4 Mio'
when cost_of_the_product between 2000000 and 2999999 then 'IDR 2 Mio - IDR 3 Mio'
when cost_of_the_product <2000000 then '<IDR 2 Mio'
end

--Define Discount Percentage
select cost_of_the_product, discount_offered,
round(discount_offered * 100.0 / cost_of_the_product,2) as discount_percentage
from courier

alter table courier
add discount_percentage numeric

update courier
set discount_percentage = round(discount_offered * 100.0 / cost_of_the_product,2)

--Outlier Detection
with iqr as (select
    percentile_25,
    percentile_75,
    (percentile_75 - percentile_25) as iqr_5 
	from
    (select
	 percentile_disc(0.5) within group (order by discount_offered) as percentile_25,
	 percentile_disc(0.5) within group (order by discount_offered) as percentile_75
	 from courier))
select id, 
	 case when discount_offered >= percentile_75 + iqr_5 then 'out of upper bound'
	 when discount_offered <= percentile_25 + iqr_5 then 'out of lower bound'
	 else 'in bound' end as status_outlier
from (select id, discount_offered from courier
	 group by id, discount_offered),
	 iqr

--Delay on time int
alter table courier
add delay_ontime int

update courier
set delay_ontime= case when delay_or_ontime = 'Ontime' then  0
when delay_or_ontime='Delay' then 1
end

--Change Data Resolution
select c.id, c.expedition, c.mode_of_shipment, 
	'CUTOMER CARE CALLS' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.customer_care_calls as value
from courier c
left join mapping_province m
on c.province_code = m.province_code
union all
select c.id, c.expedition, c.mode_of_shipment, 
	'CUTOMER RATING' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.customer_rating as value
from courier c
left join mapping_province m
on c.province_code = m.province_code
union all
select c.id, c.expedition, c.mode_of_shipment, 
	'COST OF PRODUCT' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.cost_of_the_product as value
from courier c
left join mapping_province m
on c.province_code = m.province_code
union all
select c.id, c.expedition, c.mode_of_shipment, 
	'DISC.PERCENTAGE' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.discount_percentage as value
from courier c
left join mapping_province m
on c.province_code = m.province_code
union all
select c.id, c.expedition, c.mode_of_shipment, 
	'DISCOUNT OFFERED' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.discount_offered as value
from courier c
left join mapping_province m
on c.province_code = m.province_code
union all
select c.id, c.expedition, c.mode_of_shipment, 
	'PRIOR PURCHASE' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.prior_purchases as value
from courier c
left join mapping_province m
on c.province_code = m.province_code
union all
select c.id, c.expedition, c.mode_of_shipment, 
	'WEIGHT IN GMS' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.weight_in_gms as value
from courier c
left join mapping_province m
on c.province_code = m.province_code
union all
select c.id, c.expedition, c.mode_of_shipment, 
	'DELAY OT NOT' as indicator,
	c.product_importance, c.gender, c.province_code, 
	c.delay_ontime as value
from courier c
left join mapping_province m
on c.province_code = m.province_code