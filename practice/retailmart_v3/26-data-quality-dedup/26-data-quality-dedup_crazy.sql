/* ============================================================
   SQL PRACTICE SET - Data Quality, Deduplication & Cleansing (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Staff-level DQ platforms, dedup-at-scale, anomaly+reconciliation engines, data contracts
   Database:     RetailMart V3

   Scope (CRAZY = staff-engineer / system-design / production patterns):
     - Multi-canonical-key dedup with weighted keep-rules and audit logs
     - Anomaly engines with baselines (Day 22 percentiles, Day 23 PoP) and severity scoring
     - Reconciliation pipelines across the order/payment/shipment/return graph
     - Cleansed semantic layer delivery via views/MVs (25); JSON quarantine + scorecard (24)
   NOTE: writes (UPDATE/DELETE/ALTER) -> accio_NN. Detection / quarantine / cleansed
     views & MVs on RetailMart live data (Day 25 permission applies for VIEW/MV/INDEX).
     Day 27 (cohort/RFM/funnel) appears only as readiness checks (preview).

   Structure: 25 Conceptual + 25 Dedup platforms + 25 Anomaly + reconciliation engines + 25 Production DQ delivery
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Architect a DQ platform: rule registry -> engines -> scorecards -> quarantine -> exports. */
/* Q2.  Multi-canonical-key strategy: try keys in priority; merge candidate groups. */
/* Q3.  Weighted keep-rules: composing scores (orders, recency, completeness). */
/* Q4.  Idempotent / deterministic dedup contract under reruns. */
/* Q5.  Anomaly severity scoring: distance from baseline x business weight. */
/* Q6.  Reconciliation as contracts between fact tables (orders<->payments<->...). */
/* Q7.  DQ SLAs: % rows passing per rule, freshness, time-to-detect, time-to-fix. */
/* Q8.  Quarantine lifecycle: detect -> triage -> fix -> reconcile -> close. */
/* Q9.  Cleansed semantic layer (Day 25) as the contract surface for downstream. */
/* Q10. JSON export contract (Day 24) for alerting and BI consumers. */
/* Q11. False-positive control via per-group baselines (Day 22) and seasonality (Day 23). */
/* Q12. Drift detection: rule pass-rate trend (Day 23 + window 16-18). */
/* Q13. Multi-tenant DQ: per-region baselines and isolation. */
/* Q14. Dedup performance: indexes (Day 20), sort vs hash plans (Day 19). */
/* Q15. Audit trail: capture before/after for every cleansing transform. */
/* Q16. Replay-safe pipelines: cleanse -> reconcile -> publish; rerunnable. */
/* Q17. Documentation as data: rule owner, severity, runbook in MV comments. */
/* Q18. Versioning rules and cleansing transforms; deprecation window. */
/* Q19. Data lineage: which downstream view depends on which cleansed source. */
/* Q20. Day 27 readiness: cohort/RFM/funnel demand pristine inputs - define checks. */
/* Q21. JSON quarantine envelope (Day 24): {rule_id, row, reason, severity, ts}. */
/* Q22. Anti-pattern: implicit COALESCE that hides DQ issues. */
/* Q23. Anti-pattern: dedup without a tie-breaker (non-determinism). */
/* Q24. Anti-pattern: thresholds without baselines (false positives). */
/* Q25. Sunset criteria for a rule (zero hits over N periods). */

/* ============================================================
   SECTION B: DEDUP PLATFORMS (25)
   ------------------------------------------------------------ */
/* Q26. Customer dedup platform: canonical(email,phone) primary + name fallback + score-based keep. */
/* Q27. Product dedup platform: canonical(brand,name) + supplier scoring + revenue tiebreak. */
/* Q28. Supplier dedup platform: canonical(name) + last-active fallback + multi-canonical merge. */
/* Q29. Reviews dedup platform: per (customer, product) keep latest + audit losers. */
/* Q30. Order dedup platform: per (cust, day, amount) detect double-submit + correlate payments. */
/* Q31. Session dedup platform: collapse near-duplicate page_views in 2s window. */
/* Q32. Address dedup platform: canonical(line1, city, pincode) + most-recent activity. */
/* Q33. Ticket dedup platform: per (customer, subject, day) keep first + audit reopens. */
/* Q34. Pay-slip dedup platform: per (employee, period) keep one + reconcile to attendance. */
/* Q35. Inventory snapshot dedup platform: composite PK + most-recent updated_at concept. */
/* Q36. Brand canonical-name platform: LOWER+TRIM+collapse + cross-supplier reconcile. */
/* Q37. Loser-row audit log: rule_id + reason + suggested action. */
/* Q38. Round-trip safety: kept + losers = total per group; assertion query. */
/* Q39. Multi-canonical merge: agglomerate candidate groups across two keys. */
/* Q40. Score-based keep with explainability column (why this row won). */
/* Q41. Plan inspection (Day 19) on platform queries; covering indexes (Day 20). */
/* Q42. CONCURRENTLY-refresh cleansed MV (Day 25) backed by the dedup platform. */
/* Q43. Versioned cleansed MV (vN) for safe rollout. */
/* Q44. JSON quarantine payload export (Day 24): {row, dup_group_id, kept_row_id, reasons[]}. */
/* Q45. Soft-merge contract: keep id, but tag duplicates for downstream join steering. */
/* Q46. Cross-table propagation: if a customer is deduped, orders carry the kept_id. */
/* Q47. Cohort-safe dedup (Day 27 prep): cohort uses canonical first signup. */
/* Q48. Idempotent platform run: rerun gives identical row set; test it. */
/* Q49. Per-region dedup KPIs: % rows kept, % merged, top reasons. */
/* Q50. End-to-end dedup pipeline: detect -> audit log -> cleansed MV -> JSON export. */

/* ============================================================
   SECTION C: ANOMALY + RECONCILIATION ENGINES (25)
   ------------------------------------------------------------ */
/* Q51. Anomaly engine: per region per metric P50/P95/P99 baselines (Day 22) + severity. */
/* Q52. PoP drift engine: revenue MoM/YoY > threshold (Day 23 + window). */
/* Q53. Price-change engine: > 50% jumps + actor + table + before/after. */
/* Q54. Salary-change engine: > 30% jumps + dept context + before/after. */
/* Q55. SLA-breach engine: resolution > priority P95 + breach count + trend. */
/* Q56. Delivery-anomaly engine: per region delivery_days > P95, week-over-week. */
/* Q57. Inventory-spike engine: > 5x warehouse median + rolling check. */
/* Q58. Ad-spend anomaly engine: daily > platform P95 with rolling baseline. */
/* Q59. Review-rating outlier engine: rating > 2sigma from product mean. */
/* Q60. Session anomaly engine: per device NTILE-99 (Day 16). */
/* Q61. Multi-rule anomaly engine: rule registry table (SELECT-only) + union per-rule outputs. */
/* Q62. Severity scoring engine: distance from baseline x business weight. */
/* Q63. Anomaly burn-rate engine: rolling-7d rate (Day 23 + window). */
/* Q64. Reconciliation engine: order_items SUM = orders.net_total per order. */
/* Q65. Reconciliation engine: finance.payments = sales.payments per order. */
/* Q66. Reconciliation engine: shipments coverage for Delivered orders. */
/* Q67. Reconciliation engine: returns refund_amount <= net_total per order. */
/* Q68. Reconciliation engine: attendance <-> pay_slip month parity. */
/* Q69. Reconciliation engine: addresses <-> customers parity. */
/* Q70. Per-region scorecard (Day 21 pivot) of anomaly + reconciliation counts. */
/* Q71. Trend dashboard (Day 23): pass-rate per rule per month with MoM% (window). */
/* Q72. JSON anomaly digest (Day 24) export for alerting. */
/* Q73. JSON reconciliation report (Day 24) export. */
/* Q74. Suppress repeats: dedup alerts per entity per day (Day 22 DISTINCT ON). */
/* Q75. Plan-checked anomaly engine (Day 19) + index design (Day 20). */

/* ============================================================
   SECTION D: PRODUCTION DQ DELIVERY (25)
   ------------------------------------------------------------ */
/* Q76. Semantic cleansed layer (Day 25): v_core_customers, v_core_products, v_core_orders. */
/* Q77. mv_core_customers + UNIQUE INDEX + refresh cadence comment (Day 25). */
/* Q78. mv_core_products + UNIQUE INDEX + canonical-brand contract. */
/* Q79. mv_core_orders + secondary indexes for downstream metrics (Day 20). */
/* Q80. mv_dq_scorecard per table/rule/month + UNIQUE INDEX (table, rule_id, month). */
/* Q81. mv_quarantine per rule + UNIQUE INDEX (rule_id, row_id) (Day 25). */
/* Q82. JSON DQ scorecard export (Day 24) consumed by BI. */
/* Q83. JSON quarantine export (Day 24) consumed by ops. */
/* Q84. Anomaly-digest MV (Day 25): per region top-K anomalies with severity. */
/* Q85. Reconciliation-status MV: latest pass/fail per contract. */
/* Q86. Cohort-readiness MV (Day 27 prep): customers usable for cohort analysis. */
/* Q87. RFM-readiness MV (Day 27 prep): clean recency/frequency/monetary inputs. */
/* Q88. Funnel-readiness MV (Day 27 prep): web_events sessions intact + customer linkage. */
/* Q89. DQ trend MV (Day 23): pass-rate per rule per month. */
/* Q90. Versioned cleansed MV rollout v2; deprecation script. */
/* Q91. Drift alerting MV: rules whose pass-rate fell > X% WoW (Day 23). */
/* Q92. Per region DQ scorecard MV (Day 21 pivot). */
/* Q93. Plan-check (Day 19) the heaviest DQ query; index strategy (Day 20). */
/* Q94. Refresh-DAG for the DQ layer: dedup -> cleansed -> anomaly -> scorecard -> JSON. */
/* Q95. Reconciliation alerts JSON (Day 24) with severity + runbook link. */
/* Q96. Multi-tenant per-region cleansed views (concept). */
/* Q97. Documentation: per MV - owner, rules, refresh, dependents (in COMMENT). */
/* Q98. Day 27 hand-off: list the cleansed inputs cohort/RFM/funnel will consume. */
/* Q99. End-to-end platform: dedup -> cleansed -> anomalies -> reconciliation -> scorecard -> exports. */
/* Q100. Capstone: production DQ platform - rule registry, dedup engine, anomaly engine, reconciliation engine, cleansed MV layer, scorecard MV, JSON exports - with refresh DAG documented. */
