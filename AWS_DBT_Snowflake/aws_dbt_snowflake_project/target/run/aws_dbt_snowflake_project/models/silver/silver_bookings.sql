-- back compat for old kwarg name
  
  begin;
    
        
            
            
            
            
        
    

    

    merge into AIRBNB.silver.silver_bookings as DBT_INTERNAL_DEST
        using AIRBNB.silver.silver_bookings__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.BOOKING_ID = DBT_INTERNAL_DEST.BOOKING_ID))

    
    when matched then update set
        "BOOKING_ID" = DBT_INTERNAL_SOURCE."BOOKING_ID","LISTING_ID" = DBT_INTERNAL_SOURCE."LISTING_ID","BOOKING_DATE" = DBT_INTERNAL_SOURCE."BOOKING_DATE","TOTAL_AMOUNT" = DBT_INTERNAL_SOURCE."TOTAL_AMOUNT","SERVICE_FEE" = DBT_INTERNAL_SOURCE."SERVICE_FEE","CLEANING_FEE" = DBT_INTERNAL_SOURCE."CLEANING_FEE","BOOKING_STATUS" = DBT_INTERNAL_SOURCE."BOOKING_STATUS","CREATED_AT" = DBT_INTERNAL_SOURCE."CREATED_AT"
    

    when not matched then insert
        ("BOOKING_ID", "LISTING_ID", "BOOKING_DATE", "TOTAL_AMOUNT", "SERVICE_FEE", "CLEANING_FEE", "BOOKING_STATUS", "CREATED_AT")
    values
        ("BOOKING_ID", "LISTING_ID", "BOOKING_DATE", "TOTAL_AMOUNT", "SERVICE_FEE", "CLEANING_FEE", "BOOKING_STATUS", "CREATED_AT")

;
    commit;