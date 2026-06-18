/* ============================================================
   SQL PRACTICE SET - Cohort, RFM & Funnel Queries (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Cohort triangle + LTV, RFM segments, funnel per cohort/device, PoP growth
   Database:     RetailMart V3

   Scope (MEDIUM = joins + spines + segments):
     - Cohort grid via date spine (Day 23); month-1/3/6 retention; cohort LTV
     - RFM with NTILE (Day 16) + named segments; tier x segment tables
     - Funnel by step with drop-off, sessionized via web_events (customer_id/session_id)
     - PoP MoM/YoY/QoQ per region/cohort (Day 23 + window 16-18)
   NOTE: cohort uses customers.registration_date; period_index in months.
     CLV computed on Delivered orders. Where cleansed inputs help, use the (conceptual)
     Day 26 cleansed layer. MV materialization -> Day 25.

   Structure: 25 Conceptual + 25 Cohort triangle & LTV + 25 RFM segments & drift + 25 Funnels & PoP growth
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Cohort anchor choice: registration_date vs first_order_date - implications. */
/* Q2.  Period grain: monthly vs weekly cohorts; tradeoffs. */
/* Q3.  Why an explicit date spine (Day 23) prevents missing cells. */
/* Q4.  Cohort triangle shape: cells above the diagonal are empty (future). */
/* Q5.  Retention denominator: cohort size at period 0, fixed (not rolling). */
/* Q6.  Retention vs revenue cohorts - different denominators. */
/* Q7.  Cumulative cohort LTV vs per-period LTV. */
/* Q8.  RFM ordering pitfalls: ensure Recency is "smaller-days = higher score". */
/* Q9.  Ties in NTILE: how Postgres distributes ties (Day 16). */
/* Q10. Named RFM segments: Champions, Loyal, At-Risk, Hibernating, etc. */
/* Q11. Segment drift over time: customers moving between segments (Day 23). */
/* Q12. Funnel: customer-level vs session-level - when to choose which. */
/* Q13. Drop-off ratio: between consecutive steps; reporting clarity. */
/* Q14. Funnel per device/channel/region (Day 21 pivot). */
/* Q15. Day 22 percentile of CLV per segment - robust segment value. */
/* Q16. Day 22 DISTINCT ON for "latest order per customer" -> R component. */
/* Q17. Day 23 spine to align cohorts cross-month. */
/* Q18. Day 25 MV strategy: which cohort tables benefit. */
/* Q19. Day 26 cleansed inputs: dedup customers before cohort sizing. */
/* Q20. Reconciliation: cohort sizes sum to total customers (assertion). */
/* Q21. RFM x tier matrix (Day 21) for marketing teams. */
/* Q22. Funnel completeness via spine of steps (Day 23). */
/* Q23. CLV definition choices: gross vs net; included statuses. */
/* Q24. PoP zero-division safety (NULLIF). */
/* Q25. Reporting Month-1 retention as a single trend (Day 23). */

/* ============================================================
   SECTION B: COHORT TRIANGLE & LTV (25)
   ------------------------------------------------------------ */
/* Q26. Per customer signup_month (registration_date -> month). */
/* Q27. Per (customer, order) order_month and period_index (months since signup). */
/* Q28. Cohort sizes (distinct customers) per signup_month. */
/* Q29. Active customers per (signup_month, period_index). */
/* Q30. Retention % per (signup_month, period_index). */
/* Q31. Limit to period_index 0..11 and pivot wide (Day 21). */
/* Q32. Add a date spine (Day 23) to guarantee cells. */
/* Q33. Cohort revenue per (signup_month, period_index). */
/* Q34. Cumulative cohort revenue per period_index (running sum, Day 17). */
/* Q35. Average revenue per active cohort customer per period. */
/* Q36. CLV per cohort: cumulative revenue / cohort size at period 0. */
/* Q37. Best cohorts by Month-3 retention. */
/* Q38. Best cohorts by 12-month cumulative LTV. */
/* Q39. Cohort retention by region (Day 21 pivot). */
/* Q40. Cohort retention by acquisition tier. */
/* Q41. Cohort retention by signup channel proxy (if any) - concept. */
/* Q42. Cohort LTV per region. */
/* Q43. Median spend per active cohort customer per period (Day 22). */
/* Q44. P95 spend per active cohort customer per period (Day 22). */
/* Q45. Triangle: signup_month rows x period 0..11 cols, retention values. */
/* Q46. Triangle: signup_month rows x period 0..11 cols, LTV values. */
/* Q47. Compare 2024 vs 2025 cohorts: Month-1 retention. */
/* Q48. Compare 2024 vs 2025 cohorts: 12-month LTV. */
/* Q49. Reconcile: cohort sizes sum = total customers. */
/* Q50. Save the triangle as a tidy long table (cohort, period, retention, ltv). */

/* ============================================================
   SECTION C: RFM SEGMENTS & DRIFT (25)
   ------------------------------------------------------------ */
/* Q51. Per customer Recency (days since last order). */
/* Q52. Per customer Frequency (order count). */
/* Q53. Per customer Monetary (lifetime revenue). */
/* Q54. Recency score NTILE(5) over -days_since_last_order. */
/* Q55. Frequency score NTILE(5) over order_count. */
/* Q56. Monetary score NTILE(5) over lifetime_revenue. */
/* Q57. Combine to 'RFM' string score and total R+F+M. */
/* Q58. Named segments: Champions, Loyal Customers, Potential Loyalists, New Customers,
                       Promising, Need Attention, About to Sleep, At Risk, Hibernating, Lost. */
/* Q59. Apply name-mapping based on score buckets (CASE). */
/* Q60. Count customers per named segment. */
/* Q61. Median CLV per segment (Day 22). */
/* Q62. P95 CLV per segment. */
/* Q63. Per region: counts per segment (Day 21 pivot). */
/* Q64. Per tier: counts per segment. */
/* Q65. Drift report: segment this quarter vs last quarter (Day 23). */
/* Q66. Promotion candidates: At Risk + high Monetary. */
/* Q67. Reactivation candidates: Hibernating with > 5 historical orders. */
/* Q68. New-customer pipeline: count per registration month (Day 23). */
/* Q69. Average days-since-last-order per segment. */
/* Q70. Average orders per segment. */
/* Q71. Average lifetime revenue per segment. */
/* Q72. RFM x region heatmap (Day 21). */
/* Q73. RFM x tier heatmap. */
/* Q74. Top-N customers per segment (Day 16). */
/* Q75. Reconcile: customers across segments sum = total customers. */

/* ============================================================
   SECTION D: FUNNELS & PERIOD-OVER-PERIOD (25)
   ------------------------------------------------------------ */
/* Q76. 3-step funnel: product -> cart -> checkout (distinct customers). */
/* Q77. 4-step funnel: product -> cart -> checkout -> ordered. */
/* Q78. Drop-off % per step. */
/* Q79. Session funnel via session_id (per session reach). */
/* Q80. Funnel per device (Day 21 pivot). */
/* Q81. Funnel per month (Day 23 spine). */
/* Q82. Funnel per region (joins via customers->addresses). */
/* Q83. Funnel per registration cohort. */
/* Q84. Funnel + median time-between-steps (Day 22 + Day 23). */
/* Q85. Conversion rate per device per month. */
/* Q86. CLV per cohort x per channel proxy. */
/* Q87. PoP MoM revenue per region (LAG, Day 18). */
/* Q88. PoP YoY revenue per region. */
/* Q89. PoP QoQ revenue per region. */
/* Q90. Active-customer PoP per month per region. */
/* Q91. New-customer PoP per month. */
/* Q92. Reactivated-customer PoP per month. */
/* Q93. Funnel conversion drift: WoW shift (Day 23) per channel. */
/* Q94. CLV per RFM segment with MoM trend. */
/* Q95. Cohort x CLV table for exec dashboard. */
/* Q96. Combined RFM + cohort dashboard per region. */
/* Q97. Funnel JSON export (Day 24) for product team. */
/* Q98. Cohort triangle JSON export (Day 24). */
/* Q99. Reconciliation: cohort revenue total = orders revenue (Delivered only). */
/* Q100. Exec strip: Month-1 retention by cohort, top RFM segments, funnel drop-off, MoM revenue per region. */
