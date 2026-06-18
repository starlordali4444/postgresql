/* ============================================================
   SQL PRACTICE SET - Subqueries Part 2 (Correlated & LATERAL) (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Subqueries Part 2 - Correlated & LATERAL
   Database:     RetailMart V3

   Scope:
     - Correlated subqueries
     - LATERAL JOIN syntax
     - CROSS JOIN LATERAL vs LEFT JOIN LATERAL
     - LATERAL with LIMIT / ORDER BY
     - LATERAL for top-N per group

   Structure: 25 Conceptual + 25 Correlated + 25 LATERAL basics + 25 Top-N per group
   ============================================================ */

/* ============================================================
   SECTION A: CORRELATED & LATERAL - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What is a correlated subquery? */
/* Q2.  Difference between correlated and uncorrelated. */
/* Q3.  What is LATERAL JOIN? */
/* Q4.  CROSS JOIN LATERAL vs LEFT JOIN LATERAL? */
/* Q5.  Why must LATERAL reference earlier FROM items? */
/* Q6.  Performance: per-row evaluation. */
/* Q7.  When is LATERAL the only correct choice? */
/* Q8.  LATERAL + LIMIT for top-N per group. */
/* Q9.  Compare correlated subquery in SELECT vs LATERAL in FROM. */
/* Q10. LATERAL with returning subquery vs LATERAL with table. */
/* Q11. LATERAL inside a CTE - allowed? */
/* Q12. LATERAL with generate_series. */
/* Q13. LATERAL with unnest. */
/* Q14. LATERAL with jsonb_array_elements. */
/* Q15. Why is LATERAL essential for top-N per partition pre-window functions? */
/* Q16. Does LATERAL fan-out? */
/* Q17. CROSS JOIN LATERAL with empty subquery - what happens? */
/* Q18. LEFT JOIN LATERAL with empty subquery? */
/* Q19. LATERAL in DELETE / UPDATE? */
/* Q20. Compare LATERAL vs row_to_json. */
/* Q21. LATERAL re-execution cost - index helps? */
/* Q22. LATERAL replacing scalar subquery - when faster? */
/* Q23. LATERAL replacing correlated subquery - when more readable. */
/* Q24. LATERAL with aggregate inside. */
/* Q25. LATERAL returning multiple columns + multiple rows. */

/* ============================================================
   SECTION B: CORRELATED SUBQUERIES (25)
   ------------------------------------------------------------ */
/* Q26. For each order, count of same-customer orders. */
/* Q27. For each customer, count of their orders. */
/* Q28. For each product, avg rating. */
/* Q29. For each store, count employees. */
/* Q30. For each campaign, total spend. */
/* Q31. For each customer, latest order_date. */
/* Q32. For each product, latest review. */
/* Q33. For each ticket, count comments. */
/* Q34. For each employee, latest pay_slip. */
/* Q35. For each shipment, customer email via correlated. */
/* Q36. Customers WHERE (subquery COUNT) > N. */
/* Q37. Customers WHERE EXISTS (correlated). */
/* Q38. Products WHERE (subquery AVG) < threshold. */
/* Q39. Orders WHERE net_total > correlated AVG by customer. */
/* Q40. Employees WHERE salary > correlated AVG by dept. */
/* Q41. Customers WHERE last_order > N days ago. */
/* Q42. Products WHERE last_review > N days ago. */
/* Q43. Tickets WHERE (correlated comment count) = 0. */
/* Q44. Reviews WHERE rating < (cust's avg rating). */
/* Q45. Orders WHERE net_total < (store's median). */
/* Q46. Correlated UPDATE: set tier_id = (subquery from loyalty). */
/* Q47. Correlated DELETE: delete orphan rows. */
/* Q48. Correlated EXISTS with extra filter. */
/* Q49. Correlated NOT EXISTS. */
/* Q50. Correlated subquery returning aggregate. */

/* ============================================================
   SECTION C: LATERAL BASICS (25)
   ------------------------------------------------------------ */
/* Q51. LATERAL: per customer, get count. */
/* Q52. LATERAL: per customer, get latest order. */
/* Q53. LATERAL: per product, get latest review. */
/* Q54. LATERAL: per store, get employee count. */
/* Q55. LATERAL: per campaign, get sum of spend. */
/* Q56. LATERAL: per region, get sum of revenue. */
/* Q57. LATERAL: per agent, get count of tickets. */
/* Q58. LATERAL: per warehouse, get latest snapshot. */
/* Q59. LATERAL: per supplier, get count of products. */
/* Q60. LATERAL: per courier, get avg delivery time. */
/* Q61. CROSS JOIN LATERAL vs LEFT JOIN LATERAL example. */
/* Q62. LATERAL returning multiple columns. */
/* Q63. LATERAL with WHERE inside. */
/* Q64. LATERAL with ORDER BY inside. */
/* Q65. LATERAL with LIMIT inside. */
/* Q66. LATERAL with aggregate function. */
/* Q67. LATERAL with no rows - INNER vs LEFT. */
/* Q68. LATERAL with generate_series. */
/* Q69. LATERAL with unnest array. */
/* Q70. LATERAL with jsonb_array_elements. */
/* Q71. LATERAL chain: A -> B -> C. */
/* Q72. LATERAL in subquery. */
/* Q73. LATERAL with conditional return. */
/* Q74. LATERAL with EXISTS check inside. */
/* Q75. LATERAL in CTE. */

/* ============================================================
   SECTION D: TOP-N PER GROUP (25)
   ------------------------------------------------------------ */
/* Q76. Per customer, top 3 orders by net_total. */
/* Q77. Per customer, latest 5 orders. */
/* Q78. Per customer, first 3 orders. */
/* Q79. Per region, top 5 stores by revenue. */
/* Q80. Per category, top 3 products by units. */
/* Q81. Per brand, top 5 products by sales. */
/* Q82. Per agent, top 3 tickets by priority. */
/* Q83. Per platform, top 5 campaigns by ROI. */
/* Q84. Per supplier, 3 most recent shipments. */
/* Q85. Per warehouse, top 5 products by quantity. */
/* Q86. Per dept, top 3 highest paid employees. */
/* Q87. Per store, employee with most tickets. */
/* Q88. Per call_reason, longest call. */
/* Q89. Per session, the URL visited last. */
/* Q90. Per cohort, top customer LTV. */
/* Q91. Per region, top 3 cities by orders. */
/* Q92. Per tier, top 5 by spend. */
/* Q93. Per category, top 3 brands by sales. */
/* Q94. Per warehouse, oldest snapshot. */
/* Q95. Per courier, fastest shipment. */
/* Q96. Per campaign, top attribution day. */
/* Q97. Per customer, last interaction (any source). */
/* Q98. Per product, first-buyer. */
/* Q99. Per agent, first-resolved ticket. */
/* Q100. Per region per month, top store. */

/* ============================================================
   END OF Subqueries Part 2 (Correlated & LATERAL) - EASY LEVEL (100 QUESTIONS)
============================================================ */
