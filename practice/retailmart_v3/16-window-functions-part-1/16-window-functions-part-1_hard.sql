/* ============================================================
   SQL PRACTICE SET - Window Functions Part 1: Ranking & Bucketing (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Interview-grade ranking, Top-N/nth, dedup, NTILE segmentation
   Database:     RetailMart V3

   Scope (HARD = production/interview patterns, ranking & bucketing only):
     - Top-N / nth-per-group with correct tie semantics
     - Dedup keeping the right record; gaps in ranks
     - NTILE-driven segmentation (quartiles/deciles), percentile rank
   (Aggregation/frames = Day 17; LAG/LEAD = Day 18 - not used here.)

   Structure: 25 Conceptual + 25 Top-N/nth + 25 Dedup/identity + 25 Segmentation
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Top-N per group: compare RANK <= N vs ROW_NUMBER <= N when ties exist at the boundary. */
/* Q2.  Why does ROW_NUMBER give exactly N rows but RANK may give more? */
/* Q3.  Design a deterministic tie-break for "latest order per customer". */
/* Q4.  Explain why a window function is evaluated after WHERE/GROUP BY/HAVING but before ORDER BY/LIMIT. */
/* Q5.  Why must "filter on rank" go in an outer query or CTE (not WHERE)? */
/* Q6.  Dedup: prove ORDER BY in the partition picks the surviving row. */
/* Q7.  NTILE vs PERCENT_RANK vs CUME_DIST for "percentile" - which for RFM bucketing? */
/* Q8.  When group size is not divisible by NTILE(n), which buckets get the extra rows? */
/* Q9.  Why can ranking the full table then filtering be slower than a LATERAL top-N? */
/* Q10. Explain the leftmost-tie problem: equal keys + ROW_NUMBER = arbitrary winner. */
/* Q11. How do you compute "rank within group" and "rank overall" in one query? */
/* Q12. Why is DISTINCT + window function a common bug? */
/* Q13. How to get the top-N AND a count of how many were tied out? */
/* Q14. Why PARTITION BY DATE_TRUNC('month', d) for monthly top-N? */
/* Q15. Explain "exactly the 2nd highest" with ties (DENSE_RANK = 2). */
/* Q16. When should top-N per group be solved with DISTINCT ON instead? (preview) */
/* Q17. How does NULLS FIRST/LAST in the window ORDER BY change rank 1? */
/* Q18. Why does deduping on a non-unique ORDER BY risk dropping the wrong row? */
/* Q19. How to bucket into quartiles but keep bucket edges stable across refreshes? */
/* Q20. Explain percentile rank of a value via NTILE(100) and its limitations. */
/* Q21. Why might RANK over a huge partition need a supporting sort/index (Day 20)? */
/* Q22. How to rank by a composite score computed in the same query? */
/* Q23. Top-N per group across two grain levels (region then store) - how? */
/* Q24. Why is "keep latest per email" the canonical dedup interview question? */
/* Q25. How to express "everyone in the top decile of spend" cleanly? */

/* ============================================================
   SECTION B: TOP-N / NTH PER GROUP (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: The CHRO wants the top-3 earners per department with names and salary. */
/* Q27. Top-3 products by revenue (units x price) per brand. */
/* Q28. The 2nd-highest-salary employee per store (exactly nth, ties via DENSE_RANK). */
/* Q29. Top-5 customers by lifetime spend per region. */
/* Q30. The latest delivered order per customer (full row, deterministic). */
/* Q31. Top-3 most-returned products per category (join returns->order_items->products). */
/* Q32. The single highest-margin product per supplier. */
/* Q33. Top-3 agents by resolved tickets per ticket category. */
/* Q34. The 3rd order ever placed by each customer. */
/* Q35. Top-2 stores by revenue per region, with the region total alongside. */
/* Q36. Top-N including ties: all products at the max price per brand (RANK = 1). */
/* Q37. The most recent review per product, only where rating <= 2 (worst-recent). */
/* Q38. Top-3 highest-value orders per payment_mode. */
/* Q39. The earliest and latest order per customer in one result (two ROW_NUMBERs). */
/* Q40. Top-5 longest-duration calls per agent with caller info. */
/* Q41. The top product by units in each (brand, registration-year-of-buyer) - two-level. */
/* Q42. Top-3 customers by order count per acquisition month (registration cohort). */
/* Q43. The single cheapest in-stock product per warehouse (join snapshots). */
/* Q44. Top-3 campaigns by spend per platform with rank shown. */
/* Q45. The nth (parametric) most expensive product per category. */
/* Q46. Top-2 employees by salary per (store, role) tie-broken by tenure. */
/* Q47. The latest payment per order, only for Delivered orders. */
/* Q48. Top-3 regions by average order value (aggregate then rank). */
/* Q49. The highest-rated, then most-recent, review per product (multi-key order). */
/* Q50. Top-N per group then a grand ROW_NUMBER across the survivors. */

/* ============================================================
   SECTION C: DEDUPLICATION & IDENTITY (25)
   ------------------------------------------------------------ */
/* Q51. SCENARIO: DBA found duplicate emails - keep the most-recently-registered customer per email. */
/* Q52. List the rows that WOULD be deleted by Q51 (rn > 1). */
/* Q53. Dedup products by lowercased trimmed product_name, keep the cheapest. */
/* Q54. Dedup orders sharing (cust_id, order_date) - keep the highest net_total. */
/* Q55. Keep the default address per customer; if none, keep the lowest address_id. */
/* Q56. Dedup near-duplicate suppliers by lowercased name; keep the lowest supplier_id. */
/* Q57. Dedup reviews per (customer_id, product_id) keeping the latest review_date. */
/* Q58. Keep the latest payment per order; flag orders with multiple payments. */
/* Q59. Dedup customers by normalized phone (digits only) keeping latest registration. */
/* Q60. Identify products appearing under multiple brands (same name) and pick one canonical. */
/* Q61. Dedup order_items per (order_id, prod_id) keeping the max net_amount line. */
/* Q62. Find emails with >=3 duplicate accounts and rank the keepers. */
/* Q63. Keep the most recent snapshot per (warehouse_id, product_id). */
/* Q64. Dedup loyalty.members per customer (defensive) keeping highest points_balance. */
/* Q65. Produce a "golden record" per email: keep latest, list merged ids. */
/* Q66. Dedup tickets per (customer_id, subject) keeping the latest created_date. */
/* Q67. Keep the first-ever order per customer as their "acquisition order". */
/* Q68. Dedup addresses by (customer_id, pincode) keeping is_default then lowest id. */
/* Q69. Find customers whose duplicates span different cities (data-quality flag). */
/* Q70. Dedup products by (brand_id, product_name) keeping the most expensive. */
/* Q71. Rank duplicate-group sizes: which email has the most duplicate accounts? */
/* Q72. Keep the latest review per product and compute its position vs all reviews. */
/* Q73. Dedup calls per (customer_id, call_start_time::date) keeping the longest. */
/* Q74. Produce a deduped customer list (rn = 1) ready for an export. */
/* Q75. Validate dedup: count rows before vs after (rn = 1) per email. */

/* ============================================================
   SECTION D: NTILE SEGMENTATION & PERCENTILES (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: Marketing wants customers split into spend quartiles (NTILE(4)) labeled Q1..Q4. */
/* Q77. NTILE(10) spend deciles per region; show decile boundaries. */
/* Q78. RFM "Monetary": NTILE(5) on lifetime spend per customer. */
/* Q79. RFM "Frequency": NTILE(5) on order count per customer. */
/* Q80. RFM "Recency": NTILE(5) on days-since-last-order per customer. */
/* Q81. Combine the three NTILE(5) scores into an RFM code (e.g. '5-4-3'). */
/* Q82. Tag the top spend quartile customers as 'VIP' and rank within it. */
/* Q83. NTILE(4) products by margin per category; list the top-quartile products. */
/* Q84. Percentile rank of each order's net_total via NTILE(100) per region. */
/* Q85. NTILE(4) employees by salary per department; compare to company-wide quartile. */
/* Q86. Bucket stores into 4 revenue tiers; show count and avg per tier. */
/* Q87. NTILE(3) of products by units sold (slow/medium/fast movers) per brand. */
/* Q88. NTILE(4) of reviews by rating per product and tag the bottom quartile. */
/* Q89. Find customers in the top decile of BOTH frequency and monetary. */
/* Q90. NTILE(5) of warehouses by total stock; flag the lowest quintile for audit. */
/* Q91. Quartile of delivery time per courier (NTILE(4)); slowest quartile per courier. */
/* Q92. NTILE(4) of campaigns by spend per platform; top-quartile spenders. */
/* Q93. Build a "spend tier x frequency tier" segmentation grid (two NTILEs). */
/* Q94. NTILE(10) of order values overall; the 90th-percentile bucket threshold. */
/* Q95. Segment customers into quartiles and rank them within each quartile by recency. */
/* Q96. NTILE(4) tenure buckets of employees per store; newest-quartile list. */
/* Q97. Percentile bucket of product price per brand (NTILE(100)) and its rank. */
/* Q98. NTILE(4) of customers by review count; engaged top-quartile. */
/* Q99. Compare NTILE(4) bucket vs RANK-based quartile on the same column - when they differ. */
/* Q100. Full RFM segmentation: NTILE(5) R/F/M, map codes to Champions/Loyal/At-Risk/Lost. */

/* ============================================================
   END OF Window Functions Part 1 - HARD LEVEL (100 QUESTIONS)
============================================================ */
