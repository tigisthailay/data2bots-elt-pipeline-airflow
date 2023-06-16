


DECLARE @is_holiday bool, @late_shipment int,

SET @is_holiday = (
    if (dim_dates.day_of_the_week_num BETWEEN 1 and 5 AND dim_dates.working_day = 'false')
    @is_holiday = 'True'
    ELSE
    @is_holiday = 'False'
)

SET @late_shipment = (SELECT COUNT(*) AS tt_late_shipments
    FROM shipments_deliveries 
    INNER JOIN orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date >= DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date = NULL)


with source as (
    select *
    from {{ref('feature')}}
),
destination as (
    SELECT dim_products.product_name, orders.order_date AS most_ordered_day, 
    @is_holiday AS is_public_holiday, SUM(reviews) AS tt_review_points
    
    FROM dim_products
    INNER JOIN reviews ON dim_products.product_id = reviews.product_id 
    INNER JOIN orders on orders.product_id = dim_products.product_id

    , dim_dates
    WHERE 
    HAVING MAX(reviews.reviews), MAX(SUM(quantity))
)
SELECT *
FROM destination
