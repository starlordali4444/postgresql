/* ============================================================
   SQL PRACTICE SET - Window Functions Part 2: Aggregation & Frames (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Production running/rolling metrics, frames, FIRST/LAST_VALUE
   Database:     RetailMart V3

   Scope (HARD = interview/production, aggregation+frames only):
     - Rolling windows with explicit ROWS/RANGE frames; gap-filled series
     - FIRST_VALUE/LAST_VALUE/NTH_VALUE with correct frames
     - Share-of-total, reset-at-boundary, anomaly-from-moving-average
   (Ranking = Day 16; LAG/LEAD = Day 18 - not used here.)

   Structure: 25 Conceptual + 25 Rolling metrics + 25 FIRST/LAST_VALUE + 25 Reports
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why is LAST_VALUE wrong by default, and what frame fixes it? */
/* Q2.  ROWS vs RANGE vs GROUPS frame modes - precise differences. */
/* Q3.  Why does a 7-day moving average need a complete date series first? */
/* Q4.  RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW - requirements and gotchas. */
/* Q5.  How to compute a moving average that's correct at series edges (partial windows). */
/* Q6.  Why FIRST_VALUE + frame = the partition's anchor value on every row. */
/* Q7.  How to exclude the current row from a frame (and why for "peer average"). */
/* Q8.  Cumulative distinct count - why windows can't do it directly; the workaround. */
/* Q9.  Reset-at-boundary running totals: PARTITION BY period vs frame tricks. */
/* Q10. Why pre-aggregate to a grain before applying frames on a fact table. */
/* Q11. Detect anomalies as deviation from a trailing moving average - design. */
/* Q12. Share-of-total at two partition levels in one query (region and grand). */
/* Q13. Why RANGE with duplicate ORDER BY keys sums all ties into one frame step. */
/* Q14. NTH_VALUE use-cases and its frame dependency. */
/* Q15. Rolling median - why it's hard with standard window functions. */
/* Q16. Why "running total then % of final" needs the partition total, not the frame. */
/* Q17. How to compute month-to-date and prior-month-to-date in one pass (no LAG). */
/* Q18. Window aggregate + HAVING-like filter: where does the filter go? */
/* Q19. Frame performance: why huge RANGE frames can be O(n^2) without care. */
/* Q20. Gap-filling with generate_series + LEFT JOIN before windowing - pattern. */
/* Q21. Why a centered moving average shifts trend timing vs trailing. */
/* Q22. Compute "% to peak" using a running MAX with a frame. */
/* Q23. Building a contribution-to-cumulative (Pareto) curve correctly. */
/* Q24. Why FILTER (WHERE ...) inside a window aggregate is not allowed; alternative. */
/* Q25. Combining multiple frames (trailing-7 and trailing-30) in one query. */

/* ============================================================
   SECTION B: ROLLING METRICS (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: Finance wants a gap-filled daily revenue series with a 7-day moving average. */
/* Q27. 30-day rolling revenue total per store (RANGE on a date series). */
/* Q28. 7-day rolling distinct-customer count (approximation) per day. */
/* Q29. Trailing 3-month revenue and its growth base (no LAG - just the trailing sum). */
/* Q30. Rolling 28-day order count with a 4-week moving average. */
/* Q31. Moving average of delivery time over last 20 shipments per courier. */
/* Q32. Deviation of daily revenue from its trailing 7-day average (flag > 2x). */
/* Q33. Rolling 90-day revenue per region, gap-filled. */
/* Q34. Trailing-10 average margin per product; flag drops. */
/* Q35. 7-day moving average of web page-views per device_type. */
/* Q36. Rolling 6-month average net_salary per department. */
/* Q37. Cumulative revenue with a 30-day trailing sum side by side. */
/* Q38. Rolling 14-day ticket volume per category with moving average. */
/* Q39. Trailing 5-order average basket size per customer. */
/* Q40. Rolling weekly active customers (distinct per trailing 7 days). */
/* Q41. Moving average of ratings over last 10 reviews per product. */
/* Q42. Rolling 30-day refund total per customer. */
/* Q43. 3-month moving average revenue per category, gap-filled. */
/* Q44. Trailing 7-day cumulative units sold per product. */
/* Q45. Rolling 4-week signups with moving average per region. */
/* Q46. Trailing-20 average call duration per agent; flag fatigue (rising trend). */
/* Q47. Rolling 90-day GMV with a 7-day smoothed line. */
/* Q48. Moving average of order value excluding the current order (peer baseline). */
/* Q49. Rolling 12-month revenue (TTM) per store. */
/* Q50. Daily revenue, 7-day MA, 30-day MA in one query (multiple frames). */

/* ============================================================
   SECTION C: FIRST_VALUE / LAST_VALUE / NTH_VALUE (25)
   ------------------------------------------------------------ */
/* Q51. First order value per customer on every row (FIRST_VALUE). */
/* Q52. Last (most recent) order value per customer with a correct full frame. */
/* Q53. Each order's value vs the customer's first order value (ratio). */
/* Q54. First and last review rating per product on every row. */
/* Q55. NTH_VALUE: the 2nd order value per customer on every row. */
/* Q56. Each product's price vs its brand's cheapest (FIRST_VALUE by price asc). */
/* Q57. Each employee's salary vs their department's top salary (FIRST_VALUE desc). */
/* Q58. First and current cumulative revenue per store (anchor vs running). */
/* Q59. Each month's revenue vs the year's first month (indexing to 100). */
/* Q60. Last delivered date per courier on every shipment row. */
/* Q61. Each call's duration vs the agent's longest call (FIRST_VALUE desc). */
/* Q62. First purchase date per customer attached to every order. */
/* Q63. Each order's value vs the store's max order value (peak). */
/* Q64. % to peak: running value / running MAX per series. */
/* Q65. Each product's price vs its supplier's most expensive product. */
/* Q66. First and last snapshot quantity per (warehouse, product). */
/* Q67. Each campaign's spend vs the platform's biggest campaign. */
/* Q68. NTH_VALUE: 3rd-highest order value per customer on every row (with frame). */
/* Q69. Each region's monthly revenue vs its best month (FIRST_VALUE by revenue desc). */
/* Q70. Each customer's latest tier vs first tier (anchor comparison). */
/* Q71. Each pay_slip vs the employee's first recorded net_salary. */
/* Q72. Each product's units vs brand's best-seller units (FIRST_VALUE). */
/* Q73. First and last order value per customer in one row (both ends). */
/* Q74. Each store's revenue vs region's top store revenue. */
/* Q75. Anchor every row to the partition's first AND last values, compute the span. */

/* ============================================================
   SECTION D: SHARE / RESET / REPORTS (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: CFO wants a monthly P&L strip: revenue, YTD revenue, and % of year - per region. */
/* Q77. Pareto curve: cumulative % of revenue by customer; identify the top-20% set. */
/* Q78. ABC product classification via cumulative % of units within category. */
/* Q79. Each order's % of customer spend AND % of store revenue (two windows). */
/* Q80. Running revenue reset per year with % of that year's total per month. */
/* Q81. Contribution analysis: each category's monthly % of company revenue. */
/* Q82. Month-to-date vs full-month revenue per store (frame to month end). */
/* Q83. Each employee's salary percentile-ish share within department payroll. */
/* Q84. Rolling 7-day revenue with its % of trailing 30-day revenue. */
/* Q85. Weekly revenue as % of its month (reset monthly). */
/* Q86. Each product's running share of brand revenue over time. */
/* Q87. Customer cohort: cumulative spend per customer indexed to first month = 100. */
/* Q88. Each region's quarter revenue as % of its year. */
/* Q89. Detect anomaly months: revenue > 1.5x trailing 3-month average. */
/* Q90. Each store's daily revenue as % of its trailing 7-day total. */
/* Q91. Cumulative refunds as % of cumulative revenue per customer. */
/* Q92. Each agent's daily resolved tickets as % of their trailing-week total. */
/* Q93. Reset running GMV quarterly and show quarter-to-date %. */
/* Q94. Top-20% products by cumulative units (Pareto) per category. */
/* Q95. Each campaign's spend as running % of platform spend over time. */
/* Q96. Monthly revenue with YTD total and YTD % growth-base (growth itself is Day 18). */
/* Q97. Each customer's order as % of their trailing-90-day spend. */
/* Q98. Region revenue contribution waterfall (cumulative share, sorted). */
/* Q99. Each warehouse's stock as % of region stock AND % of company stock. */
/* Q100. Executive dashboard query: per region per month - revenue, YTD, %-of-year, 3-mo MA. */

/* ============================================================
   END OF Window Functions Part 2 - HARD LEVEL (100 QUESTIONS)
============================================================ */
