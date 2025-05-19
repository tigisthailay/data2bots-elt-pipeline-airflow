/* 
Total number of late shipments
*/

with late_shipments as (
    select 
        f.shipment_id,
        f.order_id,
        f.shipment_date,
        f.order_date,
        f.delivery_date
    from {{ ref('feature') }} f
    where 
        f.shipment_date >= DATEADD(day, 6, f.order_date) -- Late shipment condition
        and f.delivery_date is null -- Undelivered shipments
)
select 
    count(*) as total_late_shipments
from late_shipments;


/* 
Total number of undelivered shipments
*/

with undelivered_shipments as (
    select 
        f.shipment_id,
        f.order_id,
        f.shipment_date,
        f.delivery_date,
        f.order_date
    from {{ ref('feature') }} f
    where 
        f.shipment_date is null
        and f.delivery_date is null
        and current_date = f.order_date + interval '15' day
)
select 
    count(*) as total_undelivered_shipments
from undelivered_shipments;
