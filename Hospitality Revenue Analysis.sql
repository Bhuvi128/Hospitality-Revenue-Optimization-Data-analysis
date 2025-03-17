use atliq_hospitality_db;

/* ----------------------------------------  Data Preparation/cleaning  ---------------------------------- */

/* 1. Check for duplicates */

-- Lets check duplicates for fact bookings table

select * from
(select *, count(*) over(partition by booking_id) as dup_count 
from fact_bookings) dup_check
where dup_count > 1;  -- using window function, extracted duplicate entries in fact bookings table. There is no duplicates.

-- Lets check duplicates for fact aggregated bookings table

select * from
(select *, count(*) over(partition by property_id) as dup_count
from fact_aggregated_bookings) dup_check
where dup_count > 1; -- There is duplicates in fact aggregated bookings table, but every duplicates have different features.

-- Lets check duplicates for dim hotels table

select * from
(select *, count(*) over(partition by property_id) dup_count
from dim_hotels) dup_check
where dup_count > 1; -- There is no duplicate entries based on property_id in dim hotels table

-- Lets check duplicates for dim rooms table

select * from
(select *, count(*) over(partition by room_id) dup_count
from dim_rooms) dup_check
where dup_count > 1; -- No duplicates

-- Lets check duplicates for dim date table

select * from
(select *, count(*) over(partition by date_d) dup_count
from dim_date) dup_check
where dup_count > 1; -- No duplicates

/* 2. Check for data types */

-- Lets check for fact bookings table
describe fact_bookings; -- No invalid data types

-- Lets check for fact aggregated bookings
describe fact_aggregated_bookings; -- Data types in fact aggregated bookings table are valid;

-- Lets check for dim hotels table
describe dim_hotels; -- Data types are valid in dim hotels table

-- Lets check for dim rooms table
describe dim_rooms; -- Valid data types

-- Lets check for dim date table
describe dim_date; -- valid data types



/* ------------------------------------   Data analysis ------------------------------------- */



/* 1. Retreive total bookings from fact_bookings table */

select count(*) total_bookings  -- Extracted total bookings using count of bookings from fact bookings table
from fact_bookings;

/* 2. Gather revenue generated and realized by booking status */

select booking_status, revenue_generated, revenue_realized
from fact_bookings;  -- Extracted revenue generated and realized by booking_status

/* 3. Fetch revenue generated and realized by room class */

select dr.room_class, fb.revenue_generated, fb.revenue_realized
from fact_bookings fb left join dim_rooms dr
on fb.room_category = dr.room_id; -- Retreived revenue generated and realized for each room class by joining dim rooms table and fact bookings table

/* 4. Obtain revenue generated and realized by room class for cancelled bookings */

select dr.room_class, booking_status, revenue_generated, revenue_realized
from
(select * from fact_bookings
where booking_status = 'Cancelled') fb left join dim_rooms dr
on fb.room_category = dr.room_id; -- Fetched revenue generated and realized for each room class for cancelled bookings by joining dim room table and fact bookings table and filtered booking status cancelled.

/* 5. Acquire revenue generated and realized by property category along with booking status */

select dh.category, fb.booking_status, fb.revenue_generated, fb.revenue_realized
from fact_bookings fb left join dim_hotels dh
on fb.property_id = dh.property_id; -- Gathered revenue generated and realized for each property category along with booking status by joining dim hotels table and fact booking table.

/* 6. Fetch revenue generated and realized by property name along with booking status*/

select dh.property_name, fb.booking_status, fb.revenue_generated, fb.revenue_realized 
from dim_hotels dh right join fact_bookings fb
on dh.property_id = fb.property_id; 






