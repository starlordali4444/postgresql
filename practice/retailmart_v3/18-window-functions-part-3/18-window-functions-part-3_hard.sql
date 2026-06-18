/* ============================================================
   SQL PRACTICE SET - Window Functions Part 3: LAG / LEAD (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Growth tables, gaps-and-islands, churn/sessionization, change detection
   Database:     RetailMart V3

   Scope (HARD = interview/production, LAG/LEAD focus):
     - MoM/YoY growth tables; consecutive-streak (gaps-and-islands) patterns
     - Churn/reactivation signals; sessionization; price/anomaly change detection
   (Ranking = Day 16; aggregation/frames = Day 17.)

   Structure: 25 Conceptual + 25 Growth tables + 25 Gaps-and-islands + 25 Churn/sessions/change
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Gaps-and-islands: how does (row_number - LAG-based group key) find consecutive runs? */
/* Q2.  Why MoM growth needs a gap-filled month spine (missing months break LAG). */
/* Q3.  YoY vs MoM: LAG 12 vs LAG 1 on a monthly grain - pitfalls. */
/* Q4.  Sessionization: new-session flag -> cumulative sum -> session id; why it works. */
/* Q5.  Churn signal: LEAD(order_date) IS NULL vs gap-to-today - which and why. */
/* Q6.  "Previous non-null value": why plain LAG fails on sparse data; the fix. */
/* Q7.  Detecting streaks of consecutive active months per customer. */
/* Q8.  Why ORDER BY (date, id) tie-break matters for LAG correctness. */
/* Q9.  Combining LAG with a moving average (Day 17) for anomaly detection. */
/* Q10. Period-over-period at two grains (store-month and region-month) in one query. */
/* Q11. Why growth tables filter the first period (no prior) out or label it. */
/* Q12. Reactivation cohorts: define via gap > 90 days then activity. */
/* Q13. First-touch to conversion latency via LEAD across event types. */
/* Q14. Detect monotonic decline (N consecutive negative deltas). */
/* Q15. Why "consecutive days" islands need a date spine, not just order rows. */
/* Q16. Compute time-in-state (status durations) using LEAD on a state log. */
/* Q17. Run-length encoding of a status series with gaps-and-islands. */
/* Q18. Why LAG-based change detection beats comparing to a stored "previous" column. */
/* Q19. Compute "days to churn" (last order to a cutoff) with LEAD/CURRENT_DATE. */
/* Q20. Multi-offset comparison (vs 1, 3, 12 periods ago) in one query. */
/* Q21. Detecting price-change events and the magnitude of each change. */
/* Q22. Build a retention curve input (active in month N after signup) with LAG/LEAD. */
/* Q23. Why sessionization thresholds belong in a CTE for tunability. */
/* Q24. Cumulative streak length that resets on a break. */
/* Q25. Combine LAG growth % with NTILE to bucket "fastest-growing" stores. */

/* ============================================================
   SECTION B: GROWTH TABLES (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: CFO wants a MoM revenue growth table per region (revenue, prev, growth %, flag). */
/* Q27. YoY monthly revenue growth % per store (LAG 12, gap-filled). */
/* Q28. QoQ revenue growth per region with up/down arrows. */
/* Q29. MoM AOV growth per store. */
/* Q30. MoM units growth % for the top-10 products by revenue. */
/* Q31. Compare growth vs 1, 3, and 12 months ago in one row. */
/* Q32. MoM new-customer growth per acquisition city. */
/* Q33. MoM refund-rate change per category. */
/* Q34. WoW active-customer growth per region. */
/* Q35. MoM contribution shift: each category's %-of-company change. */
/* Q36. MoM gross-margin growth per brand. */
/* Q37. Fastest-growing stores: rank by latest MoM growth % (combine with Day 16 rank). */
/* Q38. MoM ad-spend efficiency change per platform. */
/* Q39. MoM ticket-volume growth per priority. */
/* Q40. Detect the first month each store exceeded its prior peak revenue. */
/* Q41. MoM page-view growth per device, gap-filled. */
/* Q42. Compounded 3-month growth setup (chain of MoM deltas). */
/* Q43. MoM net_salary cost growth per department. */
/* Q44. Seasonality check: same-month-last-year compare per region. */
/* Q45. MoM growth for new vs returning customer revenue (split then LAG). */
/* Q46. Negative-growth alert: stores with 2+ consecutive declining months. */
/* Q47. MoM revenue growth with both absolute delta and % delta. */
/* Q48. Quarter-over-quarter growth for the top-5 categories. */
/* Q49. MoM growth indexed: first month = 100, each month relative. */
/* Q50. Full growth pack: per store-month revenue, prev, MoM %, YoY %, flag. */

/* ============================================================
   SECTION C: GAPS-AND-ISLANDS (25)
   ------------------------------------------------------------ */
/* Q51. SCENARIO: Find each customer's longest streak of consecutive active months. */
/* Q52. Consecutive-day order streaks per store. */
/* Q53. Identify "islands" of months where a store had revenue (vs gaps). */
/* Q54. Longest run of months a product sold continuously. */
/* Q55. Consecutive weeks a customer placed at least one order. */
/* Q56. Identify gaps (missing months) in each store's revenue timeline. */
/* Q57. Run-length of consecutive 5-star reviews per product. */
/* Q58. Streak of consecutive on-time deliveries per courier. */
/* Q59. Consecutive months an employee's salary stayed unchanged. */
/* Q60. Identify continuous in-stock periods per (warehouse, product). */
/* Q61. Longest consecutive-day login streak per customer (web_events). */
/* Q62. Islands of consecutive profitable months per store. */
/* Q63. Consecutive price-stable periods per product (no price change). */
/* Q64. Streak of months with positive MoM growth per region. */
/* Q65. Group consecutive same-status order runs per customer. */
/* Q66. Find the start/end dates of each active island per customer. */
/* Q67. Longest gap (out-of-stock island) per product. */
/* Q68. Consecutive quarters a brand grew revenue. */
/* Q69. Identify reactivation islands (active -> gap -> active) per customer. */
/* Q70. Streak of consecutive weeks a campaign ran (spend present). */
/* Q71. Run-length encode a customer's tier history. */
/* Q72. Consecutive days revenue beat the previous day (winning streak). */
/* Q73. Islands of consecutive months with refunds per customer. */
/* Q74. Longest consecutive-month payroll run per employee. */
/* Q75. Build an islands table: customer, island_start, island_end, length. */

/* ============================================================
   SECTION D: CHURN, SESSIONS & CHANGE DETECTION (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: Flag churn-risk customers: no order in the last 90 days (gap to today). */
/* Q77. Reactivation events: order after a > 90-day gap. */
/* Q78. Time-to-second-order per customer (first->second latency). */
/* Q79. Sessionize web_events: new session when gap > 30 min; output session ids. */
/* Q80. Session duration and view count per derived session. */
/* Q81. Detect price-change events with old->new and % change per product. */
/* Q82. Detect > 50% price jumps (data-entry error candidates). */
/* Q83. Detect tier upgrades and downgrades per customer over time. */
/* Q84. Detect stock-outs (positive -> 0) and recoveries (0 -> positive). */
/* Q85. Detect rating drops (review < previous) per product. */
/* Q86. Churn cohort: customers whose last order is in each month. */
/* Q87. Detect consecutive declining-revenue months per store (alert). */
/* Q88. Average session length per device and per day. */
/* Q89. Detect rapid repeat purchases (next order within 24h). */
/* Q90. Detect salary changes and their magnitude per employee. */
/* Q91. Time-in-status durations from a status log (LEAD on timestamps). */
/* Q92. Detect customers slowing down: latest gap > 2x their median gap. */
/* Q93. First-vs-last order value change per customer (loyalty value trend). */
/* Q94. Detect campaigns whose spend doubled period-over-period. */
/* Q95. Web funnel step timing: time between page -> cart -> checkout via LEAD. */
/* Q96. Detect the month a customer's spend peaked then declined. */
/* Q97. Sessionize calls into bursts (gap > 1h) and count bursts per customer. */
/* Q98. Detect inventory replenishment events and their size. */
/* Q99. Build a churn dashboard: customer, last_order, days_since, churn_flag, prior_gap. */
/* Q100. Full change-log: per product, every price change with date, old, new, %, rank of change. */

/* ============================================================
   END OF Window Functions Part 3 - HARD LEVEL (100 QUESTIONS)
============================================================ */
