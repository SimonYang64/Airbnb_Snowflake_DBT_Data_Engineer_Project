-- back compat for old kwarg name
  
  begin;
    

        insert into AIRBNB.bronze.bronze_hosts ("HOST_ID", "HOST_NAME", "HOST_SINCE", "IS_SUPERHOST", "RESPONSE_RATE", "CREATED_AT")
        (
            select "HOST_ID", "HOST_NAME", "HOST_SINCE", "IS_SUPERHOST", "RESPONSE_RATE", "CREATED_AT"
            from AIRBNB.bronze.bronze_hosts__dbt_tmp
        );
    commit;