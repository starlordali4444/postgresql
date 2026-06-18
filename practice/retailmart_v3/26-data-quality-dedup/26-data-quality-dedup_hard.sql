/* ============================================================
   SQL PRACTICE SET - Data Quality, Deduplication & Cleansing (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Fuzzy dedup, canonical-key strategy, anomaly engines, reconciliation pipelines
   Database:     RetailMart V3

   Scope (HARD = interview-grade, performance-aware, multi-step):
     - Multi-field dedup with weighted keep-rules; soft-key matching via canonicalization
     - Anomaly engines using percentile baselines (22), period-over-period (23), pivots (21)
     - Reconciliation pipelines between facts (orders <-> payments <-> shipments <-> returns)
     - Cleansed-data delivery via views/MVs (25); JSON quarantine payloads (24) optional
   NOTE: writes (UPDATE/DELETE) -> accio_NN. Detection / quarantine / views / MVs are
     read-only on the live data here (views/MVs allowed on the right day, Day 25).

   Structure: 25 Conceptual + 25 Dedup engines + 25 Anomaly engines + 25 Reconciliation & DQ delivery
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Canonical-key strategy: deterministic transforms (case, trim, collapse, strip). */
/* Q2.  Soft / fuzzy match: same-canonical-key but different verbatim (reconcile). */
/* Q3.  Keep-rule design: most-recent vs most-active vs highest-quality-score. */
/* Q4.  Tie-breakers as part of the dedup contract (always deterministic). */
/* Q5.  Quarantine pattern: invalid rows go to a side-channel SELECT for review. */
/* Q6.  Percentile-baseline anomalies vs static thresholds (Day 22). */
/* Q7.  Period-over-period drift detection (Day 23 + LAG, Day 18). */
/* Q8.  Reconciliation contracts between facts (orders<->payments<->shipments). */
/* Q9.  DQ scorecards: per rule, per dimension (region/month) pivot (Day 21). */
/* Q10. Materialized cleansed layer (Day 25) - refresh cadence and SLA. */
/* Q11. Composite-key dedup at scale: index strategy (Day 20). */
/* Q12. EXPLAIN ANALYZE (Day 19) dedup queries - sort vs hash plan. */
/* Q13. JSON quarantine payload (Day 24) for failed rows. */
/* Q14. Free-text classification: regex pre-screen + manual review. */
/* Q15. Anomaly batching: per-region thresholds prevent false positives. */
/* Q16. Multi-rule DQ engine: rule registry + per-rule pass/fail counts. */
/* Q17. Data-contract enforcement: upstream vs downstream responsibilities. */
/* Q18. NULL strategies at scale: don't COALESCE silently in DQ checks. */
/* Q19. Reproducible cleansing: deterministic, idempotent transforms. */
/* Q20. Auditing the auditor: tests for the DQ engine itself. */
/* Q21. False-positive control: outliers vs anomalies (Day 22 IQR vs P99). */
/* Q22. Reconciliation drift over time (Day 23) - when contracts break. */
/* Q23. Cleansed MV (Day 25) consumers + deprecation of old-name views. */
/* Q24. DQ for cohort analytics (Day 27 preview): why clean facts matter. */
/* Q25. Sunset criteria: when is a rule no longer needed. */

/* ============================================================
   SECTION B: DEDUP ENGINES (25)
   ------------------------------------------------------------ */
/* Q26. Customer canonical-key dedup engine: LOWER(TRIM(email)) primary, phone tiebreak. */
/* Q27. Keep-best customer: most orders -> highest revenue -> most-recent registration. */
/* Q28. Product dedup engine: (brand_id, LOWER(TRIM(name))), keep top-revenue. */
/* Q29. Supplier dedup engine: canonical name; keep most-recent activity. */
/* Q30. Review dedup engine: (customer_id, product_id), keep latest by review_date. */
/* Q31. Order dedup engine: (cust_id, order_date, net_total), keep min(order_id). */
/* Q32. Session dedup engine: (customer_id, session_id, page_url), keep within 2s window. */
/* Q33. Address dedup engine: (customer_id, LOWER(TRIM(line1, city, pincode))), keep latest. */
/* Q34. Ticket dedup engine: same (customer, subject) within 24h, keep first. */
/* Q35. Pay-slip dedup engine: (employee_id, salary_month, salary_year), keep one. */
/* Q36. Inventory snapshot dedup engine: composite PK, keep most-recent updated_at (concept). */
/* Q37. Brand canonical name engine: LOWER+TRIM+collapse-spaces; dedup. */
/* Q38. DISTINCT ON (Day 22) variant of the customer engine; compare results. */
/* Q39. Loser-rows engine: rn > 1 with reason and proposed action. */
/* Q40. Reconcile dedup outputs across two engine variants (ROW_NUMBER vs DISTINCT ON). */
/* Q41. Multi-canonical engine: try multiple canonical keys, score similarity. */
/* Q42. Sister-row detection: (city, LOWER(TRIM(name))) for stores. */
/* Q43. Employee email dedup across stores; preserve primary store. */
/* Q44. Dedup with weighted keep rule (e.g. score = orders*2 + reviews). */
/* Q45. Cohort-safe dedup (Day 27 prep): one signup per email forever. */
/* Q46. Round-trip safety: assert dedup_count + losers = total. */
/* Q47. Idempotent dedup query (rerun gives same result). */
/* Q48. Plan inspection (Day 19) on the customer dedup; index design (Day 20). */
/* Q49. Cleansed view (Day 25) for the customer engine - SELECT-only here. */
/* Q50. JSON quarantine (Day 24) payload of loser rows with dup-group id. */

/* ============================================================
   SECTION C: ANOMALY ENGINES (25)
   ------------------------------------------------------------ */
/* Q51. Region-baselined order-value anomaly engine (Day 22 P95/P99). */
/* Q52. IQR-fence outlier engine per region (Day 22). */
/* Q53. Period-over-period drift engine: revenue change > 50% MoM per region (Day 23). */
/* Q54. Price-change engine: > 50% jump in record_changes (joined to products). */
/* Q55. Salary-change engine: > 30% jump in record_changes. */
/* Q56. SLA-breach engine: resolution > priority P95 (Day 22). */
/* Q57. Delivery-anomaly engine: per region delivery_days > P95 (Day 22+23). */
/* Q58. Inventory-spike engine: snapshot qty > 5x warehouse median. */
/* Q59. Ad-spend anomaly engine: daily spend > platform P95. */
/* Q60. Review-rating anomaly: rating > 2 stddev from product mean (concept). */
/* Q61. Session-length anomaly per device (Day 22 NTILE 99). */
/* Q62. Order-without-payment anti-join (Day 9) over a period. */
/* Q63. Shipment timeline anomaly (shipped after delivered). */
/* Q64. Ticket-before-registration anomaly (impossible per business rule). */
/* Q65. Multi-rule anomaly engine: union all rule results with rule_id + severity. */
/* Q66. Anomaly trend (Day 23): % rows failing each rule per month. */
/* Q67. Per-region anomaly pivot (Day 21) of rule-fail counts. */
/* Q68. Top-K anomalies per region by severity. */
/* Q69. JSON anomaly payload (Day 24) for downstream alerting. */
/* Q70. Suppress repeat anomalies: dedup alerts per entity per day. */
/* Q71. Anomaly burn rate: rolling-7-day rate (Day 23 + window). */
/* Q72. Tier-aware anomaly: Gold/Platinum exempt from low-spend flags. */
/* Q73. Cleansed-base anomaly: run engine over cleansed view (Day 25). */
/* Q74. Plan inspection (Day 19) on the heaviest anomaly query; index hints (Day 20). */
/* Q75. SLA: every rule produces a known-good empty-result on clean data (audit-pass). */

/* ============================================================
   SECTION D: RECONCILIATION & DQ DELIVERY (25)
   ------------------------------------------------------------ */
/* Q76. Reconcile order_items SUM vs orders.net_total per order; mismatch report. */
/* Q77. Reconcile finance.payments vs sales.payments per order. */
/* Q78. Reconcile shipments vs orders (every Delivered has a shipment). */
/* Q79. Reconcile returns vs orders + refunds: refund_amount <= net_total. */
/* Q80. Reconcile inventory delta vs sales movement per warehouse (concept). */
/* Q81. Reconcile attendance vs pay_slip months (Day 23 join). */
/* Q82. Reconcile customers vs addresses (every customer has >=1 address). */
/* Q83. Reconcile customers vs orders consistency (registration_date <= first order). */
/* Q84. Reconcile reviews vs orders consistency (review_date >= order_date). */
/* Q85. Reconcile tickets vs customers consistency (ticket_date >= registration). */
/* Q86. Per region reconciliation scorecard (Day 21 pivot). */
/* Q87. Per month reconciliation drift (Day 23). */
/* Q88. Cleansed customer MV (Day 25) + dedup contract. */
/* Q89. Cleansed product MV (Day 25) + canonical-brand contract. */
/* Q90. Quarantine MV: row + rule_id + first_seen for review (Day 25). */
/* Q91. JSON DQ-scorecard export (Day 24) for the BI layer. */
/* Q92. Cohort-readiness check (Day 27 prep): customers usable for cohort analysis. */
/* Q93. RFM-readiness check (Day 27 prep): clean recency/frequency/monetary inputs. */
/* Q94. Funnel-readiness check (Day 27 prep): web_events sessions intact. */
/* Q95. Anomaly digest export to JSON (Day 24) for alerting. */
/* Q96. Multi-rule scorecard with weights and overall DQ score per table. */
/* Q97. Cleansed analytics layer (Day 25): orders/customers/products as cleaned views. */
/* Q98. Repeatable cleansing script (deterministic, idempotent SELECTs). */
/* Q99. Plan-checked DQ engine (Day 19) over 150k orders - index check (Day 20). */
/* Q100. Capstone: a multi-rule DQ scorecard (per table, per region, per month) + quarantine SELECTs + JSON export, all running off the cleansed view layer. */
