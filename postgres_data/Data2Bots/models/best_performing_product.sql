/* 
This transformation identifies the best performing product based on various metrics 
such as reviews, shipment times, and holiday performance.
*/

with source as (
    select *
    from {{ ref('feature') }}
),
aggregated_metrics as (
    SELECT
        dim_products.product_name,
        COUNT(CASE WHEN reviews.review = 1 THEN 1 END) AS one_star_reviews,
        COUNT(CASE WHEN reviews.review = 2 THEN 1 END) AS two_star_reviews,
        COUNT(CASE WHEN reviews.review = 3 THEN 1 END) AS three_star_reviews,
        COUNT(CASE WHEN reviews.review = 4 THEN 1 END) AS four_star_reviews,
        COUNT(CASE WHEN reviews.review = 5 THEN 1 END) AS five_star_reviews,
        COUNT(reviews.review) AS total_reviews,
        COUNT(CASE 
            WHEN shipments_deliveries.shipment_date < orders.order_date + interval '6' day 
                 AND shipments_deliveries.delivery_date IS NOT NULL 
            THEN 1 END) AS early_shipments,
        COUNT(CASE 
            WHEN shipments_deliveries.shipment_date >= orders.order_date + interval '6' day 
                 AND shipments_deliveries.delivery_date IS NULL 
            THEN 1 END) AS late_shipments
    FROM 
        dim_products
    LEFT JOIN tegidege9284_staging.reviews 
        ON dim_products.product_id = reviews.product_id
    LEFT JOIN tegidege9284_staging.orders 
        ON dim_products.product_id = orders.product_id
    LEFT JOIN tegidege9284_staging.shipments_deliveries 
        ON orders.order_id = shipments_deliveries.order_id
    LEFT JOIN if_common.dim_dates 
        ON orders.order_date = dim_dates.calender_dt
    GROUP BY dim_products.product_name
),
calculated_metrics as (
    SELECT
        product_name,
        total_reviews,
        ROUND(100.0 * one_star_reviews / NULLIF(total_reviews, 0), 2) AS pct_one_star_reviews,
        ROUND(100.0 * two_star_reviews / NULLIF(total_reviews, 0), 2) AS pct_two_star_reviews,
        ROUND(100.0 * three_star_reviews / NULLIF(total_reviews, 0), 2) AS pct_three_star_reviews,
        ROUND(100.0 * four_star_reviews / NULLIF(total_reviews, 0), 2) AS pct_four_star_reviews,
        ROUND(100.0 * five_star_reviews / NULLIF(total_reviews, 0), 2) AS pct_five_star_reviews,
        early_shipments,
        late_shipments,
        ROUND(100.0 * early_shipments / NULLIF((early_shipments + late_shipments), 0), 2) AS pct_early_shipments,
        ROUND(100.0 * late_shipments / NULLIF((early_shipments + late_shipments), 0), 2) AS pct_late_shipments
    FROM aggregated_metrics
)
SELECT *
FROM calculated_metrics
ORDER BY total_reviews DESC, pct_five_star_reviews DESC;
