

SELECT * FROM AIRBNB.staging.bookings


    WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM AIRBNB.bronze.bronze_bookings )
