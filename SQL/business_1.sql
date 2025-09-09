WITH monthly_sales AS (
    SELECT
        c.city,
        TO_CHAR(f."Date"::date, 'YYYY-MM') AS month,
        SUM(f."Net_Circulation") AS net_circulation
    FROM fact_print_sales f
   JOIN dim_city c ON f."City_ID" = c.city_id
    WHERE f."Year" BETWEEN 2019 AND 2024
    GROUP BY c.city, TO_CHAR(f."Date"::date, 'YYYY-MM')
),
with_lag AS (
    SELECT 
        city,
        month,
        net_circulation,
        LAG(net_circulation) OVER (PARTITION BY city ORDER BY month) AS prev_circulation
    FROM monthly_sales
)
SELECT 
    city,
    month,
    net_circulation,
    (prev_circulation - net_circulation) AS decline
FROM with_lag
WHERE prev_circulation IS NOT NULL
ORDER BY decline DESC
LIMIT 5;
