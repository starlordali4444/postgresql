/* ============================================================
   SQL PRACTICE SET - Conditional Logic & Derived Columns (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Conditional Logic - business rules at scale
   Database:     RetailMart V3

   Scope (CRAZY):
     - Decision tables in SQL
     - Multi-criteria scoring (RFM, NPS)
     - Rule engines via CASE chains
     - State machines via CASE
     - SQL-driven workflow logic
     - Domain-specific computation pipelines
     - 360deg dashboards

   Structure: 25 Decision tables + 25 RFM/NPS + 25 State machines + 25 Multi-metric dashboards
   ============================================================ */

/* ============================================================
   SECTION A: DECISION TABLES (25)
   ------------------------------------------------------------ */
/* Q1.  Tier upgrade matrix: points x lifetime_orders -> tier. */
/* Q2.  Pricing matrix: brand x region x tier -> discount %. */
/* Q3.  Shipping rules: weight x distance x tier -> cost. */
/* Q4.  Returns approval: amount x tenure x tier -> auto-approve / manual. */
/* Q5.  Fraud rules: amount x ip_country x velocity -> block / review / allow. */
/* Q6.  Loyalty bonus: spend x multiplier x tier -> points. */
/* Q7.  Subscription tier: monthly orders x avg basket -> plan. */
/* Q8.  Ticket priority: customer tier x product price x urgency -> priority. */
/* Q9.  Ad spend rules: platform x geo x season -> bid. */
/* Q10. Inventory restock: velocity x lead_time x season -> quantity. */
/* Q11. Employee bonus: review x tenure x dept -> bonus %. */
/* Q12. Promotion eligibility: revenue x tenure x violations -> flag. */
/* Q13. Tax bracket: income x dependents x region -> rate. */
/* Q14. Commission rule: sales x tier x product -> commission. */
/* Q15. Lead score: source x pages x actions -> score. */
/* Q16. Churn risk: last_order x tickets x tier -> risk_band. */
/* Q17. VIP status: spend x engagement x tenure -> VIP_level. */
/* Q18. Refund auto-approval: amount x LTV x reason -> auto/manual. */
/* Q19. Credit limit: tier x history x geographic -> limit. */
/* Q20. Bonus eligibility: salary x performance x tenure -> eligible. */
/* Q21. Risk score: amount x time-of-day x device -> score. */
/* Q22. Personalization: recent x interests x purchases -> recommend. */
/* Q23. Marketing segment: tier x geo x purchase pattern -> segment. */
/* Q24. SLA tier: contract x support level x volume -> SLA. */
/* Q25. Build a "100-rule decision table" using nested CASE. */

/* ============================================================
   SECTION B: RFM, NPS, COHORTS (25)
   ------------------------------------------------------------ */
/* Q26. R (Recency): days since last order. */
/* Q27. F (Frequency): orders in last 365d. */
/* Q28. M (Monetary): SUM(net_total) lifetime. */
/* Q29. R-score: NTILE(5) of recency. */
/* Q30. F-score: NTILE(5) of frequency. */
/* Q31. M-score: NTILE(5) of monetary. */
/* Q32. RFM combined: '555' = best, '111' = worst. */
/* Q33. RFM segment names (Champions, Loyal, At-Risk, Lost). */
/* Q34. Compute NPS from ratings (Promoters - Detractors). */
/* Q35. NPS per region. */
/* Q36. NPS per product. */
/* Q37. NPS per ticket category. */
/* Q38. NPS trend over months. */
/* Q39. Cohort by signup month, retention by month-N. */
/* Q40. Cohort by first-order month, repeat rate. */
/* Q41. Activation rate per campaign. */
/* Q42. Customer LTV by cohort. */
/* Q43. Churn rate per month. */
/* Q44. Win-back targets: lapsed customers. */
/* Q45. Engagement decile: visits x purchases x reviews. */
/* Q46. Risk decile: refund rate x ticket rate x deliveries. */
/* Q47. Health score: NPS x R x F x M weighted. */
/* Q48. Trend slope: linear regression of orders over time. */
/* Q49. Stickiness: DAU/MAU equivalent for orders. */
/* Q50. Build a complete RFM + NPS + cohort dashboard. */

/* ============================================================
   SECTION C: STATE MACHINES & WORKFLOWS (25)
   ------------------------------------------------------------ */
/* Q51. Order state: Pending -> Paid -> Shipped -> Delivered. */
/* Q52. Ticket state: Open -> Assigned -> InProgress -> Resolved -> Closed. */
/* Q53. Shipment state: Created -> Picked -> InTransit -> Delivered / Failed. */
/* Q54. Customer lifecycle: New -> Active -> Dormant -> Churned. */
/* Q55. Subscription state: Trial -> Active -> Paused -> Cancelled. */
/* Q56. Refund state: Requested -> Reviewed -> Approved/Denied. */
/* Q57. Campaign state: Draft -> Active -> Ended -> Archived. */
/* Q58. Employee onboarding state: Applied -> Interviewing -> Hired -> Onboarded. */
/* Q59. Detect invalid transitions (Open -> Resolved without InProgress). */
/* Q60. State age (time in each state). */
/* Q61. SLA breach detection. */
/* Q62. Auto-advance states via cron. */
/* Q63. State velocity: avg time per state. */
/* Q64. State funnel: % reaching each. */
/* Q65. Build a state graph (mermaid output). */
/* Q66. Reverse engineer state transitions from audit. */
/* Q67. Detect "stuck" rows (in same state too long). */
/* Q68. Build a workflow engine in pure SQL (small DSL). */
/* Q69. Multi-actor approvals (manager + finance + legal). */
/* Q70. Priority elevation if SLA risk. */
/* Q71. Auto-escalation rules. */
/* Q72. State rollback rules. */
/* Q73. Conditional branching (CASE in next-state). */
/* Q74. Parallel states (multiple in flight). */
/* Q75. Build "order lifecycle dashboard" via state-time analysis. */

/* ============================================================
   SECTION D: 360deg DASHBOARDS (25)
   ------------------------------------------------------------ */
/* Q76. Customer 360deg: 20 derived metrics in one row. */
/* Q77. Product 360deg: sales, returns, inventory, reviews. */
/* Q78. Store 360deg: orders, revenue, employees, inventory, complaints. */
/* Q79. Employee 360deg: tickets, calls, sales, attendance, bonus. */
/* Q80. Region 360deg: customers, stores, revenue, complaints. */
/* Q81. Campaign 360deg: spend, attributions, conversions, ROI. */
/* Q82. Supplier 360deg: shipments, products, costs. */
/* Q83. Brand 360deg: products, sales, returns, reviews. */
/* Q84. Category 360deg: brands, products, revenue, trends. */
/* Q85. Tier 360deg: members, points, retention, revenue. */
/* Q86. Warehouse 360deg: capacity, throughput, inventory age. */
/* Q87. Courier 360deg: shipments, delivery time, complaints. */
/* Q88. Agent 360deg: tickets, calls, ratings, hours. */
/* Q89. Reviewer 360deg: count, ratings, products covered, sentiment. */
/* Q90. Refund 360deg: rate, reasons, top customers. */
/* Q91. Health dashboard: 30 KPIs. */
/* Q92. Inventory health: SKUs in stock, low, out-of-stock. */
/* Q93. Marketing dashboard: spend, revenue, CAC, ROAS. */
/* Q94. Operations dashboard: throughput, lag, errors. */
/* Q95. Finance dashboard: revenue, cost, profit, margin. */
/* Q96. HR dashboard: headcount, payroll, attrition. */
/* Q97. Customer service dashboard: SLA, CSAT, FCR. */
/* Q98. Sales dashboard: orders, AOV, CR, repeat. */
/* Q99. Build executive 1-page report (50 metrics). */
/* Q100. Build "board meeting summary" - 10 numbers that matter. */

/* ============================================================
   END OF Conditional Logic & Derived Columns - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
