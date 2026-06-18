/* ============================================================
   SQL PRACTICE SET - Window Functions Part 3: LAG / LEAD (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Period-over-period per partition, gaps, sessionization
   Database:     RetailMart V3

   Scope (MEDIUM = joins + partitions + offsets):
     - LAG/LEAD per partition with offsets and defaults
     - Gap analysis (time between events); growth % tables
     - Simple sessionization (new session when gap > threshold)
   (Ranking = Day 16; aggregation/frames = Day 17.)

   Structure: 25 Conceptual + 25 Period-over-period + 25 Gap analysis + 25 Sessionization/change
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why partition before LAG for "previous order per customer"? */
/* Q2.  Growth % formula with LAG; why NULLIF guards division. */
/* Q3.  Why a gap-filled month series matters before LAG on monthly data. */
/* Q4.  LAG(x, n, default) - each argument's role. */
/* Q5.  How to compute "days since previous order" per customer. */
/* Q6.  How to detect a change-point (value differs from previous). */
/* Q7.  Sessionization idea: new session when gap to previous event > N minutes. */
/* Q8.  Why LEAD is natural for "time-to-next-event". */
/* Q9.  YoY compare: LAG 12 on a monthly series - requirements. */
/* Q10. How to flag the first row of each partition (LAG IS NULL). */
/* Q11. Compute both prior and next value in one query (LAG + LEAD). */
/* Q12. Why filter on a LAG result must be in an outer query/CTE. */
/* Q13. How to compute a delta and a % delta together. */
/* Q14. Detecting streaks: same value as previous row (run-length idea). */
/* Q15. Why deterministic ORDER BY (date, id) is needed for stable LAG. */
/* Q16. Difference: gap to previous vs gap to next event. */
/* Q17. How to handle missing periods (no order in a month) for growth. */
/* Q18. Compute "previous non-null value" - limitation of plain LAG. */
/* Q19. How to compute moving change (this - 3 rows ago) with LAG offset. */
/* Q20. Sessionization: cumulative sum of "new session" flags = session id. */
/* Q21. Why period-over-period needs aggregation to a grain first. */
/* Q22. How to compute first-purchase to second-purchase latency. */
/* Q23. Detect reactivations: gap to previous order > 90 days. */
/* Q24. How to compare each region's month to its own previous month. */
/* Q25. When LAG/LEAD beats a self-join (clarity + speed). */

/* ============================================================
   SECTION B: PERIOD-OVER-PERIOD (25)
   ------------------------------------------------------------ */
/* Q26. MoM revenue growth % per store (aggregate to month, LAG). */
/* Q27. WoW order-count growth % per store. */
/* Q28. QoQ revenue change per region. */
/* Q29. YoY monthly revenue compare (LAG 12). */
/* Q30. MoM signup growth % per region. */
/* Q31. MoM expense change % per department. */
/* Q32. Day-over-day revenue change (company-wide, gap-filled). */
/* Q33. MoM net_salary change per employee. */
/* Q34. MoM units-sold growth % per product. */
/* Q35. Week-over-week active customers change. */
/* Q36. MoM revenue growth % per category. */
/* Q37. QoQ growth per store with up/down flag. */
/* Q38. MoM refund change % per category. */
/* Q39. MoM ad-spend change % per platform. */
/* Q40. YoY quarterly revenue compare per region. */
/* Q41. MoM review-count change per product. */
/* Q42. MoM ticket-volume change per category. */
/* Q43. MoM page-views change per device. */
/* Q44. MoM AOV (avg order value) change per store. */
/* Q45. MoM new-customer growth per city (via addresses). */
/* Q46. MoM revenue contribution change per region (% of company). */
/* Q47. MoM growth flagged where it turns negative. */
/* Q48. Rolling 2-period change: this month vs 2 months ago (LAG 2). */
/* Q49. MoM growth for the top-5 brands by revenue. */
/* Q50. Build a MoM table per store: month, revenue, prev, growth %, flag. */

/* ============================================================
   SECTION C: GAP ANALYSIS (25)
   ------------------------------------------------------------ */
/* Q51. Days between consecutive orders per customer. */
/* Q52. Average inter-order gap per customer (LAG then AVG). */
/* Q53. Longest gap between orders per customer. */
/* Q54. Customers with a gap > 90 days (reactivation candidates). */
/* Q55. Time to second order per customer (first->second latency). */
/* Q56. Gap to next review per customer (engagement cadence). */
/* Q57. Time between consecutive calls per customer. */
/* Q58. Gap between consecutive shipments per courier. */
/* Q59. Days between consecutive snapshots per (warehouse, product). */
/* Q60. Time between first and last order per customer (lifespan). */
/* Q61. Gap between consecutive logins/page-views per session. */
/* Q62. Customers whose most recent gap exceeds their average gap (slowing down). */
/* Q63. Inter-purchase time distribution buckets per customer. */
/* Q64. Gap to next ticket per agent (workload spacing). */
/* Q65. Days since previous price change per product (price-ordered). */
/* Q66. Gap between consecutive payments per order. */
/* Q67. Median inter-order gap per region (LAG then percentile). */
/* Q68. Customers with shrinking gaps (accelerating purchase frequency). */
/* Q69. First-order to registration latency (orders vs registration_date). */
/* Q70. Gap between consecutive promotions (start dates). */
/* Q71. Time-to-next-order after a return (post-return behavior). */
/* Q72. Largest single-day revenue jump per store (gap to previous day). */
/* Q73. Customers dormant > 180 days (gap to today via LEAD/CURRENT_DATE). */
/* Q74. Average gap between reviews per product. */
/* Q75. Build a per-customer "purchase cadence" table: avg/min/max gap. */

/* ============================================================
   SECTION D: SESSIONIZATION & CHANGE DETECTION (25)
   ------------------------------------------------------------ */
/* Q76. Flag a new web session when gap to previous view > 30 minutes. */
/* Q77. Assign session ids via cumulative sum of new-session flags. */
/* Q78. Session duration per session (first to last view_timestamp). */
/* Q79. Views per session (count within derived session id). */
/* Q80. Detect price changes: rows where price <> previous price per product. */
/* Q81. Detect > 50% price jumps (likely data-entry errors). */
/* Q82. Detect order-status transitions over time per order (if status changes logged). */
/* Q83. Detect tier upgrades/downgrades per customer over time. */
/* Q84. Detect stock-outs: quantity drops to 0 from positive previous. */
/* Q85. Detect rating drops vs previous review per product. */
/* Q86. Flag revenue days that broke the previous record (running-max compare). */
/* Q87. Detect reactivation events (gap > 90 days then an order). */
/* Q88. Detect consecutive declining months (2+ negative MoM in a row). */
/* Q89. Detect the first month a store crossed Rs1,00,000 revenue. */
/* Q90. Detect churn signal: gap to next order is NULL (no next order). */
/* Q91. Count distinct sessions per customer per day. */
/* Q92. Average session length per device_type. */
/* Q93. Detect rapid repeat orders (next order within 1 day). */
/* Q94. Detect salary changes per employee across months. */
/* Q95. Flag products whose price changed more than 3 times. */
/* Q96. Detect a customer's longest active streak (consecutive months with orders). */
/* Q97. Flag campaigns whose spend doubled vs previous period. */
/* Q98. Detect inventory replenishment (quantity rises vs previous snapshot). */
/* Q99. Sessionize calls: new "call burst" when gap > 1 hour per customer. */
/* Q100. Build a sessionized web table: session_id, start, end, duration, view_count. */

/* ============================================================
   END OF Window Functions Part 3 - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
