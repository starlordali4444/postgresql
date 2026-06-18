/* ============================================================
   SQL PRACTICE SET - Date/Time Mastery for Time-Series (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Calendar dimensions, gap/island & sessionization, cohort triangles, SLA trends
   Database:     RetailMart V3

   Scope (HARD = interview-grade, performance-aware, multi-step):
     - Reusable date/fiscal dimensions; complete spines + multi-fact gap-fill
     - Gap-and-island, sessionization, as-of joins; rolling/moving windows (Day 17)
     - MoM/YoY/QoQ, cohort triangles, median/P95 SLA over time (Day 22), pivots (Day 21)
   NOTE: CREATE-TABLE dimensions/MVs -> accio_NN or Day 25; here build spines inline
     with generate_series. Index/plan notes reference Days 19-20 conceptually.

   Structure: 25 Conceptual + 25 Time-series reports + 25 Calendar/gap-fill engines + 25 Production time-series systems
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Designing a reusable date-dimension table: columns, grain, indexing (Day 20). */
/* Q2.  Calendar spine via generate_series vs recursive generation - why the spine wins. */
/* Q3.  Gap-and-island detection: the row_number-difference trick (Day 16). */
/* Q4.  RANGE vs ROWS time frames and their effect on moving aggregates (Day 17). */
/* Q5.  Correct ISO-week-year reporting across the Dec/Jan boundary. */
/* Q6.  Fiscal calendar: generating fiscal_year/quarter/period with a month offset. */
/* Q7.  Timezone correctness: UTC storage, multi-zone reporting, DST awareness. */
/* Q8.  Why "peak hour" needs timestamp columns, and which RetailMart sources qualify. */
/* Q9.  Building N-minute buckets via epoch floor - the generalized formula. */
/* Q10. Cohort analysis foundations: anchor date, period index, triangle shape (Day 27 preview). */
/* Q11. Moving average over a sparse series - why gap-fill must come first. */
/* Q12. Computing MoM / YoY safely with LAG over a complete spine. */
/* Q13. Missing-period growth %: zero vs NULL semantics. */
/* Q14. Detecting activity streaks (consecutive days) and breaks. */
/* Q15. Indexing a timestamp column for range-scan dashboards (Days 19-20). */
/* Q16. Why date_trunc on an indexed column can prevent index use - expression-index fix. */
/* Q17. Sessionization: splitting events into sessions by inactivity gap (LAG). */
/* Q18. Time-weighted metrics (e.g. average inventory over time) - the concept. */
/* Q19. Calendar-heatmap data shape (weekday x hour) and how to build it. */
/* Q20. Backfilling a daily metric idempotently (Day 25/26 preview). */
/* Q21. Median vs mean for delivery-time SLAs over time (Day 22 tie-in). */
/* Q22. Choosing the spine grain (day/week/month) for a given report. */
/* Q23. Pitfalls of EXTRACT(epoch) for interval lengths across DST. */
/* Q24. Why a materialized daily-revenue table helps dashboards (Day 25 preview). */
/* Q25. Designing an "as-of" join against a date spine (point-in-time state). */

/* ============================================================
   SECTION B: TIME-SERIES REPORTS (25)
   ------------------------------------------------------------ */
/* Q26. Complete daily revenue last 90 days + 7-day and 28-day moving averages. */
/* Q27. Per region monthly revenue with MoM% and YoY% (complete spine). */
/* Q28. Gap-and-island: longest consecutive-day ordering streak per store. */
/* Q29. Sessionize page_views (30-min inactivity) and count sessions per customer. */
/* Q30. Daily active customers with 7-day moving average and WoW% (gap-filled). */
/* Q31. ISO-weekly revenue 2024-2026 with correct boundaries, ranked weeks. */
/* Q32. Fiscal-quarter revenue per region (April start) with QoQ growth. */
/* Q33. Hour x weekday revenue-proxy heatmap from page_views (busiest cells). */
/* Q34. Rolling 28-day retention: active in window / base (window RANGE). */
/* Q35. Median + P95 delivery days per month (Day 22) - trend. */
/* Q36. New vs returning revenue split per month (first-order flag). */
/* Q37. Cohort triangle: monthly cohorts x months-since for order counts. */
/* Q38. Peak 15-minute slot per weekday with order/view counts. */
/* Q39. Daily revenue anomalies beyond P95 of the daily distribution (Day 22). */
/* Q40. Seasonal-lite: month index vs trailing-12-month average. */
/* Q41. Time-to-first-order distribution per registration cohort (median, P90). */
/* Q42. Inter-order gap distribution per tier (LAG + percentile). */
/* Q43. Refund rate per ISO week with a 4-week moving average. */
/* Q44. Ticket SLA attainment per priority per month (resolved within target). */
/* Q45. Month-end inventory snapshot value per warehouse over time (latest in month). */
/* Q46. Revenue contribution by hour-of-day (IST) as % of daily total. */
/* Q47. YoY same-week comparison (ISO week) per region. */
/* Q48. Active-days-per-month per customer and its trend. */
/* Q49. Complete store x month revenue matrix (zero-filled) + row/col totals. */
/* Q50. Detect "dormant then reactivated" customers (gap > 90 days then ordered). */

/* ============================================================
   SECTION C: CALENDAR DIMENSIONS & GAP-FILL ENGINES (25)
   ------------------------------------------------------------ */
/* Q51. Build a 2020-2030 date dimension: date, dow, iso_dow, week, iso_week, month, month_name, quarter, fiscal_year, fiscal_quarter, is_weekend, is_month_end. */
/* Q52. Use the dimension to gap-fill daily revenue across all stores. */
/* Q53. Cross-join spine x regions to guarantee complete region x month revenue. */
/* Q54. Cohort spine (cohort_month x period_index 0..11) joined to order facts. */
/* Q55. Fiscal-period spine and revenue per fiscal period with QoQ. */
/* Q56. Hour-of-day x device spine, zero-filled, with median duration per cell (Day 22). */
/* Q57. 15-minute spine for one week; join page_views; rank slots. */
/* Q58. As-of join: for each month-end, the latest inventory snapshot per SKU (Day 22 DISTINCT ON). */
/* Q59. Daily spine with multiple facts (orders, returns, payments) in one wide row. */
/* Q60. Week spine 2024-2026 with WoW and 4-week moving avg for revenue. */
/* Q61. Gap-fill + carry-forward last known value (LOCF) for a sparse metric (window). */
/* Q62. Business-day calendar (exclude weekends) and count business days to deliver. */
/* Q63. Month spine with seasonal index (month / annual mean). */
/* Q64. Streaks: classify each customer's longest active streak via gap-and-island. */
/* Q65. Reactivation spine: months-since-last-order per customer per month. */
/* Q66. Calendar heatmap dataset: weekday x hour counts for page_views. */
/* Q67. Per store: complete daily series + flag zero-revenue and record-high days. */
/* Q68. Fiscal-year-to-date cumulative revenue per region (running sum, Day 17). */
/* Q69. Rolling 12-month revenue (trailing window) per region. */
/* Q70. Date spine to compute customer "age at order" cohorts. */
/* Q71. As-of price: most-recent selling price per product at each month-end (Day 22). */
/* Q72. Spine-driven SLA: % delivered within 3 days per day, 30-day moving average. */
/* Q73. Detect missing daily snapshots per warehouse (expected vs present). */
/* Q74. First/last activity per customer from a unified event spine. */
/* Q75. Reusable "last 90 days" parameterized spine with three KPIs on it. */

/* ============================================================
   SECTION D: PRODUCTION TIME-SERIES SYSTEMS (25)
   ------------------------------------------------------------ */
/* Q76. Daily revenue dashboard: 90-day complete series, 7/28-day MA, MoM%, anomalies (P95). */
/* Q77. Cohort retention matrix (monthly cohorts x 12 periods) with retention %. */
/* Q78. Region growth board: monthly revenue, MoM%, YoY%, rolling-12m, rank. */
/* Q79. Delivery SLA monitor: median/P95 delivery days per month + breach % + trend. */
/* Q80. Sessionization pipeline: sessions per customer, median session length, bounce proxy. */
/* Q81. Peak-hour ops report: busiest 15-min slots per weekday with a staffing hint. */
/* Q82. Support SLA time-series: resolution median/P95 per priority per month + attainment. */
/* Q83. Reactivation funnel: dormant (>90d) -> reactivated counts per month. */
/* Q84. Seasonal index report per category (month / annual mean) for planning. */
/* Q85. Fiscal dashboard: FYTD revenue, QoQ, vs prior-FY same period, per region. */
/* Q86. Inventory-over-time: month-end value per warehouse + days-of-cover trend. */
/* Q87. New vs returning revenue time-series with contribution % per month. */
/* Q88. Anomaly detector: daily revenue beyond regional P95/P99 (Day 22) flagged. */
/* Q89. Heatmap export: weekday x hour activity, normalized per row. */
/* Q90. Pricing time-series: per product as-of monthly price + drift flags. */
/* Q91. Customer lifecycle timeline: registration -> first order -> latest order spans. */
/* Q92. Rolling retention: 28-day active / 28-day-prior base, per region trend. */
/* Q93. Time-to-deliver funnel by stage (order->ship->deliver) median per month. */
/* Q94. Year-week revenue with correct ISO boundaries + YoY same-week. */
/* Q95. Complete store x month revenue matrix with totals + zero-day diagnostics. */
/* Q96. "Morning report": yesterday vs trailing-28-day median per region (as-of). */
/* Q97. Cohort LTV-over-time: cumulative revenue per cohort by month-since. */
/* Q98. Multi-fact daily spine mart (orders/returns/payments/views) for BI. */
/* Q99. Streak & churn board: active streaks, dormancy, reactivation per customer. */
/* Q100. Capstone: a parameterized daily time-series mart (complete spine, MAs, MoM/YoY, anomalies) as one query. */
