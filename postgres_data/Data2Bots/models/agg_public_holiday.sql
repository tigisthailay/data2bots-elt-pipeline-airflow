/* 
Total number of orders placed on public holiday of every month of previous year
*/


/* Declar variables*/
DECLARE @previous_year int, @drived_dim_date DATE

/* set values to the variables
param: 
- GETDATE(): to get current date of the database system.
- DATEADD(): to get previous year.
- YEAR(): to extract the Year part.
*/

SET @previous_year = YEAR(DATEADD(year, -1, GETDATE()))
SET @drived_dim_date = (
    SELECT CONCAT(year_num, '-', month_of_the_year_num, '-', day_of_the_month_num) FROM if_common.dim_dates
    WHERE year_num = @previous_year AND day_of_the_week_num BETWEEN 1 AND 5 AND working_day = 'false'
)

with source as (
    select *
    from {{ref('feature')}}
),
destination as (
    SELECT SUM(quantity) as tt_order_hol_month FROM tegidege9284_staging.orders, if_common.dim_dates
    WHERE orders.order_date = @drived_dim_date
    GROUP BY MONTH(orders.order_date)
)
SELECT *
FROM destination