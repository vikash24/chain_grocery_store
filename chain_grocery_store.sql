select * from geography_dim
select * from sales_fact
select * from category_dim

-- What is the highest sales amount in a day?
select date, sum(quantity*priceusd) as sales
from sales_fact 
group by date
order by sales desc

-- What is the total sales of the category ‘Dairy’?
select b.category_desc, sum(a.quantity*a.priceusd) as sales
from sales_fact a
inner join category_dim b
on a.product_id = b.product_id
where b.category_desc='Dairy'
group by b.category_desc

-- Which city has the highest sales?
select b.city, sum(a.quantity*a.priceusd) as sales
from sales_fact a 
inner join geography_dim b 
on a.store_id=b.store_id
group by city
order by sales desc, city

-- How many customers spent less than Rs. 3000?
select count(*) from
(select customer_id, sum(quantity*priceusd) as sales
from sales_fact
group by customer_id
having sales<3000
) a

-- What is the sales of the category ‘Cereals’ in the city Bangalore?
select category_desc, sum(priceusd*quantity) as sales
from sales_fact a 
inner join category_dim b 
on a.product_id = b.product_id
inner join geography_dim c 
on a.store_id = c.store_id
where category_desc='Cereals'
and city='Bangalore'
group by category_desc

-- Which category is the top category in terms of sales for the location Mumbai?
select category_desc, sum(priceusd*quantity) as sales
from sales_fact a 
inner join category_dim b 
on a.product_id = b.product_id
inner join geography_dim c 
on a.store_id = c.store_id
where city='Mumbai'
group by category_desc
order by sales desc

-- What is the highest sales value of category Drinks and Beverages in a single transaction? Value should reflect only sales of the mentioned category.
select transaction_id, sum(quantity*priceusd) as sales
from sales_fact a 
inner join category_dim b 
on a.product_id = b.product_id
where category_desc='Drinks & Bevrages'
group by transaction_id
order by sales desc

-- What is the average amount spent per customer in Chennai?
select city, sum(priceusd*quantity)/count(distinct customer_id) as avg_amt_spent
from sales_fact a 
inner join geography_dim b 
on a.store_id = b.store_id
where city = 'Chennai'
group by city

-- What is the sales amount of the lowest selling product in ‘Cereals’?
select product_desc, sum(quantity*priceusd) as sales
from sales_fact a
inner join category_dim b 
on a.product_id=b.product_id
where category_desc = 'Cereals'
group by product_desc
order by sales

-- What is the average revenue per customer in Maharashtra?
select state, sum(quantity*priceusd)/count(distinct customer_id) as avg_revenue_per_cust
from sales_fact a 
inner join geography_dim b 
on a.store_id = b.store_id
where state='Maharashtra'
group by state

-- How many customers in Karnataka spent less than Rs 3000?
select count(*) from (select customer_id, sum(quantity*priceusd) as sales
from sales_fact a 
inner join geography_dim b 
on a.store_id = b.store_id
where state = 'Karnataka'
group by customer_id
having sales<3000
) c 


-- How many cities have average revenue per customer lesser than Rs 3500?
select count(*) from (select city, sum(quantity*priceusd)/count(distinct customer_id) as avg_revenue_per_cust_by_city
from sales_fact a 
inner join geography_dim b 
on a.store_id = b.store_id
group by city
having avg_revenue_per_cust_by_city<3500
order by avg_revenue_per_cust_by_city) a

-- Which product was bought by the most number of customers?
select product_id, count(distinct customer_id) as count_of_product
from sales_fact
group by product_id
order by count_of_product desc

-- How many products were bought by at least 5 customers in Maharashtra?
select count(*) from (select product_id, count(distinct customer_id) as count_of_product
from sales_fact a 
inner join geography_dim b 
on a.store_id = b.store_id
where state='Maharashtra'
group by product_id
having count_of_product>=5
order by count_of_product desc) s  

-- What is the highest average amount spent per product by a customer?
select customer_id, sum(priceusd*quantity)/sum(quantity) avg_amt_spent
from sales_fact
group by customer_id
order by avg_amt_spent desc