-- 01_sku_summary.sql
-- Builds one row per product (case-sensitive StockCode, to match pandas).
-- Safe to re-run: drops downstream tables first.

USE RetailInv;
GO

DROP TABLE IF EXISTS sku_status;
DROP TABLE IF EXISTS sku_abc;
DROP TABLE IF EXISTS sku_summary;
GO

-- sanity check on the import
SELECT COUNT(*)                AS row_count,   -- expect 1003338
       ROUND(SUM(Revenue), 2)  AS total_rev    -- expect 19398208.42
FROM online_retail_clean;
GO

-- one row per product
SELECT
    StockCode COLLATE Latin1_General_CS_AS AS StockCode,
    SUM(Revenue)            AS revenue,
    SUM(Quantity)           AS units,
    COUNT(DISTINCT Invoice) AS orders,
    AVG(Price)              AS avg_price,
    MIN(InvoiceDate)        AS first_sale,
    MAX(InvoiceDate)        AS last_sale
INTO sku_summary
FROM online_retail_clean
GROUP BY StockCode COLLATE Latin1_General_CS_AS;
GO

-- check: expect 4893 (pandas has 4894; SQL ignores trailing spaces in comparisons)
SELECT COUNT(*) AS total_skus FROM sku_summary;
GO
