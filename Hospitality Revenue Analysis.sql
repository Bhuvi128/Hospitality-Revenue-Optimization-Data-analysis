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

/* 3. Analyze which room class has higher successfull and cancelled bookings */

select dr.room_class, count(*) total_bookings, 
sum(case when fb.booking_status in ('Checked Out', 'No Show') then 1 else 0 end) successfull_bookings,
sum(case when fb.booking_status = 'Cancelled' then 1 else 0 end) cancelled_bookings
from fact_bookings fb left join dim_rooms dr
on fb.room_category = dr.room_id
group by dr.room_class;

/* Insights:
The Elite room class has higher successfull bookings and cancelled bookings.
The reason behind Elite room class higher in both successfull and cancelled bookings is because
of total bookings in Elite room class is higher than other room class. This may happen 
because more rooms booked there is likely to be more cancellations. */

/* 4. Analyze which room class has higher cancellation rate */

with room_bookings as (
select dr.room_class, count(*) total_bookings, 
sum(case when fb.booking_status = 'Cancelled' then 1 else 0 end) cancelled_bookings
from fact_bookings fb left join dim_rooms dr
on fb.room_category = dr.room_id
group by dr.room_class
)
select room_class, round((cancelled_bookings/total_bookings) * 100,2) cancellation_rate
from room_bookings;

/* Insights:
The cancellation rate for all room class are 24% to 25% approximately,
indicating there is no revenue loss pattern for specific room class.
So the revenue loss pattern may be in any other categories like
luxury or high cost Properties. Investigating other categories may reveal 
actionable insights. */

select * from fact_bookings;
select * from dim_hotels;

/* 5. Retreive average revenue generated and realized for each Property category */

select dh.category, round(avg(fb.revenue_generated),2) avg_revenue_generated, 
round(avg(fb.revenue_realized),2) avg_revenue_realized
from fact_bookings fb left join dim_hotels dh
on fb.property_id = dh.property_id
group by dh.category;

/* Insights:
The average revenue generated for Business Property is higher than Luxury Property,
indicating more bookings are in Business Properties. The difference of average 
between revenue generated and revenue realized suggesting there may be revenue 
loss due to cancelled bookings. So Investigating these may give actionable insights.
*/


















