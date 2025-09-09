WITH category_yearly AS (
    SELECT
        "Year",
        ad_category,
        SUM("Ad Revenue") AS category_revenue
    FROM
        fact_ad_revenue
    GROUP BY
        "Year", ad_category
),
yearly_totals AS (
    SELECT
        "Year",
        SUM(category_revenue) AS total_revenue_year
    FROM
        category_yearly
    GROUP BY
        "Year"
)
SELECT
    cy."Year",
    cy.ad_category,
    cy.category_revenue,
    yt.total_revenue_year,
    ROUND(
        (cy.category_revenue::numeric / NULLIF(yt.total_revenue_year::numeric, 0) * 100),
        2
    ) AS pct_of_year_total
FROM
    category_yearly cy
JOIN
    yearly_totals yt ON cy."Year" = yt."Year"
WHERE
    cy.category_revenue / NULLIF(yt.total_revenue_year,0) > 0
ORDER BY
    cy."Year",
    pct_of_year_total DESC;


