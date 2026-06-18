/* ============================================================
   SQL PRACTICE SET - Median, Percentiles & DISTINCT ON (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Distribution reports, latest-per-group at scale, executive KPI dashboards
   Database:     RetailMart V3

   Scope (HARD = interview-grade, performance-aware, multi-step):
     - Five-number summaries, IQR/outlier fences, trimmed means, P50-P99 spectra
     - DISTINCT ON vs ROW_NUMBER vs LATERAL for latest-per-group; index awareness (Days 19-20)
     - Multi-metric KPI dashboards mixing percentiles, windows (16-18) and pivots (21)
   (Approximate-percentile internals are conceptual; MV/precompute is a Day 25 preview.)

   Structure: 25 Conceptual + 25 Distribution reports + 25 Latest-per-group at scale + 25 Production KPI dashboards
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Implement median three ways (PERCENTILE_CONT, NTILE, manual row-offset) - tradeoffs. */
/* Q2.  Why can't PERCENTILE_CONT use an index, and what does that imply at scale? */
/* Q3.  Approximate percentiles for huge tables - strategies (sampling, t-digest concept). */
/* Q4.  Median as a window function vs as a grouped aggregate - output differences. */
/* Q5.  DISTINCT ON vs ROW_NUMBER vs correlated subquery vs LATERAL - full comparison. */
/* Q6.  What plan would DISTINCT ON over 150k orders produce (sort vs incremental)? (Day 19) */
/* Q7.  Which index makes latest-per-group fast: composite (group_key, ts DESC)? (Day 20) */
/* Q8.  Why does a covering index enable an index-only scan for DISTINCT ON? (Day 20) */
/* Q9.  Computing P95 latency from event timestamps - common pitfalls. */
/* Q10. How are NULLs handled in the ordering column of PERCENTILE_CONT? */
/* Q11. Weighted median - why SQL lacks it natively and how to approximate it. */
/* Q12. Median-of-group-medians vs the true global median - why they differ. */
/* Q13. Explain the interpolation math of PERCENTILE_CONT (the fractional-row formula). */
/* Q14. Trimmed mean (drop top/bottom 5%) implemented with percentiles. */
/* Q15. Outlier detection: IQR fences vs z-score vs percentile clipping. */
/* Q16. Why P50 != AVG, and what the gap reveals about skew. */
/* Q17. DISTINCT ON pitfalls when the ORDER BY tiebreaker is non-unique. */
/* Q18. Making "latest" reproducible when timestamps collide - tiebreak strategy. */
/* Q19. Streaming / online percentile estimation - the core idea. */
/* Q20. When to precompute group medians into a summary table / MV (Day 25 preview). */
/* Q21. Cost of many group medians - sort vs hash, and work_mem effects (Day 19). */
/* Q22. Median over a sliding window - the frame problem (Days 17-18). */
/* Q23. Why GROUPING SETS combined with PERCENTILE_CONT can get expensive. */
/* Q24. When PERCENTILE_DISC is required for an SLA (must be a real observed value). */
/* Q25. Designing a percentile-based alerting metric (what to compute, how often). */

/* ============================================================
   SECTION B: DISTRIBUTION & PERCENTILE REPORTS (25)
   ------------------------------------------------------------ */
/* Q26. Five-number summary (min, P25, P50, P75, max) of net_total per region. */
/* Q27. IQR and outlier fences per region; count the outliers beyond each fence. */
/* Q28. Trimmed mean of net_total per region (drop below P5 and above P95). */
/* Q29. P50/P90/P95/P99 of net_total per region (ARRAY) as columns, ranked by P95. */
/* Q30. Delivery-time distribution per warehouse: median, P90, P95, max. */
/* Q31. Median and P95 ticket resolution hours per priority; flag SLA breaches. */
/* Q32. Per agent: median and P95 call duration; rank worst P95 (Day 16). */
/* Q33. Income distribution: P25/P50/P75 net_salary per department. */
/* Q34. Per category: median margin % and P10 (worst-margin tail). */
/* Q35. Basket-size distribution per store (median, P90). */
/* Q36. Median gap-between-orders per customer, then the distribution of those medians. */
/* Q37. Order-value percentiles per tier with skew (mean - median). */
/* Q38. Revenue concentration per region: the P95 / P50 ratio. */
/* Q39. Median order value per region x quarter with QoQ change (LAG, Day 18). */
/* Q40. Per store: median net_total and its percent_rank among all stores (Day 16). */
/* Q41. Delivery SLA: % of orders delivered within the regional P90 target, per region. */
/* Q42. Median time-to-resolution by ticket priority. */
/* Q43. P95 session/dwell metric per device type (web_events.page_views). */
/* Q44. Per platform: median and P95 daily ad spend. */
/* Q45. Median refund per category alongside the refund rate. */
/* Q46. Cohort median order value (registration year) x subsequent order year matrix. */
/* Q47. Per region: median order value among repeat customers only. */
/* Q48. Weekly median revenue per region with a 4-week moving median (window). */
/* Q49. Bucket each customer by lifetime value with NTILE(4); show the PERCENTILE cut points. */
/* Q50. Outlier orders beyond P99 net_total per region, with customer and store context. */

/* ============================================================
   SECTION C: LATEST-PER-GROUP AT SCALE (25)
   ------------------------------------------------------------ */
/* Q51. Latest order per customer via DISTINCT ON; rewrite with ROW_NUMBER; confirm identical rows. */
/* Q52. Latest Delivered order per customer with days-since and store. */
/* Q53. Most-recent price per product (latest order_items) plus current cost margin. */
/* Q54. Latest snapshot per warehouse x product + reorder flag (qty < reorder_level). */
/* Q55. Latest salary per employee + % change vs the previous salary (LAG, Day 18). */
/* Q56. Each customer's latest order AND latest ticket in one report (two DISTINCT ON joined). */
/* Q57. Latest review per product with a running count of reviews (window). */
/* Q58. Most-recent status per shipment with age in days. */
/* Q59. Latest order per store, ranked by recency gap (stalest stores first). */
/* Q60. Customers whose latest order is Returned/Cancelled - churn-risk list. */
/* Q61. Latest order per customer, then rank customers by recency across the base. */
/* Q62. Most-recent payment per order, flagging where the latest payment Failed. */
/* Q63. Latest attendance per employee, flagging absentees. */
/* Q64. Per region: the single most-recent order with full context. */
/* Q65. Latest redemption per member + points remaining. */
/* Q66. First vs latest order per customer (two DISTINCT ON) + lifetime span in days. */
/* Q67. Latest call per agent + that call's percentile duration (Day 16). */
/* Q68. Newest customer per city with tier. */
/* Q69. Most-recent expense per store + YoY change. */
/* Q70. Latest work_order per line + cycle time. */
/* Q71. Each customer's single highest-value order (DISTINCT ON by value) + its percentile. */
/* Q72. Latest order per payment_mode. */
/* Q73. Most-recent inventory snapshot per warehouse with total stock value (qty x cost_price). */
/* Q74. Latest ticket per agent with resolution status. */
/* Q75. Build a "current state" set: exactly one latest order row per customer. */

/* ============================================================
   SECTION D: PRODUCTION KPI / EXEC DASHBOARDS (25)
   ------------------------------------------------------------ */
/* Q76. Executive KPI strip per region: orders, median AOV, P95 AOV, latest order date. */
/* Q77. Region scorecard: median AOV, P95 AOV, median delivery days, SLA% - one row per region. */
/* Q78. Store leaderboard: median net_total, P95, rank, decile (Day 16). */
/* Q79. Tier dashboard: per tier median AOV, P90, member count, latest signup. */
/* Q80. Delivery SLA dashboard per warehouse: median, P95, breach count and %. */
/* Q81. Support SLA: per priority median & P95 resolution, breach %, latest open ticket. */
/* Q82. Agent performance: median & P95 call duration, latest call, rank. */
/* Q83. Category margin board: median margin %, P10 tail, latest selling price. */
/* Q84. Cohort retention value: median AOV by registration year x order year (pivot). */
/* Q85. Outlier monitor: per region orders beyond P99, with customer and recency. */
/* Q86. Churn-risk board: customers whose latest order is Returned + lifetime median. */
/* Q87. Revenue health: per region median monthly revenue + QoQ trend (window). */
/* Q88. Pricing drift: per product latest selling price vs median historical price. */
/* Q89. Inventory freshness: per warehouse latest snapshot age + stockout flags. */
/* Q90. Delivery funnel: median time order->ship and ship->deliver per region. */
/* Q91. KPI matrix: region x quarter median AOV pivot with row and column medians. */
/* Q92. Top vs bottom decile customers by lifetime value, with the cut points. */
/* Q93. P95 latency board from web_events per device + peak hour (Day 18 hour bucket). */
/* Q94. Salary equity: per department median, P25, P75, IQR, headcount. */
/* Q95. "Most-recent everything": per customer latest order / review / ticket in one wide row. */
/* Q96. Region benchmark gap: each store's median vs its region's median. */
/* Q97. Trimmed-mean revenue per region vs raw mean vs median (three columns). */
/* Q98. Quarterly exec strip: median + P95 AOV per region per quarter, latest quarter flagged. */
/* Q99. SLA alert query: regions whose P95 delivery exceeds target this month. */
/* Q100. One-screen CXO dashboard: per region median/P90/P95 AOV, SLA%, latest order, rank. */
