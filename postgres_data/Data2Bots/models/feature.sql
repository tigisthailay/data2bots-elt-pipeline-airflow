/* this query retrives all informations 
from all tables of if_common database */

with orders as (
    select *
    from {{ source('d2b_accessment', 'tegidege9284_staging.orders') }}
),
shipments_deliveries as (
    select *
    from {{ source('d2b_accessment', 'tegidege9284_staging.shipments_deliveries') }}
),
reviews as (
    select *
    from {{ source('d2b_accessment', 'tegidege9284_staging.reviews') }}
),
dim_products as (
    select *
    from {{ source('if_common', 'dim_products') }}
),
dim_customers as (
    select *
    from {{ source('if_common', 'dim_customers') }}
),
dim_dates as (
    select *
    from {{ source('if_common', 'dim_dates') }}
),
dim_addresses as (
    select *
    from {{ source('if_common', 'dim_addresses') }}
)
select 
    o.order_id, o.customer_id, o.order_date, o.product_id, o.unit_price, o.quantity, o.amount,
    sd.shipment_id, sd.delivery_date, sd.shipment_date,
    r.review,
    dp.product_category, dp.product_name,
    dc.customer_name, dc.postal_code as customer_postal_code,
    dd.calender_dt, dd.year_num, dd.month_of_the_year_num, dd.day_of_the_month_num, dd.day_of_the_week_num, dd.working_day,
    da.region, da.state, da.address
from orders o
left join shipments_deliveries sd on o.order_id = sd.order_id
left join reviews r on o.product_id = r.product_id
left join dim_products dp on o.product_id = dp.product_id
left join dim_customers dc on o.customer_id = dc.customer_id
left join dim_dates dd on o.order_date = dd.calender_dt
left join dim_addresses da on dc.postal_code = da.postal_code
