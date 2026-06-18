/* ============================================================
   SQL PRACTICE SET - Cohort, RFM & Funnel Queries (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Cohort tables, RFM via NTILE, funnel step counts, CLV, period-over-period growth
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - Cohort table: signup_month x months-since-signup retention grid
     - RFM segmentation with NTILE on Recency / Frequency / Monetary
     - Funnel: counts at each step + drop-off; CLV per customer; PoP growth
   NOTE: signup_month uses customers.registration_date (DATE). Period index in months.
     Sessions / funnel come from web_events.page_views (has customer_id + session_id).
     RFM uses orders only. Writes (CREATE TABLE) -> accio_NN; cleansed inputs presumed
     (Day 26 cleansed layer). MVs only on Day 25.

   Structure: 25 Conceptual + 25 Cohort retention + 25 RFM segmentation + 25 Funnel & CLV & PoP
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What is a cohort (group of customers anchored to a common starting date)? */
/* Q2.  What does signup_month x months-since-signup measure (retention grid)? */
/* Q3.  What is period_index (months since signup, 0 = signup month)? */
/* Q4.  What does "Month-1 retention" mean in a cohort? */
/* Q5.  Why is a cohort triangle the standard shape (cells empty in the future)? */
/* Q6.  What does RFM stand for (Recency, Frequency, Monetary)? */
/* Q7.  How does NTILE(5) (Day 16) produce a 1..5 score per dimension? */
/* Q8.  Why is "Recency" usually ordered so that low days = high score? */
/* Q9.  What does a 555 RFM score mean for a customer? */
/* Q10. What does "111" RFM score mean? */
/* Q11. What is a funnel (counts of users at each step)? */
/* Q12. What is "drop-off" between two funnel steps? */
/* Q13. What is CLV (customer lifetime value), as a single number? */
/* Q14. Difference between MRR-style and per-customer CLV (concept). */
/* Q15. Period-over-period growth: MoM / QoQ / YoY - what do they measure? */
/* Q16. Why does cohort analysis answer "are new customers staying"? */
/* Q17. Why does RFM segmentation drive marketing campaign targeting? */
/* Q18. Why does a funnel reveal the worst step in a flow? */
/* Q19. What's the anchor date for cohort (typically first order or registration)? */
/* Q20. How does a date spine (Day 23) help with cohort completeness? */
/* Q21. Why do we need DISTINCT-customer counts in cohort cells (not order counts)? */
/* Q22. What does "active in period N" mean (placed an order in that month)? */
/* Q23. Why does a cohort table often show as % retention, not absolute counts? */
/* Q24. Why does NTILE require ORDER BY in the OVER() clause? */
/* Q25. Name three RetailMart funnels worth measuring (e.g. view->cart->order). */

/* ============================================================
   SECTION B: COHORT RETENTION (25)
   ------------------------------------------------------------ */
/* Q26. Per customer: signup_month = date_trunc('month', registration_date). */
/* Q27. Per order: order_month = date_trunc('month', order_date). */
/* Q28. Per (customer, order): months-since-signup = (order_month - signup_month)/30 (concept). */
/* Q29. Use AGE or date math (Day 23) to compute period_index in months. */
/* Q30. Cohort sizes: count distinct customers per signup_month. */
/* Q31. Active customers in cohort at period_index 0 (signup month). */
/* Q32. Active customers per (signup_month, period_index) - cohort grid raw. */
/* Q33. Retention %: active / cohort_size per (signup_month, period_index). */
/* Q34. Limit to period_index 0..11; tidy long format. */
/* Q35. Pivot the long format to wide (signup_month x period_index, Day 21). */
/* Q36. Same as Q35 with retention shown as a percentage. */
/* Q37. Month-1 retention per signup_month (a single trend line). */
/* Q38. Month-3 retention per signup_month. */
/* Q39. Month-6 retention per signup_month. */
/* Q40. Compare Month-1 retention 2025 vs 2024 (Day 23 trend). */
/* Q41. Cohort retention per region (join customers->addresses->region). */
/* Q42. Cohort retention per acquisition tier (Bronze/Silver/Gold/Platinum). */
/* Q43. Cohort sizes vs total customers - sanity reconcile. */
/* Q44. Use a date spine (Day 23) to ensure all (cohort, period) cells exist. */
/* Q45. Show the cohort triangle (only past cells filled). */
/* Q46. Cohort revenue: revenue per (signup_month, period_index). */
/* Q47. Cumulative cohort revenue per period_index (running sum, Day 17). */
/* Q48. Average revenue per customer per cohort per period. */
/* Q49. Identify the strongest cohort (highest Month-3 retention). */
/* Q50. Identify the weakest cohort (lowest Month-3 retention). */

/* ============================================================
   SECTION C: RFM SEGMENTATION (25)
   ------------------------------------------------------------ */
/* Q51. Per customer Recency: days since their last order. */
/* Q52. Per customer Frequency: count of orders. */
/* Q53. Per customer Monetary: SUM(net_total) lifetime. */
/* Q54. Recency score: NTILE(5) over -days_since_last_order (low days -> high score). */
/* Q55. Frequency score: NTILE(5) over order_count. */
/* Q56. Monetary score: NTILE(5) over lifetime_revenue. */
/* Q57. Combine into an RFM string score 'RFM' (e.g. '555'). */
/* Q58. Total RFM score: R + F + M (1..15). */
/* Q59. Top customers by RFM total. */
/* Q60. Champions segment: RFM = 555. */
/* Q61. At-Risk segment: low R, high F/M (former big spenders going quiet). */
/* Q62. New segment: R=5, F=1, M=1 (just started). */
/* Q63. Hibernating segment: low R, low F, low M. */
/* Q64. Count customers per RFM string score. */
/* Q65. Distribution of R score, F score, M score (three histograms). */
/* Q66. RFM per region (Day 21 pivot). */
/* Q67. RFM per registration cohort (Day 23). */
/* Q68. Find the median lifetime spend per RFM score (Day 22). */
/* Q69. Average orders per RFM score. */
/* Q70. Top-10 customers in Champions by lifetime revenue. */
/* Q71. Show how RFM scores correlate with customer tier (Bronze..Platinum). */
/* Q72. Per RFM string score: pivot count by region (Day 21). */
/* Q73. Per tier: percent customers in each RFM segment label. */
/* Q74. Drift: how many Champions are At-Risk this quarter vs last (Day 23). */
/* Q75. Sanity check: total customers = sum across segments (no double-count). */

/* ============================================================
   SECTION D: FUNNEL, CLV & PERIOD-OVER-PERIOD (25)
   ------------------------------------------------------------ */
/* Q76. Funnel step 1: distinct customers who viewed any page. */
/* Q77. Funnel step 2: distinct customers who placed any order. */
/* Q78. Drop-off step 1 -> step 2: % of viewers who ordered. */
/* Q79. Funnel: distinct customers who viewed a product page (page_url LIKE '%product%'). */
/* Q80. Funnel: distinct customers who added to cart (page_url LIKE '%cart%'). */
/* Q81. Funnel: distinct customers who checked out (page_url LIKE '%checkout%'). */
/* Q82. 3-step funnel counts: product -> cart -> checkout (one wide row). */
/* Q83. Drop-off % at each transition (cart/product, checkout/cart). */
/* Q84. Sessions instead of customers: per session, did it reach each step? */
/* Q85. Funnel per device_type (Day 21 pivot). */
/* Q86. Funnel per month (Day 23 spine). */
/* Q87. CLV per customer: lifetime SUM(net_total) over Delivered orders only. */
/* Q88. Average CLV per region (Day 22 also as median). */
/* Q89. CLV per registration cohort (Day 23). */
/* Q90. CLV per RFM segment. */
/* Q91. Period-over-period revenue: MoM growth per region (LAG, Day 18). */
/* Q92. PoP: this month vs same month last year (YoY). */
/* Q93. PoP: QoQ growth per category (Day 23 quarter + window). */
/* Q94. Active-customer PoP per month per region. */
/* Q95. New-customer PoP per month (first-order-month definition). */
/* Q96. Cumulative revenue per cohort over months-since-signup. */
/* Q97. CLV vs RFM-monetary correlation snapshot. */
/* Q98. Cohort retention pivot: signup_month x period_index (Day 21). */
/* Q99. RFM dashboard: per segment count + median CLV (Day 22). */
/* Q100. Exec strip: Month-1 retention, top RFM segment count, funnel drop-off, MoM revenue. */
