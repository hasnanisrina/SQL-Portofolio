/*Exploration Data in SQL used postgreSQL
Skills Used: Agrregate, Join, Subquery, CTE
Dataset: https://tinyurl.com/CoffeeShopData */

--Top Store Address Sales
Select o.store_address, sum(t.order) as sum_order, sum(t.quantity) as sum_quantity
From transaction_data t
Join outlet_data o
on t.sales_outlet_id =o.sales_outlet_id 
Group by 1
Order by sum_order DESC
Limit 1

--Top Customer Sales
Select c.loyalty_card_number, sum(t.order) as sum_order, sum(t.quantity) as sum_quantity
From transaction_data t
Join customer_data c
on t.customer_id  =c.customer_id 
Group by 1
order by sum_order DESC
Limit 5

--Top Product Sales
Select  p.product, p.product_category, sum(t.order) as sum_order, sum(t.quantity) as sum_quantity
From transaction_data t
Join product_data p
on t.product_id  =p.product_id 
Group by 1,2
Order by sum_order DESC
Limit 3

--Total Revenue for Each Day
Select transaction_date, count(transaction_date), sum(unit_price) as sum_revenue
From transaction_data
Group by 1
Order by sum_revenue

--Total Number of Unique Customer for Each Day
Select transaction_date, count(distinct customer_id) as unique_cust
From transaction_data
Group by 1
Order by unique_cust DESC

--The Average Customer Spend by Month (Definition: average customer spend: total customer spend divided by the unique number of customers for that month)
Select transaction_date, sum(unit_price)/count(distinct customer_id) as avg_spend
From transaction_data
Group by 1
Order by avg_spend DESC

--Customer Who Never Order
Select loyalty_card_number
From customer_data
Where customer_id not in (Select customer_id
From transaction_data)

--Top 3 Product In Each City
With Top_Product as
(Select  p.product,t.sales_outlet_id, sum(t.order) as sum_order
From transaction_data t
Join product_data p
on t.product_id  =p.product_id 
Group by 1,2
Order by sum_order DESC)
Select store_city, p.product, p.sum_order
From outlet_data o
Join Top_Product p
on o.sales_outlet_id = p.sales_outlet_id
Order by sum_order DESC
Limit 3

--The Longest Working Staff
Select first_name, last_name, position
From staff_data
Order by start_date
Limit 3

