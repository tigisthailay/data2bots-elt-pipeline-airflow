/* 
Total number of orders placed on public holiday of every month of previous year
*/

with public_holidays as (
    select 
        calender_dt,
        month_of_the_year_num
    from {{ ref('feature') }}
    where 
        year_num = YEAR(DATEADD(year, -1, GETDATE())) -- Previous year
        and working_day = 'false' -- Non-working days (public holidays)
        and day_of_the_week_num BETWEEN 1 AND 5
),
orders_on_holidays as (
    select 
        d.month_of_the_year_num,
        sum(f.quantity) as total_orders
    from {{ ref('feature') }} f
    inner join public_holidays d
        on f.order_date = d.calender_dt
    group by d.month_of_the_year_num
)
select 
    month_of_the_year_num,
    total_orders
from orders_on_holidays
order by month_of_the_year_num;
