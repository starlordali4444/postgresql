/* ============================================================
   SQL PRACTICE SET - Reading Query Plans (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        EXPLAIN ANALYZE diagnosis, join algorithms, sargable rewrites
   Database:     RetailMart V3   (EXPLAIN is read-only - safe to run)

   Scope (MEDIUM = real plans on joins/aggregates + targeted rewrites):
     - Estimated vs actual rows; join-algorithm choice; sort/hash spills
     - Diagnosing the bottleneck node; analyst-level query rewrites
   (Index creation is Day 20 - diagnose here, don't create.)

   Structure: 25 Conceptual + 25 Diagnose + 25 Rewrite-for-sargability + 25 Joins/sorts
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  How do you decide a plan is "bad" from EXPLAIN ANALYZE? */
/* Q2.  Why does a wrong row estimate cascade into a bad join choice? */
/* Q3.  When does the planner prefer Hash Join over Nested Loop? */
/* Q4.  When is a Merge Join chosen, and what does it need (sorted inputs)? */
/* Q5.  What makes a Sort spill to disk, and how does the plan show it? */
/* Q6.  What does "Batches > 1" in a Hash node mean? */
/* Q7.  Why does a leading-wildcard LIKE force a Seq Scan? */
/* Q8.  Why is function-on-column non-sargable; give the general fix. */
/* Q9.  What is "Rows Removed by Filter" telling you about selectivity? */
/* Q10. How does LIMIT change the chosen plan (early stop)? */
/* Q11. Why can OR across columns be slower than UNION ALL? */
/* Q12. Why does SELECT * prevent an Index Only Scan? */
/* Q13. What does a high loop count on a Nested Loop inner side imply? */
/* Q14. Estimated vs actual: which side (over/under) causes nested-loop blowups? */
/* Q15. Why might ANALYZE (stats refresh) fix a bad plan with no query change? */
/* Q16. How do BUFFERS hits vs reads indicate caching behavior? */
/* Q17. What is a Bitmap scan's sweet spot (selectivity range)? */
/* Q18. Why is "SELECT DISTINCT" to fix a fan-out join a smell? */
/* Q19. How does a correlated subquery appear in a plan (SubPlan/loops)? */
/* Q20. Why prefer EXISTS over IN when the subquery may return NULLs? */
/* Q21. What does GroupAggregate vs HashAggregate tell you about sorting? */
/* Q22. How does parallelism (Gather) show up and when does it help? */
/* Q23. Why is planning time relevant for very simple, frequently-run queries? */
/* Q24. How to compare two plans fairly (same warm cache, EXPLAIN ANALYZE)? */
/* Q25. What 3 things do you check first on any slow analyst query? */

/* ============================================================
   SECTION B: DIAGNOSE THE BOTTLENECK (25)
   ------------------------------------------------------------ */
/* Q26. EXPLAIN ANALYZE a customer-lifetime-spend aggregate; name the slow node. */
/* Q27. EXPLAIN ANALYZE the orders->customers join; Hash or Nested Loop? */
/* Q28. EXPLAIN ANALYZE a top-10 orders by net_total; did LIMIT help? */
/* Q29. EXPLAIN ANALYZE WHERE email LIKE '%gmail.com'; identify the Seq Scan. */
/* Q30. EXPLAIN ANALYZE a 3-table join; find the dominant node. */
/* Q31. EXPLAIN ANALYZE a GROUP BY with HAVING; HashAggregate or GroupAggregate? */
/* Q32. EXPLAIN ANALYZE an ORDER BY on a non-indexed column; did Sort spill? */
/* Q33. EXPLAIN ANALYZE a correlated subquery over orders; note loop count. */
/* Q34. EXPLAIN ANALYZE the equivalent JOIN; compare to Q33. */
/* Q35. EXPLAIN ANALYZE a query with a big estimate/actual mismatch; quantify it. */
/* Q36. EXPLAIN (ANALYZE,BUFFERS) a page_views scan; reads vs hits. */
/* Q37. EXPLAIN ANALYZE a DISTINCT over a fan-out join; spot the inflation. */
/* Q38. EXPLAIN ANALYZE a date-range filter; Index/Bitmap/Seq? */
/* Q39. EXPLAIN ANALYZE a NOT IN with a nullable subquery; behavior. */
/* Q40. EXPLAIN ANALYZE a self-join-free vs correlated "above-avg" query. */
/* Q41. EXPLAIN ANALYZE a query joining reviews->products->brand; bottleneck. */
/* Q42. EXPLAIN ANALYZE a wide SELECT * on orders vs trimmed columns. */
/* Q43. EXPLAIN ANALYZE an OR-across-columns filter; note the scan. */
/* Q44. EXPLAIN ANALYZE the UNION ALL rewrite of Q43; compare. */
/* Q45. EXPLAIN ANALYZE a HAVING-without-WHERE that should pre-filter. */
/* Q46. EXPLAIN ANALYZE a GROUP BY high-cardinality column; memory use. */
/* Q47. EXPLAIN ANALYZE a join missing a condition (accidental cross join). */
/* Q48. EXPLAIN ANALYZE a query with function-on-column in WHERE. */
/* Q49. EXPLAIN ANALYZE the sargable rewrite of Q48; compare. */
/* Q50. EXPLAIN ANALYZE a paginated OFFSET 100000 LIMIT 50; cost of deep offset. */

/* ============================================================
   SECTION C: REWRITE FOR SARGABILITY (25)
   ------------------------------------------------------------ */
/* Q51. Rewrite WHERE UPPER(email)=... to a sargable predicate. */
/* Q52. Rewrite WHERE EXTRACT(YEAR FROM order_date)=2025 to a half-open range. */
/* Q53. Rewrite WHERE date_trunc('month',order_date)=DATE '2025-03-01' to a range. */
/* Q54. Rewrite WHERE order_date::text LIKE '2025-03%' to a range. */
/* Q55. Rewrite WHERE cast(cust_id AS text)='123' to integer equality. */
/* Q56. Rewrite WHERE price*1.0 > 5000 to drop the no-op cast. */
/* Q57. Rewrite WHERE substring(email FROM 1 FOR 1)='a' to LIKE 'a%'. */
/* Q58. Rewrite WHERE COALESCE(net_total,0) > 0 to a sargable form. */
/* Q59. Rewrite OR (status='A' OR status='B') to IN and compare plans. */
/* Q60. Rewrite OR across two different columns as UNION ALL. */
/* Q61. Rewrite NOT IN (nullable subquery) to NOT EXISTS. */
/* Q62. Rewrite a correlated "above brand average" subquery as a JOIN to a grouped CTE. */
/* Q63. Rewrite SELECT * + LIMIT to a trimmed column list. */
/* Q64. Rewrite a leading-wildcard contains-search to a prefix search. */
/* Q65. Rewrite WHERE age(now(),registration_date) > INTERVAL '1 year' to a date compare. */
/* Q66. Rewrite WHERE lower(city)='mumbai' to compare with the literal lowered. */
/* Q67. Rewrite IN (huge literal list) as a JOIN to a VALUES table. */
/* Q68. Rewrite a self-join "previous order" into LAG (Day 18) and compare plans. */
/* Q69. Rewrite WHERE net_total/quantity > 100 to avoid per-row division where possible. */
/* Q70. Rewrite a HAVING filter that belongs in WHERE (pre-aggregation). */
/* Q71. Rewrite DISTINCT-to-dedup-join using EXISTS instead. */
/* Q72. Rewrite WHERE order_date BETWEEN x AND y (inclusive) to half-open. */
/* Q73. Rewrite an ORDER BY random() sample to TABLESAMPLE. */
/* Q74. Rewrite a deep OFFSET pagination to keyset (Day 5). */
/* Q75. Rewrite WHERE concat(first_name,last_name) ILIKE '%x%' to per-column predicates. */

/* ============================================================
   SECTION D: JOIN & SORT TUNING (read/rewrite only) (25)
   ------------------------------------------------------------ */
/* Q76. Compare plans of correlated-subquery vs JOIN for "customers above avg spend". */
/* Q77. Identify which table drives a Nested Loop and whether that's sensible. */
/* Q78. Pre-aggregate one side of a join in a CTE to cut fan-out; compare plans. */
/* Q79. Show how filtering before joining changes the plan (push WHERE down). */
/* Q80. Compare INNER JOIN vs EXISTS for "orders that have items". */
/* Q81. Compare LEFT JOIN ... IS NULL vs NOT EXISTS for anti-join. */
/* Q82. Identify a Sort that exists only to satisfy DISTINCT; rethink. */
/* Q83. Compare GROUP BY then JOIN vs JOIN then GROUP BY for an aggregate report. */
/* Q84. Show a Hash Join spilling (Batches>1) on a big aggregate; note it. */
/* Q85. Compare a 3-table join in two join orders (rewrite FROM order). */
/* Q86. Identify Materialize on the inner side and explain its role. */
/* Q87. Replace a redundant ORDER BY inside a subquery; show plan change. */
/* Q88. Compare DISTINCT vs GROUP BY for deduplication plans. */
/* Q89. Show how adding LIMIT lets a Nested Loop short-circuit. */
/* Q90. Compare UNION vs UNION ALL plans (dedupe cost). */
/* Q91. Identify an accidental cross join and add the join key. */
/* Q92. Compare IN (subquery) vs JOIN for "orders by top customers". */
/* Q93. Show the plan effect of selecting fewer columns (Index Only Scan eligibility). */
/* Q94. Compare correlated EXISTS vs semi-join rewrite plans. */
/* Q95. Identify a GroupAggregate forced by ORDER BY; could HashAggregate work? */
/* Q96. Compare a window-function top-N (Day 16) vs correlated top-N plans. */
/* Q97. Show how a CTE materialization barrier changes a plan (MATERIALIZED hint). */
/* Q98. Compare aggregating in SQL vs returning rows for the BI tool (row counts). */
/* Q99. Identify the single most expensive node across a 4-table report and propose a rewrite. */
/* Q100. Given a slow 4-table analyst report, produce a prioritized rewrite plan (no indexes). */

/* ============================================================
   END OF Reading Query Plans - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
