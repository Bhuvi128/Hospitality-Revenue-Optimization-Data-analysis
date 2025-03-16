use atliq_hospitality_db;

/* 1. Retreive average revenue generated and revenue realized by booking_status */

select booking_status, round(avg(revenue_generated),2) avg_rev_generated, round(avg(revenue_realized),2) avg_rev_realized
from fact_bookings
group by booking_status;

/* Insights:
The average of revenue generated and revenue realized is equal for both no show and checked out,
but for cancelled bookings there is significant difference */

/* 2. Retreive average revenue generated and revenue realized by room category */

select dr.room_class, round(avg(fb.revenue_generated),2) avg_revenue_generated, 
round(avg(fb.revenue_realized),2) avg_revenue_realized
from fact_bookings fb left join dim_rooms dr
on fb.room_category = dr.room_id
group by dr.room_class;

/* Insights:
There is a significant difference for average revenue generated and average revenue realized
for all room class, indicating in all room class there may be cancelled bookings so there would 
be fincancial impact in this pattern.
*/

select * from fact_aggregated_bookings;

