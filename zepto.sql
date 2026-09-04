drop table if exists zepto;
create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOFStock BOOLEAN,
Quantity INTEGER
);
-- Data Exploration
select count(*) from zepto;

select * from zepto limit 10;
-- Null
select * from zepto where
name is NULL 
or
category is NULL 
or
mrp is NULL 
or
discountpercent is NULL 
or
availablequantity is NULL 
or
discountedsellingprice is NULL 
or
weightingms is NULL 
or
quantity is NULL 
or
outofstock is NULL ;
--category
select distinct category from zepto order by category;
--products in stock vs outofstock
select outOFStock, count(sku_id) from zepto group by outOFStock;
--product names present multiple times
select name ,count(sku_id) 
from zepto 
group by name
having count(sku_id)>1
order by count(sku_id) DESC;
-- Data Cleaning
Select * from zepto
where mrp=0 or discountedSellingPrice=0;

Delete from zepto where mrp=0;
--Convert paise to rupees
Update zepto set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;
Select mrp, discountedSellingPrice from zepto;
--Q1 Find the top 10 best-value products based on the discount percentage.
select distinct name, mrp, discountpercent from zepto 
order by discountpercent desc 
limit 10;
--Q2.What are the Products with High MRP but Out of Stock
Select distinct name, mrp from zepto
where outofstock=True
order by mrp desc;
--Q3. Calculate estimated revenue for each category.
select category ,
sum(discountedsellingprice*availablequantity) as total_revenue from zepto
group by category
order by total_revenue;
--Q4.Find all products where MRP is greater than rs 500 and discount is less than 10%
Select distinct name , mrp, discountpercent from zepto 
where mrp>500 And discountpercent<10
order by mrp desc, discountpercent desc;
--Q5. Identify the top 5 categories offering the highest average discount percentage.
Select category, round(avg(discountpercent),2) as avg_discountpercent from zepto
group by category
order by avg_discountpercent desc limit 5 ;
--Q6. Find the price per gram for products above 100g and sort by best value.
Select distinct name,weightingms,discountedsellingprice,round((discountedsellingprice/weightingms),2) as price_per_gm from zepto
where weightingms>=100
order by price_per_gm asc;
--Q7. Group the products into categories like Low, Medium, Bulk.
Select Distinct name, weightingms,
CASE
when weightingms<1000 Then 'Low'
when weightingms<5000 Then 'Medium'
else 'Bulk'
End as weight_category
from zepto;
--Q8. What is the Total Inventory Weight per category.
Select category,
sum(weightingms * availablequantity) as total_weight
from zepto
group by category 
order by total_weight;