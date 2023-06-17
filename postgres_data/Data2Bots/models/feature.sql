/* this query retrives all informations 
from all tables of if_common database */

with source as (
    select *
    from {{ source('orders','shipments_deliveries','reviews','dim_products','dim_customers','dim_dates', 'dim_addresses') }}
),
destination as (
    SELECT orders.order_id, orders.customer_id, orders.order_date, orders.product_id, orders.unit_price, orders.quantity, orders.amount,
    shipments_deliveries.shipment_id, shipments_deliveries.order_id, shipments_deliveries.delivery_date, shipments_deliveries.shipment_date,
    reviews.review, reviews.product_id, 
    dim_product.product_id, _dim_product.product_category, dim_product.product_name,
    dim_customers.customer_id, dim_customers.customer_name, dim_customers.postal_code,
    dim_dates.calender_dt, dim_dates.year_num, dim_dates.month_of_the_year_num, dim_dates.day_of_the_month_num, dim_dates.day_of_the_week_num, dim_dates.working_day,
    dim_addresses.postal_code, dim_addresses.region, dim_addresses.state, dim_addresses.address
    from source
)
SELECT *
FROM destination