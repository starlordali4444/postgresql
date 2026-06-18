/* ============================================================
   SQL PRACTICE SET - Filtering & Sorting (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Filtering & Sorting - advanced patterns
   Database:     RetailMart V3

   Scope (HARD = production-grade query craft):
     - Sargable predicates (index-friendly)
     - NULL semantics in WHERE / IS DISTINCT FROM
     - Complex range predicates
     - Keyset pagination (vs OFFSET)
     - ORDER BY with NULLS FIRST/LAST, ties
     - Subquery filters (EXISTS / NOT EXISTS / ANY / ALL)
     - Predicate pushdown / planner hints

   Structure: 25 Conceptual + 25 Index-aware filtering + 25 Pagination/ORDER BY + 25 Subquery filters
   ============================================================ */

/* ============================================================
   SECTION A: FILTERING & SORTING - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does "sargable" mean - and why does WHERE LOWER(email) = ... defeat an index? */
/* Q2.  Compare WHERE col = NULL vs WHERE col IS NULL - why the first never matches. */
/* Q3.  Explain IS DISTINCT FROM - and why it's safer than = for nullable columns. */
/* Q4.  Walk through how WHERE col BETWEEN x AND y treats inclusive bounds. */
/* Q5.  Why is WHERE col1 = a AND col2 = b often faster with a composite index (col1, col2)? */
/* Q6.  Explain index column-order matters: (a, b) vs (b, a). */
/* Q7.  Why is WHERE date_col >= '2025-01-01' AND date_col < '2026-01-01' faster than EXTRACT(year FROM date_col) = 2025? */
/* Q8.  Compare ILIKE 'abc%' vs ILIKE '%abc' - only one is index-usable. */
/* Q9.  Walk through LIMIT + OFFSET pagination - and why deep OFFSETs are slow. */
/* Q10. Explain keyset pagination - show ORDER BY id > last_seen_id LIMIT 50. */
/* Q11. What is ORDER BY ... NULLS LAST - and what's the default for ASC vs DESC? */
/* Q12. Compare DISTINCT vs DISTINCT ON - and when each preserves which row. */
/* Q13. Explain WHERE x = ANY(array) vs WHERE x IN (...) - semantically equivalent. */
/* Q14. What is WHERE x = ALL(subquery) - and why is it rarely used? */
/* Q15. Explain EXISTS vs IN - when does each scale better? */
/* Q16. Why does NOT IN break when the subquery returns NULLs? */
/* Q17. Compare NOT EXISTS vs LEFT JOIN ... IS NULL for anti-join. */
/* Q18. What does WHERE col @@ tsquery do - full-text search predicate. */
/* Q19. Explain how a covering index can answer a query without touching the heap. */
/* Q20. What is "row constructor compare": (a, b) > (1, 2) - and how does it help keyset paging. */
/* Q21. Why is ORDER BY RANDOM() LIMIT 1 catastrophic on huge tables? */
/* Q22. Compare WHERE col IN (subq) vs WHERE col = (subq scalar). */
/* Q23. Explain WHERE col SIMILAR TO regex - and why most use ~ instead. */
/* Q24. What is a "false predicate" (WHERE 1=0) - used as table-shape filter. */
/* Q25. Walk through the planner's decision: SeqScan vs IndexScan vs BitmapIndexScan. */

/* ============================================================
   SECTION B: INDEX-AWARE FILTERING (25)
   ------------------------------------------------------------ */
/* Q26. Find orders in date range '2025-03-01' to '2025-04-01' (sargable). */
/* Q27. Find customers whose email LIKE 'a%' (prefix-search index-friendly). */
/* Q28. Find products WHERE price BETWEEN 1000 AND 5000 (range index). */
/* Q29. Find orders WHERE order_status IN ('Pending','Processing') using IN-list. */
/* Q30. Find products WHERE supplier_id = 10 AND brand_id = 3 (composite-index candidate). */
/* Q31. Find tickets WHERE priority = 'Critical' AND status = 'Open' (composite). */
/* Q32. Find shipments WHERE courier_name = 'Bluedart' AND shipped_date >= now() - 7. */
/* Q33. Find page_views WHERE device_type = 'Mobile' AND os = 'iOS' (composite-index potential). */
/* Q34. Find employees WHERE role = 'Manager' AND store_id IN (1,2,3). */
/* Q35. Find orders WHERE net_total > 10000 AND order_date >= '2025-01-01' (compound). */
/* Q36. Sargable date filter: orders in current month (DATE_TRUNC vs range bounds). */
/* Q37. Sargable: WHERE created_at >= now() - INTERVAL '7 days'. */
/* Q38. Non-sargable rewrite: WHERE year(order_date) = 2025 -> WHERE order_date >= '2025-01-01' AND order_date < '2026-01-01'. */
/* Q39. Index-only scan: SELECT email FROM customers WHERE email LIKE 'a%' (with appropriate index). */
/* Q40. Find tickets WHERE resolved_date IS NULL (partial-index candidate). */
/* Q41. Find orders WHERE order_status = 'Cancelled' (partial-index for rare value). */
/* Q42. Find customers WHERE deleted_at IS NULL AND email = 'x@y.com'. */
/* Q43. Find pay_slips WHERE salary_year = 2025 AND salary_month IN (1,2,3). */
/* Q44. Find reviews WHERE rating >= 4 AND created_at >= '2025-01-01'. */
/* Q45. Find inventory_snapshots WHERE warehouse_id = 5 AND snapshot_date = '2025-04-15'. */
/* Q46. Find calls WHERE call_reason = 'Refund' AND duration > 300. */
/* Q47. Find ad_spend WHERE platform = 'Facebook' AND spend_date BETWEEN ... AND .... */
/* Q48. Find page_views with referrer_url LIKE 'https://google.%' (prefix). */
/* Q49. Find customers with tier_id IN (3, 4) - top tiers. */
/* Q50. Find supply_chain.shipments WHERE supplier_id = 7 AND quantity > 100. */

/* ============================================================
   SECTION C: PAGINATION + ORDER BY EDGE CASES (25)
   ------------------------------------------------------------ */
/* Q51. OFFSET-LIMIT pagination: orders page 100, page size 50 (OFFSET 4950). */
/* Q52. Keyset pagination: orders WHERE (order_date, order_id) < (last_date, last_id) ORDER BY order_date DESC, order_id DESC LIMIT 50. */
/* Q53. ORDER BY net_total DESC NULLS LAST - keep NULLs at end. */
/* Q54. ORDER BY tier_id NULLS FIRST - surface "no tier" first. */
/* Q55. ORDER BY priority CASE WHEN priority='Critical' THEN 1 WHEN 'High' THEN 2 ... (custom sort). */
/* Q56. Tie-breaker: ORDER BY revenue DESC, customer_id ASC (deterministic order). */
/* Q57. ORDER BY DATE_TRUNC('month', order_date), net_total DESC - bucket-then-sort. */
/* Q58. SELECT DISTINCT ON (cust_id) * FROM orders ORDER BY cust_id, order_date DESC - latest order per customer. */
/* Q59. SELECT DISTINCT ON (product_id) ... ORDER BY product_id, review_date DESC - most-recent review per product. */
/* Q60. Top-N per group via window or DISTINCT ON. */
/* Q61. Stable pagination across DELETEs - why id-based keyset is robust. */
/* Q62. Sort with LOCALE: ORDER BY full_name COLLATE "C" vs default. */
/* Q63. Sort numbers stored as TEXT: ORDER BY col::int (cast). */
/* Q64. Sort emails by domain: ORDER BY split_part(email, '@', 2). */
/* Q65. Sort tickets by priority weight: CASE-driven. */
/* Q66. Pagination cursor with composite key (created_at, id). */
/* Q67. Backward pagination (previous page) using keyset. */
/* Q68. LIMIT + OFFSET 0 - degenerate case (just LIMIT). */
/* Q69. LIMIT 0 - return no rows but force query plan & metadata. */
/* Q70. ORDER BY column_position (1, 2, 3) - quick demo. */
/* Q71. Find duplicates: ORDER BY email, customer_id then row_number window pattern. */
/* Q72. Avoid OFFSET 100000: use keyset with composite cursor. */
/* Q73. ORDER BY 1 vs ORDER BY full_name - when each is appropriate. */
/* Q74. ORDER BY RANDOM() LIMIT N - sample N random rows (small tables only). */
/* Q75. TABLESAMPLE BERNOULLI(1) - proper random sampling on huge tables. */

/* ============================================================
   SECTION D: SUBQUERY & SET FILTERS (25)
   ------------------------------------------------------------ */
/* Q76. EXISTS: customers who placed at least one order. */
/* Q77. EXISTS: products with at least one 5-star review. */
/* Q78. NOT EXISTS: customers who never wrote a review. */
/* Q79. NOT EXISTS: products that never sold. */
/* Q80. IN (subquery): orders by Gold-tier customers. */
/* Q81. NOT IN (subquery): customers NOT in loyalty.members - show NULL-safety variant with NOT EXISTS. */
/* Q82. = ANY: orders matching list of statuses pulled from a config table. */
/* Q83. > ALL: products priced higher than all products of brand_id=5. */
/* Q84. < ANY: customers whose tier_id < ANY(SELECT tier_id FROM ...). */
/* Q85. Find orders by customers in the top 10 highest-spend cust_ids (subquery + IN). */
/* Q86. Find products in categories with > 100 products. */
/* Q87. Find tickets opened on dates when there was a system outage (subquery joining audit logs). */
/* Q88. Find customers in cities where there is at least one store. */
/* Q89. Find shipments in months where average delivery time was < 2 days. */
/* Q90. Find pay_slips in months when total payroll > 100,000 (HAVING + subquery). */
/* Q91. Find orders whose product mix overlaps with the top-selling brand. */
/* Q92. Find ad_campaigns active during a customer signup spike (subquery joining). */
/* Q93. Find customers whose tier matches a calculated cohort. */
/* Q94. Find products in brands whose AVG(price) > 5000 (correlated subquery). */
/* Q95. Find employees whose salary > AVG(salary) for their department (correlated subquery). */
/* Q96. Find customers who placed > 3 orders in any single week (subquery + grouping). */
/* Q97. Find products whose total units sold > median product units. */
/* Q98. Find orders that placed in the same hour as the spike (audit-linked). */
/* Q99. Find calls handled by agents who also resolved tickets (intersection-style subquery). */
/* Q100. Find customers who have ALL of {order, review, ticket, call} (relational division pattern). */

/* ============================================================
   END OF Filtering & Sorting - HARD LEVEL (100 QUESTIONS)
============================================================ */
