show databases;
use retail_events_db;
select * from dim_campaigns as dc;
select * from dim_products as dp;
select * from dim_stores as ds;
select * from fact_events as fe;
select distinct(category) from dim_products;
# products which are costs more the 500 and promotype='buy one get one free'(code basic 1st question question)
select distinct(product_name) from dim_products inner join fact_events on fact_events.product_code=dim_products.product_code where base_price>500 and promo_type='BOGOF';

#store count in each city in desending order(code basic 2nd  question)
select distinct(city),count(store_id) from dim_stores group by city order by count(store_id) desc ;

#product names according to their promotype
select distinct(promo_type),product_name from fact_events inner join dim_products
on  dim_products.product_code=fact_events.product_code;


# top 5 maximum price products in the stores
select product_name,max(base_price) from fact_events inner join dim_products
on  dim_products.product_code=fact_events.product_code group by product_name
order by max(base_price) desc limit 5;

#total revenue before promo( code basic 3rd question)
 SELECT sum(base_price*`quantity_sold(before_promo)`) as total_revenue_before_promo,campaign_name
 FROM `retail_events_db`.`fact_events` inner join dim_campaigns 
on dim_campaigns.campaign_id= `retail_events_db`.`fact_events`.campaign_id group by campaign_name ;

#total revenue after promo(code basic 3rd question)
SELECT sum(base_price*`quantity_sold(after_promo)`) as total_revenue_after_promo,campaign_name FROM `retail_events_db`.`fact_events` inner join dim_campaigns 
on dim_campaigns.campaign_id= `retail_events_db`.`fact_events`.campaign_id group by campaign_name;

#total quantity sales after and before promo
SELECT sum(`quantity_sold(before_promo)`) FROM `retail_events_db`.`fact_events`;
SELECT sum(`quantity_sold(after_promo)`) FROM `retail_events_db`.`fact_events`;

#calculate ISU in Diwali(codebasic 4th question)
select (sum(`quantity_sold(after_promo)`)-sum(`quantity_sold(before_promo)`))/sum(`quantity_sold(before_promo)`)*100 as isu,category from `retail_events_db`.`fact_events` 
inner join dim_campaigns
on dim_campaigns.campaign_id=`retail_events_db`.`fact_events`.campaign_id
inner join dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code
where campaign_name='Diwali'
group by category
order by isu;

#total units sold category wise 
select (sum(`quantity_sold(after_promo)`)+sum(`quantity_sold(before_promo)`)),category from `retail_events_db`.`fact_events`
inner join dim_campaigns
on dim_campaigns.campaign_id=`retail_events_db`.`fact_events`.campaign_id
inner join dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code
group by category
;

#top 5 products (code basics 5th question)
select distinct(product_name),(sum(base_price*`quantity_sold(after_promo)`)-sum(base_price*`quantity_sold(before_promo)`)) as IR from `retail_events_db`.`fact_events` 
inner join dim_campaigns
on dim_campaigns.campaign_id=`retail_events_db`.`fact_events`.campaign_id
inner join dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code
group by product_name
order by IR desc limit 5;

# Bottom 10 stores based on their ISU values
select dim_stores.store_id ,(sum(`quantity_sold(after_promo)`)-sum(`quantity_sold(before_promo)`))/sum(`quantity_sold(before_promo)`)*100 as isu
from `retail_events_db`.`fact_events`
inner join dim_stores
on dim_stores.store_id=`retail_events_db`.`fact_events`.store_id
group by dim_stores.store_id
order by isu asc
limit 10;

# Top 10 stores according to their Incremental values
select dim_stores.store_id,(sum(base_price*`quantity_sold(after_promo)`)-sum(base_price*`quantity_sold(before_promo)`)) as IR 
from `retail_events_db`.`fact_events`
inner join dim_stores
on dim_stores.store_id=`retail_events_db`.`fact_events`.store_id
group by dim_stores.store_id
order by IR 
limit 10;

#top 2 and bottom 2  promotion types on their Incremental revenue
select promo_type,(sum(base_price*`quantity_sold(after_promo)`)-sum(base_price*`quantity_sold(before_promo)`)) as IR 
from `retail_events_db`.`fact_events`
group by promo_type
order by IR desc;

#Total revenue
 SELECT sum(base_price*`quantity_sold(before_promo)`)+sum(base_price*`quantity_sold(after_promo)`) as total_revenue
 FROM `retail_events_db`.`fact_events` inner join dim_campaigns 
on dim_campaigns.campaign_id= `retail_events_db`.`fact_events`.campaign_id ;

# Total revenue by each city
 SELECT sum(base_price*`quantity_sold(before_promo)`)+sum(base_price*`quantity_sold(after_promo)`) as total_revenue,city
 FROM `retail_events_db`.`fact_events` inner join dim_stores 
 on dim_stores.store_id=`retail_events_db`.`fact_events`.store_id group by city order by total_revenue desc;

#Incremental Revenue ratio(incremental_revenue/total revenue)
 select (sum(base_price*`quantity_sold(after_promo)`)-sum(base_price*`quantity_sold(before_promo)`))/(sum(base_price*`quantity_sold(before_promo)`)+sum(base_price*`quantity_sold(after_promo)`)) 
 as Incremental_revenue_ratio
 FROM `retail_events_db`.`fact_events`;
 
 #IRPU
select (sum(base_price*`quantity_sold(after_promo)`)-sum(base_price*`quantity_sold(before_promo)`))/((sum(`quantity_sold(after_promo)`)-sum(`quantity_sold(before_promo)`))/sum(`quantity_sold(before_promo)`))*100
AS INCREMENTAL_REVENUE_PER_UNIT
FROM `retail_events_db`.`fact_events`;  

#ARPU
SELECT (sum(base_price*`quantity_sold(before_promo)`)+sum(base_price*`quantity_sold(after_promo)`))/(sum(`quantity_sold(after_promo)`)+sum(`quantity_sold(before_promo)`))
AS AVERAGE_REVENUE_PER_UNIT
FROM `retail_events_db`.`fact_events`;  

# NO. OF UNITS SOLD BY EACH CATEGORY
SELECT (sum(`quantity_sold(after_promo)`)+sum(`quantity_sold(before_promo)`)) AS UNIT_SOLD,category
FROM `retail_events_db`.`fact_events` INNER JOIN dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code 
group by category;

#INCREMENTAL REV BY EACH CATEGORY
 select (sum(base_price*`quantity_sold(after_promo)`)-sum(base_price*`quantity_sold(before_promo)`)) AS IR,category
FROM `retail_events_db`.`fact_events` INNER JOIN dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code 
group by category 
ORDER BY IR DESC;

#total revenue by each category
SELECT sum(base_price*`quantity_sold(before_promo)`)+sum(base_price*`quantity_sold(after_promo)`) as total_revenue,category
FROM `retail_events_db`.`fact_events` INNER JOIN dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code 
group by category 
ORDER BY total_revenue DESC;

# ISU BY EACH CATEGORY
select ((sum(`quantity_sold(after_promo)`)-sum(`quantity_sold(before_promo)`))/sum(`quantity_sold(before_promo)`))*100 as ISU,category
FROM `retail_events_db`.`fact_events`INNER JOIN dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code 
group by category 
ORDER BY ISU DESC;


 

