show databases;
use retail_events_db;
select * from dim_campaigns as dc;
select * from dim_products as dp;
select * from dim_stores as ds;
select * from fact_events as fe;
select distinct(category) from dim_products;
# products which are costs more the 500 and promotype='buy one get one free'
select distinct(product_name) from dim_products inner join fact_events on fact_events.product_code=dim_products.product_code where base_price>500 and promo_type='BOGOF';

#store count in each city in desending order
select distinct(city),count(store_id) from dim_stores group by city order by count(store_id) desc ;

#product names according to their promotype
select distinct(promo_type),product_name from fact_events inner join dim_products
on  dim_products.product_code=fact_events.product_code;


# top 5 maximum price products in the stores
select product_name,max(base_price) from fact_events inner join dim_products
on  dim_products.product_code=fact_events.product_code group by product_name
order by max(base_price) desc limit 5;

#total revenue before promo
 SELECT sum(base_price*`quantity_sold(before_promo)`) as total_revenue_before_promo,campaign_name
 FROM `retail_events_db`.`fact_events` inner join dim_campaigns 
on dim_campaigns.campaign_id= `retail_events_db`.`fact_events`.campaign_id group by campaign_name ;

#total revenue after promo
SELECT sum(base_price*`quantity_sold(after_promo)`) as total_revenue_after_promo,campaign_name FROM `retail_events_db`.`fact_events` inner join dim_campaigns 
on dim_campaigns.campaign_id= `retail_events_db`.`fact_events`.campaign_id group by campaign_name;

#total quantity sales after and before promo
SELECT sum(`quantity_sold(before_promo)`) FROM `retail_events_db`.`fact_events`;
SELECT sum(`quantity_sold(after_promo)`) FROM `retail_events_db`.`fact_events`;

#calculate ISU in Diwali
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

#top 5 products
select distinct(product_name),(sum(base_price*`quantity_sold(after_promo)`)-sum(base_price*`quantity_sold(before_promo)`)) as IR from `retail_events_db`.`fact_events` 
inner join dim_campaigns
on dim_campaigns.campaign_id=`retail_events_db`.`fact_events`.campaign_id
inner join dim_products
on dim_products.product_code=`retail_events_db`.`fact_events`.product_code
group by product_name
order by IR desc limit 5;
