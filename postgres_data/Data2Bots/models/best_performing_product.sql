/* This transformation gives the best performing product*/

/*
Declar local variables
*/

DECLARE @is_holiday bool, @late_shipment int, @tt_early_shipments int,
@particular_late_shipment int, @particular_early_shipment int,
@total_reviews int, @one_star int, @two_star int, @three_star int,
@four_star int, @five_star int

/*
Set values to the variables.
*/
SET @is_holiday = (
    if (dim_dates.day_of_the_week_num BETWEEN 1 and 5 AND dim_dates.working_day = 'false')
    @is_holiday = 'True'
    ELSE
    @is_holiday = 'False'
)

SET @tt_late_shipment = (SELECT COUNT(*) AS tt_late_shipments
    FROM user1234_staging.shipments_deliveries 
    INNER JOIN user1234_staging.orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date >= DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date = 'NULL')

SET @particular_late_shipment = (SELECT COUNT(order.product_id) AS particular_late_shipments
    FROM user1234_staging.orders 
    INNER JOIN user1234_staging.shipments_deliveries
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date >= DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date = 'NULL')

SET @tt_early_shipments = (SELECT COUNT(*) AS tt_early_shipments
    FROM user1234_staging.shipments_deliveries 
    INNER JOIN user1234_staging.orders
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date < DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date != 'NULL')

SET @particular_early_shipment = (SELECT COUNT(product_id) AS particular_early_shipment_early_shipments
    FROM user1234_staging.orders 
    INNER JOIN user1234_staging.shipments_deliveries
    ON shipments_deliveries.order_id = orders.order_id
    WHERE shipments_deliveries.shipment_date < DATEADD(day, 6, orders.order_date)
    AND shipments_deliveries.delivery_date != 'NULL')

SET @total_reviews = (SELECT count(*) over() FROM user1234_staging.reviews)
SET @one_star = (SELECT COUNT(reviews) FROM user1234_staging.reviews WHERE reviews = 1)
SET @two_star = (SELECT COUNT(reviews) FROM user1234_staging.reviews WHERE reviews = 2)
SET @three_star = (SELECT COUNT(reviews) FROM user1234_staging.reviews WHERE reviews = 3)
SET @four_star = (SELECT COUNT(reviews) FROM user1234_staging.reviews WHERE reviews = 4)
SET @five_star = (SELECT COUNT(reviews) FROM user1234_staging.reviews WHERE reviews = 5)

/* Start transformation*/

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

    FROM if_common.dim_products
    INNER JOIN user1234_staging.reviews ON dim_products.product_id = reviews.product_id 
    INNER JOIN user1234_staging.orders on orders.product_id = dim_products.product_id
    INNER JOIN user1234_staging.shipments_deliveries on shipments_deliveries.order_id = orders.order_id
    , if_common.dim_dates
    HAVING MAX(reviews) AND MAX(SUM(quantity))
    GROUP BY reviews
)
SELECT *
FROM destination
