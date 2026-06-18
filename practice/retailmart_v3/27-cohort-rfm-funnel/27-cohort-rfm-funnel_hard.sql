/* ============================================================
   SQL PRACTICE SET - Cohort, RFM & Funnel Queries (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Cohort+LTV triangles, RFM drift & segments, multi-stage funnels, growth attribution
   Database:     RetailMart V3

   Scope (HARD = interview-grade, performance-aware, multi-step):
     - Cohort triangle (retention + cumulative LTV) per region/tier; weekly cohorts
     - RFM with named segments + per-quarter drift tracking + reactivation candidates
     - Multi-stage funnels (session + customer level) with time-between-step distributions
     - PoP MoM/YoY/QoQ growth + decomposition (new / returning / reactivated)
     - Leverages percentiles (22), windows (16-18), date spines (23), pivots (21), JSON (24);
       cleansed inputs from Day 26; materialization choices flagged for Day 25.

   Structure: 25 Conceptual + 25 Cohort triangle + LTV + 25 RFM segments + drift + 25 Funnels + growth attribution
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Cohort anchor: registration vs first_order - implications for retention shape. */
/* Q2.  Weekly vs monthly cohorts - when noisy/clean. */
/* Q3.  Cohort triangle storage shape: long vs wide; pivot in BI vs SQL. */
/* Q4.  Cumulative cohort LTV: when to divide by cohort size vs active size. */
/* Q5.  RFM ties at percentile boundaries (NTILE vs PERCENTILE_CONT, Day 22). */
/* Q6.  Named-segment governance (Champions/Loyal/At-Risk) - rule book. */
/* Q7.  Drift accounting: customers moving segments quarter-over-quarter. */
/* Q8.  Funnel: customer reach vs session reach vs per-event count. */
/* Q9.  Drop-off math: ratio chain vs absolute deltas. */
/* Q10. Time-between-steps (median/P95, Day 22) as a funnel KPI. */
/* Q11. Multi-channel/device funnel splits (Day 21 pivot). */
/* Q12. Survivor-bias trap in cohort analysis. */
/* Q13. CLV horizon: 12-month vs lifetime; cap and report both. */
/* Q14. PoP growth decomposition: new vs returning vs reactivated contribution. */
/* Q15. Per-cohort PoP: aging vs same-period-by-cohort. */
/* Q16. Spine-driven completeness for cohort and funnel reports (Day 23). */
/* Q17. Day 26 dependency: cleansed customers/orders/sessions feed the cohort layer. */
/* Q18. Day 25 dependency: which cohort/funnel results should be MVs. */
/* Q19. Plan inspection (Day 19): cohort joins over 150k orders. */
/* Q20. Index strategy (Day 20): customer_id PK + order_date btree, view_timestamp btree. */
/* Q21. JSON export (Day 24) of triangles and funnel payloads. */
/* Q22. Segmentation playback: scoring as-of historical points (point-in-time). */
/* Q23. Anti-pattern: changing RFM cutoffs without versioning the segment definitions. */
/* Q24. Cross-team handoff: marketing wants segments; product wants funnels. */
/* Q25. Documenting the cohort/RFM/funnel rules in a runbook. */

/* ============================================================
   SECTION B: COHORT TRIANGLE + LTV (25)
   ------------------------------------------------------------ */
/* Q26. Monthly cohort grid (signup_month x period 0..11): distinct active customers. */
/* Q27. Monthly cohort grid as retention % (active / cohort_size_at_0). */
/* Q28. Cumulative cohort LTV per period_index (running sum, Day 17). */
/* Q29. Pivot the LTV grid wide (Day 21). */
/* Q30. Per region cohort grid (join customers->addresses->region). */
/* Q31. Per tier cohort grid (Bronze..Platinum). */
/* Q32. Weekly cohort grid (signup_week x week 0..12). */
/* Q33. Spine-driven completeness (Day 23) for all (cohort, period) cells. */
/* Q34. Cohort size sanity: sum across grid columns equals total. */
/* Q35. Best cohort by Month-1 retention. */
/* Q36. Best cohort by Month-3 retention. */
/* Q37. Best cohort by 12-month LTV. */
/* Q38. Worst cohort by Month-3 retention (for diagnostics). */
/* Q39. Cohort x region retention heatmap (Day 21). */
/* Q40. Cohort x tier LTV heatmap. */
/* Q41. Average revenue per active customer per period (Day 22 median per cell). */
/* Q42. Reactivation rate per cohort (active in period N after gap). */
/* Q43. Survival proxy: cohort customers with >=3 active months. */
/* Q44. Compare 2024 vs 2025 cohorts: retention shape. */
/* Q45. Compare 2024 vs 2025 cohorts: cumulative LTV shape. */
/* Q46. JSON cohort export (Day 24): {cohort, period, retention, ltv} array. */
/* Q47. MV candidate (Day 25): cohort x period retention/LTV - refresh cadence. */
/* Q48. Plan check (Day 19): cohort query on 150k orders + 50k customers. */
/* Q49. Index check (Day 20): orders(order_date, cust_id) helps cohort joins. */
/* Q50. Reconciliation: monthly cohort active count vs MAU per month (Day 23). */

/* ============================================================
   SECTION C: RFM SEGMENTS + DRIFT (25)
   ------------------------------------------------------------ */
/* Q51. R/F/M raw values per customer (Day 22 latest order for R). */
/* Q52. RFM scores via NTILE(5) on each (Day 16). */
/* Q53. Combine to 'RFM' string + total R+F+M. */
/* Q54. Named segments via score buckets (CASE). */
/* Q55. Counts per named segment + total customers. */
/* Q56. Median & P95 CLV per segment (Day 22). */
/* Q57. Per region segment counts (Day 21 pivot). */
/* Q58. Per tier segment counts. */
/* Q59. Per cohort segment counts (cohort_month x segment). */
/* Q60. Drift: segment Q1 vs Q2 (transition matrix). */
/* Q61. Movers report: Champions in Q1 -> which segments in Q2. */
/* Q62. Promotion candidates: At Risk + monetary high. */
/* Q63. Reactivation candidates: Hibernating + >=5 historical orders. */
/* Q64. New-customer pipeline per month (Day 23). */
/* Q65. Average orders, avg lifetime revenue per segment. */
/* Q66. CLV percentile bands per segment (Day 22). */
/* Q67. Top-10 customers per segment by CLV (Day 16). */
/* Q68. Segment x delivery-SLA breach rate (Day 22). */
/* Q69. Segment x support-ticket volume per customer. */
/* Q70. JSON RFM segment export (Day 24). */
/* Q71. Point-in-time segmentation: scores as-of last quarter (Day 22 DISTINCT ON). */
/* Q72. Versioned segment rules (v1 vs v2); count divergence. */
/* Q73. RFM x cohort retention join: do high-R customers have higher Month-3 retention? */
/* Q74. RFM x region anomaly (Day 22 baseline + segment). */
/* Q75. Reconciliation: customers across segments sum = total customers. */

/* ============================================================
   SECTION D: FUNNELS + GROWTH ATTRIBUTION (25)
   ------------------------------------------------------------ */
/* Q76. 4-step funnel: product -> cart -> checkout -> ordered (distinct customers). */
/* Q77. Session-level funnel via session_id (per session reach). */
/* Q78. Drop-off per step (% lost). */
/* Q79. Time-between-steps median/P95 (Day 22 + Day 23). */
/* Q80. Funnel per device per month (Day 21 + Day 23). */
/* Q81. Funnel per region per cohort. */
/* Q82. Conversion rate per device per month. */
/* Q83. PoP funnel: this month vs last month per device. */
/* Q84. PoP funnel: same month last year (YoY). */
/* Q85. Revenue PoP per region: MoM, YoY, QoQ in one pivot (Day 21+23). */
/* Q86. Growth decomposition per month: new / returning / reactivated revenue. */
/* Q87. Active-customer decomposition per month. */
/* Q88. Cohort-level PoP: cohort revenue MoM vs aging. */
/* Q89. Funnel x RFM segment: do Champions convert better at checkout? */
/* Q90. Funnel JSON export (Day 24) with drop-off and time-between-steps. */
/* Q91. CLV per RFM segment with MoM trend. */
/* Q92. Triangle pivot to wide (Day 21) + JSON envelope (Day 24). */
/* Q93. Top movers report: cohorts whose retention shifted > X% (Day 23). */
/* Q94. Plan-check (Day 19) the heaviest funnel; index strategy (Day 20). */
/* Q95. MV candidates (Day 25): funnel per month per device; cohort grid. */
/* Q96. Reconciliation: funnel-ordered customers = orders.distinct cust_id. */
/* Q97. Reconciliation: PoP MoM revenue sum equals monthly_revenue MV (Day 25). */
/* Q98. Cleansed-base (Day 26) -> cohort layer: deduped customers -> cohort sizes. */
/* Q99. Exec dashboard: Month-1 retention per cohort + RFM segment counts + funnel drop-off + MoM revenue per region. */
/* Q100. Capstone: cohort triangle (retention+LTV), RFM segments with named labels, 4-step funnel with drop-off and times, MoM/YoY/QoQ per region, and a JSON exec export - one cohesive set of queries. */
