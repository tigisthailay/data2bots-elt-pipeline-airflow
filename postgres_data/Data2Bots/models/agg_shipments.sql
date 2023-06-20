/* 
Total number of late shipments
*/

with source as (
    select *
    from {{ref('feature')}}
),
destination as (
    SELECT COUNT(*) AS tt_late_shipments
    FROM user1234_staging.shipments_deliveries 
    INNER JOIN user1234_staging.orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date >= DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date = NULL
)
SELECT *
FROM destination

/* 
Total number of undelivered shipments
*/
with source as (
    select *
    from {{ref('feature')}}
),
destination as (
    SELECT COUNT(*) AS tt_undelivered_items
    FROM tegidege9284_staging.shipments_deliveries 
    INNER JOIN tegidege9284_staging.orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date = NULL
    AND shipments_deliveries.delivery_date = NULL
    AND CONVERT(DATE,GETDATE()) = DATEADD(day, 15, orders.order_date)
    AND  = NULL
)
SELECT *
FROM destination