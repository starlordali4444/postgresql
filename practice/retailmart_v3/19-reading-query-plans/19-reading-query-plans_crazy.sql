/* ============================================================
   SQL PRACTICE SET - Reading Query Plans (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Staff-level plan forensics, multi-join tuning, regression hunting
   Database:     RetailMart V3   (EXPLAIN is read-only - safe to run)

   Scope (CRAZY = staff-engineer diagnosis + rewrite; index creation = Day 20):
     - Estimate-error chains, join-order, spills, parallelism, plan stability
     - End-to-end tuning methodology for big analyst reports
   (We diagnose & rewrite here; CREATE INDEX lives in Day 20.)

   Structure: 25 Conceptual + 25 Multi-join forensics + 25 Stability/regression + 25 End-to-end tuning
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Explain the full lifecycle: parse -> plan (cost model) -> execute, and where EXPLAIN sits. */
/* Q2.  How do the cost constants (seq_page_cost, random_page_cost, cpu_*) shape plan choice? */
/* Q3.  effective_cache_size and its effect on index-vs-seq decisions. */
/* Q4.  How estimate errors compound across a 5-table join. */
/* Q5.  join_collapse_limit / from_collapse_limit and large-join planning. */
/* Q6.  When does the planner stop reordering joins, and how to influence it. */
/* Q7.  work_mem per-node semantics; total memory = nodes x work_mem x parallelism. */
/* Q8.  Hash spill (batches) vs Sort spill (external merge) - diagnosis and levers. */
/* Q9.  Parallel query: when Gather/Gather Merge helps; parallel-unsafe blockers. */
/* Q10. Genetic Query Optimizer (GEQO) for very large joins - implications. */
/* Q11. Extended statistics (CREATE STATISTICS) for correlated columns - when needed. */
/* Q12. Why row-estimate skew on a FK join causes nested-loop catastrophes. */
/* Q13. Plan stability: why the "same" query can flip plans over time. */
/* Q14. CTE materialization fence vs inlining (PG12+) and forcing each. */
/* Q15. Index Only Scan requirements (covering + visibility map). */
/* Q16. Bitmap AND/OR combining multiple indexes - when the planner does it. */
/* Q17. LATERAL for top-N-per-group vs window - plan tradeoffs. */
/* Q18. Partition pruning in plans (if partitioned) - what to look for. */
/* Q19. Why a tiny LIMIT can pick a wildly different (sometimes worse) plan. */
/* Q20. Auto-explain / pg_stat_statements for catching slow queries (concept; not installed here). */
/* Q21. Reading parallel-aware vs parallel-restricted nodes. */
/* Q22. Cost vs actual divergence: planner model limits to be aware of. */
/* Q23. When to push work to a materialized view (Day 25) vs tune the query. */
/* Q24. Designing a repeatable benchmark for plan comparison. */
/* Q25. A staff-level mental model: read a plan in 60 seconds - the algorithm. */

/* ============================================================
   SECTION B: MULTI-JOIN FORENSICS (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: A 6-table BI dashboard query times out - isolate the single worst node. */
/* Q27. Find the join whose intermediate result explodes and why (estimate error). */
/* Q28. Diagnose a Nested Loop chosen on a bad rows=1 estimate. */
/* Q29. Diagnose a Hash Join spilling across many batches on a big aggregate. */
/* Q30. Find where a Sort dominates and whether an upstream order could remove it. */
/* Q31. Identify a correlated SubPlan executed millions of times. */
/* Q32. Detect a cartesian product hidden in a 5-table FROM list. */
/* Q33. Quantify estimate/actual skew at each join level. */
/* Q34. Find the projection (SELECT *) inflating row width through the whole plan. */
/* Q35. Identify the parallelism gain (or lack) on a large scan. */
/* Q36. Detect a Materialize that should be a hash, or vice versa. */
/* Q37. Trace BUFFERS through the plan to find the I/O hotspot. */
/* Q38. Identify which FK join lacks support causing repeated scans. */
/* Q39. Find a GroupAggregate forced by a Sort that an index could remove (diagnose). */
/* Q40. Detect a deep OFFSET in a paginated report killing performance. */
/* Q41. Identify a DISTINCT masking a join fan-out and the true cause. */
/* Q42. Find the most expensive subtree in a JSON plan and summarize it. */
/* Q43. Diagnose a window-function sort dominating a report. */
/* Q44. Identify a HAVING that should be a WHERE pre-aggregation. */
/* Q45. Detect repeated computation that a CTE would materialize once. */
/* Q46. Find the join order the planner chose and propose a better one (rewrite FROM). */
/* Q47. Detect an aggregate spilling and estimate the memory needed. */
/* Q48. Identify a parallel-restricted function blocking parallelism. */
/* Q49. Compare the plan with/without a LIMIT to expose plan flips. */
/* Q50. Produce a ranked bottleneck report for the 6-table dashboard. */

/* ============================================================
   SECTION C: PLAN STABILITY & REGRESSION (25)
   ------------------------------------------------------------ */
/* Q51. SCENARIO: A nightly report got 10x slower with no code change - hypothesize causes from the plan. */
/* Q52. Show how stale statistics flip an Index Scan to a Seq Scan. */
/* Q53. Demonstrate ANALYZE restoring a good plan (run ANALYZE, re-EXPLAIN). */
/* Q54. Show how data growth changes selectivity and the chosen join. */
/* Q55. Show how a parameter value (generic vs custom plan) changes the plan. */
/* Q56. Demonstrate LIMIT-induced plan instability. */
/* Q57. Show extended statistics fixing a correlated-column estimate (concept + diagnose). */
/* Q58. Compare warm vs cold cache to avoid false regressions (BUFFERS). */
/* Q59. Identify a plan that's fast on small partitions but bad overall. */
/* Q60. Show CTE inlining (PG12+) changing a plan vs MATERIALIZED. */
/* Q61. Demonstrate how ORDER BY + LIMIT picks a different index path. */
/* Q62. Show how join_collapse_limit affects a many-table plan. */
/* Q63. Identify a regression from a row-estimate cliff at a boundary value. */
/* Q64. Show how work_mem changes a Sort from in-memory to disk. */
/* Q65. Build a minimal repro to compare two plans deterministically. */
/* Q66. Detect parameter-sniffing-style instability (custom vs generic plan). */
/* Q67. Show a plan that regresses only at month-end data volumes. */
/* Q68. Identify a function-volatility change forcing re-evaluation. */
/* Q69. Demonstrate that adding columns to SELECT removed an Index Only Scan. */
/* Q70. Show how a new low-cardinality value skews MCV-based estimates. */
/* Q71. Compare plans across two date ranges with very different selectivity. */
/* Q72. Detect a plan relying on an assumption that breaks as data evolves. */
/* Q73. Establish a "good plan" baseline to detect future regressions. */
/* Q74. Show how disabling a plan node (enable_seqscan=off, session) reveals alternatives. */
/* Q75. Write a regression-watch note: query, baseline plan, triggers to watch. */

/* ============================================================
   SECTION D: END-TO-END TUNING METHODOLOGY (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: Own the company revenue dashboard - produce a full tuning report (diagnose->rewrite->index rec for Day 20). */
/* Q77. Step 1: capture EXPLAIN (ANALYZE,BUFFERS) and identify the top bottleneck. */
/* Q78. Step 2: apply the highest-ROI rewrite and re-measure. */
/* Q79. Step 3: refresh statistics and re-check the plan. */
/* Q80. Step 4: list index recommendations (for Day 20) with justification. */
/* Q81. Step 5: decide what belongs in a materialized view (Day 25). */
/* Q82. Tune the customer-360 query end-to-end (rewrites only). */
/* Q83. Tune a cohort-retention query's plan (rewrites only). */
/* Q84. Tune a "top products per category" report (window vs LATERAL choice). */
/* Q85. Tune a monthly P&L report (pre-aggregation + push-down). */
/* Q86. Tune a funnel query's plan (rewrites only). */
/* Q87. Tune an RFM scoring query's plan. */
/* Q88. Tune a slow search query (leading wildcard) - diagnose trigram need (Day 20). */
/* Q89. Tune a deep-pagination listing to keyset. */
/* Q90. Tune a COUNT(DISTINCT) heavy KPI query. */
/* Q91. Tune a self-join-based "previous order" to LAG. */
/* Q92. Tune an OR-heavy filter via UNION ALL. */
/* Q93. Tune an aggregate-over-join to aggregate-then-join. */
/* Q94. Decide MV vs query for an expensive nightly metric. */
/* Q95. Produce before/after metrics (time, BUFFERS) for one big win. */
/* Q96. Document the tuning so another analyst can reproduce it. */
/* Q97. Prioritize a backlog of 10 slow queries by expected ROI. */
/* Q98. Establish SLOs for dashboard query latency and how to monitor. */
/* Q99. Decide when to stop tuning (good enough) for an analyst workload. */
/* Q100. Deliver a one-page tuning playbook for the analytics team. */

/* ============================================================
   END OF Reading Query Plans - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
