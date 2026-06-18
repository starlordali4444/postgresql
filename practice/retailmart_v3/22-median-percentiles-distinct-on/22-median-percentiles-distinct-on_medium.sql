/* ============================================================
   SQL PRACTICE SET - Median, Percentiles & DISTINCT ON (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Grouped percentiles with joins; DISTINCT ON across tables; pivot/window integration
   Database:     RetailMart V3

   Scope (MEDIUM = joins + multi-condition + tidy reshaping):
     - Per-group median / P25-P75-P90-P95 via PERCENTILE_CONT (ARRAY for many at once)
     - DISTINCT ON joined to other tables for enriched latest-per-group reports
     - Percentiles combined with pivots (Day 21) and window functions (Days 16-18)
   (Approximate / streaming percentiles are conceptual until the Hard/Crazy tiers.)

   Structure: 25 Conceptual + 25 Percentiles w/ joins + 25 DISTINCT ON across tables + 25 Pivot/Window integration
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why does PERCENTILE_CONT interpolate while PERCENTILE_DISC snaps to a real row? */
/* Q2.  Show the exact output difference of CONT vs DISC on an even-count set {10,20,30,40}. */
/* Q3.  Why is median exactly PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY x)? */
/* Q4.  How do you compute several percentiles in one pass using an ARRAY argument? */
/* Q5.  How do you unnest the array result of PERCENTILE_CONT(ARRAY[0.5,0.9,0.95])? */
/* Q6.  Why can't PERCENTILE_CONT appear directly in a WHERE clause? */
/* Q7.  How does DISTINCT ON break ties - what decides which row wins? */
/* Q8.  Why add a deterministic tiebreaker (e.g. order_id) to DISTINCT ON's ORDER BY? */
/* Q9.  DISTINCT ON vs ROW_NUMBER() OVER(...) - when is each cleaner? */
/* Q10. Why must the DISTINCT ON column(s) be the leftmost ORDER BY keys? */
/* Q11. Compare the cost of DISTINCT ON vs a correlated subquery for latest-per-group. */
/* Q12. Can PERCENTILE_CONT be used as a window function with OVER (and what changes)? */
/* Q13. What does mode() WITHIN GROUP return when two values tie for most-frequent? */
/* Q14. How do you combine FILTER (WHERE ...) (Day 21) with a percentile aggregate? */
/* Q15. Why does a per-group median need GROUP BY but DISTINCT ON does not? */
/* Q16. How does NTILE(4) (Day 16) give quartile buckets vs PERCENTILE_CONT cut points? */
/* Q17. Define percent_rank() vs cume_dist() precisely. */
/* Q18. Why can P50 from PERCENTILE_CONT differ from the NTILE(2) boundary value? */
/* Q19. How do you compute the interquartile range (P75 - P25)? */
/* Q20. For outlier fences via 1.5xIQR, which percentiles do you need? */
/* Q21. Why does DISTINCT ON keep the entire row, not just the key column? */
/* Q22. How would you emulate DISTINCT ON in standard SQL (ROW_NUMBER filter)? */
/* Q23. How do you take the median of a *computed* expression (e.g. delivery days)? */
/* Q24. Do ordered-set aggregates include or ignore NULLs in the ordering input? */
/* Q25. When is a single median misleading (e.g. a bimodal distribution)? */

/* ============================================================
   SECTION B: PERCENTILES WITH JOINS & GROUPS (25)
   ------------------------------------------------------------ */
/* Q26. Median and P95 net_total per region (full join chain). */
/* Q27. Median delivery days per warehouse (orders -> stores -> warehouse). */
/* Q28. Median, P90 and P95 of net_total per store in one query (ARRAY). */
/* Q29. P25, P50, P75 of net_total per region (quartiles via ARRAY). */
/* Q30. Interquartile range (P75 - P25) of net_total per region. */
/* Q31. Median unit price per category (order_items -> products -> brand -> category). */
/* Q32. Median basket size (items per order) per store. */
/* Q33. Median order value per customer tier, only tiers with > 1000 customers. */
/* Q34. Median review rating per brand. */
/* Q35. Median call duration per agent, only agents with > 50 calls. */
/* Q36. P95 ticket resolution hours per priority. */
/* Q37. Median net_salary per department, with headcount alongside. */
/* Q38. Median gap (days) between consecutive orders per customer (LAG, Day 18, then median). */
/* Q39. Median monthly revenue per region (group by month, then median across months). */
/* Q40. Median ad spend per platform per quarter. */
/* Q41. P90 delivery days per region, excluding Cancelled/Failed orders. */
/* Q42. Median points_balance per tier with member counts. */
/* Q43. Median refund_amount per category (returns -> products -> category). */
/* Q44. Median order value per weekday (day-of-week). */
/* Q45. Median order value for new vs returning customers (first-order flag via window). */
/* Q46. Median gross margin per category (item revenue - cost_price). */
/* Q47. Median time-to-first-order in days per registration-year cohort. */
/* Q48. Median net_total per store, ranked, top 10 (Day 16 RANK). */
/* Q49. Median vs mean net_total per region with the spread and % difference. */
/* Q50. P95 net_total per payment_mode with order counts (FILTER mix). */

/* ============================================================
   SECTION C: DISTINCT ON across tables (25)
   ------------------------------------------------------------ */
/* Q51. Latest order (full row) per customer, with the store name. */
/* Q52. Most-recent review per product, with the reviewer's name. */
/* Q53. Latest ticket per customer, with priority and subject. */
/* Q54. Most-recent payment per order, with the payment_mode name. */
/* Q55. Latest inventory snapshot per warehouse x product, with quantity. */
/* Q56. Latest salary per employee, with department. */
/* Q57. Most-recent price each product sold at (latest order_items by order_date). */
/* Q58. Latest order per customer, plus days since that order. */
/* Q59. First and latest order per customer (two DISTINCT ON queries, joined). */
/* Q60. Most-recent *Delivered* order per customer. */
/* Q61. Latest call per agent, with duration. */
/* Q62. Newest customer per city (addresses). */
/* Q63. Latest redemption per member, with points. */
/* Q64. Most-recent expense per store, with amount. */
/* Q65. Latest page_view per customer, with page_url. */
/* Q66. Highest-rated review per product (tie-break by latest review_date). */
/* Q67. Latest order per store, with net_total and status. */
/* Q68. Most-recent work_order per production line. */
/* Q69. Latest attendance per employee, with status. */
/* Q70. Latest order per region (one row per region). */
/* Q71. Most-recent ad spend per platform, with amount. */
/* Q72. Latest shipment per order, with status and date. */
/* Q73. Each customer's single largest order (DISTINCT ON by net_total DESC). */
/* Q74. Latest transfer per account, with amount. */
/* Q75. Most-recent ticket per agent. */

/* ============================================================
   SECTION D: PERCENTILE + PIVOT / WINDOW INTEGRATION (25)
   ------------------------------------------------------------ */
/* Q76. Median net_total per region x quarter pivot (Day 21). */
/* Q77. P95 net_total per region x month matrix. */
/* Q78. Median delivery days per region x quarter. */
/* Q79. Each customer's latest order plus that order's percent_rank of net_total (Day 16). */
/* Q80. Flag orders above their region's P90 (join the regional P90 back to each order). */
/* Q81. Median order value per region with a rolling per-quarter view (window framing). */
/* Q82. Customers whose latest order exceeds their own median order value. */
/* Q83. Per store: median net_total, then rank stores by it (Day 16). */
/* Q84. Region median vs each store's median (gap to the regional benchmark). */
/* Q85. NTILE(10) deciles of net_total vs PERCENTILE_CONT cut points, side by side. */
/* Q86. Per category: median price and the latest selling price (DISTINCT ON + percentile). */
/* Q87. Per agent: median resolution time and their latest ticket status. */
/* Q88. Executive KPI strip: count, median, P95 order value per region. */
/* Q89. Median basket size per store pivoted by quarter. */
/* Q90. Customers above the global P95 net_total whose latest order is Returned. */
/* Q91. Per region: median order value and the % of orders above it. */
/* Q92. IQR-based outlier orders per region (net_total beyond P75 + 1.5.IQR). */
/* Q93. Median monthly revenue per region with the latest month flagged. */
/* Q94. Per tier: median order value and the single most-recent order. */
/* Q95. P90 / P95 / P99 net_total per region (ARRAY) as three columns. */
/* Q96. Median delivery days per warehouse, plus the latest snapshot quantity. */
/* Q97. Rank regions by median order value, showing P95 alongside. */
/* Q98. Per payment_mode: median order value pivoted by region. */
/* Q99. Median net_total per customer cohort (registration year) x order year. */
/* Q100. Full exec dashboard: per region - median, P90, P95 order value + latest order date. */
