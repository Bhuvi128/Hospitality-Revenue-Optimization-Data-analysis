use atliq_hospitality_db;

/* ----------------------------------------  Data Preparation/cleaning  ---------------------------------- */

/* 1. Check for duplicates */

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



/* ------------------------------------   Data analysis ------------------------------------- */



/* 1. How many total bookings exist in the fact_bookings table? */

select count(*) total_bookings  -- Extracted total bookings using count of bookings from fact bookings table
from fact_bookings;

/* 2. What is the revenue generated and realized by each booking status? */

select booking_status, revenue_generated, revenue_realized
from fact_bookings;  -- Extracted revenue generated and realized by booking_status

/* 3. What is the revenue generated and realized for each room class? */

select dr.room_class, fb.revenue_generated, fb.revenue_realized
from fact_bookings fb left join dim_rooms dr
on fb.room_category = dr.room_id; -- Retreived revenue generated and realized for each room class by joining dim rooms table and fact bookings table

/* 4. For cancelled bookings, what is the revenue generated and realized for each room class? */

select dr.room_class, booking_status, revenue_generated, revenue_realized
from
(select * from fact_bookings
where booking_status = 'Cancelled') fb left join dim_rooms dr
on fb.room_category = dr.room_id; -- Fetched revenue generated and realized for each room class for cancelled bookings by joining dim room table and fact bookings table and filtered booking status cancelled.

/* 5. What is the revenue generated and realized by property category and booking status? */

select dh.category, fb.booking_status, fb.revenue_generated, fb.revenue_realized
from fact_bookings fb left join dim_hotels dh
on fb.property_id = dh.property_id; -- Gathered revenue generated and realized for each property category along with booking status by joining dim hotels table and fact booking table.

/* 6. What is the revenue generated and realized by property name and booking status? */

select dh.property_name, fb.booking_status, fb.revenue_generated, fb.revenue_realized 
from dim_hotels dh right join fact_bookings fb
on dh.property_id = fb.property_id; 

/* 7. What is the revenue generated and realized by property city and booking status? */

select dh.city, fb.booking_status, fb.revenue_generated, fb.revenue_realized
from dim_hotels dh right join fact_bookings fb
on dh.property_id = fb.property_id;



