/* ============================================================
   SQL PRACTICE SET - Data Quality, Deduplication & Cleansing (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Multi-column dedup, NULL-safe joins, regex audits, anomaly thresholds with baselines
   Database:     RetailMart V3

   Scope (MEDIUM = joins + dedup-with-keep-rule + multi-rule scorecards):
     - ROW_NUMBER / DISTINCT ON for "keep the right one" dedup (Day 22)
     - NULL-safe joins via IS DISTINCT FROM; coalesced join keys
     - Regex audits with ~ / ~* / REGEXP_REPLACE for canonicalization
     - Anomaly flags using BASELINE (median, P95, regional benchmark - Day 22)
   NOTE: writes (UPDATE/DELETE) -> accio_NN; here we detect / quarantine via SELECT.

   Structure: 25 Conceptual + 25 Multi-key dedup + 25 Null-safe joins & standardization + 25 Anomaly thresholds with baselines
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Composite dedup keys vs single column - when each is right. */
/* Q2.  Canonicalization-before-dedup: LOWER+TRIM+collapse-spaces, then group. */
/* Q3.  ROW_NUMBER vs DISTINCT ON for "keep most recent" - performance and clarity. */
/* Q4.  Tie-breaking in dedup (always include a deterministic secondary key). */
/* Q5.  NULL-safe equality: IS DISTINCT FROM and its inverse. */
/* Q6.  Coalesced-key join: COALESCE(a.x, '') = COALESCE(b.x, '') tradeoffs. */
/* Q7.  Soft-delete tag vs hard delete in cleansing (DELETE -> accio_NN). */
/* Q8.  Quarantine pattern: invalid rows go to a SELECT result for review. */
/* Q9.  Baseline-driven anomaly: median, P95, IQR fences (Day 22). */
/* Q10. Why a fixed threshold (e.g. > 100k) ages badly; benchmark-relative is robust. */
/* Q11. Regex anchors ^ / $ and why they pin patterns to whole strings. */
/* Q12. Character classes [], quantifiers *, +, ?, {m,n}. */
/* Q13. Greedy vs lazy quantifiers (concept). */
/* Q14. Capture groups + backreferences in REGEXP_REPLACE. */
/* Q15. Unicode pitfalls in TRIM (some "spaces" aren't ASCII). */
/* Q16. Email normalization: lowercase, trim, strip plus-tags (concept). */
/* Q17. Phone normalization: strip non-digits, keep last 10, prefix country. */
/* Q18. Reconciliation across two lists: full-outer join on canonical key (Day 10). */
/* Q19. DQ scorecards: % rules passed per dimension (Day 21 pivot). */
/* Q20. Anomaly per group vs global - why per-group is more honest (Day 22). */
/* Q21. Missing-value clusters: detecting concentrations by time/region. */
/* Q22. Inconsistent labels (e.g. "Maharastra" vs "Maharashtra"). */
/* Q23. Why fixing data at ETL beats fixing at every query. */
/* Q24. When to materialize a "cleaned" view (Day 25 tie-in). */
/* Q25. Day 27 preview: how clean cohorts depend on clean customers/orders. */

/* ============================================================
   SECTION B: MULTI-KEY DEDUP (25)
   ------------------------------------------------------------ */
/* Q26. Dedup customers by LOWER(TRIM(email)); keep latest registration. */
/* Q27. Dedup customers by (LOWER(email), phone); keep most-orders row. */
/* Q28. Dedup products by (brand_id, LOWER(name)); keep highest-revenue. */
/* Q29. Dedup suppliers by LOWER(TRIM(name)); keep most-recently-active. */
/* Q30. Dedup reviews by (customer_id, product_id); keep latest review_date. */
/* Q31. Dedup tickets by (customer_id, subject, created_date::date); keep one per day. */
/* Q32. Dedup orders by (cust_id, order_date, net_total); keep first by order_id. */
/* Q33. Dedup page_views by (customer_id, session_id, page_url) within 1-second window. */
/* Q34. Dedup addresses by (customer_id, LOWER(TRIM(address_line1))); keep latest. */
/* Q35. Dedup inventory_snapshots by composite PK (warehouse, prod, date). */
/* Q36. Dedup brand names by canonical LOWER+TRIM+collapse-spaces. */
/* Q37. Use DISTINCT ON (Day 22) to keep one row per canonical email. */
/* Q38. Rank duplicates by quality score (orders, recency) and keep best. */
/* Q39. List the "loser" rows in a dedup (rn > 1) for review. */
/* Q40. Reconcile dedup result counts vs raw count per group. */
/* Q41. Detect customers with same (first_name, last_name, date_of_first_order). */
/* Q42. Detect products with same (brand_id, name, supplier_id) - supplier-level dupes. */
/* Q43. Detect employee records with same (LOWER(email)) across stores. */
/* Q44. Detect stores with same (city, LOWER(TRIM(name))) - sister stores. */
/* Q45. Cohort-safe dedup: keep first signup per email (Day 27 prep). */
/* Q46. Per-month dedup: only allow one ticket per (customer, subject) per month. */
/* Q47. Dedup keeping highest aggregate (e.g. customer with most spend). */
/* Q48. Cross-table dedup: align customers with addresses on canonical pin/city. */
/* Q49. Two-pass dedup: canonicalize -> dedup -> verify counts equal expected. */
/* Q50. Build "v_customers_dedup" candidate (SELECT-only; Day 25 view in your accio_NN). */

/* ============================================================
   SECTION C: NULL-SAFE JOINS & STANDARDIZATION (25)
   ------------------------------------------------------------ */
/* Q51. NULL-safe match: a.x IS NOT DISTINCT FROM b.x in a JOIN ON. */
/* Q52. Coalesced join key: COALESCE(a.email,'') = COALESCE(b.email,''). */
/* Q53. Anti-join with IS DISTINCT FROM for unmatched rows. */
/* Q54. Replace NULL store_id in HQ employees with -1 for grouping (concept). */
/* Q55. Group missing-value clusters: % NULL phone per region per registration year. */
/* Q56. COALESCE chain to backfill a derived city across customers/addresses. */
/* Q57. NULLIF to neutralize sentinel '' before joining. */
/* Q58. Standardize and re-join: LOWER+TRIM email both sides, then anti-join. */
/* Q59. Detect mismatches that disappear after canonicalization (rule report). */
/* Q60. Use REGEXP_REPLACE to canonicalize brand names, then group. */
/* Q61. Normalize phone to last-10 digits, then dedup. */
/* Q62. Identify free-text categorical drift (e.g. "Critical " vs "Critical"). */
/* Q63. Compute "after vs before" cleansing row counts (audit log). */
/* Q64. Find pairs of rows that match only after canonicalization (reconciliation). */
/* Q65. Build a cleaned customer set: COALESCE+TRIM+LOWER on email, phone, name. */
/* Q66. Build a cleaned product set: TRIM+collapse-spaces on name. */
/* Q67. Build a cleaned address set: standardized city/pincode (LOWER+regex). */
/* Q68. Per region: missing-value heatmap by column (Day 21 pivot of NULL %). */
/* Q69. Detect "near-empty" strings: TRIM length 0 (treat as NULL). */
/* Q70. Detect "all caps" or "all lower" rows (likely raw imports). */
/* Q71. Detect mixed digit/letter junk in name fields. */
/* Q72. Detect emails with disallowed characters via regex. */
/* Q73. Detect addresses missing pincode digits via regex (~ '^\d{6}$'). */
/* Q74. Compose a "cleaned customer" derived row in a SELECT (Day 25 view prep). */
/* Q75. Quarantine view (SELECT-only): rows failing any standardization rule. */

/* ============================================================
   SECTION D: ANOMALY THRESHOLDS WITH BASELINES (25)
   ------------------------------------------------------------ */
/* Q76. Flag orders with net_total > regional P95 (Day 22 baseline). */
/* Q77. Flag products with margin % below category median. */
/* Q78. Flag price-change events with ratio |new-old|/old > 0.5 (record_changes). */
/* Q79. Flag salary changes > 30% in record_changes. */
/* Q80. Flag tickets with resolution time > priority P95 (Day 22). */
/* Q81. Flag stores whose monthly revenue dropped > 50% vs last month (Day 23). */
/* Q82. Flag page_views per customer above NTILE-99 of session lengths (Day 16). */
/* Q83. Flag reviews whose rating is > 2 std devs from product mean (concept). */
/* Q84. Flag pay_slip net outside [department-P5, department-P95]. */
/* Q85. Flag inventory snapshots with qty > 5x the warehouse median. */
/* Q86. Flag ad spend per platform > P95 (Day 22 baseline). */
/* Q87. Detect orders without payments (consistency anti-join). */
/* Q88. Detect deliveries with shipped_date AFTER delivered_date. */
/* Q89. Detect tickets whose customer was registered AFTER ticket creation. */
/* Q90. Detect orders whose customer doesn't exist (orphan FK) - should be empty. */
/* Q91. Reconcile finance.payments vs sales.payments per order. */
/* Q92. Reconcile order_items SUM vs orders.net_total per order. */
/* Q93. Reconcile inventory snapshots vs sales activity (concept). */
/* Q94. DQ scorecard: per rule total + failure count (Day 21 pivot). */
/* Q95. DQ scorecard per region (Day 21 multi-dim pivot). */
/* Q96. DQ trend over time (Day 23 monthly): % rules failed per month. */
/* Q97. Cleansed-derived MV (Day 25 preview): a cleaned customers view. */
/* Q98. Cleansed-derived MV: a cleaned products view (TRIM name, canonical brand). */
/* Q99. Per region anomaly count per rule (Day 21 pivot + Day 22 baselines). */
/* Q100. End-to-end audit: scorecard + quarantine sample for one BIG table (orders). */
