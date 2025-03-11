/* 1. Retreive total property for each property category */

select category, count(*) as tot_property from dim_hotels
group by category;

/* 2. Retreive total property for each city */

select city, count(*) as tot_property from dim_hotels
group by city;

/* 3. Retreive total property for each property name */

select property_name, count(*) tot_property from dim_hotels
group by property_name
order by tot_property desc;











