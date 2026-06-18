/* ============================================================
   SQL PRACTICE SET - Reading Query Plans (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Production plan forensics, BUFFERS, plan comparison, rewrites
   Database:     RetailMart V3   (EXPLAIN is read-only - safe to run)

   Scope (HARD = diagnose real plans + interview-grade rewrites):
     - BUFFERS, spills, estimate errors, join blowups
     - Methodical bottleneck isolation; "would an index help?" diagnosis
   (Creating the index is Day 20; here, diagnose + rewrite only.)

   Structure: 25 Conceptual + 25 Forensics + 25 Rewrites + 25 "Would an index help?"
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Walk a methodical process for diagnosing a slow query from EXPLAIN ANALYZE. */
/* Q2.  How do estimate errors propagate and cause Nested Loop blowups? */
/* Q3.  BUFFERS: shared hit/read/dirtied - what each implies for I/O. */
/* Q4.  When is a Seq Scan actually optimal (full aggregate, low selectivity)? */
/* Q5.  How do you tell a Sort or Hash spilled to disk, and the work_mem link? */
/* Q6.  Why is "actual rows x loops" the true work of an inner node? */
/* Q7.  How does a missing/stale ANALYZE produce a bad plan? */
/* Q8.  Identify a query where parallelism helps vs where it doesn't. */
/* Q9.  Why can adding LIMIT dramatically change the chosen plan? */
/* Q10. How to compare two plans fairly (cache warmth, ANALYZE, repetition). */
/* Q11. What plan signs suggest "an index would help here"? */
/* Q12. What plan signs suggest indexing will NOT help? */
/* Q13. How does selectivity decide Index vs Bitmap vs Seq? */
/* Q14. Why does SELECT * block Index Only Scans? */
/* Q15. How does join order interact with the planner's reordering limit? */
/* Q16. What is a "row estimate of 1" trap that triggers Nested Loops? */
/* Q17. Why might a CTE act as an optimization fence (and PG12+ inlining)? */
/* Q18. How do you read NestedLoop + Materialize together? */
/* Q19. Why are leading-wildcard and function-on-column the top analyst smells? */
/* Q20. When is HashAggregate forced to spill, and the symptom in the plan? */
/* Q21. How to spot an accidental cross join from cost/row explosion. */
/* Q22. Why prefer rewriting before indexing for analyst ad-hoc queries? */
/* Q23. How does EXPLAIN (ANALYZE, BUFFERS, VERBOSE, FORMAT JSON) aid tooling? */
/* Q24. What is plan regression and how do you catch it? */
/* Q25. Build a one-paragraph "tuning checklist" for analysts. */

/* ============================================================
   SECTION B: PLAN FORENSICS (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: A customer-360 report is slow - EXPLAIN ANALYZE it and name the top-3 costly nodes. */
/* Q27. Find the node with the worst estimate/actual ratio in a 4-table report. */
/* Q28. From BUFFERS, decide if a query is I/O-bound or CPU-bound. */
/* Q29. Detect a Sort spilling to disk on a big ORDER BY; quantify. */
/* Q30. Detect a Hash Join with Batches>1; what would reduce it (no index)? */
/* Q31. Identify a Nested Loop with loops in the millions and explain the cause. */
/* Q32. Quantify "Rows Removed by Filter" and compute filter selectivity. */
/* Q33. Identify whether ORDER BY used an index or a Sort node. */
/* Q34. Find the planning-time vs execution-time split for a trivial query run often. */
/* Q35. Detect a Bitmap Heap Scan with high "exact heap blocks" vs "lossy". */
/* Q36. Identify a parallel plan and whether workers were actually launched. */
/* Q37. Detect a Materialize node and decide if it helped. */
/* Q38. From a JSON plan, extract the most expensive subtree programmatically (describe). */
/* Q39. Identify a SubPlan re-executed per row (correlated) and its cost. */
/* Q40. Detect a GroupAggregate forced by an upstream Sort. */
/* Q41. Identify a deep OFFSET causing a full scan+sort. */
/* Q42. Find a wide SELECT * preventing Index Only Scan; show row width impact. */
/* Q43. Detect a cartesian product from cost explosion in a multi-join. */
/* Q44. Compare warm vs cold cache runs (BUFFERS reads -> hits). */
/* Q45. Identify the join whose reorder would most help (largest intermediate). */
/* Q46. Detect an aggregate spilling (HashAggregate Disk Usage). */
/* Q47. From the plan, estimate the intermediate result size before the final aggregate. */
/* Q48. Identify whether a LIMIT short-circuited a Nested Loop early. */
/* Q49. Spot a redundant Sort that a prior operator already satisfied. */
/* Q50. Produce a ranked list of bottleneck nodes for a slow 5-table query. */

/* ============================================================
   SECTION C: REWRITES THAT CHANGE THE PLAN (25)
   ------------------------------------------------------------ */
/* Q51. Rewrite a correlated "above-average" query as a grouped JOIN; show plan win. */
/* Q52. Rewrite OR-across-columns as UNION ALL; quantify the improvement. */
/* Q53. Rewrite EXTRACT(YEAR ...) filter to a range; show Index/Bitmap appears. */
/* Q54. Rewrite NOT IN (nullable) to NOT EXISTS; correctness + plan. */
/* Q55. Rewrite SELECT * to needed columns to enable an Index Only Scan path. */
/* Q56. Rewrite deep OFFSET to keyset; show constant-time plan. */
/* Q57. Rewrite a fan-out DISTINCT into EXISTS; show row reduction. */
/* Q58. Pre-aggregate one side in a CTE to cut a Nested Loop blowup. */
/* Q59. Push a WHERE below a join (rewrite) to shrink intermediates. */
/* Q60. Replace ORDER BY random() LIMIT with TABLESAMPLE; plan diff. */
/* Q61. Rewrite IN (huge list) as a VALUES join; plan diff. */
/* Q62. Rewrite a self-join "previous value" into LAG; plan diff. */
/* Q63. Rewrite leading-wildcard search to prefix (where business allows). */
/* Q64. Rewrite a HAVING-only filter into WHERE; show pre-aggregation savings. */
/* Q65. Split an OR into two indexed-friendly branches via UNION ALL. */
/* Q66. Rewrite a date::text LIKE filter to a range; plan diff. */
/* Q67. Replace a multi-column concat ILIKE with per-column predicates. */
/* Q68. Rewrite correlated EXISTS to a semi-join; compare. */
/* Q69. Rewrite an aggregate over a join to aggregate-then-join; compare. */
/* Q70. Materialize a reused subquery via a CTE; measure. */
/* Q71. Convert a scalar correlated subquery in SELECT to a LEFT JOIN aggregate. */
/* Q72. Rewrite COUNT(DISTINCT x) heavy query into a two-step group; compare. */
/* Q73. Rewrite a window top-N vs correlated top-N and pick the better plan. */
/* Q74. Trim projected columns flowing into a sort to shrink memory. */
/* Q75. Produce before/after EXPLAIN ANALYZE for the biggest available win. */

/* ============================================================
   SECTION D: "WOULD AN INDEX HELP?" (diagnosis only - fix is Day 20) (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: A point-lookup by email is slow - diagnose whether an index would help (don't create it). */
/* Q77. Decide if a date-range orders query would benefit from an index. */
/* Q78. Decide if a full-table SUM(net_total) would benefit from an index (it won't - why). */
/* Q79. Identify the best candidate column(s) for a composite index from a 2-predicate query. */
/* Q80. Decide if a partial index (WHERE status='Cancelled') is justified by selectivity. */
/* Q81. Decide whether ORDER BY net_total DESC LIMIT 10 would benefit from an index. */
/* Q82. Decide if a leading-wildcard search needs a trigram index (Day 20/extension). */
/* Q83. Decide if an expression index on lower(email) is warranted. */
/* Q84. Identify a redundant-index situation (describe; don't change). */
/* Q85. Decide if a join key lacks an index causing a Hash/Seq pattern. */
/* Q86. Decide if a low-selectivity predicate makes indexing pointless. */
/* Q87. Estimate the rows an index would have to return to be worthwhile. */
/* Q88. Decide if covering columns (INCLUDE) would enable Index Only Scan. */
/* Q89. Decide between single-column vs composite for a (cust_id, order_date) filter. */
/* Q90. Decide if a BRIN index suits the append-only page_views timestamp (concept). */
/* Q91. Decide if indexing helps a GROUP BY high-cardinality key (usually not). */
/* Q92. Decide if a foreign-key column needs an index for join performance. */
/* Q93. Identify which of 3 slow queries is the best indexing candidate. */
/* Q94. Decide if statistics (ANALYZE / extended stats) fix the plan instead of an index. */
/* Q95. Decide if the query should be rewritten before considering any index. */
/* Q96. Estimate index size/write-cost tradeoff for a hot write table (concept). */
/* Q97. Decide if a partial+covering index is the right tool for an "active rows" query. */
/* Q98. Rank 5 queries by expected index ROI (diagnosis). */
/* Q99. Write the Day-20 "to-do" index recommendation for a slow report (don't run it). */
/* Q100. Produce a full tuning report: bottleneck, rewrites tried, and index recommendations for Day 20. */

/* ============================================================
   END OF Reading Query Plans - HARD LEVEL (100 QUESTIONS)
============================================================ */
