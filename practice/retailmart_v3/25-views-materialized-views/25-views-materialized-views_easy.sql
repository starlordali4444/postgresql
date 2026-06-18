/* ============================================================
   SQL PRACTICE SET - Views & Materialized Views (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        CREATE VIEW, CREATE MATERIALIZED VIEW, REFRESH, layered view stacks
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - CREATE VIEW for sharing tested logic; SELECT through a view
     - CREATE MATERIALIZED VIEW for precomputed analytics; REFRESH semantics
     - Layered stack: raw -> cleaned -> metrics; DROP CASCADE awareness
   NOTE: Day 25 PERMITS CREATE VIEW / CREATE MATERIALIZED VIEW / CREATE INDEX on
     RetailMart (read-only base tables stay untouched). DROP/RENAME views you create
     here are fine. Base-table ALTER / CREATE TABLE / INSERT / UPDATE / DELETE ->
     do those in your own accio_NN DB.

   Structure: 25 Conceptual + 25 Plain views + 25 Materialized views + 25 Layered stacks & maintenance
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What is a VIEW (a stored SELECT, run live on each query)? */
/* Q2.  What is a MATERIALIZED VIEW (a stored result set, refreshed on demand)? */
/* Q3.  Why share tested logic as a view rather than copy-pasting SQL? */
/* Q4.  View vs MV: which trades freshness for query speed, and why? */
/* Q5.  What does CREATE OR REPLACE VIEW do (when allowed)? */
/* Q6.  Why are views great for the "metrics layer" of a stack? */
/* Q7.  What does CREATE MATERIALIZED VIEW ... WITH NO DATA do? */
/* Q8.  What does REFRESH MATERIALIZED VIEW do? */
/* Q9.  What does REFRESH MATERIALIZED VIEW CONCURRENTLY require (unique index)? */
/* Q10. Why does a concurrent refresh need a unique index on the MV? */
/* Q11. Layered stack: raw -> cleaned -> metrics - what lives where? */
/* Q12. What is a "raw" view (passthrough + minimal column selection)? */
/* Q13. What is a "cleaned" view (typed, trimmed, deduped values)? */
/* Q14. What is a "metrics" view (aggregates, KPIs)? */
/* Q15. Why are views read-only abstractions for downstream consumers? */
/* Q16. What does DROP VIEW ... CASCADE do (and why is it risky)? */
/* Q17. How do you list dependencies on a view before dropping (concept)? */
/* Q18. Why does a view inherit security from underlying tables? */
/* Q19. What is the difference between CREATE VIEW and CREATE TEMP VIEW? */
/* Q20. Why an MV makes sense for slow analytics that don't need real-time freshness? */
/* Q21. What's the freshness model of a normal view (always current) vs MV (refreshed)? */
/* Q22. Why is a daily refresh schedule common for MVs (and when is hourly needed)? */
/* Q23. Can you index a materialized view? (Yes - Day 20 indexing applies). */
/* Q24. Why is a view a good place to enforce join discipline (one canonical join)? */
/* Q25. Name two analyst reports you'd ship as a view vs as an MV. */

/* ============================================================
   SECTION B: PLAIN VIEWS (25)
   ------------------------------------------------------------ */
/* Q26. Create v_delivered_orders: orders WHERE order_status = 'Delivered'. */
/* Q27. Create v_customer_full_name: customer_id + (first_name||' '||last_name). */
/* Q28. Create v_orders_enriched: orders joined to customers and stores (key columns). */
/* Q29. Create v_orders_clean: filter Failed/Cancelled out + standardize status case. */
/* Q30. SELECT through v_delivered_orders and count rows. */
/* Q31. Create v_high_value_orders: net_total > 5000. */
/* Q32. Create v_gold_platinum_customers: tier IN ('Gold','Platinum'). */
/* Q33. Create v_products_with_brand: products + brand + category names. */
/* Q34. Create v_returns_with_customer: returns -> orders -> customers. */
/* Q35. Create v_revenue_by_region: aggregated SUM(net_total) per region. */
/* Q36. Create v_orders_2025: just orders from 2025 (date_trunc, Day 23). */
/* Q37. Drop v_high_value_orders. */
/* Q38. Create or replace v_orders_clean to also exclude Returned. */
/* Q39. Create v_employee_with_dept: employees + department name. */
/* Q40. Create v_top_customers: top 100 customers by lifetime spend. */
/* Q41. Create v_orders_with_items_count: orders + count(items). */
/* Q42. Create v_active_stores: stores with at least one order. */
/* Q43. Create v_customer_latest_order using DISTINCT ON (Day 22). */
/* Q44. Create v_monthly_revenue using date_trunc('month') (Day 23). */
/* Q45. SELECT a slice from v_monthly_revenue for one year. */
/* Q46. Create v_tickets_open: tickets not yet resolved. */
/* Q47. Create v_pay_slip_clean: parse month-year text into a real date (Day 23). */
/* Q48. Create v_reviews_clean: trim text + drop NULL ratings. */
/* Q49. List the row count of every view you've created so far. */
/* Q50. Drop a view safely after checking no other view depends on it. */

/* ============================================================
   SECTION C: MATERIALIZED VIEWS (25)
   ------------------------------------------------------------ */
/* Q51. Create MV mv_monthly_revenue: month, total revenue, order count. */
/* Q52. REFRESH MATERIALIZED VIEW mv_monthly_revenue. */
/* Q53. Create UNIQUE INDEX on mv_monthly_revenue(month) (prereq for CONCURRENTLY). */
/* Q54. REFRESH MATERIALIZED VIEW CONCURRENTLY mv_monthly_revenue. */
/* Q55. Create mv_revenue_by_region with a unique key + index. */
/* Q56. Create mv_customer_lifetime: per customer total orders, total revenue, latest order. */
/* Q57. Add a UNIQUE INDEX on mv_customer_lifetime(customer_id). */
/* Q58. Create mv_store_kpis: per store monthly revenue & order count. */
/* Q59. Create mv_product_sales: per product units sold + revenue. */
/* Q60. Create mv_orders_with_items_count (heavy join - good MV candidate). */
/* Q61. Create mv_top_customers_by_year: top 100 per year. */
/* Q62. Create mv_returns_by_category. */
/* Q63. Create mv_calls_hourly: per hour-of-day call count & median duration (Day 22/23). */
/* Q64. Create mv_page_views_hourly per device. */
/* Q65. Create mv_employee_salary_latest: latest salary per employee (DISTINCT ON, Day 22). */
/* Q66. Create mv_inventory_latest: latest snapshot per (warehouse, prod). */
/* Q67. Add an index on mv_inventory_latest(warehouse_id, prod_id) (Day 20). */
/* Q68. REFRESH the MV and re-count rows. */
/* Q69. Create MV ... WITH NO DATA; then REFRESH to populate. */
/* Q70. Drop an MV you created. */
/* Q71. Create mv_revenue_quarterly with a unique (region, quarter) key. */
/* Q72. Create mv_ticket_sla: per priority median + P95 resolution hours (Day 22). */
/* Q73. Create mv_daily_revenue (gap-filled spine, Day 23) + UNIQUE INDEX(d). */
/* Q74. Compare row counts: live aggregate query vs MV (should match post-REFRESH). */
/* Q75. EXPLAIN ANALYZE the MV scan (Day 19) - note index-only scan if applicable. */

/* ============================================================
   SECTION D: LAYERED STACK & MAINTENANCE (25)
   ------------------------------------------------------------ */
/* Q76. Layer 1 (raw): v_orders_raw = passthrough of sales.orders with renamed cols. */
/* Q77. Layer 2 (cleaned): v_orders_clean built on v_orders_raw (filter + trim). */
/* Q78. Layer 3 (metrics): v_monthly_revenue_kpis built on v_orders_clean. */
/* Q79. Show that v_monthly_revenue_kpis transitively depends on v_orders_raw. */
/* Q80. Materialize the metrics layer: mv_monthly_revenue_kpis. */
/* Q81. Replace the metrics view with an MV; consumers keep the same name (drop + create). */
/* Q82. Stack: raw -> cleaned -> metrics for returns; one MV at the top. */
/* Q83. Stack: raw -> cleaned -> metrics for tickets (SLA dashboard). */
/* Q84. Decision: which of your 3 layers should be an MV (heaviest aggregate)? */
/* Q85. REFRESH order: refresh bottom-up vs top-down - discuss. */
/* Q86. Detect dependent views before dropping a base view (pg_depend/pg_views). */
/* Q87. DROP a view CASCADE and explain what got dropped (then recreate). */
/* Q88. Schedule strategy: daily vs hourly refresh - pick for monthly_revenue_kpis. */
/* Q89. Add a UNIQUE INDEX on each MV that needs CONCURRENTLY. */
/* Q90. Refresh strategy: stale-MV note vs CONCURRENT - tradeoffs. */
/* Q91. Build a "customer-360" view (Day 24 spirit, relational) on top of the stack. */
/* Q92. Time-series MV (Day 23): daily revenue + 7-day MA, with index. */
/* Q93. Percentile MV (Day 22): median & P95 net_total per region. */
/* Q94. Pivot MV (Day 21): region x month revenue. */
/* Q95. Build an MV for the executive KPI strip (orders, median, P95, latest). */
/* Q96. Document each MV's refresh cadence in a comment header. */
/* Q97. Test view substitutability: same query on view vs base - equal rows? */
/* Q98. Drop all the MVs you created (cleanup) - list first, then drop. */
/* Q99. Drop all the views you created (in dependency-safe order). */
/* Q100. Recreate the full 3-layer stack as a script you can re-run. */
