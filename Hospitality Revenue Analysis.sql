/* 1. Retreive total property for each property category */

select category, count(*) as tot_cust from dim_hotels
group by category;


/* 1. Retreive the data for total no of guests for each property category*/

select dh.category, sum(fb.no_guests)
from fact_bookings fb left join dim_hotels dh
on fb.property_id = dh.property_id
group by dh.category;









