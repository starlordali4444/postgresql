/* ============================================================
   SQL PRACTICE SET - Window Functions Part 3: LAG / LEAD (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        LAG, LEAD, period-over-period comparison
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - LAG / LEAD with default and offset/default args
     - Previous vs next row comparison; simple deltas
     - Period-over-period (month-over-month) basics
   (Ranking = Day 16; aggregation/frames = Day 17.)

   Structure: 25 Conceptual + 25 LAG basics + 25 LEAD basics + 25 Deltas/period-over-period
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does LAG(x) return for a given row? */
/* Q2.  What does LEAD(x) return for a given row? */
/* Q3.  Why do LAG/LEAD require an ORDER BY inside OVER()? */
/* Q4.  What does LAG(x, 2) return (offset)? */
/* Q5.  What does LAG(x, 1, 0) do (default for the first row)? */
/* Q6.  What value does LAG return for the first row of a partition with no default? */
/* Q7.  How does PARTITION BY change LAG/LEAD (reset per group)? */
/* Q8.  Write the formula for month-over-month growth % using LAG. */
/* Q9.  Why guard the LAG denominator with NULLIF in a growth %? */
/* Q10. Difference between LAG and accessing the previous row via a self-join. */
/* Q11. What is "period-over-period" analysis? */
/* Q12. How to compute the gap (days) between consecutive orders per customer. */
/* Q13. Can LAG/LEAD appear in WHERE directly? What's the workaround? */
/* Q14. How does LEAD(x, 1) help compute "time to next event"? */
/* Q15. Why must the ORDER BY be deterministic for LAG/LEAD to be meaningful? */
/* Q16. What's the result type of LAG on a numeric column? */
/* Q17. How to detect a change (current <> previous) with LAG. */
/* Q18. How to flag rows where value increased vs the previous row. */
/* Q19. Why might LAG over months need a gap-filled month series first? */
/* Q20. How to compute first-vs-second order delta with LAG. */
/* Q21. What does LEAD return for the last row of a partition (no default)? */
/* Q22. How to compute a running difference (delta) series with LAG. */
/* Q23. When to use LAG vs a window frame for "previous value". */
/* Q24. How to compute % change vs the same month last year (LAG 12 on monthly series). */
/* Q25. Name one analyst use each for LAG, LEAD, and period-over-period growth. */

/* ============================================================
   SECTION B: LAG BASICS (25)
   ------------------------------------------------------------ */
/* Q26. For each order per customer, show the previous order's net_total (LAG). */
/* Q27. For each order per customer, show the previous order_date. */
/* Q28. Monthly revenue with the previous month's revenue beside it. */
/* Q29. For each product price-ordered, the previous product's price. */
/* Q30. For each review per product, the previous review's rating. */
/* Q31. For each call per agent, the previous call's duration. */
/* Q32. For each shipment per courier, the previous delivery time. */
/* Q33. For each pay_slip per employee, the previous month's net_salary. */
/* Q34. For each order per store (by date), the previous order's value. */
/* Q35. LAG with offset 2: the order two-before per customer. */
/* Q36. LAG with default 0: previous net_total, 0 for first order. */
/* Q37. Monthly signups with previous month's signups. */
/* Q38. For each snapshot per (warehouse, product), the previous quantity. */
/* Q39. For each customer's order, the date of their previous order. */
/* Q40. Previous day's revenue beside each day's revenue. */
/* Q41. For each ad spend per campaign, the previous spend amount. */
/* Q42. For each ticket per agent, the previous ticket's created_date. */
/* Q43. For each product per brand (price desc), the next-cheaper price (LAG on desc). */
/* Q44. Previous week's order count beside each week. */
/* Q45. For each member, the previous points_balance snapshot (if ordered by date). */
/* Q46. LAG to show "prior status" of orders per customer over time. */
/* Q47. Previous quarter revenue beside each quarter. */
/* Q48. For each order line, the previous line's net_amount within the order. */
/* Q49. Previous month's expenses per department. */
/* Q50. For each customer, previous order value AND the one before (LAG 1 and LAG 2). */

/* ============================================================
   SECTION C: LEAD BASICS (25)
   ------------------------------------------------------------ */
/* Q51. For each order per customer, the NEXT order's net_total (LEAD). */
/* Q52. For each order per customer, the next order_date. */
/* Q53. Days until the next order per customer (LEAD on order_date - order_date). */
/* Q54. For each review per product, the next review's rating. */
/* Q55. For each call per customer, time until the next call. */
/* Q56. Monthly revenue with the next month's revenue beside it. */
/* Q57. For each product price-ordered, the next product's price. */
/* Q58. For each shipment per courier, the next shipment's shipped_date. */
/* Q59. LEAD with offset 2: the order two-after per customer. */
/* Q60. LEAD with default: next net_total, NULL->0 for the last order. */
/* Q61. For each page_view per session, the next view_timestamp (session step). */
/* Q62. For each pay_slip per employee, the next month's net_salary. */
/* Q63. Time gap to next ticket per agent. */
/* Q64. For each snapshot per product, the next day's quantity. */
/* Q65. For each customer's first order, when their second order happened (LEAD). */
/* Q66. Next week's order count beside each week. */
/* Q67. For each order per store, the next order's value. */
/* Q68. Gap to next review per customer (engagement cadence). */
/* Q69. For each campaign spend, the next spend amount and date. */
/* Q70. Next quarter revenue beside each quarter. */
/* Q71. For each member, the next points snapshot. */
/* Q72. Time until next purchase per customer (churn signal). */
/* Q73. For each order line, the next line's net_amount within the order. */
/* Q74. Next day's revenue beside each day. */
/* Q75. For each customer, next order value AND the one after (LEAD 1 and LEAD 2). */

/* ============================================================
   SECTION D: DELTAS & PERIOD-OVER-PERIOD (25)
   ------------------------------------------------------------ */
/* Q76. Month-over-month revenue growth % (LAG, NULLIF-guarded). */
/* Q77. Day-over-day change in order count. */
/* Q78. Gap in days between consecutive orders per customer. */
/* Q79. First-vs-second order value delta per customer. */
/* Q80. Detect price changes: rows where current price <> previous (price-ordered series). */
/* Q81. Flag days where revenue > previous day by > 20%. */
/* Q82. Week-over-week order growth % per store. */
/* Q83. Quarter-over-quarter revenue change per region. */
/* Q84. Change in net_salary vs previous month per employee. */
/* Q85. Delta in points_balance vs previous snapshot per member. */
/* Q86. Month-over-month signup growth %. */
/* Q87. Difference in delivery time vs previous shipment per courier. */
/* Q88. Web session duration: last view_timestamp - first via LEAD per session. */
/* Q89. Same-month-last-year revenue compare (LAG 12 on monthly series). */
/* Q90. Flag rating drops: review rating < previous review rating per product. */
/* Q91. Detect stock-outs: snapshot quantity drops to 0 from a positive previous. */
/* Q92. Order value delta vs previous order per customer (absolute + %). */
/* Q93. Month-over-month expense change % per department. */
/* Q94. Days between first and second order per customer (LEAD on first). */
/* Q95. Flag months with negative MoM growth. */
/* Q96. Consecutive-day revenue streak setup (current vs previous comparison). */
/* Q97. Detect a >50% price jump vs previous (data-entry error flag). */
/* Q98. Customer reactivation gap: longest gap between consecutive orders. */
/* Q99. Period-over-period contribution: this month vs last month per category. */
/* Q100. MoM revenue table per store: revenue, prev_revenue, growth %, up/down flag. */

/* ============================================================
   END OF Window Functions Part 3 - EASY LEVEL (100 QUESTIONS)
============================================================ */
