/* ============================================================
   SQL PRACTICE SET - Window Functions Part 2: Aggregation & Frames (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Partitioned running totals, moving averages, frame syntax
   Database:     RetailMart V3

   Scope (MEDIUM = joins + partitions + explicit frames):
     - Running totals / counts per partition over time
     - Moving averages with ROWS BETWEEN; % of partition total
     - Reset-at-boundary patterns (PARTITION BY period)
   (Ranking = Day 16; LAG/LEAD = Day 18.)

   Structure: 25 Conceptual + 25 Partitioned running + 25 Moving averages/frames + 25 Share/reset
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why does PARTITION BY reset a running total at each partition boundary? */
/* Q2.  Default frame (RANGE UNBOUNDED PRECEDING) vs ROWS UNBOUNDED PRECEDING - when do they differ? */
/* Q3.  Why can RANGE with ties sum more rows than you expect? */
/* Q4.  How to build a 7-day moving average correctly when some days are missing? */
/* Q5.  Why is gap-filling (date series) sometimes required before a moving average? */
/* Q6.  ROWS BETWEEN 6 PRECEDING AND CURRENT ROW - how many rows in the frame? */
/* Q7.  How to reset a running total at the year boundary (PARTITION BY year)? */
/* Q8.  Why compute % of partition total with SUM() OVER (PARTITION BY g) in the denominator? */
/* Q9.  Difference between a trailing and a centered moving average. */
/* Q10. Why must the ORDER BY be deterministic for a reproducible running total? */
/* Q11. How does a frame interact with PARTITION BY (frame is within partition)? */
/* Q12. When is RANGE BETWEEN INTERVAL '7 days' PRECEDING ... valid (date/numeric ORDER BY)? */
/* Q13. Why might a moving average over ROWS differ from over RANGE on daily data? */
/* Q14. How to compute cumulative distinct counts (and why it's hard with windows)? */
/* Q15. Explain "percent of running total" vs "running percent". */
/* Q16. Why pre-aggregate to a grain (day/month) before windowing a time series? */
/* Q17. How to show both the partition total and the running total in one row. */
/* Q18. What does FIRST_VALUE/LAST_VALUE need (a frame) to be correct? (preview) */
/* Q19. Why is LAST_VALUE often "wrong" without an explicit full frame? */
/* Q20. How to compute a moving sum that ignores the current row (exclude current). */
/* Q21. Why does a running max never decrease and a running min never increase? */
/* Q22. How to combine a window aggregate with a GROUP BY in layered steps. */
/* Q23. When to use RANGE vs ROWS for financial running balances. */
/* Q24. How to compute share-of-total within multiple partition levels at once. */
/* Q25. Why are window aggregates ideal for "detail + subtotal" report rows? */

/* ============================================================
   SECTION B: PARTITIONED RUNNING TOTALS (25)
   ------------------------------------------------------------ */
/* Q26. Running total of net_total per customer over order_date. */
/* Q27. Running order count per store over order_date. */
/* Q28. Cumulative revenue by month per store (aggregate then window). */
/* Q29. Running total of expenses per department over expense_date. */
/* Q30. Cumulative units sold per product over order_date. */
/* Q31. Running total of points_balance per tier over join_date. */
/* Q32. Cumulative new customers per registration month per region. */
/* Q33. Running revenue per region by month. */
/* Q34. Running total of refunds per customer over return_date. */
/* Q35. Cumulative ad spend per platform over spend_date. */
/* Q36. Running count of reviews per product over review_date. */
/* Q37. Running net_salary total per employee over salary month. */
/* Q38. Cumulative orders per customer with the purchase number (1,2,3...). */
/* Q39. Running revenue per payment_mode by month. */
/* Q40. Cumulative shipments per courier by week. */
/* Q41. Running total of order value per store, reset each year. */
/* Q42. Cumulative call minutes per agent by day. */
/* Q43. Running revenue per category by month (via brand). */
/* Q44. Cumulative distinct products ordered per customer (approx via min order_date per product). */
/* Q45. Running headcount per department by joining_date. */
/* Q46. Cumulative revenue per city by month (via addresses). */
/* Q47. Running total of net_amount per order over order_item_id. */
/* Q48. Cumulative tickets per agent by created_date. */
/* Q49. Running revenue per brand by week. */
/* Q50. Running total per customer with both partition total and running total shown. */

/* ============================================================
   SECTION C: MOVING AVERAGES & FRAMES (25)
   ------------------------------------------------------------ */
/* Q51. 7-day moving average of daily revenue. */
/* Q52. 7-day moving average of daily order count. */
/* Q53. 3-month moving average of monthly revenue per store. */
/* Q54. Trailing 5-order average net_total per customer. */
/* Q55. Centered 3-point moving average of monthly signups. */
/* Q56. 4-week moving average of weekly revenue per region. */
/* Q57. Trailing 30-day sum of revenue (daily series). */
/* Q58. Moving average rating over last 5 reviews per product. */
/* Q59. 7-day moving average of web page-views (gap-filled by date series). */
/* Q60. Trailing 3-month average expenses per department. */
/* Q61. Moving average delivery time over last 10 shipments per courier. */
/* Q62. Running average order value per customer (expanding window). */
/* Q63. Difference of daily revenue from its 7-day moving average (anomaly setup). */
/* Q64. 5-period moving sum of units sold per product. */
/* Q65. Trailing 6-month average net_salary per employee. */
/* Q66. Moving average of call duration over last 20 calls per agent. */
/* Q67. 3-row moving average with ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING. */
/* Q68. Rolling 90-day revenue total (RANGE INTERVAL on a date series). */
/* Q69. Trailing average review rating per customer (last 3). */
/* Q70. 7-day moving average AND daily value side by side for spotting spikes. */
/* Q71. Moving average that excludes the current row (n PRECEDING to 1 PRECEDING). */
/* Q72. 4-quarter moving average of revenue (quarterly aggregate). */
/* Q73. Trailing 10-order average margin per product. */
/* Q74. Rolling 7-day distinct-customer count approximation per day. */
/* Q75. Compare ROWS vs RANGE moving average on a series with duplicate dates. */

/* ============================================================
   SECTION D: SHARE-OF-TOTAL & RESET-AT-BOUNDARY (25)
   ------------------------------------------------------------ */
/* Q76. Each order's % of its customer's total spend. */
/* Q77. Each product's % of its brand's total units sold. */
/* Q78. Each store's revenue as % of its region total. */
/* Q79. Each category's revenue as % of grand total. */
/* Q80. Each employee's salary as % of department payroll. */
/* Q81. Running total of revenue reset at each year boundary (PARTITION BY year). */
/* Q82. Running total reset at each month per store. */
/* Q83. Each month's revenue as % of its year's revenue. */
/* Q84. Pareto: cumulative % of revenue by customer (sorted desc) - find the top 20%. */
/* Q85. Each agent's resolved tickets as % of their category total. */
/* Q86. Each product's review count as % of brand review count. */
/* Q87. Running revenue per store reset quarterly. */
/* Q88. Each campaign's spend as % of its platform total. */
/* Q89. Each region's contribution % to monthly company revenue. */
/* Q90. Cumulative % of units by product within category (ABC analysis setup). */
/* Q91. Each customer's monthly spend as % of their lifetime spend. */
/* Q92. Reset running headcount at each department. */
/* Q93. Each order line's % of order total (basket composition). */
/* Q94. Each city's spend as % of region spend (via addresses). */
/* Q95. Running revenue reset at year boundary AND % of that year's total. */
/* Q96. Each warehouse's stock as % of its region's stock. */
/* Q97. Each tier's points as % of all points. */
/* Q98. Each weekday's revenue as % of the week (PARTITION BY ISO week). */
/* Q99. Top-20% revenue customers via cumulative share (Pareto cutoff). */
/* Q100. Build a monthly report: revenue, running YTD total, and % of year - per store. */

/* ============================================================
   END OF Window Functions Part 2 - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
