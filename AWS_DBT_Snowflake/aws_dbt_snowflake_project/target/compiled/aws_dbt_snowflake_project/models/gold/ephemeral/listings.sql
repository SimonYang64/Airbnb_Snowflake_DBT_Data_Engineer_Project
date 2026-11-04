

WITH listings AS 
(
    SELECT 
        LISTING_ID,
        PROPERTY_TYPE,
        ROOM_TYPE,
        CITY,
        COUNTRY,
        PRICE_PER_NIGHT_TAG,
        LISTING_CREATED_AT
    FROM 
        AIRBNB.gold.obt
)
SELECT * FROM listings