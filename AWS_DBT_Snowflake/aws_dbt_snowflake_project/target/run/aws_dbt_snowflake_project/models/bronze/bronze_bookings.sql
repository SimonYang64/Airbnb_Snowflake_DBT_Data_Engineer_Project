-- back compat for old kwarg name
  
  begin;
    

        insert into AIRBNB.bronze.bronze_bookings ("BOOKING_ID", "LISTING_ID", "BOOKING_DATE", "NIGHTS_BOOKED", "BOOKING_AMOUNT", "CLEANING_FEE", "SERVICE_FEE", "BOOKING_STATUS", "CREATED_AT")
        (
            select "BOOKING_ID", "LISTING_ID", "BOOKING_DATE", "NIGHTS_BOOKED", "BOOKING_AMOUNT", "CLEANING_FEE", "SERVICE_FEE", "BOOKING_STATUS", "CREATED_AT"
            from AIRBNB.bronze.bronze_bookings__dbt_tmp
        );
    commit;