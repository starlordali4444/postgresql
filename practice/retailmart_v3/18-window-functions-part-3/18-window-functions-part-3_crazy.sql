/* ============================================================
   SQL PRACTICE SET - Window Functions Part 3: LAG / LEAD (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Staff-level period-over-period systems, retention, anomaly, sessions
   Database:     RetailMart V3

   Scope (CRAZY = staff-engineer LAG/LEAD systems):
     - Multi-offset growth dashboards; cohort/retention inputs
     - Gaps-and-islands at scale; sessionization & funnel timing
     - Anomaly detection blending LAG with moving averages (Day 17)
   (Ranking = Day 16; pure aggregation/frames = Day 17.)

   Structure: 25 Conceptual + 25 Growth/retention systems + 25 Islands/sessions + 25 Dashboards
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Architect a growth dashboard comparing vs 1/3/12 periods in one query. */
/* Q2.  Cohort retention matrix inputs purely via LAG/LEAD + date math. */
/* Q3.  Gaps-and-islands at scale: the (rn - dense group) trick and its cost. */
/* Q4.  Sessionization pipeline: threshold -> flag -> cumulative session id -> aggregate. */
/* Q5.  Anomaly = (value - trailing MA) / trailing stddev; combine Day-17 frame + LAG. */
/* Q6.  Robust MoM on sparse data: date spine + LAG + COALESCE strategy. */
/* Q7.  "Previous non-null" via a running max of (value's row when not null) - pattern. */
/* Q8.  Churn vs reactivation definitions and how LAG/LEAD encode each. */
/* Q9.  Multi-grain period-over-period (SKU/brand/category) without N queries. */
/* Q10. Time-in-state and state-transition matrices from a log via LEAD. */
/* Q11. Why compounded growth needs careful chaining (product of (1+gi)). */
/* Q12. Funnel timing: median time between steps via LEAD + percentile. */
/* Q13. Detect monotonic trends (N consecutive same-sign deltas) generically. */
/* Q14. Reproducible cohort timelines across refreshes (anchor on first activity). */
/* Q15. Sessionization tuning: choosing the gap threshold from the gap distribution. */
/* Q16. Why LAG-based change logs beat trigger-based audit for analytics. */
/* Q17. Period-over-period with mixed calendars (fiscal vs ISO week). */
/* Q18. Detecting seasonality via YoY LAG and de-seasonalizing. */
/* Q19. Combine LAG growth with NTILE to rank fastest/slowest movers. */
/* Q20. Building a "days to next purchase" survival-style table. */
/* Q21. Streak analytics: longest/current/average streak per entity. */
/* Q22. Why sessionization + funnel must share one ordered event stream. */
/* Q23. Anomaly suppression: ignore deltas within +/- of a trailing band. */
/* Q24. Cohort decay curve from retention deltas. */
/* Q25. When to precompute these in an MV (Day 25) vs on-the-fly. */

/* ============================================================
   SECTION B: GROWTH & RETENTION SYSTEMS (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: Build a per-store growth board: MoM %, QoQ %, YoY %, and a trend flag. */
/* Q27. Signup-cohort retention: % of each month's cohort active in months 1-6 (LAG/LEAD + date math). */
/* Q28. Multi-offset compare (1/3/12 months ago) per region in one row. */
/* Q29. Compounded 6-month growth per store (chain of MoM). */
/* Q30. New vs returning revenue MoM growth (split then LAG). */
/* Q31. Fastest-growing brands: latest MoM % then NTILE into growth tiers. */
/* Q32. Retention curve per acquisition channel (first order channel proxy). */
/* Q33. YoY same-month compare per category with seasonality flag. */
/* Q34. Cohort revenue indexed to cohort month 0 = 100. */
/* Q35. MoM contribution shift: category %-of-company change over time. */
/* Q36. Reactivation rate per month (reactivated / churned base). */
/* Q37. Customer lifetime value trajectory: cumulative spend with MoM deltas. */
/* Q38. Detect decelerating stores: 3 consecutive declining MoM %. */
/* Q39. Region revenue YoY with both absolute and % change. */
/* Q40. AOV trend per store: MoM AOV growth with up/down streak. */
/* Q41. Per-cohort "months to second purchase" distribution. */
/* Q42. Growth attribution: which categories drove company MoM change. */
/* Q43. Rolling retention: % active in trailing 30/60/90 days per cohort. */
/* Q44. MoM churn count and reactivation count side by side. */
/* Q45. Top-10 fastest-growing products by YoY units. */
/* Q46. Net revenue retention proxy per cohort (this period / prior period spend). */
/* Q47. Detect first month a store turned profitable then stayed. */
/* Q48. Compounded category growth ranked across the catalog. */
/* Q49. Per-customer spend momentum (recent 3-mo vs prior 3-mo). */
/* Q50. Full growth+retention pack per region-month (8 metrics). */

/* ============================================================
   SECTION C: GAPS-AND-ISLANDS & SESSIONS AT SCALE (25)
   ------------------------------------------------------------ */
/* Q51. SCENARIO: Sessionize all web_events (gap > 30 min) and emit session_id, start, end, duration, views. */
/* Q52. Longest active-month streak per customer across 50k customers. */
/* Q53. Continuous in-stock islands per (warehouse, product) with start/end. */
/* Q54. Consecutive-day order streaks per store with streak length. */
/* Q55. Run-length encode each customer's tier history into intervals. */
/* Q56. Funnel timing: median minutes page->cart->checkout via LEAD per session. */
/* Q57. Identify reactivation islands (active->gap->active) and count per customer. */
/* Q58. Consecutive profitable months per store with longest run. */
/* Q59. Out-of-stock islands and their durations per product. */
/* Q60. Group consecutive same-status order runs and their spans. */
/* Q61. Login streaks per customer (consecutive days) from web_events. */
/* Q62. Price-stability islands per product (no change) with lengths. */
/* Q63. Sessionize calls into bursts (gap > 1h) and average burst size. */
/* Q64. Continuous-growth islands (consecutive positive MoM) per region. */
/* Q65. Time-in-status durations from an order status log (LEAD). */
/* Q66. Longest consecutive 5-star review run per product. */
/* Q67. Per-session funnel completion flag (reached checkout?). */
/* Q68. Streaks of consecutive on-time deliveries per courier. */
/* Q69. Identify the dominant session length band per device. */
/* Q70. Consecutive payroll months per employee (employment continuity). */
/* Q71. Bounce sessions (1 view) vs engaged sessions (>=5 views) per day. */
/* Q72. Reactivation latency distribution (gap length before reactivation). */
/* Q73. Longest winning streak (revenue beats prior day) per store. */
/* Q74. Per-customer cadence islands: stable-frequency vs erratic periods. */
/* Q75. Build a sessions fact table from web_events (one row per session). */

/* ============================================================
   SECTION D: ANOMALY & EXECUTIVE DASHBOARDS (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: Daily revenue anomaly board: value, 7-day MA (Day 17), MoM, z-score, flag. */
/* Q77. Detect days where revenue deviates > 2sigma from trailing 30-day mean. */
/* Q78. Price-change log: every product price change with old/new/%/rank and date. */
/* Q79. Churn dashboard: customer, last_order, days_since, prior_gap, churn_flag. */
/* Q80. Retention heatmap inputs: cohort x month-since with retained %. */
/* Q81. Sessionized funnel dashboard: sessions, cart rate, checkout rate, median step time. */
/* Q82. Store momentum board: MoM %, QoQ %, YoY %, streak, percentile of growth. */
/* Q83. Demand-spike detector: product days where units > 3x trailing-7 average. */
/* Q84. Reactivation dashboard per month: churned, reactivated, net. */
/* Q85. Delivery-degradation alert: courier whose delivery time rose 3 months running. */
/* Q86. Inventory volatility board: stock change deltas and stock-out events per product. */
/* Q87. Customer health trend: spend momentum + recency + churn risk in one row. */
/* Q88. Category growth waterfall MoM (who gained/lost share). */
/* Q89. Agent performance trend: resolved/day MoM with streaks. */
/* Q90. Anomalous orders: value > customer's trailing-mean by large margin. */
/* Q91. Web engagement board: sessions/day, avg duration, MoM growth per device. */
/* Q92. Refund-spike detector per category (MoM refund % jump). */
/* Q93. Seasonality board: YoY same-month index per region. */
/* Q94. Fastest decelerating SKUs (steepest negative YoY units). */
/* Q95. Net-new-customer board with MoM and YoY growth. */
/* Q96. Executive trend pack per region-month: revenue, MoM, YoY, 3-mo MA, anomaly flag. */
/* Q97. First-to-second purchase conversion board per cohort. */
/* Q98. Price-war detector: clusters of frequent price changes per brand. */
/* Q99. Sessionized conversion funnel with drop-off % per step. */
/* Q100. End-to-end exec board: growth + retention + anomaly + churn, per region-month. */

/* ============================================================
   END OF Window Functions Part 3 - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
