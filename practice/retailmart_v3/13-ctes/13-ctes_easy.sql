/* ============================================================
   SQL PRACTICE SET - CTEs (WITH, non-recursive) (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        CTEs (WITH) - non-recursive
   Database:     RetailMart V3

   Scope:
     - WITH x AS (...) SELECT FROM x
     - Multiple CTEs in one query
     - CTE vs subquery
     - MATERIALIZED / NOT MATERIALIZED
     - Writeable CTEs (preview)

   Structure: 25 Conceptual + 25 Single CTE + 25 Multi-CTE + 25 CTE + DML
   ============================================================ */

/* ============================================================
   SECTION A: CTE - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What is a CTE? */
/* Q2.  Compare CTE vs derived table. */
/* Q3.  Why are CTEs called "named subqueries"? */
/* Q4.  Can a CTE be referenced multiple times? */
/* Q5.  CTE scope - only the current SQL statement. */
/* Q6.  When does Postgres inline CTE vs materialize? */
/* Q7.  MATERIALIZED keyword (PG12+). */
/* Q8.  NOT MATERIALIZED keyword. */
/* Q9.  Multiple CTEs separated by comma. */
/* Q10. CTE referencing earlier CTE. */
/* Q11. Recursive CTE syntax (preview). */
/* Q12. CTE vs view - when each. */
/* Q13. CTE vs materialized view. */
/* Q14. CTE inside view. */
/* Q15. CTE inside function. */
/* Q16. CTE in DML (INSERT/UPDATE/DELETE). */
/* Q17. CTE with column list aliasing. */
/* Q18. CTE with derived computation. */
/* Q19. CTE with GROUP BY. */
/* Q20. CTE with HAVING. */
/* Q21. CTE with ORDER BY + LIMIT. */
/* Q22. CTE with window function. */
/* Q23. CTE with JOIN inside. */
/* Q24. CTE with UNION. */
/* Q25. CTE with INTERSECT/EXCEPT. */

/* ============================================================
   SECTION B: SINGLE-CTE QUERIES (25)
   ------------------------------------------------------------ */
/* Q26. Top 10 customers by spend (CTE). */
/* Q27. Top 10 products by units sold (CTE). */
/* Q28. Top 10 stores by revenue (CTE). */
/* Q29. Top 5 brands (CTE). */
/* Q30. Top 5 categories (CTE). */
/* Q31. Per region orders count (CTE). */
/* Q32. Per dept employee count (CTE). */
/* Q33. Per tier member count (CTE). */
/* Q34. Per warehouse SUM(qty) (CTE). */
/* Q35. Per courier shipment count (CTE). */
/* Q36. Customers with > 10 orders (CTE + filter). */
/* Q37. Products with > 5 reviews (CTE + filter). */
/* Q38. Above-average orders (CTE + comparison). */
/* Q39. Below-median orders (CTE + percentile). */
/* Q40. Outliers (CTE + z-score). */
/* Q41. Latest order per customer (CTE + DISTINCT ON). */
/* Q42. Latest review per product (CTE + ROW_NUMBER). */
/* Q43. Latest pay_slip per employee (CTE). */
/* Q44. Latest snapshot per warehouse-product (CTE). */
/* Q45. Latest shipment per courier (CTE). */
/* Q46. First-order date per customer (CTE). */
/* Q47. First-review date per product (CTE). */
/* Q48. Active customers in last 30 days (CTE). */
/* Q49. New customers this month (CTE). */
/* Q50. Churned customers (CTE). */

/* ============================================================
   SECTION C: MULTI-CTE QUERIES (25)
   ------------------------------------------------------------ */
/* Q51. orders_agg + revs_agg -> JOIN customer. */
/* Q52. orders_agg + tickets_agg -> customer 360deg. */
/* Q53. spend_per_cust + tier_lookup -> segment. */
/* Q54. revenue_per_region + region_dim -> label. */
/* Q55. revenue_per_brand + brand_dim -> label. */
/* Q56. inventory_levels + product_dim -> label. */
/* Q57. agent_workload + employee_dim -> label. */
/* Q58. courier_perf + courier_dim. */
/* Q59. cohort_signup + cohort_first_order. */
/* Q60. churned_customers + win_back_targets. */
/* Q61. monthly_rev + monthly_cost -> profit. */
/* Q62. monthly_orders + monthly_churn -> growth. */
/* Q63. top_products + their_brands -> cross. */
/* Q64. top_customers + their_orders -> cross. */
/* Q65. top_brands + their_categories -> cross. */
/* Q66. agent_stats + customer_stats -> match. */
/* Q67. supplier_stats + product_stats -> cross. */
/* Q68. warehouse_stats + inventory_stats -> join. */
/* Q69. region_stats + city_stats -> roll up. */
/* Q70. tier_stats + lifecycle_stats -> cross. */
/* Q71. 3-CTE chain: A -> B -> C. */
/* Q72. 4-CTE chain: A -> B -> C -> D. */
/* Q73. 5-CTE chain. */
/* Q74. Chain referencing each previous. */
/* Q75. Chain with UNION across CTEs. */

/* ============================================================
   SECTION D: WRITEABLE CTEs (DML) (25)
   ------------------------------------------------------------ */
/* Q76. WITH d AS (DELETE ... RETURNING *) INSERT INTO archive SELECT * FROM d. */
/* Q77. WITH ins AS (INSERT ...) SELECT * FROM ins. */
/* Q78. WITH upd AS (UPDATE ...) SELECT * FROM upd. */
/* Q79. Multi-step: WITH a (INSERT) WITH b (DELETE) UNION ALL. */
/* Q80. CTE + RETURNING captures id. */
/* Q81. CTE-DML chain: customer -> loyalty member. */
/* Q82. CTE-DML chain: order -> audit_log. */
/* Q83. CTE-DML chain: refund -> archive. */
/* Q84. CTE-DML chain: signup -> welcome email. */
/* Q85. CTE-DML chain: cancel -> audit. */
/* Q86. CTE for batched DELETE. */
/* Q87. CTE for batched UPDATE. */
/* Q88. CTE for batched INSERT. */
/* Q89. CTE for dedup INSERT. */
/* Q90. CTE for merge-style UPSERT. */
/* Q91. CTE for soft-delete + audit. */
/* Q92. CTE for state transition + audit. */
/* Q93. CTE for tier upgrade. */
/* Q94. CTE for loyalty redemption. */
/* Q95. CTE for fraud flag + ticket creation. */
/* Q96. CTE for stock decrement + audit. */
/* Q97. CTE for shipment + delivery log. */
/* Q98. CTE for return + refund + audit. */
/* Q99. CTE for campaign close + final attribution. */
/* Q100. Complete order pipeline: order -> payment -> inventory -> shipment via CTEs. */

/* ============================================================
   END OF CTEs (WITH, non-recursive) - EASY LEVEL (100 QUESTIONS)
============================================================ */
