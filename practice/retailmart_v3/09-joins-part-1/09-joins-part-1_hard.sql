/* ============================================================
   SQL PRACTICE SET - JOINs Part 1 (Foundations) (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JOINs Part 1 - advanced patterns
   Database:     RetailMart V3

   Scope (HARD):
     - JOIN planner choices (hash/merge/nested loop)
     - Non-equi JOINs (range, BETWEEN)
     - Multi-column JOINs
     - JOIN with subqueries / LATERAL preview
     - Anti-join variations (LEFT-NULL, NOT EXISTS, EXCEPT)
     - SEMI-JOIN patterns
     - Fan-out detection + COUNT correction
     - JOIN + GROUP BY pitfalls
     - Self-anti-join

   Structure: 25 Conceptual + 25 Non-equi/multi-col + 25 Anti-/semi-join + 25 Multi-table chains w/ performance
   ============================================================ */

/* ============================================================
   SECTION A: JOINs - CONCEPTUAL DEEP (25)
   ------------------------------------------------------------ */
/* Q1.  When does the planner pick Hash Join vs Merge Join vs Nested Loop? */
/* Q2.  Why does adding ORDER BY join_key encourage Merge Join? */
/* Q3.  Compare hash join build/probe phases - which side is hashed. */
/* Q4.  What is a "broadcast join" - and does Postgres do it? */
/* Q5.  Why is INNER JOIN ON a.x = b.y faster than CROSS JOIN + WHERE? (Hint: same plan in modern engines.) */
/* Q6.  Why is JOIN ON a.x = b.y AND a.z = b.z faster with a composite index (x, z)? */
/* Q7.  Non-equi join: WHERE a.range_start <= b.event_date <= a.range_end - give a RetailMart case. */
/* Q8.  Range join in Postgres - what indexes help (GIST on tsrange)? */
/* Q9.  Compare LATERAL JOIN vs correlated subquery - same idea, different syntax. */
/* Q10. Anti-join three ways: LEFT JOIN IS NULL vs NOT EXISTS vs EXCEPT. */
/* Q11. SEMI-JOIN: when does Postgres convert EXISTS to a semi-join? */
/* Q12. Fan-out: how does it create row multiplication in aggregations? */
/* Q13. How do you detect fan-out (compare COUNT(*) vs expected)? */
/* Q14. Why does GROUP BY after a fan-out join over-count SUM? */
/* Q15. Why is JOIN order irrelevant for INNER but critical for OUTER? */
/* Q16. How does the planner decide JOIN order (join_collapse_limit)? */
/* Q17. What is "estimated rows mismatch" - and why bad row estimates kill performance? */
/* Q18. Walk through a triangle inequality JOIN: a.x + b.y > c.z. */
/* Q19. Why is JOIN through a many-to-many bridge table called a "fan-out fan-in"? */
/* Q20. Compare JOIN ON (a.x, a.y) = (b.x, b.y) vs separate AND. */
/* Q21. Explain how OUTER JOIN's qualifying-side filter pushed into ON differs from WHERE. */
/* Q22. What is "join reordering" - and how does the planner explore options? */
/* Q23. Why does adding indexes BOTH sides of a JOIN help? */
/* Q24. Why is `WHERE a.x = b.x` (comma syntax) equivalent to INNER JOIN but missing the OUTER semantics? */
/* Q25. Walk through Postgres's "implicit JOIN" rewriting. */

/* ============================================================
   SECTION B: NON-EQUI / MULTI-COL JOINS (25)
   ------------------------------------------------------------ */
/* Q26. Range join: orders to ad_campaigns where order_date BETWEEN campaign.start_date AND campaign.end_date. */
/* Q27. Range join: customer signup to loyalty.tier valid_from / valid_to history. */
/* Q28. Range join: page_views to A/B test buckets active during that view. */
/* Q29. Range join: pay_slip to active_tax_bracket for that month. */
/* Q30. BETWEEN join: orders to ship-zones based on delivery_address. */
/* Q31. Multi-col join: order_items to inventory on (warehouse_id, product_id). */
/* Q32. Multi-col join: pay_slip to attendance on (employee_id, salary_month). */
/* Q33. Multi-col join: inventory_snapshot to supply_chain.shipment on (warehouse_id, product_id, date). */
/* Q34. Multi-col join: campaign_attribution to orders on (customer_id, order_date). */
/* Q35. Multi-col join: returns to orders on (cust_id, product_id). */
/* Q36. INNER JOIN with > predicate: orders where net_total > campaign threshold. */
/* Q37. Triangle JOIN: a + b > c constraint (e.g., bundle pricing). */
/* Q38. JOIN where order_date is within 7 days of campaign start_date. */
/* Q39. JOIN where customer's city = store's city (proxy for "local order"). */
/* Q40. JOIN with composite key from CTE-derived label. */
/* Q41. Range JOIN: SQL gaps-and-islands warmup (next/prev event matching). */
/* Q42. JOIN orders to weather events on (city, date) for analysis. */
/* Q43. JOIN customers to tier_history valid_from/valid_to for "tier at order time". */
/* Q44. JOIN with date_trunc to align granularity. */
/* Q45. JOIN ON expression: orders to seasons (CASE-based). */
/* Q46. Self-equality on derived key: orders ON LEFT(order_id::text, 4) = LEFT(b.order_id::text, 4). */
/* Q47. JOIN with substring matching: tickets ON product code prefix. */
/* Q48. JOIN with array overlap: product tags && campaign tags. */
/* Q49. JOIN with JSONB ?| array: campaign.tags ?| product.tag_array. */
/* Q50. JOIN with tsvector match: review_text @@ campaign_keyword tsquery. */

/* ============================================================
   SECTION C: ANTI-JOIN & SEMI-JOIN PATTERNS (25)
   ------------------------------------------------------------ */
/* Q51. Anti-join 3 ways: customers never ordered (LEFT IS NULL, NOT EXISTS, EXCEPT). */
/* Q52. Anti-join: products with no reviews. */
/* Q53. Anti-join: employees never assigned a ticket as agent. */
/* Q54. Anti-join: customers with orders but no loyalty membership. */
/* Q55. Anti-join: orders with no shipment. */
/* Q56. Anti-join: ad spend rows with no matching campaign. */
/* Q57. Anti-join: inventory_snapshot rows where product no longer exists. */
/* Q58. Anti-join: pay_slips for employees no longer in stores.employees. */
/* Q59. Anti-join: tickets created by deleted customers (orphans). */
/* Q60. Anti-join: warehouses with no shipments in last 90 days. */
/* Q61. Anti-join: customers who never wrote a review for products they bought. */
/* Q62. Semi-join: customers who placed AT LEAST one order (EXISTS). */
/* Q63. Semi-join: products with ANY review. */
/* Q64. Semi-join: stores with employees AND orders AND inventory. */
/* Q65. Semi-join: agents who handled BOTH tickets AND calls. */
/* Q66. Find products sold in MULTIPLE regions (semi-join with HAVING COUNT > 1). */
/* Q67. Find customers with returns AND no follow-up order. */
/* Q68. Find suppliers who ship to ALL warehouses (relational division). */
/* Q69. Find brands present in EVERY region (relational division). */
/* Q70. Find customers who placed orders in BOTH 2024 AND 2025. */
/* Q71. Find products in inventory with no order_items linkage. */
/* Q72. Find pay_slips with no matching attendance record. */
/* Q73. Find campaigns with no spend rows. */
/* Q74. Find call_center.agents with NO calls in last 30 days. */
/* Q75. Find shipments referencing deleted orders (FK enforce check). */

/* ============================================================
   SECTION D: MULTI-TABLE CHAINS + PERFORMANCE (25)
   ------------------------------------------------------------ */
/* Q76. 6-table chain: order -> order_item -> product -> brand -> category -> supplier. */
/* Q77. 5-table customer 360deg: customer -> order -> order_item -> product -> review. */
/* Q78. 5-table workforce: employee -> pay_slip -> attendance -> department -> store. */
/* Q79. 5-table marketing: ad_spend -> campaign -> attribution -> order -> customer. */
/* Q80. 5-table inventory: warehouse -> snapshot -> product -> supplier -> shipment. */
/* Q81. 5-table support: ticket -> customer -> product -> order -> agent. */
/* Q82. Detect fan-out: COUNT(*) of orders JOIN order_items vs orders alone. */
/* Q83. Subquery aggregation to avoid fan-out: pre-aggregate order_items into a CTE, then JOIN. */
/* Q84. Fan-out fan-in: orders x order_items -> DISTINCT cust_id COUNT. */
/* Q85. EXPLAIN ANALYZE a 5-table JOIN - read the plan top-to-bottom. */
/* Q86. Force hash join with SET enable_nestloop = off - observe plan diff. */
/* Q87. Show indexes the planner used (Index Cond / Filter) from EXPLAIN. */
/* Q88. Compare query with and without an index - runtime difference. */
/* Q89. Add a covering index for a hot 4-table JOIN - measure improvement. */
/* Q90. Identify a SORT step in JOIN plan and tune work_mem to fit in memory. */
/* Q91. Re-write a JOIN as EXISTS to avoid fan-out. */
/* Q92. Convert correlated subquery to LEFT JOIN (rewrite for clarity). */
/* Q93. Add stat targets (ALTER TABLE ... ALTER COLUMN ... SET STATISTICS 1000). */
/* Q94. Use materialized CTE to force pre-computation. */
/* Q95. Detect bad row estimates: actual rows vs planned rows in EXPLAIN ANALYZE. */
/* Q96. Use pg_stat_statements to find which JOIN-heavy query is slowest. */
/* Q97. Refactor 6-table JOIN with subquery-per-level to keep memory bounded. */
/* Q98. Test JOIN performance with 1M-row table - sample row counts. */
/* Q99. Build a "BI report query" that joins 7 tables and uses materialized views. */
/* Q100. Audit query: produce a customer table with EVERY available metric across 8 schemas. */

/* ============================================================
   END OF JOINs Part 1 (Foundations) - HARD LEVEL (100 QUESTIONS)
============================================================ */
