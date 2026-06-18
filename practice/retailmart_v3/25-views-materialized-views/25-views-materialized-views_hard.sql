/* ============================================================
   SQL PRACTICE SET - Views & Materialized Views (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Production view stacks, MV indexing & refresh choreography, dependency hygiene
   Database:     RetailMart V3

   Scope (HARD = interview-grade, performance-aware, multi-step):
     - 3-layer stacks at scale; cascade safety; refresh dependency choreography
     - MV indexing (Day 20), CONCURRENTLY constraints, plan inspection (Day 19)
     - Composed analytics: percentiles (22), DISTINCT ON (22), windows (16-18),
       date spines (23), pivots (21), JSON (24); previews for Day 26 dedup / Day 27 cohort
   NOTE: CREATE VIEW / MV / INDEX permitted; base-table ALTER / DML -> accio_NN.

   Structure: 25 Conceptual + 25 Production view stacks + 25 MV refresh choreography + 25 Composed analytics MVs
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Designing a 3-layer view stack at scale: raw / cleaned / metrics responsibilities. */
/* Q2.  View inlining limits: when the planner can't push predicates through. */
/* Q3.  Materializing for query speed vs view for freshness - a decision rubric. */
/* Q4.  REFRESH MV CONCURRENTLY constraints + unique-index requirement at scale. */
/* Q5.  Refresh choreography for a DAG of MVs (dependency-safe ordering). */
/* Q6.  Indexing MVs (Day 20) - primary unique + secondary range + expression. */
/* Q7.  Plan inspection on MV-backed dashboards (Day 19) - index-only-scan goals. */
/* Q8.  DROP CASCADE blast-radius mitigation (dependency audit). */
/* Q9.  Backward-compat view evolution (versioned vN; deprecation pattern). */
/* Q10. Stale-data SLAs per consumer and how to drive refresh cadence. */
/* Q11. Hybrid: live view on top of an MV (last-N-minutes UNIONed in). */
/* Q12. Multi-grain MVs (day / week / month) with consistent rollups. */
/* Q13. Partial MV (filtered set) for hot dashboards. */
/* Q14. View security & search_path discipline at scale. */
/* Q15. Anti-pattern: deeply nested views causing replanning cost. */
/* Q16. Time-series MV refresh strategy (Day 23) - incremental concept. */
/* Q17. Percentile MV (Day 22) - chunked rebuild for huge tables. */
/* Q18. JSON-export MV (Day 24) - when to ship API payload as an MV. */
/* Q19. Pivot MV (Day 21) - wide vs long, schema stability concerns. */
/* Q20. Validation checks against MVs (totals match base) as a contract. */
/* Q21. Documentation: per MV - owner, grain, refresh cadence, dependents. */
/* Q22. View naming & namespacing (raw_/clean_/m_/mv_) - stack hygiene. */
/* Q23. Index maintenance cost on MV refresh - when to drop+recreate. */
/* Q24. Multi-tenant view layering (per-region filtered views). */
/* Q25. When NOT to materialize (small / cheap / volatile data). */

/* ============================================================
   SECTION B: PRODUCTION VIEW STACKS (25)
   ------------------------------------------------------------ */
/* Q26. Orders stack: raw -> clean -> enriched -> metrics (4 views) with proper dependencies. */
/* Q27. Customers stack: raw -> clean (full_name, primary city) -> enriched (latest order Day 22). */
/* Q28. Products stack: raw -> clean -> enriched (brand+category+promo flag). */
/* Q29. Inventory stack: raw -> latest-per-(warehouse,prod) (Day 22) -> value (x cost_price). */
/* Q30. Tickets stack: raw -> clean -> SLA per priority (median/P95, Day 22). */
/* Q31. Pay-slip stack: raw -> clean (period date) -> summary per dept (Day 22). */
/* Q32. Returns stack: raw -> enriched (with order/customer) -> metrics by category. */
/* Q33. Audit stack: record_changes raw -> typed -> change-summary. */
/* Q34. Web stack: page_views raw -> cleaned -> hourly (Day 23). */
/* Q35. Calls stack: raw -> enriched (agent dept) -> SLA / hour-of-day (Day 22+23). */
/* Q36. Cross-stack: orders + customers -> v_orders_with_customer (canonical join). */
/* Q37. Cross-stack: orders + payments (latest, Day 22) -> v_orders_with_payment. */
/* Q38. Cross-stack: orders + shipments + delivery_days (Day 23). */
/* Q39. Cross-stack: returns -> orders -> customers -> tier-aware metrics. */
/* Q40. Region rollup stack: stores -> region revenue/quarter (Day 21+23). */
/* Q41. Region percentiles layer: median/P90/P95 AOV per region (Day 22) on top of metrics. */
/* Q42. Top-N layer (Day 16): top customers per region by lifetime spend. */
/* Q43. Cohort layer (Day 23 + window): cohort_month + period_index 0..11. */
/* Q44. RFM layer (Day 16 NTILE): recency/freq/monetary scores per customer. */
/* Q45. Customer-360 layer (Day 24-spirit): joined arrays-of-IDs of latest activity. */
/* Q46. Anomaly layer (Day 22+23): daily revenue beyond P95 flagged. */
/* Q47. Funnel layer: stage counts from web_events + drop-off ratios. */
/* Q48. Pricing-corridor layer (Day 22): P25-P75 + latest selling price. */
/* Q49. Sales-trend layer: MoM / YoY per region (Day 23 + window). */
/* Q50. Build an "exec metrics" leaf view that pulls from all the above. */

/* ============================================================
   SECTION C: MV REFRESH CHOREOGRAPHY (25)
   ------------------------------------------------------------ */
/* Q51. Convert the orders-metrics layer to MV + UNIQUE INDEX + CONCURRENTLY-safe. */
/* Q52. mv_revenue_by_region_month (region, month) with UNIQUE + range index. */
/* Q53. mv_customer_lifetime + secondary indexes (tier, region). */
/* Q54. mv_store_kpis monthly per store; refresh cadence comment in DDL. */
/* Q55. mv_ticket_sla per priority; UNIQUE INDEX + plan-check (Day 19). */
/* Q56. mv_daily_revenue (Day 23) gap-filled + UNIQUE INDEX(d) + plan-check. */
/* Q57. mv_inventory_latest + UNIQUE INDEX(warehouse_id, prod_id). */
/* Q58. mv_top_customers_per_region (Day 16) + (region, rank) UNIQUE. */
/* Q59. mv_region_percentiles AOV (Day 22) + UNIQUE INDEX(region). */
/* Q60. mv_region_x_month_revenue (Day 21 pivot) + UNIQUE INDEX(region). */
/* Q61. mv_funnel_counts + UNIQUE INDEX(stage). */
/* Q62. mv_cohort_retention (cohort_month, period_index) + UNIQUE INDEX. */
/* Q63. mv_rfm_scores (customer_id) + UNIQUE INDEX. */
/* Q64. mv_customer_360_summary (customer_id) + UNIQUE INDEX (Day 24-spirit). */
/* Q65. Dependency graph: list refresh order for the above MVs. */
/* Q66. Script: refresh all MVs in dependency order with CONCURRENTLY where possible. */
/* Q67. Detect MVs missing UNIQUE INDEX (would block CONCURRENTLY) - audit query. */
/* Q68. Compare REFRESH (lock) vs REFRESH CONCURRENTLY timings - concept + measurement. */
/* Q69. Hybrid view: mv_daily_revenue UNION live last-N-hour aggregate. */
/* Q70. Partial MV: only the last 90 days (Day 23 cutoff) - speed up refresh. */
/* Q71. Multi-grain MVs (day/week/month) revenue with reconciliation checks. */
/* Q72. Validation: per MV - totals match the live aggregate (assertion query). */
/* Q73. Drop+recreate index on MV refresh to keep bloat low (concept). */
/* Q74. Refresh budgeting: which MVs fit a 5-minute SLO; which need hourly. */
/* Q75. Document each MV: owner, grain, refresh, dependents - in DDL comment. */

/* ============================================================
   SECTION D: COMPOSED ANALYTICS MVS (25)
   ------------------------------------------------------------ */
/* Q76. mv_region_dashboard (orders, median/P90/P95 AOV, latest order, rank) - exec strip. */
/* Q77. mv_cohort_triangle_with_ltv: cohort x period retention + cumulative revenue (Day 23). */
/* Q78. mv_delivery_sla per region (median/P95 days + breach %, Day 22). */
/* Q79. mv_ticket_sla_extended per priority/month (Day 23). */
/* Q80. mv_pricing_corridor per product + latest price + drift flag (Day 22). */
/* Q81. mv_inventory_value per warehouse + days-of-cover (Day 23). */
/* Q82. mv_anomaly_daily revenue beyond regional P95 (Day 22+23) for alerting. */
/* Q83. mv_funnel_drop_off per stage + per hour (Day 23). */
/* Q84. mv_customer_rfm_segments (Day 16 NTILE) - Day 27 preview. */
/* Q85. mv_audit_change_jumps > 50% price-change (Day 26 preview). */
/* Q86. mv_heatmap_weekday_hour (Day 23) - small but indexed for UI. */
/* Q87. mv_region_x_quarter median AOV (Day 22+21+23). */
/* Q88. mv_growth_metrics MoM/YoY per region (Day 23). */
/* Q89. mv_customer_360_summary (Day 24-spirit) - refreshed nightly, comment cadence. */
/* Q90. mv_pay_slip_dept_summary (median/P95 net by dept, Day 22). */
/* Q91. mv_top_products_per_category (Day 16) - for catalog highlights. */
/* Q92. mv_revenue_decomposition new/returning per month per region. */
/* Q93. mv_inventory_stockout_streaks per warehouse (Day 23 + gap-and-island concept). */
/* Q94. mv_dynamic_sla_attainment (target = prior-Q P90, Day 22). */
/* Q95. mv_calls_hourly per agent + median duration (Day 22+23). */
/* Q96. mv_returns_root_cause per category/region (counts + refund %). */
/* Q97. mv_executive_strip (orders, median, P95, SLA%, churn-risk count, rank). */
/* Q98. Validation suite: assert mv totals = live totals for all the above. */
/* Q99. Drop-all script in dependency-safe order (audit dependencies first). */
/* Q100. Capstone: deliver a 3-layer stack (raw / cleaned / metrics) + MV at the top, with UNIQUE INDEX, refresh cadence documented, plan-checked (Day 19), and reconciliation. */
