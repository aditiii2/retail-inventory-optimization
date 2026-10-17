-- 02_abc_classification.sql
-- Pareto / ABC classification using a cumulative revenue window function.
-- A = top 80% of revenue, B = next 15%, C = last 5%.
-- Run after 01_sku_summary.sql. Safe to re-run.

USE RetailInv;
GO

DROP TABLE IF EXISTS sku_status;
DROP TABLE IF EXISTS sku_abc;
GO

WITH ranked AS (
    SELECT *,
        SUM(revenue) OVER (ORDER BY revenue DESC
                           ROWS UNBOUNDED PRECEDING) AS cum_rev,
        SUM(revenue) OVER ()                         AS total_rev
    FROM sku_summary
)
SELECT *,
    CASE
        WHEN cum_rev / total_rev <= 0.80 THEN 'A'
        WHEN cum_rev / total_rev <= 0.95 THEN 'B'
        ELSE 'C'
    END AS abc
INTO sku_abc
FROM ranked;
GO

-- check: pandas gives A = 1050, B = 1280, C = 2564 (SQL should be within about 1)
SELECT abc,
       COUNT(*)                                            AS sku_count,
       ROUND(SUM(revenue), 0)                              AS revenue,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)  AS pct_of_skus
FROM sku_abc
GROUP BY abc
ORDER BY abc;
GO
