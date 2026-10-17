-- 03_dead_slow_flag.sql
-- Flags each SKU as Active / Slow / Dead by days since last sale.
-- Dead = 180+ days, Slow = 90 to 179 days, Active = under 90 days.
-- Run after 02_abc_classification.sql. Safe to re-run.

USE RetailInv;
GO

DROP TABLE IF EXISTS sku_status;
GO

-- snapshot = last date in the data
DECLARE @snapshot datetime2 = (SELECT MAX(InvoiceDate) FROM online_retail_clean);

-- seconds / 86400 gives full 24-hour days, which matches pandas
SELECT *,
    DATEDIFF(second, last_sale, @snapshot) / 86400 AS days_since_sale,
    CASE
        WHEN DATEDIFF(second, last_sale, @snapshot) / 86400 >= 180 THEN 'Dead'
        WHEN DATEDIFF(second, last_sale, @snapshot) / 86400 >= 90  THEN 'Slow'
        ELSE 'Active'
    END AS status
INTO sku_status
FROM sku_abc;
GO

-- check: pandas gives Active 3224, Dead 1453, Slow 217 (SQL should be within about 1)
SELECT status, COUNT(*) AS sku_count
FROM sku_status
GROUP BY status
ORDER BY status;
GO

-- by ABC class
-- pandas: A = 966 Active / 69 Dead / 15 Slow
--         B = 993 Active / 242 Dead / 45 Slow
--         C = 1265 Active / 1142 Dead / 157 Slow
SELECT abc, status, COUNT(*) AS sku_count
FROM sku_status
GROUP BY abc, status
ORDER BY abc, status;
GO
