/* 
Total number of late shipments
*/

with source as (
    select *
    from {{ref('feature')}}
),
destination as (
    SELECT COUNT(*) FROM AS tt_late_shipments
    FROM shipments_deliveries 
    INNER JOIN orders
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
    SELECT COUNT(*) FROM AS tt_undelivered_items
    FROM shipments_deliveries 
    INNER JOIN orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date = NULL
    AND shipments_deliveries.delivery_date = NULL
    AND CONVERT(DATE,GETDATE()) = DATEADD(day, 15, orders.order_date)
    AND  = NULL
)
SELECT *
FROM destination