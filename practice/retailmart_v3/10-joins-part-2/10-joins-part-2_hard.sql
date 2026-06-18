/* ============================================================
   SQL PRACTICE SET - JOINs Part 2 (Advanced) (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JOINs Part 2 - advanced (SELF/FULL/CROSS/Set ops/LATERAL)
   Database:     RetailMart V3

   Scope (HARD):
     - LATERAL: deep patterns (top-N per group, exploding, JOIN-LATERAL chains)
     - Self-join "previous/next" before window functions
     - Recursive thinking (preview of WITH RECURSIVE)
     - FULL OUTER reconciliation at scale
     - CROSS JOIN + generate_series for grids
     - UNION ALL "stack" patterns for cross-source dashboards
     - Set ops + correlated logic

   Structure: 25 Conceptual + 25 LATERAL deep + 25 SELF-JOIN advanced + 25 Set ops + RECURSIVE preview
   ============================================================ */

/* ============================================================
   SECTION A: ADVANCED JOIN PART 2 - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Walk through how LATERAL is planned: re-evaluated per outer row. */
/* Q2.  Compare LATERAL LIMIT 1 vs DISTINCT ON for "latest per group". */
/* Q3.  When is FULL OUTER JOIN's COALESCE(left.k, right.k) required vs optional? */
/* Q4.  How does CROSS JOIN LATERAL generate_series produce "N rows per outer row" - explosion pattern. */
/* Q5.  Compare self-join with window function performance (preview Day 16). */
/* Q6.  Explain how UNION ALL is a "stack vertically" while JOIN is "merge horizontally". */
/* Q7.  When does INTERSECT use a Hash Aggregate vs Sort + Merge? */
/* Q8.  Why is EXCEPT sometimes a better choice than NOT EXISTS for whole-row diffs? */
/* Q9.  Explain "relational division" - every X who has ALL Ys - give a SQL recipe. */
/* Q10. What is WITH RECURSIVE - and why do hierarchies need it? */
/* Q11. Walk through a RECURSIVE CTE: anchor + recursive part + termination. */
/* Q12. Why is CYCLE detection needed in RECURSIVE - and how to add it. */
/* Q13. Compare RECURSIVE CTE vs application-side recursion. */
/* Q14. What is "graph traversal" in SQL - BFS vs DFS in RECURSIVE. */
/* Q15. Why do CROSS JOIN reports use ARRAY_AGG to build grids? */
/* Q16. Compare CROSS JOIN small x small x small vs CROSS JOIN huge x huge - performance cliff. */
/* Q17. Walk through "dense reporting" pattern: CROSS JOIN time x dim LEFT JOIN facts COALESCE 0. */
/* Q18. Why is LATERAL essential for "for each parent, get a subset of children with ORDER BY/LIMIT"? */
/* Q19. When does a SELF JOIN with composite key match patterns (a.x=b.x AND a.y<b.y)? */
/* Q20. Why does UNION drop information vs UNION ALL - and when is that desirable? */
/* Q21. Explain how INTERSECT can replace INNER JOIN + DISTINCT on all columns. */
/* Q22. Compare CROSS JOIN unnest(array) vs unnest in SELECT. */
/* Q23. What is "PIVOT" - how do you simulate it with FILTER + GROUP BY? */
/* Q24. What is "UNPIVOT" - how do you simulate it with UNION ALL or jsonb_each? */
/* Q25. Walk through a "session attribution" query that requires LATERAL + set ops. */

/* ============================================================
   SECTION B: LATERAL DEEP (25)
   ------------------------------------------------------------ */
/* Q26. LATERAL: per customer, latest 5 orders. */
/* Q27. LATERAL: per product, latest 3 reviews (with rating). */
/* Q28. LATERAL: per region, top 5 stores by revenue. */
/* Q29. LATERAL: per category, top 3 products by units sold. */
/* Q30. LATERAL: per agent, latest 5 tickets resolved. */
/* Q31. LATERAL: per platform, top 3 campaigns by spend. */
/* Q32. LATERAL: per warehouse, oldest snapshot. */
/* Q33. LATERAL: per supplier, 3 most-recent shipments. */
/* Q34. LATERAL: per call_reason, longest call. */
/* Q35. LATERAL: per dept, highest-paid employee. */
/* Q36. LATERAL: explode order into installments (generate_series 1..3). */
/* Q37. LATERAL: explode shipment into "shipped -> in-transit -> delivered" steps. */
/* Q38. LATERAL: per customer, derive 12 monthly buckets (generate_series + LATERAL). */
/* Q39. LATERAL: per product, count of distinct buyers. */
/* Q40. LATERAL: per ticket, list all comments (joined). */
/* Q41. LATERAL + aggregation: per customer, JSON of all orders. */
/* Q42. LATERAL: per session, the URL clicked just before checkout. */
/* Q43. LATERAL chain: per customer, last order -> that order's first item -> that item's product. */
/* Q44. LATERAL with WHERE that references outer row. */
/* Q45. LEFT JOIN LATERAL - keep outer row when subquery is empty. */
/* Q46. LATERAL + LIMIT 0 (no rows) - INNER excludes; LEFT keeps with NULLs. */
/* Q47. LATERAL with EXISTS - short-circuit detect. */
/* Q48. LATERAL with generate_series + interval - date-bucket per parent. */
/* Q49. LATERAL on view - pattern with materialized view. */
/* Q50. LATERAL with json_array_elements - explode JSON arrays. */

/* ============================================================
   SECTION C: SELF-JOIN ADVANCED + RECURSIVE PREVIEW (25)
   ------------------------------------------------------------ */
/* Q51. Self-join: prev/next order per customer (and gap days). */
/* Q52. Self-join: detect chains of 3+ same-day orders (multi-step). */
/* Q53. Self-join: find "repeat-buyer pattern" - same product, same customer, > 30 days apart. */
/* Q54. Self-join: detect ticket re-opens (status='Open' after status='Closed'). */
/* Q55. Self-join: find inventory "shortage events" - qty < threshold within 7 days of another shortage. */
/* Q56. Self-join: customer signup -> first purchase delay (anchor + first event). */
/* Q57. Self-join: detect pricing changes (price_history same product, prev != current). */
/* Q58. Self-join: campaign overlap - two campaigns running same dates. */
/* Q59. Self-join: returns following purchases within 7 days. */
/* Q60. Self-join: detect "churn risk pairs" - customers with 2 unresolved tickets back-to-back. */
/* Q61. RECURSIVE: employee->manager hierarchy (level depth). */
/* Q62. RECURSIVE: product category tree traversal. */
/* Q63. RECURSIVE: dependency graph for "products requiring X". */
/* Q64. RECURSIVE: chain of refunds (refund -> original order -> previous refund). */
/* Q65. RECURSIVE: month-by-month customer growth path. */
/* Q66. RECURSIVE: web_event session reconstruction (page_view -> next page_view). */
/* Q67. RECURSIVE: shipping route trace (warehouse -> courier -> city -> customer). */
/* Q68. RECURSIVE: detect cycle in supplier-supplier relationships. */
/* Q69. RECURSIVE: organizational reporting tree (CEO -> direct reports -> indirect). */
/* Q70. RECURSIVE: friend-of-friend network (preview). */
/* Q71. Use SELF JOIN to compute "rank" before LAG/window. */
/* Q72. Use SELF JOIN to detect duplicate emails. */
/* Q73. Use SELF JOIN to detect ticket subject duplicates. */
/* Q74. Use SELF JOIN to detect inventory mismatches across warehouses. */
/* Q75. Use SELF JOIN to find "twin orders" - same cust, same amount, same day. */

/* ============================================================
   SECTION D: SET OPS + RECONCILIATION (25)
   ------------------------------------------------------------ */
/* Q76. FULL OUTER reconciliation: orders.cust_id vs customers.customer_id. */
/* Q77. FULL OUTER: production data vs archive - find drift. */
/* Q78. UNION ALL stacked: events from orders + tickets + reviews + calls. */
/* Q79. INTERSECT: customers in BOTH high-spend + active-reviewer cohorts. */
/* Q80. EXCEPT: customers in shadow_index but not in primary_index. */
/* Q81. UNION ALL: "customer churn analysis" - combine multiple definitions of churn. */
/* Q82. UNION ALL + ROLLUP-like grand total. */
/* Q83. INTERSECT ALL: detect rows that match across two snapshots with count. */
/* Q84. EXCEPT ALL: rows in old but not new (with multiplicity). */
/* Q85. Set-op + CTE: differences between two computed reports. */
/* Q86. Full reconciliation report: 4-bucket layout (both / only-A / only-B / neither). */
/* Q87. Multi-source dashboard: revenue + cost + profit + churn - all in one UNION ALL output. */
/* Q88. UNION ALL + DENSE_RANK (preview Day 16). */
/* Q89. Detect Eve drift across nightly ETL: EXCEPT both ways. */
/* Q90. Compare two materialized views with INTERSECT to verify match. */
/* Q91. Catch unmatched rows in left-only via EXCEPT - output stable diff list. */
/* Q92. PIVOT customers by tier using FILTER. */
/* Q93. UNPIVOT order item columns into rows. */
/* Q94. INTERSECT customers in 2 campaigns. */
/* Q95. INTERSECT three lifecycle stages. */
/* Q96. EXCEPT to find new-only campaigns vs last month. */
/* Q97. Build a "delta report" between two snapshots. */
/* Q98. Build a "diff" between primary and replica (proxy: two CTEs). */
/* Q99. Combine LATERAL + UNION ALL: per customer, top 1 from each of 4 sources. */
/* Q100. Customer 360deg "all interactions" feed: UNION ALL across 6 schemas, ordered by timestamp. */

/* ============================================================
   END OF JOINs Part 2 (Advanced) - HARD LEVEL (100 QUESTIONS)
============================================================ */
