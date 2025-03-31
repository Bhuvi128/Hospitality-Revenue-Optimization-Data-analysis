/*
===============================================================================================================================================================================
===============================================================================================================================================================================
								-- Hospitality Revenue Optimization --
===============================================================================================================================================================================
===============================================================================================================================================================================

*/

-- Problem Statement:
/*
AtliQ Grands owns multiple five-star hotels across India. They have been in the hospitality industry for the past 20 years. 
Due to strategic moves from other competitors and ineffective decision-making in management, AtliQ Grands are losing its market share 
and revenue in the luxury/business hotels category. As a strategic move, the managing director of AtliQ Grands wanted to 
incorporate “Business and Data Intelligence” to regain their market share and revenue. However, they do not have an in-house data analytics
team to provide them with these insights.
Their revenue management team had decided to hire a 3rd party service provider to provide them with insights from their historical data.
*/

use atliq_hospitality_db;

/*
===================================================================================================================================================
----------------------------------------  Data Preparation and cleaning  --------------------------------------------------------------------------
===================================================================================================================================================
*/


-- Are there duplicate entries in the fact_bookings table?

select * from
(select *, count(*) over(partition by booking_id) as dup_count 
from fact_bookings) dup_check
where dup_count > 1;  -- using window function, extracted duplicate entries in fact bookings table. There is no duplicates.

-- Investigate duplicates in fact_aggregated_bookings — do they have distinct features?

select * from
(select *, count(*) over(partition by property_id) as dup_count
from fact_aggregated_bookings) dup_check
where dup_count > 1; -- There is duplicates in fact aggregated bookings table, but every duplicates have different features.

-- Confirm if dim_hotels contains any duplicate property_id values.

select * from
(select *, count(*) over(partition by property_id) dup_count
from dim_hotels) dup_check
where dup_count > 1; -- There is no duplicate entries based on property_id in dim hotels table

-- Check for duplicates in dim_rooms — are any found?

select * from
(select *, count(*) over(partition by room_id) dup_count
from dim_rooms) dup_check
where dup_count > 1; -- No duplicates

-- Are there duplicate entries in the dim_date table?

select * from
(select *, count(*) over(partition by date_d) dup_count
from dim_date) dup_check
where dup_count > 1; -- No duplicates

/* 2. Check for data types */

-- Are there any invalid data types in fact_bookings?
describe fact_bookings; -- No invalid data types

-- Verify if data types in fact_aggregated_bookings are valid.
describe fact_aggregated_bookings; -- Data types in fact aggregated bookings table are valid;

-- Verify if data types in dim_hotels are valid.
describe dim_hotels; -- Data types are valid in dim hotels table

-- Are there any invalid data types in dim_rooms?
describe dim_rooms; -- Valid data types

-- Are there any invalid data types in dim_date?
describe dim_date; -- valid data types

/*
=======================================================================================================================================================
------------------------------------------------------- Exploratory Data analysis ---------------------------------------------------------------------
=======================================================================================================================================================
*/

/* How many total bookings exist in the fact_bookings table? */

select count(*) total_bookings  
from fact_bookings;

/* How are bookings distributed among different booking statuses? */

select booking_status, count(*) total_bookings
from fact_bookings
group by booking_status;

/* Retreive revenue generated from fact bookings to calculate summary statistics and its distribution analysis */

select revenue_generated from fact_bookings;

/* Retreive revenue realized from fact bookings to calculate summary statistics and its distribution analysis */

select revenue_realized from fact_bookings;

/* Retreive revenue generated and realized and check relationship between them */

select revenue_generated, revenue_realized from fact_bookings;

/* Does booking status impact the difference between revenue generated and revenue realized? */

select booking_status, revenue_generated, revenue_realized
from fact_bookings;  

/* How bookings are distributed among room class */

select dr.room_class, count(*) total_bookings
from dim_rooms dr right join fact_bookings fb
on dr.room_id = fb.room_category
group by dr.room_class;

/* What is the revenue generated and realized for each room class? */

select dr.room_class, fb.revenue_generated, fb.revenue_realized
from fact_bookings fb left join dim_rooms dr
on fb.room_category = dr.room_id; 

/* For cancelled bookings, what is the revenue generated and realized for each room class? */

select dr.room_class, booking_status, revenue_generated, revenue_realized
from
(select * from fact_bookings
where booking_status = 'Cancelled') fb left join dim_rooms dr
on fb.room_category = dr.room_id; 

/* What is the revenue generated and realized by property category and booking status? */

select dh.category, fb.booking_status, fb.revenue_generated, fb.revenue_realized
from fact_bookings fb left join dim_hotels dh
on fb.property_id = dh.property_id; 

/* What is the revenue generated and realized by property name and booking status? */

select dh.property_name, fb.booking_status, fb.revenue_generated, fb.revenue_realized 
from dim_hotels dh right join fact_bookings fb
on dh.property_id = fb.property_id; 

/* What is the revenue generated and realized by property city and booking status? */

select dh.city, fb.booking_status, fb.revenue_generated, fb.revenue_realized
from dim_hotels dh right join fact_bookings fb
on dh.property_id = fb.property_id;

/* what is the revenue generated and realized by booking month? */

select month(booking_date) booking_month, booking_status, revenue_generated, revenue_realized
from fact_bookings
order by booking_month;


select * from fact_bookings;




