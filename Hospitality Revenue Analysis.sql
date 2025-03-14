use atliq_hospitality_db;

/* 1. Retreive average revenue generated and revenue realized by booking_status */

select booking_status, round(avg(revenue_generated),2) avg_rev_generated, round(avg(revenue_realized),2) avg_rev_realized
from fact_bookings
group by booking_status;

/* Insights:
The average of revenue generated and revenue realized is equal for both no show and checked out,
but for cancelled bookings there is significant difference */

