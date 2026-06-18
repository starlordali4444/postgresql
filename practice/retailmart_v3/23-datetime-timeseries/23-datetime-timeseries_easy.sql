/* ============================================================
   SQL PRACTICE SET - Date/Time Mastery for Time-Series (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        DATE_TRUNC, EXTRACT, intervals, generate_series, gap-filling, timezones
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - DATE_TRUNC / EXTRACT / to_char for bucketing dates
     - generate_series to build a date spine; LEFT JOIN to gap-fill zeros
     - Interval arithmetic; AT TIME ZONE for UTC->IST; hour-of-day buckets
   NOTE: order_date / shipped_date / delivered_date are DATE (no time-of-day) ->
     hour/minute analysis uses real TIMESTAMP columns (page_views.view_timestamp,
     calls.call_start_time, tickets.created_date). CREATE-TABLE date dimensions
     belong in your own accio_NN DB; live queries SELECT from generate_series.

   Structure: 25 Conceptual + 25 Trunc/Extract/Format + 25 generate_series & gap-fill + 25 Intervals/TZ/buckets
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does DATE_TRUNC('month', d) do? */
/* Q2.  What does EXTRACT(YEAR FROM d) return? */
/* Q3.  Difference between a DATE and a TIMESTAMP in PostgreSQL. */
/* Q4.  Why are order_date / delivered_date stored as DATE (no time) in RetailMart? */
/* Q5.  What does `date - date` return (and in what unit)? */
/* Q6.  What does `date + integer` return? */
/* Q7.  What does an INTERVAL represent, e.g. INTERVAL '7 days'? */
/* Q8.  What does generate_series(a, b, step) produce? */
/* Q9.  How does generate_series build a date dimension (one row per day)? */
/* Q10. What is "gap-filling" and why LEFT JOIN a generated date series? */
/* Q11. What does to_char(d, 'YYYY-MM') produce? */
/* Q12. What does EXTRACT(DOW FROM d) return (which day is 0)? */
/* Q13. Difference between DOW and ISODOW. */
/* Q14. What is an ISO week, and why can it cross a calendar-year boundary? */
/* Q15. What weekday does date_trunc('week', d) anchor to? */
/* Q16. How do you get the first day of a date's month? */
/* Q17. How do you get the last day of a date's month? */
/* Q18. What does age(d1, d2) compute vs plain d1 - d2? */
/* Q19. What do now() and current_date return? */
/* Q20. What does AT TIME ZONE do to a timestamp? */
/* Q21. Why do hour-of-day analyses need a TIMESTAMP, not a DATE column? */
/* Q22. Which RetailMart columns carry real time-of-day (name three)? */
/* Q23. What is a fiscal quarter, and how can it differ from a calendar quarter? */
/* Q24. How do you bucket timestamps into 15-minute slots (concept)? */
/* Q25. What does make_date(y, m, d) build? */

/* ============================================================
   SECTION B: TRUNC / EXTRACT / FORMAT (25)
   ------------------------------------------------------------ */
/* Q26. Orders grouped by month (date_trunc) with counts. */
/* Q27. Orders grouped by year with counts. */
/* Q28. Revenue per calendar quarter (date_trunc('quarter', order_date)). */
/* Q29. Order count per day-of-week name (to_char). */
/* Q30. Order count per month name (to_char 'Month'). */
/* Q31. Year and month as two separate columns from order_date. */
/* Q32. Revenue per week (date_trunc('week')). */
/* Q33. Count of customers registered per year. */
/* Q34. Page_view count per hour-of-day (EXTRACT HOUR from view_timestamp). */
/* Q35. Calls per hour-of-day (call_start_time). */
/* Q36. Tickets opened per month (created_date). */
/* Q37. Orders per quarter for 2025 only. */
/* Q38. Average net_total per month for 2025. */
/* Q39. Revenue by 'YYYY-MM' label (to_char). */
/* Q40. Orders on weekends vs weekdays (DOW filter). */
/* Q41. Order count per ISO week of 2025 (to_char 'IYYY-IW'). */
/* Q42. Earliest and latest order_date in the data. */
/* Q43. Delivery days per order (delivered_date - order_date). */
/* Q44. Orders delivered in 0-2 days vs 3+ days (date-diff buckets). */
/* Q45. Month name of each customer's registration. */
/* Q46. Revenue per half-year (H1/H2) using EXTRACT(month). */
/* Q47. Count of reviews per month. */
/* Q48. Ad spend per month per platform. */
/* Q49. Parse pay-slip period: to_date(salary_month||' '||salary_year,'FMMonth YYYY'). */
/* Q50. Orders per day-of-month (1..31) distribution. */

/* ============================================================
   SECTION C: GENERATE_SERIES & GAP-FILLING (25)
   ------------------------------------------------------------ */
/* Q51. Generate one row per day for January 2025. */
/* Q52. Generate one row per month for all of 2025. */
/* Q53. Generate a 2025 date spine with date, dow name, week_num, month_name. */
/* Q54. Daily order counts for Jan 2025, zero on days with no orders (gap-fill). */
/* Q55. Daily revenue for one month with zeros on missing days. */
/* Q56. Monthly revenue for 2025 with zeros for months that had none. */
/* Q57. Generate the last 90 days ending at max(order_date). */
/* Q58. Complete daily revenue for the last 90 days (one row per day, zero when none). */
/* Q59. Weekly order counts for 2025 with missing weeks shown as zero. */
/* Q60. Generate hours 0..23 and LEFT JOIN page_view counts (zero-fill hours). */
/* Q61. Generate every Monday in 2025. */
/* Q62. Build the 2025 quarter-start dates. */
/* Q63. Generate a date spine with a fiscal_quarter column (April-start concept). */
/* Q64. Gap-fill a sparse weekly metric (a week with no rows shows 0). */
/* Q65. Daily new-customer counts with zero-filled days. */
/* Q66. Per store: daily order counts gap-filled for one month. */
/* Q67. Generate the 12 month-start dates of 2025. */
/* Q68. LEFT JOIN a date series to returns for daily refund totals (zero-filled). */
/* Q69. Generate 15-minute slots across one day (interval '15 min'). */
/* Q70. Generate week numbers 1..52 for labelling. */
/* Q71. Calendar of 2025 with an is_weekend flag. */
/* Q72. Day series marking Indian weekends (Sat/Sun). */
/* Q73. Per day in the last 30: distinct customers ordering (zero-filled). */
/* Q74. Build a "first 30 days" date series from one customer's registration. */
/* Q75. Daily cumulative registrations across 2025 (series + running sum, Day 17). */

/* ============================================================
   SECTION D: INTERVALS, TIMEZONES & BUCKETS (25)
   ------------------------------------------------------------ */
/* Q76. Add 7 days to each order_date (order_date + INTERVAL '7 days'). */
/* Q77. Orders placed in the last 30 days of the data window. */
/* Q78. Customers registered more than 365 days before their first order. */
/* Q79. Convert view_timestamp from UTC to IST (AT TIME ZONE). */
/* Q80. Hour-of-day distribution of page_views in IST. */
/* Q81. Peak shopping hour from page_views (IST) - top hour by count. */
/* Q82. Count calls in each hour-of-day (call_start_time). */
/* Q83. 15-minute bucket of page_views to find the busiest slot. */
/* Q84. Time-to-resolution in hours for tickets (resolved_date - created_date). */
/* Q85. Tickets resolved within 24 hours vs longer. */
/* Q86. Orders shipped within 1 day of order (shipped_date - order_date <= 1). */
/* Q87. Average delivery interval per region in days. */
/* Q88. Morning/afternoon/evening buckets of page_views (needs a timestamp). */
/* Q89. Days since last order for each customer (current_date - max order_date). */
/* Q90. Customer tenure in years (age(current_date, registration_date)). */
/* Q91. Revenue per ISO week with correct year-week boundary (to_char 'IYYY-IW'). */
/* Q92. Orders per fiscal quarter (fiscal year starting April). */
/* Q93. Month-over-month revenue growth (date_trunc + LAG, Day 18). */
/* Q94. Rolling 7-day order count over a daily series (window frame, Day 17). */
/* Q95. First and last activity date per customer (orders + page_views). */
/* Q96. Events per weekday x hour heatmap (page_views). */
/* Q97. Median order value per month (Day 22 percentile + date_trunc). */
/* Q98. Latest order per customer with days-since (DISTINCT ON, Day 22 + date diff). */
/* Q99. Daily revenue gap-filled for 90 days with a 7-day moving average (Day 17). */
/* Q100. Executive time-series strip: monthly orders, revenue, and MoM % for 2025. */
