/* ============================================================
   SQL PRACTICE SET - Views & Materialized Views (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Layered view stacks, MV indexing & refresh, schema discipline
   Database:     RetailMart V3

   Scope (MEDIUM = joins + tidy layers + MV strategy):
     - 3-layer stacks (raw -> cleaned -> metrics); WITH CHECK OPTION concept
     - MV unique-index + CONCURRENTLY; index on MVs (Day 20); refresh ordering
     - Composing views with windows (16-18), percentiles/DISTINCT ON (22), dates (23),
       pivots (21), JSON (24) - and EXPLAIN ANALYZE (19) on view-backed queries
   NOTE: CREATE VIEW / MV / INDEX on RetailMart is allowed this day; base-table
     ALTER / CREATE TABLE / DML -> accio_NN only.

   Structure: 25 Conceptual + 25 Layered stacks + 25 MV maintenance & indexing + 25 Composed analytics views
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Layered stack discipline: what belongs in raw / cleaned / metrics and why. */
/* Q2.  When does a view enable an index-only scan on the base table? */
/* Q3.  View inlining: how the planner expands views during optimization. */
/* Q4.  Why CREATE OR REPLACE VIEW requires the same column list shape. */
/* Q5.  Updatable vs non-updatable views in Postgres (concept). */
/* Q6.  WITH CHECK OPTION semantics (CASCADED vs LOCAL) - concept. */
/* Q7.  View vs MV vs summary table - three-way decision matrix. */
/* Q8.  Why MV CONCURRENTLY requires a UNIQUE INDEX (no full lock). */
/* Q9.  Indexing strategy for MVs (Day 20): primary lookup index + secondary. */
/* Q10. Refresh ordering for a stack of MVs (dependencies). */
/* Q11. Detect view dependencies via pg_depend / pg_views (concept). */
/* Q12. DROP CASCADE trap: how to inventory dependents first. */
/* Q13. Schema namespacing for views (e.g. analytics.v_*) - why it matters. */
/* Q14. View security & search_path pitfalls (concept). */
/* Q15. When inlining hurts the plan (many small views combined). */
/* Q16. Materializing a percentile MV (Day 22) - refresh cost vs query cost. */
/* Q17. Time-series MVs (Day 23): daily vs hourly grain trade-offs. */
/* Q18. Pivot MV (Day 21) shape vs long MV - when which is right. */
/* Q19. EXPLAIN ANALYZE on MV vs underlying view (Day 19) - what to look for. */
/* Q20. Stale-data tolerance per consumer - driving refresh cadence. */
/* Q21. Combining views from many schemas - naming + ownership. */
/* Q22. Documenting an MV's refresh contract in a comment. */
/* Q23. When a view becomes a performance crutch (anti-pattern). */
/* Q24. Versioning views (v2 alongside v1) for safe migration. */
/* Q25. Anti-patterns: views over views over views (depth that hurts). */

/* ============================================================
   SECTION B: LAYERED STACKS (25)
   ------------------------------------------------------------ */
/* Q26. Build the orders stack: v_orders_raw -> v_orders_clean -> v_orders_enriched. */
/* Q27. v_orders_clean: trim status, drop Failed, normalize date typing. */
/* Q28. v_orders_enriched: join customers, stores, region, payment_mode. */
/* Q29. v_revenue_by_region_month built on the enriched view. */
/* Q30. Returns stack: v_returns_raw -> v_returns_clean -> v_returns_by_category. */
/* Q31. Tickets stack with SLA: v_tickets_clean -> v_ticket_sla (median/P95). */
/* Q32. Customers stack: v_customers_clean (full_name, primary city via addresses). */
/* Q33. Employees stack: v_employees_clean + v_employee_with_dept. */
/* Q34. Products stack: v_products_clean + v_products_with_brand_category. */
/* Q35. Build v_inventory_latest on top of supply_chain.inventory_snapshots (Day 22). */
/* Q36. Build v_customer_latest_order (DISTINCT ON) and v_customer_first_order. */
/* Q37. Build v_orders_with_basket (items joined + count). */
/* Q38. Build v_orders_with_payment (latest payment, Day 22). */
/* Q39. Build v_revenue_by_region quarter (Day 23) on top of the enriched orders. */
/* Q40. Stack a percentiles layer: v_region_aov_percentiles (Day 22). */
/* Q41. Stack a window-rank layer: v_top_customers_per_region (Day 16). */
/* Q42. Stack a time-series gap-filled layer (Day 23) v_daily_revenue. */
/* Q43. Stack a pivot layer (Day 21): v_region_x_month_revenue. */
/* Q44. Build v_customer_360 as a layered view (Day 24 spirit, relational). */
/* Q45. Cross-stack: v_orders_clean + v_customers_clean -> v_orders_with_customer. */
/* Q46. Show that v_revenue_by_region depends transitively on v_orders_raw. */
/* Q47. Rebuild a view with CREATE OR REPLACE; assert column list unchanged. */
/* Q48. Add a new column to the cleaned layer; propagate through the stack. */
/* Q49. Drop a leaf view safely (verify no dependents first). */
/* Q50. Write a "recreate-stack" script that runs idempotently. */

/* ============================================================
   SECTION C: MV MAINTENANCE & INDEXING (25)
   ------------------------------------------------------------ */
/* Q51. Convert v_monthly_revenue -> MV; add UNIQUE INDEX(month); REFRESH CONCURRENTLY. */
/* Q52. mv_revenue_by_region (region, month) + UNIQUE INDEX; concurrent refresh. */
/* Q53. mv_customer_lifetime (customer_id PK) + indexes for tier / region. */
/* Q54. mv_store_kpis monthly per store + UNIQUE INDEX(store_id, month). */
/* Q55. mv_product_sales by product + secondary index on category. */
/* Q56. mv_top_customers_per_region (Day 16) + index on (region, rank). */
/* Q57. mv_ticket_sla per priority median+P95 (Day 22) + UNIQUE INDEX(priority). */
/* Q58. mv_calls_hourly (hour-of-day, Day 23) + UNIQUE INDEX(hour). */
/* Q59. mv_inventory_latest (warehouse_id, prod_id) + UNIQUE INDEX. */
/* Q60. mv_daily_revenue (date, Day 23) gap-filled + UNIQUE INDEX(d). */
/* Q61. mv_revenue_quarterly (region, quarter) + UNIQUE INDEX. */
/* Q62. mv_returns_by_category (category) + UNIQUE INDEX. */
/* Q63. mv_pay_slip_monthly (employee_id, period) + UNIQUE INDEX. */
/* Q64. mv_employee_salary_latest (employee_id) + UNIQUE INDEX. */
/* Q65. mv_orders_clean (heavy join) + secondary indexes for common filters (Day 20). */
/* Q66. mv_page_view_hourly (hour, device) + UNIQUE INDEX. */
/* Q67. mv_region_x_month_revenue (Day 21 pivot) + UNIQUE INDEX(region). */
/* Q68. mv_top_customers_year (year, rank) + UNIQUE INDEX. */
/* Q69. mv_customer_360_summary (customer_id) + UNIQUE INDEX (Day 24-style). */
/* Q70. Refresh dependency order: list which MVs must refresh before others. */
/* Q71. Write a refresh script that runs in dependency order. */
/* Q72. CONCURRENTLY-safe refresh requirements: verify each MV has a UNIQUE INDEX. */
/* Q73. Compare REFRESH (locks) vs REFRESH CONCURRENTLY (online) - pick per MV. */
/* Q74. EXPLAIN ANALYZE a query against the MV (Day 19) - index-only? */
/* Q75. Decide hourly vs daily refresh per MV; document in a comment. */

/* ============================================================
   SECTION D: COMPOSED ANALYTICS VIEWS (25)
   ------------------------------------------------------------ */
/* Q76. v_region_dashboard: orders, revenue, median AOV, P95 AOV (Day 22). */
/* Q77. mv_region_dashboard + UNIQUE INDEX(region); concurrent refresh. */
/* Q78. v_cohort_retention (Day 23 spine) layered. */
/* Q79. v_funnel_stage_counts (web_events) layered. */
/* Q80. v_delivery_sla per region (median/P95, Day 22). */
/* Q81. v_pricing_corridor per product (P25-P75, Day 22) + latest price (DISTINCT ON). */
/* Q82. v_customer_rfm (NTILE, Day 16) - base layer for Day 27 preview. */
/* Q83. v_anomaly_daily (Day 22 P95 / Day 23 spine) on top of mv_daily_revenue. */
/* Q84. v_top_products_per_category (Day 16) -> mv with refresh. */
/* Q85. v_heatmap_weekday_hour (Day 23) -> mv (small but indexed). */
/* Q86. v_audit_change_summary on record_changes. */
/* Q87. v_customer_360_relational with arrays-of-IDs (Day 24-adjacent). */
/* Q88. v_pay_slip_summary per dept (median/P95 net, Day 22). */
/* Q89. v_inventory_value per warehouse (latest snap x cost_price). */
/* Q90. v_revenue_decomposition new/returning per month. */
/* Q91. v_orders_with_filter_pivot (Day 21) of status counts. */
/* Q92. v_region_x_quarter median AOV (Day 22+21). */
/* Q93. v_dynamic_sla per region (target = prior-Q P90, Day 22). */
/* Q94. mv_customer_360_summary (Day 24-spirit) refreshed nightly. */
/* Q95. v_growth_metrics MoM / YoY per region (Day 23). */
/* Q96. mv_growth_metrics + UNIQUE INDEX(region, month); test refresh. */
/* Q97. Document each MV's refresh cadence and dependency chain. */
/* Q98. Validate substitutability: live aggregate vs MV - totals match? */
/* Q99. Drop all created MVs in dependency-safe order. */
/* Q100. Drop the full stack; provide an idempotent recreate script. */
