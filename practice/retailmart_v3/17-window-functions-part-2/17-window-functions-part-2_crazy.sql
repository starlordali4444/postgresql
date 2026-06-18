/* ============================================================
   SQL PRACTICE SET - Window Functions Part 2: Aggregation & Frames (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Staff-level rolling analytics, multi-frame queries, time-series KPIs
   Database:     RetailMart V3

   Scope (CRAZY = staff-engineer aggregation/frames - NO ranking, NO LAG/LEAD):
     - Multiple frames in one query; gap-filled rolling KPIs
     - FIRST/LAST/NTH_VALUE systems; Pareto/ABC/contribution analytics
     - Reproducible reset-at-boundary cumulative metrics
   (Ranking = Day 16; period-over-period via LAG/LEAD = Day 18.)

   Structure: 25 Conceptual + 25 Multi-frame KPIs + 25 Anchored/Pareto + 25 Dashboards
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Architect a daily KPI query with 7-day, 30-day, and YTD windows in one pass. */
/* Q2.  RANGE vs ROWS vs GROUPS - precise frame semantics and when each is correct. */
/* Q3.  Why gap-filling must precede rolling windows; build the date spine. */
/* Q4.  LAST_VALUE/NTH_VALUE frame correctness; the UNBOUNDED FOLLOWING fix. */
/* Q5.  Rolling distinct counts: why windows fail and how to approximate/solve. */
/* Q6.  Rolling median: approaches (percentile_cont per window via LATERAL) and cost. */
/* Q7.  Performance of large RANGE INTERVAL frames; mitigation strategies. */
/* Q8.  Multi-level share-of-total in one query (line/order/customer/grand). */
/* Q9.  Reproducible reset-at-boundary cumulative metrics across refreshes. */
/* Q10. Anomaly detection: deviation-from-trailing-MA, z-score within a window. */
/* Q11. Why FILTER isn't allowed in window aggregates; CASE-inside-aggregate alternative. */
/* Q12. Building Pareto/ABC curves correctly with cumulative share + cut-points. */
/* Q13. Combining window aggregates with GROUP BY in layered CTEs (grain discipline). */
/* Q14. Centered vs trailing MA: trend-timing tradeoffs for forecasting inputs. */
/* Q15. Exclude-current-row frames for unbiased peer baselines. */
/* Q16. Index-to-100 time series (each row / partition's first value) at scale. */
/* Q17. % to running peak (drawdown) using running MAX frames. */
/* Q18. TTM (trailing-twelve-month) metrics with monthly grain. */
/* Q19. Why duplicate ORDER BY keys + RANGE inflate frames; ROWS as the fix. */
/* Q20. Designing a query that emits detail + subtotal + grand total rows. */
/* Q21. Rolling cohort retention inputs purely from aggregation windows (no LAG). */
/* Q22. Multi-frame correctness when partitions have sparse/uneven dates. */
/* Q23. Materializing the date spine + facts before windowing for speed. */
/* Q24. Contribution waterfall ordering and cumulative share semantics. */
/* Q25. When to push windowing to an MV (Day 25) vs compute on the fly. */

/* ============================================================
   SECTION B: MULTI-FRAME ROLLING KPIs (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: Build the daily revenue KPI line: value, 7-day MA, 30-day MA, YTD - gap-filled. */
/* Q27. Per store: daily revenue with 7/28/90-day moving sums. */
/* Q28. Rolling 7-day and 30-day active-customer counts per day. */
/* Q29. Trailing-3-month and trailing-12-month revenue per region. */
/* Q30. Daily orders with 7-day MA and deviation flag (> 2x MA). */
/* Q31. Rolling 30-day GMV and its % of trailing 90-day GMV. */
/* Q32. Per product: trailing-7 and trailing-30 units with both moving averages. */
/* Q33. Rolling weekly signups, 4-week MA, and 12-week MA per region. */
/* Q34. Delivery time: trailing-20 and trailing-100 moving average per courier. */
/* Q35. Per agent: trailing-week and trailing-month resolved-ticket counts. */
/* Q36. Daily refunds with 7-day MA and refund-spike flag. */
/* Q37. Rolling 90-day revenue per category, gap-filled, with 7-day smoothing. */
/* Q38. Per warehouse: trailing-30-day stock movement (snapshots) moving average. */
/* Q39. Web page-views: 7-day MA per device and the device's share of daily total. */
/* Q40. Rolling 6-month and 12-month net_salary average per department. */
/* Q41. Per customer: trailing-90-day spend and trailing-365-day spend. */
/* Q42. Daily revenue z-score within a trailing 30-day window (anomaly score). */
/* Q43. Rolling 14-day ticket volume with MA per priority. */
/* Q44. Per brand: trailing-30-day revenue and its rank-free % of trailing-90. */
/* Q45. Rolling 7-day and 30-day average basket size per store. */
/* Q46. Trailing-12-month revenue (TTM) with month-over-month base (sums only). */
/* Q47. Per region: 4-week and 12-week moving average of new customers. */
/* Q48. Rolling 30-day distinct products sold per store (approximation). */
/* Q49. Daily revenue, 7-day MA, and % deviation from MA per store. */
/* Q50. One query: per store per day - revenue, 7/30-day MA, YTD, and YTD %-of-year. */

/* ============================================================
   SECTION C: ANCHORED VALUES, PARETO & ABC (25)
   ------------------------------------------------------------ */
/* Q51. SCENARIO: Product team wants ABC classification: cumulative % of revenue per category -> A/B/C. */
/* Q52. Pareto: top-20% of customers driving what % of revenue (cumulative share). */
/* Q53. Index each store's monthly revenue to its first month = 100. */
/* Q54. Each order vs the customer's first and last order value (FIRST/LAST_VALUE). */
/* Q55. % to peak (drawdown) of cumulative revenue per store. */
/* Q56. ABC classification of products by units within brand. */
/* Q57. Each region's month vs its best month (FIRST_VALUE by revenue desc). */
/* Q58. Cumulative revenue contribution curve per category (waterfall order). */
/* Q59. NTH_VALUE: each customer's 2nd and 3rd order values on every row. */
/* Q60. Each product's price vs brand cheapest and dearest (FIRST + LAST_VALUE). */
/* Q61. Customer spend indexed to first active month per acquisition cohort. */
/* Q62. Pareto cutoff: smallest set of products making 80% of revenue. */
/* Q63. Each campaign vs platform's biggest campaign spend (anchor). */
/* Q64. Drawdown from running max of cumulative GMV (max underwater %). */
/* Q65. ABC by margin contribution per category. */
/* Q66. Each store's revenue vs region's top and bottom store (span). */
/* Q67. Top-20% SKUs by cumulative units within each warehouse. */
/* Q68. Each employee's salary vs department first/last by hire order. */
/* Q69. Cumulative % of refunds by customer (who drives returns). */
/* Q70. Each month indexed to year's first month per region (=100). */
/* Q71. Contribution of each payment_mode to cumulative revenue. */
/* Q72. First/last snapshot per (warehouse, product) and net change. */
/* Q73. Pareto of agents by resolved-ticket contribution. */
/* Q74. ABC customers by lifetime spend (A=top 80% cum, etc.). */
/* Q75. Each product's running share of brand revenue with peak-share month. */

/* ============================================================
   SECTION D: EXECUTIVE DASHBOARDS (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: Build the exec monthly dashboard per region: revenue, YTD, %-of-year, 3-mo MA, contribution %. */
/* Q77. Daily company KPI: revenue, orders, AOV, 7-day MA of each, gap-filled. */
/* Q78. Store scorecard: revenue, region-share %, YTD, trailing-90 MA. */
/* Q79. Product performance board: units, brand-share %, ABC class, trailing-30 MA. */
/* Q80. Customer value board: lifetime spend, spend percentile (window), recency, trailing-90. */
/* Q81. Category monthly board: revenue, % of company, cumulative YTD, 3-mo MA. */
/* Q82. Courier SLA board: avg delivery, trailing-100 MA, % of shipments under 2 days. */
/* Q83. Agent productivity board: resolved/day, trailing-week MA, share of category. */
/* Q84. Region waterfall: monthly revenue contribution to company cumulative. */
/* Q85. Marketing board: platform spend, share %, trailing-30 MA, cumulative. */
/* Q86. Warehouse health board: stock, region-share %, trailing-30 movement MA. */
/* Q87. Cohort revenue board: per signup-month cumulative spend indexed to 100. */
/* Q88. Daily anomaly board: revenue, 7-day MA, z-score, flagged spikes. */
/* Q89. Pareto board: cumulative customer revenue share with the 80% line. */
/* Q90. P&L strip: revenue, expenses (windowed), running margin per month per region. */
/* Q91. Retention input board: rolling weekly active customers + 4-week MA. */
/* Q92. Brand board: revenue, category-share %, YTD, ABC class. */
/* Q93. Store-of-month: highest trailing-30 revenue store per region (aggregate window). */
/* Q94. Inventory turns board: trailing-90 COGS / avg stock per product. */
/* Q95. Channel board: web sessions, conversion proxy, 7-day MA per device. */
/* Q96. Executive "one big query": region x month with 8 windowed KPIs. */
/* Q97. Top-line board: company revenue, YTD, %-of-year, TTM in one query. */
/* Q98. Quartile-free contribution board (pure cumulative share, no NTILE). */
/* Q99. Returns board: refund total, % of revenue, trailing-30 MA per category. */
/* Q100. Full monthly exec pack: revenue, YTD, %-of-year, 3-mo MA, contribution %, drawdown - per region. */

/* ============================================================
   END OF Window Functions Part 2 - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
