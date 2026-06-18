/* ============================================================
   SQL PRACTICE SET - Median, Percentiles & DISTINCT ON (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        PERCENTILE_CONT/DISC for median & P90/P95; DISTINCT ON latest-per-group
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - PERCENTILE_CONT(0.5) for median - treat it like AVG, one new function
     - P90 / P95 via PERCENTILE_CONT; WITHIN GROUP (ORDER BY ...) syntax
     - DISTINCT ON (key) ORDER BY key, ts DESC  ->  "latest record per group"
   (Window-function recap from Days 16-18, pivot recap from Day 21, are fair game.)

   Structure: 25 Conceptual + 25 Median/Percentile + 25 DISTINCT ON + 25 Combined
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does the median represent, and how does it differ from the mean (AVG)? */
/* Q2.  Why is the median more robust to outliers than the average? */
/* Q3.  What does PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY x) compute? */
/* Q4.  What is the WITHIN GROUP (ORDER BY ...) clause for? */
/* Q5.  Difference between PERCENTILE_CONT (interpolates) and PERCENTILE_DISC (real value)? */
/* Q6.  What do "P90" and "P95" mean as percentiles? */
/* Q7.  Why is P95 a common SLA / latency metric instead of the average? */
/* Q8.  What values do PERCENTILE_CONT(0.0) and PERCENTILE_CONT(1.0) return? */
/* Q9.  Is PERCENTILE_CONT an aggregate like SUM/AVG? (ordered-set aggregate) */
/* Q10. Can PERCENTILE_CONT be combined with GROUP BY for a per-group median? */
/* Q11. What does DISTINCT ON (col) do in PostgreSQL? */
/* Q12. Why must DISTINCT ON normally be paired with an ORDER BY? */
/* Q13. Which row does DISTINCT ON keep per group (first by the ORDER BY)? */
/* Q14. How is DISTINCT ON different from GROUP BY? */
/* Q15. How is DISTINCT ON different from filtering ROW_NUMBER() = 1 (Day 16)? */
/* Q16. Why is DISTINCT ON a PostgreSQL-specific shortcut? */
/* Q17. What does "latest record per group" mean for an analyst (give an example)? */
/* Q18. Why does PERCENTILE_CONT interpolate between two neighbouring values? */
/* Q19. When would you prefer PERCENTILE_DISC (must return an actual observed value)? */
/* Q20. What does the mode() WITHIN GROUP (ORDER BY x) aggregate return? */
/* Q21. How do percent_rank() / cume_dist() (Day 16) relate to percentiles? */
/* Q22. How does NTILE(100) (Day 16) approximate percentile buckets? */
/* Q23. Why can median delivery time tell a different story than average delivery time? */
/* Q24. Can you pass an array of fractions, e.g. PERCENTILE_CONT(ARRAY[0.5,0.9,0.95])? */
/* Q25. Name two business KPIs better expressed as a median than as a mean. */

/* ============================================================
   SECTION B: MEDIAN & PERCENTILES (25)
   ------------------------------------------------------------ */
/* Q26. Median net_total across all orders. */
/* Q27. Average vs median net_total side by side in one row. */
/* Q28. P90 and P95 of net_total across all orders. */
/* Q29. Median net_total per region (orders -> stores -> region). */
/* Q30. Median net_total per store. */
/* Q31. P95 net_total per region. */
/* Q32. Median order value per payment_mode. */
/* Q33. Median delivery time in days (delivered_date - order_date) for Delivered orders. */
/* Q34. P90 delivery time in days across Delivered orders. */
/* Q35. Median delivery time in days per region. */
/* Q36. Median review rating per product. */
/* Q37. Median call_duration_seconds per agent. */
/* Q38. P95 call_duration_seconds across all calls. */
/* Q39. Median refund_amount across all returns. */
/* Q40. Median net_salary from pay_slips. */
/* Q41. P90 net_salary per department. */
/* Q42. Median line quantity from order_items. */
/* Q43. Median unit price (order_items) per category. */
/* Q44. Median daily ad spend per platform. */
/* Q45. Median points_balance of loyalty members per tier. */
/* Q46. Median net_total per customer tier (Bronze..Platinum). */
/* Q47. Median ticket resolution hours (resolved_date - created_date). */
/* Q48. P95 ticket resolution hours per priority. */
/* Q49. Median order value per month for 2025. */
/* Q50. Median AND P95 net_total per region in one query (ARRAY of fractions). */

/* ============================================================
   SECTION C: DISTINCT ON - latest record per group (25)
   ------------------------------------------------------------ */
/* Q51. Latest order per customer: DISTINCT ON (cust_id) ORDER BY cust_id, order_date DESC. */
/* Q52. The most-recent order_status per customer. */
/* Q53. Latest review per customer. */
/* Q54. Latest review per product. */
/* Q55. Most-recent ticket per customer. */
/* Q56. Latest payment per order. */
/* Q57. Latest shipment row per order. */
/* Q58. Most-recent inventory snapshot per warehouse x product. */
/* Q59. Latest salary_history row per employee. */
/* Q60. Most-recent price a product sold at (order_items via order_date). */
/* Q61. Latest page_view per customer. */
/* Q62. First (earliest) order per customer (ORDER BY order_date ASC). */
/* Q63. Highest-value order per customer (ORDER BY net_total DESC). */
/* Q64. Cheapest order per customer. */
/* Q65. Latest call per agent. */
/* Q66. Most-recent redemption per member. */
/* Q67. Latest order per store. */
/* Q68. Latest order per region. */
/* Q69. Newest customer per region (join addresses). */
/* Q70. Latest ad spend row per platform. */
/* Q71. Most-recent expense per store. */
/* Q72. Latest work_order per production line. */
/* Q73. Top-rated review per product (ORDER BY rating DESC). */
/* Q74. Latest attendance row per employee. */
/* Q75. Most-recent transfer per account. */

/* ============================================================
   SECTION D: COMBINED / MIXED (25)
   ------------------------------------------------------------ */
/* Q76. Per customer: median net_total and the date of their latest order. */
/* Q77. Per region: median order value and the single latest order. */
/* Q78. Per store: median net_total and the most-recent order_status. */
/* Q79. Median delivery time in days per warehouse (orders -> stores -> warehouse). */
/* Q80. Take each customer's latest order, then report the median net_total of those. */
/* Q81. P95 net_total per region, sorted descending. */
/* Q82. Per product: median rating and the latest review's text. */
/* Q83. Per agent: median call duration and their latest call timestamp. */
/* Q84. Per customer: median resolution time and their latest ticket. */
/* Q85. Per tier: median net_total and count of customers. */
/* Q86. Median vs average net_total per region (show the gap). */
/* Q87. P90 net_total per payment_mode, only modes with > 100 orders. */
/* Q88. Latest *Delivered* order per customer (filter status, then DISTINCT ON). */
/* Q89. Median net_total computed over each customer's most-recent order only. */
/* Q90. Per category: median unit price and the latest selling price. */
/* Q91. Per tier: median points_balance and the latest join_date. */
/* Q92. P95 delivery days per region, only regions with > 500 orders. */
/* Q93. Median order value for Gold/Platinum customers, per region. */
/* Q94. Latest order per customer whose net_total is above the global median. */
/* Q95. Per store: median net_total and P95 net_total as two columns. */
/* Q96. Per month: median net_total and the latest order of that month. */
/* Q97. Customers whose latest order is Returned (DISTINCT ON + filter). */
/* Q98. Median refund_amount per region (returns -> orders -> stores -> region). */
/* Q99. Median order value per region pivoted by quarter (Day 21 pivot + percentile). */
/* Q100. Executive KPI strip: median and P95 order value per region in one tidy result. */
