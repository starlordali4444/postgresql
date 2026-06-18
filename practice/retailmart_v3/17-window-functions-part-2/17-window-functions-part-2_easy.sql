/* ============================================================
   SQL PRACTICE SET - Window Functions Part 2: Aggregation & Frames (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        SUM/AVG/COUNT OVER, running totals, % of total, frame basics
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - Aggregate window functions vs GROUP BY aggregates
     - Running totals (default frame), % of total, partitioned aggregates
     - Intro to ROWS BETWEEN frame syntax
   (Ranking = Day 16; LAG/LEAD = Day 18.)

   Structure: 25 Conceptual + 25 Aggregate-OVER + 25 Running totals/% + 25 Frame basics
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  How does SUM(x) OVER () differ from SUM(x) with GROUP BY? */
/* Q2.  What does SUM(x) OVER (PARTITION BY g) compute for each row? */
/* Q3.  What does adding ORDER BY inside OVER() do to SUM() (running total)? */
/* Q4.  What is the default window frame when ORDER BY is present? */
/* Q5.  What is the default frame when ORDER BY is absent? */
/* Q6.  Define a "running total" in one sentence. */
/* Q7.  How do you compute each row's % of the grand total with a window? */
/* Q8.  How do you compute each row's % of its partition total? */
/* Q9.  What does AVG(x) OVER (PARTITION BY g) give (group average on every row)? */
/* Q10. Why keep detail rows AND a group aggregate in the same result with windows? */
/* Q11. What does COUNT(*) OVER (PARTITION BY g) return? */
/* Q12. Explain ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW. */
/* Q13. Explain ROWS BETWEEN 6 PRECEDING AND CURRENT ROW (7-row window). */
/* Q14. Difference between ROWS and RANGE frame modes (intro). */
/* Q15. Why does a running total need a deterministic ORDER BY? */
/* Q16. Can you mix a window aggregate and a plain aggregate? (no - why) */
/* Q17. What is a moving (rolling) average conceptually? */
/* Q18. Why does SUM() OVER() avoid a self-join for "value vs group total"? */
/* Q19. What does MAX(x) OVER (PARTITION BY g) give? */
/* Q20. How is "share of total" different from a rank? */
/* Q21. Why must you be careful with frames and ties in the ORDER BY? */
/* Q22. What is a cumulative count and how do you build it? */
/* Q23. When would you PARTITION BY DATE_TRUNC('month', d)? */
/* Q24. Can window aggregates appear in WHERE? What's the workaround? */
/* Q25. Name one analyst use each for running total, moving avg, and % of total. */

/* ============================================================
   SECTION B: AGGREGATE OVER (25)
   ------------------------------------------------------------ */
/* Q26. Show each order with the grand total net_total alongside (SUM OVER ()). */
/* Q27. Show each order with its customer's total spend (SUM OVER PARTITION BY cust_id). */
/* Q28. Show each product with its brand's average price. */
/* Q29. Show each employee with their department's average salary. */
/* Q30. Show each order with the count of orders for its store. */
/* Q31. Show each product with the max price in its brand. */
/* Q32. Show each review with the average rating for its product. */
/* Q33. Show each order with its store's total revenue. */
/* Q34. Show each employee with the min and max salary of their store. */
/* Q35. Show each order_item with the order's total net_amount. */
/* Q36. Show each customer's order with the customer's order count. */
/* Q37. Show each product with its category's average price (via brand). */
/* Q38. Show each ticket with the count of tickets for its agent. */
/* Q39. Show each call with the average duration for its agent. */
/* Q40. Show each pay_slip with the company-wide average net_salary. */
/* Q41. Show each shipment with the average delivery days for its courier. */
/* Q42. Show each ad spend with the platform's total spend. */
/* Q43. Show each store with its region's total square_ft. */
/* Q44. Show each order with the customer's average order value. */
/* Q45. Show each product with the supplier's product count. */
/* Q46. Show each member with the average points_balance of their tier. */
/* Q47. Show each order with both the store total and the grand total. */
/* Q48. Show each review with the customer's review count. */
/* Q49. Show each employee with the company headcount (COUNT(*) OVER ()). */
/* Q50. Show each product with brand average and overall average side by side. */

/* ============================================================
   SECTION C: RUNNING TOTALS & % OF TOTAL (25)
   ------------------------------------------------------------ */
/* Q51. Running total of net_total over orders ordered by order_date. */
/* Q52. Running total of net_total per customer ordered by order_date. */
/* Q53. Running count of orders per store over time. */
/* Q54. Each order's % of the grand total revenue. */
/* Q55. Each order's % of its customer's total spend. */
/* Q56. Each product's % of its brand's total price (catalog share). */
/* Q57. Cumulative revenue by month (aggregate to month, then running sum). */
/* Q58. Running total of expenses per department (finance.expenses or stores.expenses). */
/* Q59. Each employee's salary as % of department payroll. */
/* Q60. Running total of points_balance per tier ordered by join_date. */
/* Q61. Each store's revenue as % of its region total. */
/* Q62. Cumulative order count per customer (purchase number). */
/* Q63. Each review's contribution to product's rating sum (running). */
/* Q64. Running total of ad spend per campaign over spend_date. */
/* Q65. Each order_item's % of the order total. */
/* Q66. Cumulative revenue by week across the whole company. */
/* Q67. Each category's revenue as % of grand total (aggregate + window). */
/* Q68. Running total of net_salary per employee across months. */
/* Q69. Each product's units as % of brand units sold. */
/* Q70. Cumulative new customers by registration month. */
/* Q71. Running total of refunds per customer over return_date. */
/* Q72. Each region's store count as % of all stores. */
/* Q73. Cumulative revenue per store ordered by date; show first/last. */
/* Q74. Each call's duration as % of the agent's total talk time. */
/* Q75. Pareto check: cumulative % of revenue by customer (sorted desc). */

/* ============================================================
   SECTION D: FRAME BASICS (ROWS BETWEEN) (25)
   ------------------------------------------------------------ */
/* Q76. 3-row moving average of daily revenue (1 preceding, current, 1 following). */
/* Q77. 7-day moving average of daily order count (6 preceding to current). */
/* Q78. Trailing 3-order average net_total per customer. */
/* Q79. Running max of net_total per customer (UNBOUNDED PRECEDING to CURRENT). */
/* Q80. Running min price seen so far per brand (ordered by product_id). */
/* Q81. Moving sum of last 5 orders' value per customer. */
/* Q82. Centered 3-point average of monthly revenue. */
/* Q83. Trailing 7-day sum of revenue (daily series). */
/* Q84. Difference of current revenue from its 3-row moving average. */
/* Q85. Running average rating per product as reviews accumulate. */
/* Q86. Last-3 average call duration per agent. */
/* Q87. Cumulative max points_balance per customer over join_date. */
/* Q88. 4-week moving average of new signups. */
/* Q89. Trailing 30-row sum of expenses per department. */
/* Q90. Moving average of order value with frame ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING. */
/* Q91. Running total that uses an explicit UNBOUNDED PRECEDING frame. */
/* Q92. Compare default-frame running total vs explicit ROWS frame (same result?). */
/* Q93. 3-month moving average of revenue per store. */
/* Q94. Trailing average delivery time over last 10 shipments per courier. */
/* Q95. Smoothed daily web page-view count (7-day moving average). */
/* Q96. Running sum that resets per customer (PARTITION BY) with a frame. */
/* Q97. Moving average of ratings over last 5 reviews per product. */
/* Q98. Trailing 3-period revenue growth setup (sum windows; growth itself is Day 18). */
/* Q99. Cumulative units sold per product over order_date. */
/* Q100. Build a daily revenue table with 7-day moving avg AND cumulative total in one query. */

/* ============================================================
   END OF Window Functions Part 2 - EASY LEVEL (100 QUESTIONS)
============================================================ */
