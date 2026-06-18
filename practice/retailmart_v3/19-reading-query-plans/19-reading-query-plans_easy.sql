/* ============================================================
   SQL PRACTICE SET - Reading Query Plans (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        EXPLAIN, EXPLAIN ANALYZE, reading a plan, scan types
   Database:     RetailMart V3   (EXPLAIN is read-only - safe to run)

   Scope (EASY = one concept per question):
     - What EXPLAIN / EXPLAIN ANALYZE show
     - Seq Scan vs Index Scan vs Bitmap; cost vs actual time; est vs actual rows
     - Spotting obvious slow patterns (SELECT *, leading-wildcard LIKE, missing LIMIT)
   (Fixing via CREATE INDEX is Day 20 - here we only READ and REWRITE.)

   Structure: 25 Conceptual + 25 Run-EXPLAIN + 25 Read-the-plan + 25 Spot-the-smell
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does EXPLAIN show vs EXPLAIN ANALYZE? */
/* Q2.  Does EXPLAIN (without ANALYZE) run the query? */
/* Q3.  Does EXPLAIN ANALYZE actually execute the query? Caution for writes? */
/* Q4.  What is a Seq Scan and when is it chosen? */
/* Q5.  What is an Index Scan and when is it chosen? */
/* Q6.  What is a Bitmap Index Scan / Bitmap Heap Scan (rough idea)? */
/* Q7.  In "cost=0.00..431.00", what do the two numbers mean? */
/* Q8.  What's the difference between estimated rows and actual rows? */
/* Q9.  Why is a big gap between estimated and actual rows a warning sign? */
/* Q10. What does "rows" vs "loops" mean in EXPLAIN ANALYZE? */
/* Q11. What is a Nested Loop join (intuition)? */
/* Q12. What is a Hash Join (intuition)? */
/* Q13. What is a Merge Join (intuition)? */
/* Q14. Why is "SELECT * on a wide table" often wasteful? */
/* Q15. Why does LIKE '%abc' (leading wildcard) defeat a B-tree index? */
/* Q16. Why does WHERE UPPER(email) = '...' prevent index use? */
/* Q17. Why add LIMIT to exploratory queries? */
/* Q18. What does "actual time=...rows=..." tell you about a node? */
/* Q19. What does ANALYZE (the maintenance command) do, vs EXPLAIN ANALYZE? */
/* Q20. What does EXPLAIN (BUFFERS) add? */
/* Q21. What does EXPLAIN (FORMAT JSON) give you? */
/* Q22. Why read a plan bottom-up (leaves first)? */
/* Q23. What is the "actual rows" you multiply by loops to get total work? */
/* Q24. Why might the planner pick a Seq Scan even when an index exists? */
/* Q25. Name two analyst query smells you can spot from a plan alone. */

/* ============================================================
   SECTION B: RUN EXPLAIN (25)
   ------------------------------------------------------------ */
/* Q26. EXPLAIN a SELECT of all orders for one cust_id. */
/* Q27. EXPLAIN a SELECT of orders in a date range. */
/* Q28. EXPLAIN a COUNT(*) of sales.orders. */
/* Q29. EXPLAIN a join of orders to customers on cust_id. */
/* Q30. EXPLAIN ANALYZE the same join; note actual time. */
/* Q31. EXPLAIN a query filtering products by price > 5000. */
/* Q32. EXPLAIN a query with ORDER BY net_total DESC LIMIT 10. */
/* Q33. EXPLAIN a GROUP BY cust_id SUM(net_total). */
/* Q34. EXPLAIN ANALYZE a WHERE email LIKE 'a%' on customers. */
/* Q35. EXPLAIN ANALYZE a WHERE email LIKE '%gmail.com' (leading wildcard). */
/* Q36. EXPLAIN a WHERE UPPER(email) = 'X@Y.COM'. */
/* Q37. EXPLAIN a 3-table join (orders->order_items->products). */
/* Q38. EXPLAIN (ANALYZE, BUFFERS) a customer aggregate. */
/* Q39. EXPLAIN a SELECT * FROM web_events.page_views LIMIT 100. */
/* Q40. EXPLAIN ANALYZE a query with no LIMIT on page_views (then add LIMIT). */
/* Q41. EXPLAIN a query with an OR across two columns. */
/* Q42. EXPLAIN a query with IN (subquery). */
/* Q43. EXPLAIN a query with EXISTS (subquery). */
/* Q44. EXPLAIN a DISTINCT on order_status. */
/* Q45. EXPLAIN ANALYZE a HAVING COUNT(*) > 5 grouping. */
/* Q46. EXPLAIN a self-join-free aggregate vs a correlated subquery version. */
/* Q47. EXPLAIN a LEFT JOIN anti-join (IS NULL). */
/* Q48. EXPLAIN (FORMAT JSON) a simple filter query. */
/* Q49. EXPLAIN a query ordering by a non-indexed expression. */
/* Q50. EXPLAIN ANALYZE a query and read off estimated vs actual rows. */

/* ============================================================
   SECTION C: READ THE PLAN (25)
   ------------------------------------------------------------ */
/* Q51. From a plan, state whether a Seq Scan or Index Scan was used and why. */
/* Q52. Identify the join algorithm in a 2-table join plan. */
/* Q53. Find the most expensive node (highest cost) in a plan. */
/* Q54. Find the node with the largest actual-time in EXPLAIN ANALYZE. */
/* Q55. Identify a large estimate-vs-actual row mismatch in a plan. */
/* Q56. Read off total estimated cost of a query. */
/* Q57. Identify whether a Sort spilled to disk (external merge) from the plan. */
/* Q58. Find "Rows Removed by Filter" and explain what it means. */
/* Q59. Identify a Nested Loop with a high loop count. */
/* Q60. Read "Heap Fetches" in an Index Only Scan. */
/* Q61. Determine if the query used the LIMIT to stop early (plan shows it). */
/* Q62. Identify a Bitmap Heap Scan + Bitmap Index Scan pair. */
/* Q63. From BUFFERS, tell cache hits from disk reads. */
/* Q64. Identify a Gather/parallel node in a plan. */
/* Q65. Explain what "loops=N" multiplies in a Nested Loop inner side. */
/* Q66. Identify the driving (outer) vs inner table in a Nested Loop. */
/* Q67. Read off the hash table memory usage in a Hash node. */
/* Q68. Spot a Materialize node and explain why it appeared. */
/* Q69. Tell whether ORDER BY was satisfied by an index or a Sort node. */
/* Q70. Identify aggregate node type (HashAggregate vs GroupAggregate). */
/* Q71. Determine if a subplan/SubPlan appears and what it represents. */
/* Q72. Read planning time vs execution time in EXPLAIN ANALYZE. */
/* Q73. Spot a Seq Scan on a big table that should have been filtered earlier. */
/* Q74. Compare two plans and say which is cheaper and why. */
/* Q75. Summarize a plan in one sentence ("scan -> filter -> sort -> limit"). */

/* ============================================================
   SECTION D: SPOT THE SMELL (no index changes) (25)
   ------------------------------------------------------------ */
/* Q76. Rewrite WHERE UPPER(email) = 'A@B.COM' to a sargable form (lower on literal side or LIKE). */
/* Q77. Rewrite WHERE email LIKE '%@gmail.com' - why it can't use a plain B-tree; alternative. */
/* Q78. Replace SELECT * with only the needed columns in a wide-table query. */
/* Q79. Add a missing LIMIT to an exploration query on page_views. */
/* Q80. Rewrite WHERE EXTRACT(YEAR FROM order_date)=2025 to a sargable range. */
/* Q81. Rewrite OR across two columns as UNION ALL (and EXPLAIN both). */
/* Q82. Rewrite WHERE order_date::text LIKE '2025%' to a proper date range. */
/* Q83. Replace a correlated subquery with a JOIN and compare plans. */
/* Q84. Rewrite NOT IN (subquery with NULLs) as NOT EXISTS and compare. */
/* Q85. Rewrite WHERE price + 0 > 5000 to WHERE price > 5000 (drop the no-op math). */
/* Q86. Rewrite WHERE COALESCE(phone,'') = '' to an IS NULL/empty form. */
/* Q87. Show why SELECT DISTINCT to dedupe a join is a smell; suggest the fix. */
/* Q88. Rewrite a function-on-column ORDER BY into a plain-column ORDER BY where possible. */
/* Q89. Spot a cartesian product (missing join condition) in a plan. */
/* Q90. Rewrite WHERE substring(email,1,1)='a' to LIKE 'a%'. */
/* Q91. Identify SELECT * feeding a small LIMIT and trim the columns. */
/* Q92. Rewrite a leading-wildcard search to a prefix search where business allows. */
/* Q93. Spot an unfiltered join on a huge table and add the missing WHERE. */
/* Q94. Rewrite WHERE date_trunc('day',order_date)=DATE '2025-03-01' to a range. */
/* Q95. Replace an IN (long literal list) with a VALUES join and compare. */
/* Q96. Identify a missing LIMIT causing a full sort; add it. */
/* Q97. Rewrite WHERE cast(cust_id AS text)='123' to WHERE cust_id=123. */
/* Q98. Spot redundant ORDER BY in a subquery and remove it. */
/* Q99. Rewrite an aggregate-then-filter that should be a WHERE-then-aggregate. */
/* Q100. Given a slow plan, list 3 analyst-level rewrites (no index changes) to try first. */

/* ============================================================
   END OF Reading Query Plans - EASY LEVEL (100 QUESTIONS)
============================================================ */
