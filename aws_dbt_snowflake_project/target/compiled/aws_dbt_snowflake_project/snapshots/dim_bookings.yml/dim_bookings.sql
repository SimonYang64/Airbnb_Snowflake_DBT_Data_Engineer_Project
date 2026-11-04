with __dbt__cte__bookings as (


WITH bookings AS 
(
    SELECT 
        BOOKING_ID,
        BOOKING_DATE,
        BOOKING_STATUS,
        CREATED_AT
    FROM 
        AIRBNB.gold.obt
)
SELECT * FROM bookings
) select * from __dbt__cte__bookings