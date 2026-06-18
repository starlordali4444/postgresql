/* ============================================================
   SQL PRACTICE SET - Date/Time Mastery for Time-Series (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Bucketing & aggregation, calendar spines, gap-fill, timezones, trends
   Database:     RetailMart V3

   Scope (MEDIUM = joins + spines + multi-fact reshaping):
     - Month/quarter/ISO-week/fiscal bucketing across joins
     - Calendar spines (generate_series) to guarantee complete, zero-filled series
     - Timezone conversion to IST, intervals, MoM/YoY with LAG (Day 18), pivots (Day 21)
   NOTE: hour/sub-day analysis uses real TIMESTAMP columns only; CREATE-TABLE
     dimensions -> accio_NN; live queries SELECT from generate_series.

   Structure: 25 Conceptual + 25 Bucketing & aggregation + 25 Spines & gap-fill + 25 Timezones/intervals/trends
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why prefer date_trunc over to_char for grouping (returns a date, sorts right)? */
/* Q2.  Pitfall of grouping by to_char(d,'Month') (alphabetical sort) - and the fix. */
/* Q3.  Why gap-fill with a generated calendar instead of trusting present rows? */
/* Q4.  LEFT JOIN calendar -> fact: which side drives, and why COALESCE(...,0)? */
/* Q5.  ISO week vs calendar week - when the year-week label matters. */
/* Q6.  Why can EXTRACT(week) differ from to_char('IW') at year boundaries? */
/* Q7.  Fiscal year: shifting months by an offset to start in April. */
/* Q8.  Timezone: storing UTC, displaying IST - the two AT TIME ZONE steps explained. */
/* Q9.  Difference: ts AT TIME ZONE 'UTC' vs ts AT TIME ZONE 'Asia/Kolkata'. */
/* Q10. Why DATE columns cannot answer "peak hour" questions. */
/* Q11. Interval ambiguity: INTERVAL '1 month' vs '30 days'. */
/* Q12. generate_series with timestamps and an interval step. */
/* Q13. Building arbitrary-width buckets (15-min, 4-hour) via epoch math. */
/* Q14. Why a date-dimension table speeds up repeated reporting (Day 20 indexing). */
/* Q15. One calendar spine, many facts: the multi-LEFT-JOIN pattern. */
/* Q16. Detecting activity gaps/islands (consecutive-day runs) - the idea. */
/* Q17. Rolling windows: RANGE vs ROWS frames over time (Day 17). */
/* Q18. Why a 7-day moving average needs a gap-filled daily series first. */
/* Q19. Cohort timelines: how to anchor "day 0" per customer. */
/* Q20. Computing "days since previous order" with LAG (Day 18). */
/* Q21. Month boundaries: date_trunc('month') + interval to reach month-end. */
/* Q22. Handling DST / ambiguous local times (concept; note IST has no DST). */
/* Q23. Why age() can surprise across months of different lengths. */
/* Q24. Controlling the week anchor: ISO Monday-start vs Sunday-start. */
/* Q25. When to precompute a time-series in a materialized view (Day 25 preview). */

/* ============================================================
   SECTION B: BUCKETING & AGGREGATION (25)
   ------------------------------------------------------------ */
/* Q26. Monthly revenue, order count, and AOV for 2025. */
/* Q27. Quarterly revenue per region (date_trunc + join). */
/* Q28. Weekly order counts per store (ISO week). */
/* Q29. Day-of-week x store revenue matrix (pivot, Day 21). */
/* Q30. Hour-of-day page_view counts per device type. */
/* Q31. Monthly new vs returning customer counts. */
/* Q32. Revenue per fiscal quarter (April-start fiscal year). */
/* Q33. Month-name-labelled revenue ordered by month number. */
/* Q34. Orders per ISO week handling the 2025-12 / 2026-01 boundary correctly. */
/* Q35. Per region: monthly revenue for 2025 as a tidy long table. */
/* Q36. Average delivery days per month (trend). */
/* Q37. Tickets opened per weekday x priority (pivot). */
/* Q38. Per hour-of-day: call volume and median call duration (Day 22). */
/* Q39. Registrations per month with a cumulative running total (Day 17). */
/* Q40. Daily revenue with a 7-day moving average (gap-filled series + window). */
/* Q41. Monthly refund totals and refund rate. */
/* Q42. Page_views per 15-minute slot; busiest 10 slots. */
/* Q43. Revenue by half-year per region. */
/* Q44. Orders per month split into weekday vs weekend (FILTER, Day 21). */
/* Q45. Per category: monthly units sold for 2025 (pivot by month). */
/* Q46. Average basket size per quarter. */
/* Q47. Median order value per month per region (Day 22). */
/* Q48. Ad spend vs revenue per month (two facts on one month spine). */
/* Q49. Seasonality: average revenue per calendar month across all years. */
/* Q50. Year-over-year monthly revenue (same month, prior year) with LAG. */

/* ============================================================
   SECTION C: GENERATE_SERIES, SPINES & GAP-FILL (25)
   ------------------------------------------------------------ */
/* Q51. Build a 2024-2026 daily spine with dow, iso_week, month, quarter, is_weekend. */
/* Q52. Complete daily revenue for the last 90 days (zero-filled) - the lab. */
/* Q53. Per store: complete daily order counts for one month (spine x stores, zero-fill). */
/* Q54. Weekly revenue for 2025, every ISO week present even if zero. */
/* Q55. Monthly revenue per region with every region x month present (cross join). */
/* Q56. Hour-of-day spine (0..23) x device, zero-filled page_view counts. */
/* Q57. Gap-fill a sparse weekly metric and compute WoW change (LAG). */
/* Q58. First-30-days cohort timeline per customer (registration + series 0..29). */
/* Q59. Daily active customers for 90 days (zero-filled) with 7-day moving avg. */
/* Q60. Calendar spine joined to orders AND returns AND payments (multi-fact). */
/* Q61. Generate a quarter spine 2024-2026 and LEFT JOIN revenue. */
/* Q62. New-customer daily series with a cumulative running total. */
/* Q63. 15-minute spine across a day; join page_views; find the peak slot per device. */
/* Q64. Per region daily revenue spine for a month; flag zero-revenue days. */
/* Q65. Monthly spine with revenue and zero-safe MoM growth %. */
/* Q66. Build a fiscal-calendar spine (fiscal_year, fiscal_quarter) 2024-2026. */
/* Q67. Cohort retention spine: months-since-registration 0..11 per cohort. */
/* Q68. Generate week-start dates for 2025 and bucket orders into them. */
/* Q69. Daily refund totals zero-filled with a 14-day moving average. */
/* Q70. Detect days with zero orders per store (via spine anti-join). */
/* Q71. Per customer: a 12-month activity timeline from their first order. */
/* Q72. Build an hour x weekday heatmap spine and fill page_view counts. */
/* Q73. Generate a 2020-2030 date dimension with fiscal_quarter and week_num. */
/* Q74. Calendar spine to compute "active days in month" per store. */
/* Q75. Gap-and-island: longest run of consecutive days a store had orders. */

/* ============================================================
   SECTION D: TIMEZONES, INTERVALS & TIME-SERIES (25)
   ------------------------------------------------------------ */
/* Q76. Convert all page_view timestamps to IST and bucket by hour. */
/* Q77. Peak shopping hour overall and per device (IST). */
/* Q78. Calls per IST hour with median duration per hour (Day 22). */
/* Q79. Time-to-ship and time-to-deliver intervals per order, averaged per region. */
/* Q80. % of orders delivered within SLA (<=3 days) per month. */
/* Q81. % of tickets resolved within 24h per priority per month. */
/* Q82. Customer tenure buckets (age) cross-tabbed with tier. */
/* Q83. Days-between-orders per customer (LAG) and its monthly trend. */
/* Q84. MoM and YoY revenue growth per region (two LAGs). */
/* Q85. Rolling 28-day revenue per region (window RANGE frame). */
/* Q86. Inter-arrival time of page_views per session (LAG on timestamp). */
/* Q87. Median delivery interval per region per quarter (Day 22 + date). */
/* Q88. Revenue per ISO week with year-week label, correct across 2025/2026. */
/* Q89. Busiest 15-minute window of the week (weekday x slot). */
/* Q90. First-purchase latency: days from registration to first order, distribution. */
/* Q91. Monthly cohort sizes and their month-1 retention. */
/* Q92. Hour-of-day revenue proxy via page_views->orders timing (concept + join). */
/* Q93. Time-bucketed funnel: events per stage per hour (web_events). */
/* Q94. Daily revenue anomalies: days beyond P95 of the daily distribution (Day 22). */
/* Q95. Seasonal index: each month's revenue / its yearly average. */
/* Q96. Latest activity timestamp per customer across orders + views (GREATEST/DISTINCT ON). */
/* Q97. Rolling 7-day active-customer count (gap-filled + window). */
/* Q98. Month-end vs month-start revenue (date_trunc boundaries). */
/* Q99. Per region monthly revenue pivot (region x month) with MoM in cells. */
/* Q100. Exec time-series dashboard: monthly orders, revenue, AOV, MoM%, YoY% for 2025. */
