/* ============================================================
   SQL PRACTICE SET - Indexing for Analysts (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Composite indexes, partial indexes, expression indexes
   Database:     RetailMart V3   (CREATE INDEX ok; drop demos afterward)

   Scope (MEDIUM = design + verify the right index for a query):
     - Composite indexes & leftmost-prefix rule; column ordering
     - Partial indexes (WHERE-bound); expression indexes
     - Before/after EXPLAIN; Index Only Scan via covering
   (Plan reading is Day 19.)

   Structure: 25 Conceptual + 25 Composite + 25 Partial/expression + 25 Verify/measure
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Explain the leftmost-prefix rule for composite indexes. */
/* Q2.  For WHERE a=? AND b=?, is (a,b) or (b,a) better? How to decide? */
/* Q3.  Can (a,b) serve WHERE a=? alone? WHERE b=? alone? */
/* Q4.  When does column order in a composite index matter for ORDER BY? */
/* Q5.  What is a partial index and a good use-case (active/rare rows)? */
/* Q6.  What is an expression index (e.g. on LOWER(email))? */
/* Q7.  How does a covering index (INCLUDE) enable an Index Only Scan? */
/* Q8.  Why put the equality column before the range column in a composite? */
/* Q9.  When is a single composite better than two single-column indexes? */
/* Q10. When can the planner combine two single-column indexes (BitmapAnd)? */
/* Q11. Why does a partial index for WHERE status='Cancelled' stay small? */
/* Q12. What must a query's WHERE match for a partial index to be usable? */
/* Q13. Why must an expression index match the exact expression in WHERE? */
/* Q14. Trade-off: more indexes = faster reads but slower writes. Explain. */
/* Q15. What is a redundant index (prefix of another)? */
/* Q16. Why is (a) redundant if (a,b) exists for a-only lookups? */
/* Q17. When does INCLUDE help vs adding the column to the key? */
/* Q18. How does selectivity of the leading column affect a composite's usefulness? */
/* Q19. Why might a partial index need its predicate to be IMMUTABLE-ish/stable? */
/* Q20. How to index for a frequent (cust_id, order_date DESC) access pattern? */
/* Q21. Why does ORDER BY benefit from matching the index's sort order? */
/* Q22. What is index bloat and what causes it (concept)? */
/* Q23. When does CREATE INDEX CONCURRENTLY matter (no table lock)? */
/* Q24. Why ANALYZE after creating an expression index? */
/* Q25. Give a 1-line rule for "what to index" for analyst workloads. */

/* ============================================================
   SECTION B: COMPOSITE INDEXES (25)
   ------------------------------------------------------------ */
/* Q26. Create (cust_id, order_date) on sales.orders for per-customer time queries. */
/* Q27. Verify it serves WHERE cust_id=? AND order_date>=?. */
/* Q28. Show it serves WHERE cust_id=? alone (leftmost prefix). */
/* Q29. Show it does NOT serve WHERE order_date=? alone. */
/* Q30. Create (store_id, order_date) and verify a store-time-range query. */
/* Q31. Create (brand_id, price) on products; verify brand + price filter. */
/* Q32. Choose the better order for WHERE supplier_id=? AND price>?; justify. */
/* Q33. Create (order_id, prod_id) on order_items; verify a line lookup. */
/* Q34. Create (customer_id, review_date) on reviews; verify latest-per-customer. */
/* Q35. Create (agent_id, status) on tickets; verify agent open-ticket query. */
/* Q36. Create (cust_id, order_date DESC) to support ORDER BY DESC LIMIT. */
/* Q37. Verify the DESC composite removes a Sort node in the plan. */
/* Q38. Create (warehouse_id, product_id, snapshot_date) and verify a lookup. */
/* Q39. Show two single-col indexes combined via BitmapAnd vs one composite. */
/* Q40. Create (region_id, ...) friendly index for store filters. */
/* Q41. Create (campaign_id, spend_date) on ads_spend; verify. */
/* Q42. Create (employee_id, salary_year) on pay_slips; verify. */
/* Q43. Create (call_reason, agent_id) on calls; verify. */
/* Q44. Decide column order for WHERE order_status=? AND order_date>=?. */
/* Q45. Create a composite to support a GROUP BY cust_id, order_date::month. */
/* Q46. Verify a composite enables an Index Only Scan when selecting only its columns. */
/* Q47. Add INCLUDE(net_total) to (cust_id, order_date) for a covering scan. */
/* Q48. Show the INCLUDE version yields Index Only Scan for SELECT net_total. */
/* Q49. Identify a redundant single-column index given a composite; drop it. */
/* Q50. Drop the composite indexes you created (cleanup). */

/* ============================================================
   SECTION C: PARTIAL & EXPRESSION INDEXES (25)
   ------------------------------------------------------------ */
/* Q51. Create a partial index on orders(order_date) WHERE order_status='Cancelled'. */
/* Q52. Verify the partial index serves a Cancelled-orders date query. */
/* Q53. Show the partial index is NOT used for a non-Cancelled query. */
/* Q54. Create a partial index for unresolved tickets (WHERE resolved_date IS NULL). */
/* Q55. Verify it serves the "open tickets" query. */
/* Q56. Create an expression index on LOWER(email). */
/* Q57. Verify WHERE LOWER(email)='x@y.com' now uses it. */
/* Q58. Create an expression index on (first_name || ' ' || last_name). */
/* Q59. Verify a full-name equality search uses it. */
/* Q60. Create an expression index on date_trunc('month', order_date::timestamp). */
/* Q61. Verify a monthly-bucket query uses it. */
/* Q62. Create a partial index for high-value orders (WHERE net_total > 50000). */
/* Q63. Verify a high-value-orders query uses it. */
/* Q64. Create an expression index on (price - cost_price) (margin). */
/* Q65. Verify a margin filter uses it. */
/* Q66. Create a partial UNIQUE-style index concept (note V3 dup emails block true UNIQUE). */
/* Q67. Create a partial index for recent orders (WHERE order_date >= DATE '2025-01-01'). */
/* Q68. Verify recent-orders queries use it. */
/* Q69. Create an expression index on EXTRACT(YEAR FROM order_date). */
/* Q70. Show why a range rewrite may beat the expression index anyway. */
/* Q71. Create a partial index on reviews WHERE rating <= 2 (negative reviews). */
/* Q72. Verify the negative-review query uses it. */
/* Q73. Create an expression index on regexp_replace(phone,'\\D','','g') (digits). */
/* Q74. Verify a normalized-phone lookup uses it. */
/* Q75. Drop all partial/expression demo indexes (cleanup). */

/* ============================================================
   SECTION D: VERIFY & MEASURE (25)
   ------------------------------------------------------------ */
/* Q76. EXPLAIN ANALYZE a point lookup before/after a single-col index; compare time. */
/* Q77. EXPLAIN ANALYZE a date-range before/after a composite; compare. */
/* Q78. Measure BUFFERS before/after indexing a hot query. */
/* Q79. Show a Sort disappears after a matching DESC composite. */
/* Q80. Confirm an Index Only Scan via a covering index. */
/* Q81. Confirm a partial index reduces scanned rows vs full index. */
/* Q82. Show the planner choosing Bitmap when selectivity is medium. */
/* Q83. Compare two candidate composites for the same query; pick the winner. */
/* Q84. Show that adding the wrong index doesn't change the plan (planner ignores). */
/* Q85. Measure the plan for a join before/after indexing the FK. */
/* Q86. Confirm ANALYZE was needed for the planner to use a new expression index. */
/* Q87. Show an Index Only Scan breaks when you add a non-covered column. */
/* Q88. Demonstrate leftmost-prefix: composite used for a-only, ignored for b-only. */
/* Q89. Measure ORDER BY ... LIMIT with vs without a matching index. */
/* Q90. Show a low-selectivity filter still Seq Scans despite an index. */
/* Q91. Compare single composite vs two singles (BitmapAnd) on a 2-predicate query. */
/* Q92. Verify a partial index is smaller (pg_relation_size) than the full one. */
/* Q93. Confirm dropping a redundant index leaves the plan unchanged. */
/* Q94. Show a covering index removing heap fetches (Heap Fetches=0 after VACUUM). */
/* Q95. Measure a GROUP BY before/after an index supporting it. */
/* Q96. Demonstrate the index that best serves a customer-orders-by-date page. */
/* Q97. Pick the right index for a "top products per brand by price" query. */
/* Q98. Verify the chosen index, then DROP it to keep RetailMart clean. */
/* Q99. Produce a before/after measurement table for one optimized query. */
/* Q100. Recommend a minimal index set (<=3) for the customer-360 query and justify each. */

/* ============================================================
   END OF Indexing for Analysts - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
