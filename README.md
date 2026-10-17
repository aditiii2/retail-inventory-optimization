## Project status

**Completed**
- Data cleaning and outlier handling
- ABC (Pareto) and lifecycle-adjusted XYZ classification
- Dead, slow and seasonal stock analysis, with threshold sensitivity
- Capital locked and capital freed estimates
- Strategy mapping per class
- SQL (T-SQL / SQL Server) reproduction of the SKU aggregation, ABC classification and dead/slow flag (see `sql/`). Results match pandas to within one SKU, due to SQL Server's trailing-space handling in text comparison
- Safety stock and reorder point calculation for active SKUs

**In progress**
- Power BI dashboard (Pareto curve, ABC-XYZ matrix, capital by class, delist candidates)
- Reorder point and safety stock validation
- Chart images in this README
- 

**Assumptions and limitations**
### Reorder points

Safety stock and reorder points are calculated for active SKUs with at least 3 months of sales history:

- Safety stock = Z × (monthly demand std × √(lead time in months)), with Z = 2.05 / 1.65 / 1.28 for A / B / C (98% / 95% / 90% service level)
- Reorder point = demand during a 14-day lead time + safety stock
- Dead, slow and short-life SKUs get no reorder point

These are indicative. The formula assumes roughly normal demand, so very lumpy or seasonal SKUs (for example Christmas items and wholesale tissue packs) get large buffers. In practice these would be reviewed manually or ordered ahead of season.
