/* ============================================================
   SQL PRACTICE SET - Indexing for Analysts (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        What an index is, B-Tree, CREATE INDEX, verifying use
   Database:     RetailMart V3
                 NOTE: CREATE INDEX is fine on RetailMart (it doesn't change
                 table structure/data). Real DDL/DML (ALTER/INSERT...) belongs
                 in your own accio_NN DB.

   Scope (EASY = one concept per question):
     - What indexes do; B-Tree basics; CREATE INDEX [IF NOT EXISTS] syntax
     - Single-column indexes; verifying use with EXPLAIN; pg_indexes inventory
   (Reading plans is Day 19 - here we add indexes and confirm they're used.)

   Structure: 25 Conceptual + 25 Create single-col + 25 Verify-with-EXPLAIN + 25 Inventory/cleanup
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What is an index, and how does it speed up reads? */
/* Q2.  What is the default index type in PostgreSQL (B-Tree)? */
/* Q3.  Which operators can a B-Tree serve (=, <, >, BETWEEN, ORDER BY)? */
/* Q4.  What is the write-time cost of having indexes? */
/* Q5.  Why doesn't an index help a full-table aggregate (SUM of all rows)? */
/* Q6.  Syntax: CREATE INDEX name ON schema.table (column); */
/* Q7.  What does IF NOT EXISTS add to CREATE INDEX? */
/* Q8.  How do you DROP an index? */
/* Q9.  How do you confirm a query USES an index (EXPLAIN)? */
/* Q10. What is a primary key's relationship to an index? */
/* Q11. Does a UNIQUE constraint create an index automatically? */
/* Q12. What is selectivity, and why do indexes help selective filters most? */
/* Q13. Why is an index on a low-cardinality column (e.g. gender) often useless? */
/* Q14. What is an Index Only Scan (intuition)? */
/* Q15. How do you list existing indexes on a table (pg_indexes)? */
/* Q16. Why can't an index help WHERE LOWER(col)=... (plain column index)? */
/* Q17. What is CREATE INDEX CONCURRENTLY for (concept)? */
/* Q18. Why might the planner ignore an index you created (stats/selectivity)? */
/* Q19. What is a composite (multi-column) index (intro)? */
/* Q20. What is a partial index (intro)? */
/* Q21. Why run ANALYZE after creating an index / loading data? */
/* Q22. What does an index cost in disk space, roughly? */
/* Q23. When should you NOT add an index (write-heavy, low selectivity)? */
/* Q24. Difference between a clustered and non-clustered index (PG has no clustered by default). */
/* Q25. Name two analyst queries that clearly benefit from an index. */

/* ============================================================
   SECTION B: CREATE SINGLE-COLUMN INDEXES (25)
   (run on RetailMart; drop afterward to keep it clean)
   ------------------------------------------------------------ */
/* Q26. Create a B-Tree index on sales.orders(cust_id). */
/* Q27. Create an index on sales.orders(order_date). */
/* Q28. Create an index on customers.customers(email). */
/* Q29. Create an index on products.products(brand_id). */
/* Q30. Create an index on sales.order_items(prod_id). */
/* Q31. Create an index on support.tickets(customer_id). */
/* Q32. Create an index on customers.reviews(product_id). */
/* Q33. Create an index on stores.employees(store_id). */
/* Q34. Create an index on sales.orders(store_id). */
/* Q35. Create an index on web_events.page_views(session_id). */
/* Q36. Create an index on call_center.calls(customer_id). */
/* Q37. Create an index on sales.shipments(order_id). */
/* Q38. Create an index on products.products(price). */
/* Q39. Create an index on loyalty.members(tier_id). */
/* Q40. Create an index on customers.addresses(customer_id). */
/* Q41. Create an index IF NOT EXISTS on sales.orders(order_status). */
/* Q42. Create an index on payroll.pay_slips(employee_id). */
/* Q43. Create an index on marketing.ads_spend(campaign_id). */
/* Q44. Create an index on supply_chain.inventory_snapshots(product_id). */
/* Q45. Create an index on customers.customers(registration_date). */
/* Q46. Create an index on sales.returns(order_id). */
/* Q47. Name an index explicitly (idx_orders_custid) for clarity. */
/* Q48. Create an index on stores.employees(salary). */
/* Q49. Create an index on support.tickets(agent_id). */
/* Q50. Drop one of the indexes you created (DROP INDEX). */

/* ============================================================
   SECTION C: VERIFY WITH EXPLAIN (25)
   ------------------------------------------------------------ */
/* Q51. EXPLAIN a WHERE cust_id=1234 before creating the index (Seq Scan). */
/* Q52. Create the index on cust_id, ANALYZE, then EXPLAIN again (Index Scan?). */
/* Q53. Verify an index on order_date is used by a range query. */
/* Q54. Verify an email-equality lookup uses the email index. */
/* Q55. Show that WHERE LOWER(email)=... does NOT use the plain email index. */
/* Q56. Verify a join on cust_id uses the index on the FK side. */
/* Q57. Verify ORDER BY order_date LIMIT 10 uses the order_date index. */
/* Q58. Show a full-table COUNT(*) ignores indexes (Seq Scan). */
/* Q59. Verify a brand_id filter uses its index. */
/* Q60. Show a low-selectivity filter (order_status='Delivered') may still Seq Scan. */
/* Q61. Verify a prod_id join in order_items uses the index. */
/* Q62. EXPLAIN ANALYZE before/after adding an index; compare actual time. */
/* Q63. Show an Index Only Scan when selecting only the indexed column. */
/* Q64. Show that SELECT * breaks the Index Only Scan. */
/* Q65. Verify a date-range BETWEEN uses the index. */
/* Q66. Show a leading-wildcard LIKE ignores the index. */
/* Q67. Show a prefix LIKE 'a%' can use the index (with appropriate opclass). */
/* Q68. Verify an index on price is used by price > 10000. */
/* Q69. Show the planner picks Seq Scan when the predicate matches most rows. */
/* Q70. Verify a customer_id filter on reviews uses the index. */
/* Q71. EXPLAIN to confirm the index name actually appears in the plan. */
/* Q72. Show BUFFERS difference before/after indexing a point lookup. */
/* Q73. Verify a store_id filter on orders uses its index. */
/* Q74. Show how ANALYZE changes the plan after bulk data (concept on RetailMart). */
/* Q75. Confirm an index is unused for a query and explain why. */

/* ============================================================
   SECTION D: INVENTORY & CLEANUP (25)
   ------------------------------------------------------------ */
/* Q76. List all indexes on sales.orders via pg_indexes. */
/* Q77. List all indexes in the sales schema. */
/* Q78. Count indexes per table across the database. */
/* Q79. Find the index definition (indexdef) for a given index name. */
/* Q80. List indexes on customers.customers. */
/* Q81. Identify which columns of sales.orders are indexed. */
/* Q82. Find tables in sales that have NO non-PK index. */
/* Q83. List unique indexes vs non-unique on a table. */
/* Q84. Show the size of an index (pg_relation_size) - concept. */
/* Q85. Find duplicate/overlapping index candidates (same leading column). */
/* Q86. Drop a named index you created earlier. */
/* Q87. Drop all the demo indexes you created in Section B (cleanup). */
/* Q88. Verify the table is back to only its PK/constraint indexes. */
/* Q89. List indexes on products.products and their columns. */
/* Q90. Find which index backs the primary key of sales.orders. */
/* Q91. List the largest indexes by size (concept query). */
/* Q92. Show indexes on a join-heavy table (order_items). */
/* Q93. Identify a missing FK index from pg_indexes + foreign keys. */
/* Q94. List partial indexes (those with a WHERE in indexdef). */
/* Q95. List expression indexes (indexdef contains a function). */
/* Q96. Confirm dropping an index doesn't affect query results (only speed). */
/* Q97. Re-create an index with a clear naming convention. */
/* Q98. Show pg_indexes output filtered to a single table. */
/* Q99. Inventory all indexes and flag tables with > 5 indexes. */
/* Q100. Produce a tidy index inventory report for the sales schema. */

/* ============================================================
   END OF Indexing for Analysts - EASY LEVEL (100 QUESTIONS)
============================================================ */
