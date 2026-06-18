/* ============================================================
   SQL PRACTICE SET - Window Functions Part 1: Ranking & Bucketing (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Multi-key ranking, ties, Top-N per group, NTILE bucketing
   Database:     RetailMart V3

   Scope (MEDIUM = multi-table joins + partitions + tie handling):
     - Ranking within multi-column partitions; deterministic tie-breaks
     - Top-N / nth-per-group; dedup keeping the right record
     - NTILE quartile/decile bucketing on joined/aggregated data
   (Aggregation/frames = Day 17; LAG/LEAD = Day 18.)

   Structure: 25 Conceptual + 25 Ranking-in-partitions + 25 Top-N/nth + 25 NTILE/dedup
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why can't you reference a window alias in the same SELECT's WHERE? Show the subquery/CTE fix. */
/* Q2.  How does PARTITION BY a, b differ from PARTITION BY a for ranking? */
/* Q3.  Why does ROW_NUMBER need a tie-breaker column to be reproducible? */
/* Q4.  Explain how RANK leaves gaps and DENSE_RANK does not, with a tie example. */
/* Q5.  When ranking, what does ORDER BY ... DESC NULLS LAST change vs default? */
/* Q6.  NTILE(4) vs width_bucket - when would an analyst pick each? */
/* Q7.  Why is "Top-N per group" a window job, not a GROUP BY job? */
/* Q8.  How do you get exactly the Nth row per group (not top-N)? */
/* Q9.  Dedup: why ORDER BY in the window decides which duplicate you keep. */
/* Q10. Can two window functions share a window via the WINDOW clause? Show the idea. */
/* Q11. What happens to NTILE buckets when group size < bucket count? */
/* Q12. Why might RANK and ROW_NUMBER give the same result on a UNIQUE column? */
/* Q13. Explain "PARTITION BY with no ORDER BY" for a ranking function. */
/* Q14. How do you rank descending but break ties by an ascending second key? */
/* Q15. Why does filtering rn <= 3 in an outer query implement top-3? */
/* Q16. What's the cost difference between ranking all rows vs adding a WHERE first? */
/* Q17. How does DISTINCT interact with a window function in the SELECT? */
/* Q18. Why is NTILE sensitive to the ORDER BY tie order? */
/* Q19. Explain quartile labeling (NTILE(4) -> Q1..Q4) for segmentation. */
/* Q20. When is RANK the "right" choice over ROW_NUMBER for business meaning? */
/* Q21. How do you rank within a partition but reset for each new partition value? */
/* Q22. Why might you PARTITION BY a derived expression (e.g. DATE_TRUNC)? */
/* Q23. What does PERCENT_RANK conceptually add over RANK? (preview only) */
/* Q24. How do you keep ties together at the top-N boundary (RANK <= N vs ROW_NUMBER <= N)? */
/* Q25. Why compute ranking in a CTE before joining to other tables? */

/* ============================================================
   SECTION B: RANKING WITHIN PARTITIONS (25)
   ------------------------------------------------------------ */
/* Q26. Rank products by price within each brand, tie-break by product_id. */
/* Q27. Rank employees by salary within each store, tie-break by joining_date. */
/* Q28. Rank orders by net_total within each store and order_date month. */
/* Q29. Rank customers by points_balance within each tier (join loyalty.members). */
/* Q30. Rank products by price within each category (products -> brand -> category). */
/* Q31. Rank stores by total revenue within each region (CTE-aggregate then rank). */
/* Q32. Rank reviews by rating then review_date within each product. */
/* Q33. Rank employees by salary within each (store, role). */
/* Q34. Rank brands by product count within each category. */
/* Q35. Rank agents by resolved-ticket count within each ticket category. */
/* Q36. Rank orders within each customer by net_total DESC, order_date DESC. */
/* Q37. DENSE_RANK products by cost_price within each supplier. */
/* Q38. Rank shipments by delivery-day count within each courier. */
/* Q39. Rank pay_slips by net_salary within each (salary_year, salary_month). */
/* Q40. Rank customers by order count within each registration-year cohort. */
/* Q41. Rank products by review count within each brand (join reviews). */
/* Q42. Rank warehouses by total snapshot quantity within each region. */
/* Q43. Rank stores by employee count within each region. */
/* Q44. Rank order_items by net_amount within each order. */
/* Q45. Rank campaigns by total ad spend within each platform (join ads_spend). */
/* Q46. Rank customers by lifetime spend within each city (via addresses). */
/* Q47. Rank products by units sold within each brand (join order_items). */
/* Q48. Rank employees by salary within department; keep ranks 1-5. */
/* Q49. Rank tickets by resolution time within each agent. */
/* Q50. Rank regions by average order value (aggregate then rank). */

/* ============================================================
   SECTION C: TOP-N / NTH PER GROUP (25)
   ------------------------------------------------------------ */
/* Q51. Top-3 highest-paid employees per department (with names). */
/* Q52. Top-3 best-selling products per brand by units. */
/* Q53. Top-2 most recent orders per customer (full rows). */
/* Q54. Top-5 stores by revenue per region. */
/* Q55. The 2nd-highest salary per department (exactly nth). */
/* Q56. The 3rd-most-recent order per customer. */
/* Q57. Top-1 (latest) review per product, with the review text. */
/* Q58. Top-3 customers by spend per city. */
/* Q59. Top-N with tie inclusion: all products tied for the top price per brand (RANK). */
/* Q60. The single highest-value order per store. */
/* Q61. Top-3 longest-open tickets per agent. */
/* Q62. Top-2 products by margin (price - cost_price) per category. */
/* Q63. The earliest (first-ever) order per customer. */
/* Q64. Top-3 regions by store count (rank aggregated). */
/* Q65. Top-5 most-reviewed products per brand. */
/* Q66. The most expensive product per supplier. */
/* Q67. Top-3 agents by call volume per call_reason. */
/* Q68. Top-2 highest-rated reviews per customer. */
/* Q69. The nth order (parametric, e.g. 5th) per customer. */
/* Q70. Top-3 warehouses by capacity per region. */
/* Q71. Top-1 per group but break ties deterministically (ROW_NUMBER design). */
/* Q72. Top-10 orders overall, then number them per store. */
/* Q73. Top-3 brands by revenue per category. */
/* Q74. The most recent payment per order. */
/* Q75. Top-3 customers by review count per registration year. */

/* ============================================================
   SECTION D: NTILE BUCKETING & DEDUP (25)
   ------------------------------------------------------------ */
/* Q76. NTILE(4) customers into spend quartiles (join orders, aggregate). */
/* Q77. NTILE(10) products into price deciles within each brand. */
/* Q78. NTILE(5) orders into net_total quintiles per store. */
/* Q79. NTILE(4) employees into salary quartiles per department; label Q1..Q4. */
/* Q80. NTILE(3) stores into small/mid/large by square_ft per region. */
/* Q81. Dedup customers by email keeping the most recently registered. */
/* Q82. Dedup products by product_name (lowercased) keeping the cheapest. */
/* Q83. Dedup orders by (cust_id, order_date) keeping the highest net_total. */
/* Q84. Dedup addresses keeping the default (is_default) per customer. */
/* Q85. NTILE(4) of review ratings per product into quartile buckets. */
/* Q86. NTILE(100) percentile bucket of order net_total per region. */
/* Q87. Bucket customers into RFM "Monetary" quartiles (NTILE(4) on spend). */
/* Q88. Bucket customers into "Frequency" quartiles (NTILE(4) on order count). */
/* Q89. Dedup reviews keeping the latest per (customer, product). */
/* Q90. NTILE(4) of products by units sold within category. */
/* Q91. Dedup near-duplicate suppliers by lowercased trimmed name. */
/* Q92. NTILE(5) of employees by salary across the company; show band ranges. */
/* Q93. Dedup payments keeping the latest per order. */
/* Q94. NTILE(4) of stores by revenue; tag the top quartile. */
/* Q95. Dedup customers by phone (digits only) keeping the latest. */
/* Q96. NTILE(3) tenure buckets of employees by joining_date per department. */
/* Q97. Combine: top quartile (NTILE(4)=1) customers by spend, then rank within it. */
/* Q98. Dedup order_items keeping the line with the largest net_amount per (order, product). */
/* Q99. NTILE(4) of products by margin per brand. */
/* Q100. RFM bucket preview: NTILE(4) on recency, frequency, monetary separately per customer. */

/* ============================================================
   END OF Window Functions Part 1 - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
