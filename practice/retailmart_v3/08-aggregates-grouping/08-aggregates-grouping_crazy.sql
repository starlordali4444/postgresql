/* ============================================================
   SQL PRACTICE SET - Aggregate Functions & Grouping (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Aggregates - advanced statistics & analytics
   Database:     RetailMart V3

   Scope (CRAZY):
     - Multi-dimensional OLAP cubes
     - Percentiles, histograms, distributions
     - Pivot tables in SQL
     - Window aggregates (preview)
     - Bayesian / weighted averages
     - Anomaly detection via stats
     - Funnel analysis
     - Top-N within groups

   Structure: 25 OLAP cubes + 25 Distributions + 25 Pivots + 25 Funnel/Anomaly
   ============================================================ */

/* ============================================================
   SECTION A: OLAP CUBES (25)
   ------------------------------------------------------------ */
/* Q1.  CUBE(region, month, status) - full 3D. */
/* Q2.  ROLLUP(year, quarter, month) - hierarchical. */
/* Q3.  GROUPING SETS for parallel cohort views. */
/* Q4.  Per region x month x status, revenue + subtotals. */
/* Q5.  Per brand x category x region, revenue. */
/* Q6.  Per tier x age_band x city, count. */
/* Q7.  Per priority x dept x month, ticket count. */
/* Q8.  Per supplier x warehouse x month, shipment count. */
/* Q9.  Per platform x campaign x month, ad spend. */
/* Q10. Per device x os x browser, page view count. */
/* Q11. Per category x brand x supplier x region, sales. */
/* Q12. Use GROUPING() to label rows. */
/* Q13. Filter only subtotal rows. */
/* Q14. Filter only grand total. */
/* Q15. Cubes with multiple measures (SUM + AVG + COUNT). */
/* Q16. Cubes with FILTER per measure. */
/* Q17. Per region x month x status as a cross-tab. */
/* Q18. Year-over-year cube. */
/* Q19. Quarter-over-quarter cube. */
/* Q20. Day-of-week x hour-of-day cube. */
/* Q21. Customer cohort x month x tier cube. */
/* Q22. Ad attribution cube: campaign x source x medium x geo. */
/* Q23. Fiscal cube: fiscal year x quarter x dept. */
/* Q24. Combine ROLLUP with FILTER (per-status totals). */
/* Q25. Build executive cube: 6 dimensions x 4 measures. */

/* ============================================================
   SECTION B: DISTRIBUTIONS & STATISTICS (25)
   ------------------------------------------------------------ */
/* Q26. Distribution of net_total: 20-bucket histogram. */
/* Q27. Distribution of order_date: monthly bucket. */
/* Q28. Distribution of ticket priority. */
/* Q29. Distribution of page_views per session. */
/* Q30. Customer LTV distribution. */
/* Q31. Time-to-deliver distribution. */
/* Q32. Time-to-resolve distribution. */
/* Q33. Refund-rate distribution per product. */
/* Q34. Review-length distribution. */
/* Q35. Median + MAD (median absolute deviation). */
/* Q36. Mean / median / mode together. */
/* Q37. Skewness: (mean - median) / stddev. */
/* Q38. Z-score of each order vs population. */
/* Q39. Outlier detection: z > 3. */
/* Q40. IQR outlier detection (1.5 x IQR). */
/* Q41. Pearson correlation (price vs rating). */
/* Q42. Spearman correlation (preview). */
/* Q43. Covariance between two metrics. */
/* Q44. Linear regression slope (REGR_SLOPE). */
/* Q45. R^2 (REGR_R2). */
/* Q46. Moving average (preview window). */
/* Q47. Exponentially weighted moving average. */
/* Q48. Anomaly detection via 7-day SMA vs current. */
/* Q49. Seasonality detection (week-over-week diff). */
/* Q50. P-value for difference of means (manual computation). */

/* ============================================================
   SECTION C: PIVOTS & UNPIVOTS (25)
   ------------------------------------------------------------ */
/* Q51. Pivot orders by month: rows = year, columns = month. */
/* Q52. Pivot tickets by status: rows = priority, columns = status. */
/* Q53. Pivot revenue by region x tier. */
/* Q54. Pivot reviews by rating: rows = brand, columns = rating. */
/* Q55. Pivot inventory by warehouse x product. */
/* Q56. Pivot pay_slips by year x dept. */
/* Q57. Pivot calls by reason x shift. */
/* Q58. Pivot campaigns by platform x month. */
/* Q59. Unpivot order_items metrics. */
/* Q60. Unpivot per-customer scoring. */
/* Q61. Crosstab with N dynamic columns (tablefunc extension). */
/* Q62. Pivot using FILTER for each column. */
/* Q63. Pivot using CASE for each column. */
/* Q64. Pivot using ARRAY_AGG. */
/* Q65. Pivot using jsonb_object_agg. */
/* Q66. Pivot with percentage of total per row. */
/* Q67. Pivot with running total. */
/* Q68. Pivot with rank within row. */
/* Q69. Reverse pivot via UNION ALL. */
/* Q70. Reverse pivot via jsonb_each. */
/* Q71. Stacked column report. */
/* Q72. Sparse vs dense pivot. */
/* Q73. Pivot with nulls treated as 0. */
/* Q74. Multi-measure pivot. */
/* Q75. Pivot with comparison vs prior period. */

/* ============================================================
   SECTION D: FUNNELS & ANOMALIES (25)
   ------------------------------------------------------------ */
/* Q76. Funnel: visit -> signup -> first order. */
/* Q77. Funnel: signup -> activation -> retention -> revenue. */
/* Q78. Funnel: campaign click -> cart -> checkout -> paid. */
/* Q79. Funnel conversion %. */
/* Q80. Funnel drop-off per step. */
/* Q81. Time-between-step funnel. */
/* Q82. Cohort funnel by signup month. */
/* Q83. Multi-touch attribution. */
/* Q84. First-touch attribution. */
/* Q85. Last-touch attribution. */
/* Q86. Linear-touch attribution. */
/* Q87. Time-decay attribution. */
/* Q88. Anomaly: revenue today vs 30-day avg. */
/* Q89. Anomaly: ticket count today vs 30-day avg. */
/* Q90. Anomaly: error log spike. */
/* Q91. Anomaly: SLA breach rate. */
/* Q92. Anomaly: per-product return rate. */
/* Q93. Anomaly: customer behavior drift. */
/* Q94. Outlier orders. */
/* Q95. Outlier returns. */
/* Q96. Detect bot traffic. */
/* Q97. Detect data quality issues (sudden NULLs). */
/* Q98. Detect schema drift. */
/* Q99. Detect "stuck" inventory (not moving). */
/* Q100. Build a "RetailMart anomaly summary" - 20 detectors. */

/* ============================================================
   END OF Aggregate Functions & Grouping - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
