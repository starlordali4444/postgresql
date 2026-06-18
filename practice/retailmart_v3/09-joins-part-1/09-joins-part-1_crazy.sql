/* ============================================================
   SQL PRACTICE SET - JOINs Part 1 (Foundations) (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JOINs Part 1 - mega-table reports, BI architecture
   Database:     RetailMart V3

   Scope (CRAZY):
     - 8+ table JOINs with controlled fan-out
     - Mega BI dashboards in one query
     - Star schema queries
     - Snowflake schema queries
     - Cross-schema cross-database queries
     - Materialized view design
     - Query rewriting for performance
     - Recursive joins

   Structure: 25 Mega chains + 25 BI dashboards + 25 Performance tuning + 25 MV design
   ============================================================ */

/* ============================================================
   SECTION A: MEGA TABLE CHAINS (25)
   ------------------------------------------------------------ */
/* Q1.  8 tables: order -> items -> product -> brand -> category -> supplier -> warehouse -> region. */
/* Q2.  10 tables: customer full lifecycle joining all activity. */
/* Q3.  Fan-out controlled with pre-aggregation CTEs. */
/* Q4.  6-table sales pipeline. */
/* Q5.  6-table marketing attribution. */
/* Q6.  6-table workforce / payroll. */
/* Q7.  6-table support pipeline. */
/* Q8.  6-table inventory & supply chain. */
/* Q9.  Cross-domain JOIN: sales + marketing + support per customer. */
/* Q10. Cross-domain: HR + sales + customer per region. */
/* Q11. Order trace: order -> payment -> shipment -> delivery -> review. */
/* Q12. Customer trace: signup -> first order -> tier upgrade -> first review. */
/* Q13. Refund trace: order -> item -> return -> refund -> audit. */
/* Q14. Campaign trace: spend -> attribution -> order -> customer -> review. */
/* Q15. Ticket trace: ticket -> customer -> product -> order -> resolution. */
/* Q16. Call trace: call -> customer -> past_orders -> tickets. */
/* Q17. Web -> order trace: page_view -> session -> cart -> checkout -> order. */
/* Q18. Supplier trace: supplier -> product -> inventory -> shipment -> order_item. */
/* Q19. Pay_slip trace: employee -> attendance -> pay_slip -> bank. */
/* Q20. Region rollup: region -> store -> employee -> orders -> customers. */
/* Q21. Brand revenue chain: brand -> product -> order_item -> order -> store -> region. */
/* Q22. Loyalty chain: customer -> tier -> points -> redemption. */
/* Q23. AB-test chain: page_view -> AB -> cart -> order. */
/* Q24. Audit chain: order -> audit_log -> api_request -> app_log. */
/* Q25. Full 10-table receipt: every dimension visible. */

/* ============================================================
   SECTION B: BI DASHBOARDS (25)
   ------------------------------------------------------------ */
/* Q26. Executive: revenue, orders, customers, AOV per month. */
/* Q27. Regional: per region, top 5 stores by revenue. */
/* Q28. Tier dashboard: members, points, redemptions, revenue. */
/* Q29. Marketing: campaigns, spend, attributions, ROI. */
/* Q30. Customer service: tickets, calls, resolution time, CSAT. */
/* Q31. Inventory: stock by warehouse, low-stock, in-transit. */
/* Q32. Supplier: top suppliers, deliveries, late count. */
/* Q33. Brand performance: revenue, returns, avg rating. */
/* Q34. Category trends: month-over-month. */
/* Q35. Channel mix: organic vs paid vs referral. */
/* Q36. Cohort retention. */
/* Q37. Churn analysis. */
/* Q38. Refund leaderboard. */
/* Q39. Top customer LTV. */
/* Q40. Top product velocity. */
/* Q41. Employee productivity scoreboard. */
/* Q42. Warehouse throughput. */
/* Q43. Courier performance. */
/* Q44. Geographic heatmap. */
/* Q45. Device/platform mix. */
/* Q46. Hourly traffic curve. */
/* Q47. Weekly cadence. */
/* Q48. Holiday vs non-holiday compare. */
/* Q49. New vs returning customers. */
/* Q50. Full executive 1-page (30 metrics). */

/* ============================================================
   SECTION C: PERFORMANCE TUNING (25)
   ------------------------------------------------------------ */
/* Q51. EXPLAIN ANALYZE a 6-table JOIN. */
/* Q52. Pre-aggregate one branch into a CTE. */
/* Q53. Use MATERIALIZED CTE for fan-out control. */
/* Q54. Force partition-wise JOIN. */
/* Q55. Add INDEX on FK column. */
/* Q56. Add COVERING index. */
/* Q57. Add INCLUDE columns. */
/* Q58. Use partial index for hot subset. */
/* Q59. Use expression index for derived column. */
/* Q60. Use BRIN for time-series. */
/* Q61. Replace LEFT JOIN with NOT EXISTS for anti-join. */
/* Q62. Replace IN-subquery with JOIN. */
/* Q63. Replace EXISTS with semi-join INNER. */
/* Q64. Use LATERAL instead of correlated subquery. */
/* Q65. Add ORDER BY for Merge Join. */
/* Q66. Increase work_mem for big sort. */
/* Q67. Pre-sort via index for Merge Join. */
/* Q68. ANALYZE before heavy report. */
/* Q69. Increase stats target for skewed columns. */
/* Q70. Use extended stats for correlated columns. */
/* Q71. Set enable_nestloop = off to force hash. */
/* Q72. Set enable_hashjoin = off to force merge. */
/* Q73. Tune random_page_cost for SSD. */
/* Q74. Use parallel scan (max_parallel_workers). */
/* Q75. Benchmark before/after with pg_stat_statements. */

/* ============================================================
   SECTION D: MATERIALIZED VIEWS (25)
   ------------------------------------------------------------ */
/* Q76. MV: per region per month revenue. */
/* Q77. MV: per category top 10 products. */
/* Q78. MV: customer 360deg. */
/* Q79. MV: product 360deg. */
/* Q80. MV: store 360deg. */
/* Q81. REFRESH MATERIALIZED VIEW CONCURRENTLY. */
/* Q82. Schedule MV refresh via cron. */
/* Q83. Index a MV. */
/* Q84. Combine multiple MVs. */
/* Q85. Drop-and-rebuild MV when underlying changes. */
/* Q86. MV vs continuous aggregate (TimescaleDB). */
/* Q87. MV vs UI-side caching. */
/* Q88. MV with WITH NO DATA. */
/* Q89. MV depending on another MV. */
/* Q90. Incremental MV refresh (PG18 hints). */
/* Q91. Trigger-based recompute. */
/* Q92. Partition the MV. */
/* Q93. MV cost analysis. */
/* Q94. MV staleness monitoring. */
/* Q95. MV with row-level security. */
/* Q96. MV for cross-schema reports. */
/* Q97. MV for cross-database (via FDW). */
/* Q98. MV for replication-friendly reports. */
/* Q99. MV for "ad hoc" exec dashboard. */
/* Q100. Build a 5-MV pipeline: facts -> daily -> weekly -> monthly -> exec. */

/* ============================================================
   END OF JOINs Part 1 (Foundations) - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
