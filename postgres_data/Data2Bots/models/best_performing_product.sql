


DECLARE @is_holiday bool, @late_shipment int, @tt_early_shipments int,
@particular_late_shipment int, @particular_early_shipment int,
@total_reviews int, @one_star int, @two_star int, @three_star int,
@four_star int, @five_star int

SET @is_holiday = (
    if (dim_dates.day_of_the_week_num BETWEEN 1 and 5 AND dim_dates.working_day = 'false')
    @is_holiday = 'True'
    ELSE
    @is_holiday = 'False'
)

SET @tt_late_shipment = (SELECT COUNT(*) AS tt_late_shipments
    FROM shipments_deliveries 
    INNER JOIN orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date >= DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date = 'NULL')

SET @particular_late_shipment = (SELECT COUNT(order.product_id) AS particular_late_shipments
    FROM orders 
    INNER JOIN shipments_deliveries
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date >= DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date = 'NULL')

SET @tt_early_shipments = (SELECT COUNT(*) AS tt_early_shipments
    FROM shipments_deliveries 
    INNER JOIN orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date < DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date != 'NULL')

SET @particular_early_shipment = (SELECT COUNT(product_id) AS particular_early_shipment_early_shipments
    FROM orders 
    INNER JOIN shipments_deliveries
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date < DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date != 'NULL')

SET @total_reviews = (SELECT count(*) over() FROM reviews)
SET @one_star = (SELECT COUNT(reviews) FROM reviews WHERE reviews = 1)
SET @two_star = (SELECT COUNT(reviews) FROM reviews WHERE reviews = 2)
SET @three_star = (SELECT COUNT(reviews) FROM reviews WHERE reviews = 3)
SET @four_star = (SELECT COUNT(reviews) FROM reviews WHERE reviews = 4)
SET @five_star = (SELECT COUNT(reviews) FROM reviews WHERE reviews = )

with source as (
    select *
    from {{ref('feature')}}
),
destination as (
    SELECT dim_products.product_name, 
    orders.order_date AS most_ordered_day, 
    @is_holiday AS is_public_holiday, 
    COUNT(DISTINCT reviews) AS tt_review_points,
    COUNT(reviews) AS pct_one_star_review,
    round(100 * @one_star / @total_reviews) AS pct_one_star_review,
    round(100 * @two_star / @total_reviews) AS pct_two_star_review,
    round(100 * @three_star / @total_reviews) AS pct_three_star_review,
    round(100 * @four_star / @total_reviews) AS pct_four_star_review,
    round(100 * @five_star / @total_reviews) AS pct_five_star_review,
    round(100 * @particular_early_shipment / @tt_early_shipment) AS pct_early_shipments,
    round(100 * @particular_late_shipment / @tt_late_shipments)  AS pct_late_shipments

    FROM dim_products
    INNER JOIN reviews ON dim_products.product_id = reviews.product_id 
    INNER JOIN orders on orders.product_id = dim_products.product_id
    INNER JOIN shipments_deliveries on shipments_deliveries.order_id = orders.order_id

    , dim_dates
    WHERE 
    HAVING MAX(reviews), MAX(SUM(quantity))
    GROUP BY reviews
)
SELECT *
FROM destination
