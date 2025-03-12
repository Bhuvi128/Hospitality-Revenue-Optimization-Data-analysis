use atliq_hospitality_db;

/* 1. Retreive total revenue generated and revenue realised */

select avg(revenue_generated) avg_rev_generated, avg(revenue_realized) avg_rev_realized
from fact_bookings;

/* 2. Retreive average revenue generated and revenue realized for each property */

select dh.property_name, round(avg(revenue_generated),2) avg_revenue_generated, round(avg(revenue_realized),2) avg_revenue_realized
from fact_bookings fb left join dim_hotels dh
on fb.property_id = dh.property_id
group by dh.property_name;

select * from dim_hotels;







