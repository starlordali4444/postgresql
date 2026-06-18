/* ============================================================
   SQL PRACTICE SET - Subqueries + CTEs Combined (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Subqueries + CTEs combined - real-world reports
   Database:     RetailMart V3

   Scope:
     - Combining CTEs + subqueries + joins
     - Building reusable report patterns
     - Pre-aggregation patterns
     - End-of-week-3 review / synthesis

   Structure: 25 Conceptual / synthesis + 25 KPI reports + 25 Cohort/funnel reports + 25 Dashboards
   ============================================================ */

/* SECTION A: SYNTHESIS / CONCEPTUAL (25) */
/* Q1.  When to use subquery vs CTE? */
/* Q2.  When to use subquery vs JOIN? */
/* Q3.  When to use CTE vs derived table? */
/* Q4.  When to use LATERAL vs correlated? */
/* Q5.  When to use RECURSIVE vs iterative app code? */
/* Q6.  Pre-aggregate via CTE before JOIN - why? */
/* Q7.  EXPLAIN ANALYZE-driven choice. */
/* Q8.  Readability vs performance. */
/* Q9.  CTE for modularity. */
/* Q10. Subquery for inline computation. */
/* Q11. Combine subquery + CTE + window. */
/* Q12. Combine LATERAL + CTE. */
/* Q13. Combine RECURSIVE + CTE chain. */
/* Q14. Combine subquery in SELECT + JOIN. */
/* Q15. Combine HAVING subquery + window. */
/* Q16. When to materialize. */
/* Q17. When to inline. */
/* Q18. When to use view vs MV. */
/* Q19. When to refactor subquery to CTE. */
/* Q20. When to refactor CTE to MV. */
/* Q21. When to denormalize. */
/* Q22. When to partition. */
/* Q23. When to index. */
/* Q24. When to write a stored procedure. */
/* Q25. When to push computation to app vs DB. */

/* SECTION B: KPI REPORTS (25) */
/* Q26. MRR (monthly recurring revenue) approximation. */
/* Q27. ARR (annual recurring revenue). */
/* Q28. CAC (customer acquisition cost). */
/* Q29. LTV (customer lifetime value). */
/* Q30. LTV / CAC ratio. */
/* Q31. AOV (average order value). */
/* Q32. CR (conversion rate). */
/* Q33. Repeat purchase rate. */
/* Q34. Refund rate. */
/* Q35. Cancellation rate. */
/* Q36. SLA compliance rate. */
/* Q37. CSAT (customer satisfaction). */
/* Q38. NPS (net promoter score). */
/* Q39. FCR (first-contact resolution). */
/* Q40. AHT (average handle time). */
/* Q41. CPL (cost per lead). */
/* Q42. CPC (cost per click). */
/* Q43. ROAS (return on ad spend). */
/* Q44. ROI (campaigns). */
/* Q45. Inventory turnover. */
/* Q46. Days sales outstanding (DSO). */
/* Q47. Days inventory outstanding (DIO). */
/* Q48. Gross margin. */
/* Q49. Net margin. */
/* Q50. Operating margin. */

/* SECTION C: COHORT & FUNNEL REPORTS (25) */
/* Q51. Cohort retention by signup month. */
/* Q52. Cohort retention by first-purchase month. */
/* Q53. Cohort LTV. */
/* Q54. Cohort churn. */
/* Q55. Win-back rate. */
/* Q56. Re-activation cohort. */
/* Q57. Funnel: visitor -> signup. */
/* Q58. Funnel: signup -> first order. */
/* Q59. Funnel: cart -> checkout -> paid. */
/* Q60. Funnel: campaign -> conversion. */
/* Q61. Marketing funnel. */
/* Q62. Sales funnel. */
/* Q63. Support funnel: ticket -> in-progress -> resolved. */
/* Q64. Onboarding funnel. */
/* Q65. Trial -> paid funnel. */
/* Q66. Drop-off detection. */
/* Q67. Step-by-step time. */
/* Q68. Bottleneck identification. */
/* Q69. Cohort size variance. */
/* Q70. Retention curve. */
/* Q71. Stickiness DAU/MAU. */
/* Q72. Engagement frequency. */
/* Q73. Activity decay. */
/* Q74. Reactivation. */
/* Q75. Revenue cohort. */

/* SECTION D: DASHBOARDS (25) */
/* Q76. Executive 1-pager. */
/* Q77. Sales dashboard. */
/* Q78. Marketing dashboard. */
/* Q79. Operations dashboard. */
/* Q80. Customer service dashboard. */
/* Q81. HR dashboard. */
/* Q82. Finance dashboard. */
/* Q83. Inventory dashboard. */
/* Q84. Supply chain dashboard. */
/* Q85. Channel mix dashboard. */
/* Q86. Geo dashboard. */
/* Q87. Loyalty dashboard. */
/* Q88. Mobile vs desktop dashboard. */
/* Q89. New vs returning. */
/* Q90. Subscription dashboard. */
/* Q91. Fraud dashboard. */
/* Q92. Compliance dashboard. */
/* Q93. SLA dashboard. */
/* Q94. Engagement dashboard. */
/* Q95. Cohort dashboard. */
/* Q96. Anomaly dashboard. */
/* Q97. Performance dashboard. */
/* Q98. Health dashboard. */
/* Q99. Quality dashboard. */
/* Q100. Master 100-metric dashboard. */

/* ============================================================
   END OF Subqueries + CTEs Combined - EASY LEVEL (100 QUESTIONS)
============================================================ */
