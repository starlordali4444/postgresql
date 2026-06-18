/* ============================================================
   SQL PRACTICE SET - Aggregate Functions & Grouping (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Aggregates & GROUP BY - advanced
   Database:     RetailMart V3

   Scope (HARD):
     - PERCENTILE_CONT / PERCENTILE_DISC (median, P90, P99)
     - ARRAY_AGG / STRING_AGG / JSON_AGG / JSONB_OBJECT_AGG
     - CUBE / ROLLUP / GROUPING SETS deep
     - GROUPING() function
     - DISTINCT inside aggregates
     - FILTER + multi-condition aggregation
     - Custom aggregate via CASE
     - HAVING with subqueries
     - BIT_AND / BOOL_AND / BOOL_OR

   Structure: 25 Conceptual + 25 Percentile/Stats + 25 GROUPING SETS/CUBE/ROLLUP + 25 ARRAY/STRING/JSON_AGG
   ============================================================ */

/* ============================================================
   SECTION A: AGGREGATES - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Compare PERCENTILE_CONT vs PERCENTILE_DISC - which interpolates? */
/* Q2.  Why does median require WITHIN GROUP (ORDER BY ...)? */
/* Q3.  What is an "ordered-set aggregate" in PostgreSQL? */
/* Q4.  Explain how PERCENTILE_CONT(0.5) computes median for even-count groups (interpolates). */
/* Q5.  Compare MODE() WITHIN GROUP vs custom CASE-COUNT logic. */
/* Q6.  What does ROLLUP(a, b, c) produce - listed subtotals. */
/* Q7.  What does CUBE(a, b, c) produce - all 2^3 subtotal combinations. */
/* Q8.  GROUPING SETS - when is it more flexible than CUBE/ROLLUP? */
/* Q9.  GROUPING(col) function - how to read 1/0 in subtotal rows. */
/* Q10. ARRAY_AGG(col ORDER BY ...) - what's stored vs unordered? */
/* Q11. STRING_AGG(col, ',' ORDER BY col) - when ORDER BY is non-deterministic. */
/* Q12. JSON_AGG vs JSONB_AGG - when each. */
/* Q13. JSONB_OBJECT_AGG - build a key->value map from rows. */
/* Q14. ARRAY_AGG(DISTINCT col) - when DISTINCT matters. */
/* Q15. SUM(DISTINCT col) - uncommon but valid case. */
/* Q16. Explain FILTER WHERE - when this is cleaner than CASE WHEN ... THEN ... END. */
/* Q17. Multi-FILTER in one aggregate row: COUNT(*) FILTER WHERE A, COUNT(*) FILTER WHERE B. */
/* Q18. BIT_AND / BIT_OR - when does bit-aggregation matter (flags). */
/* Q19. BOOL_AND / BOOL_OR - used for "all-or-any" group checks. */
/* Q20. HAVING with subquery - can it reference outer GROUP BY columns? */
/* Q21. Why does GROUP BY GROUPING SETS((a), (b)) produce 2 reports in one query? */
/* Q22. Explain DISTINCT ON inside aggregation contexts. */
/* Q23. What does AVG(NULL, NULL, 5) return in Postgres? (Skips NULLs.) */
/* Q24. Why does SUM() on an empty set return NULL but COUNT() return 0? */
/* Q25. ORDER BY inside aggregate (ARRAY_AGG col ORDER BY ...) - execution model. */

/* ============================================================
   SECTION B: PERCENTILES & STATISTICAL AGGREGATES (25)
   ------------------------------------------------------------ */
/* Q26. Median order net_total. */
/* Q27. P90 order net_total. */
/* Q28. P99 order net_total. */
/* Q29. Median, P90, P99 in one row. */
/* Q30. Median resolution_time per ticket priority. */
/* Q31. Median time-to-deliver per courier. */
/* Q32. P95 call_duration per call_reason. */
/* Q33. P99 page_view dwell time per device_type. */
/* Q34. Median product price per brand. */
/* Q35. Median pay_slip gross_salary per dept. */
/* Q36. STDDEV salary per dept. */
/* Q37. STDDEV ad spend per platform. */
/* Q38. VARIANCE order net_total per status. */
/* Q39. MIN, MAX, AVG, MEDIAN per store. */
/* Q40. Quartiles (P25, P50, P75) of order_total per region. */
/* Q41. MODE() WITHIN GROUP - most-frequent order_status. */
/* Q42. MODE() WITHIN GROUP - most-frequent city per tier. */
/* Q43. PERCENT_RANK preview: identify orders in top 10% by net_total. */
/* Q44. CUME_DIST preview: cumulative distribution of order_total. */
/* Q45. Range (MAX - MIN) of order_total per region. */
/* Q46. Coefficient of variation = STDDEV / AVG. */
/* Q47. Skewness check: AVG vs MEDIAN per category (proxy: comparing means). */
/* Q48. P95 vs MAX delivery_days - outlier detection. */
/* Q49. Median revenue per fiscal quarter. */
/* Q50. PERCENTILE_DISC vs PERCENTILE_CONT comparison on the same set. */

/* ============================================================
   SECTION C: GROUPING SETS / CUBE / ROLLUP (25)
   ------------------------------------------------------------ */
/* Q51. ROLLUP(region, status): per-region+status counts + per-region subtotal + grand total. */
/* Q52. CUBE(device_type, os): all 2^2 subtotal combinations. */
/* Q53. GROUPING SETS((priority), (status)): two reports in one query. */
/* Q54. ROLLUP(year, month) for monthly revenue + yearly subtotals + grand total. */
/* Q55. CUBE(brand_id, category_id): full cross-tabulation of brand x category. */
/* Q56. GROUPING SETS((cust_tier, region), (cust_tier), ()): hierarchical revenue report. */
/* Q57. ROLLUP(dept, role) for employee counts + dept subtotals + grand total. */
/* Q58. Use GROUPING(col) to label subtotal rows clearly. */
/* Q59. Filter only subtotal rows: WHERE GROUPING(col) = 1. */
/* Q60. ROLLUP(region, store): regional + store-level summaries. */
/* Q61. CUBE(payment_method, status): all combinations of payment+status counts. */
/* Q62. GROUPING SETS for marketing dashboard: campaign-level + platform-level + grand total. */
/* Q63. ROLLUP(supplier, product): supplier-level + product-level inventory totals. */
/* Q64. ROLLUP(year, quarter) - fiscal report. */
/* Q65. CUBE(brand, region, category): 3-dim subtotals. */
/* Q66. GROUPING SETS with empty (): include grand-total row. */
/* Q67. ORDER BY with GROUPING() puts subtotals at the bottom. */
/* Q68. ROLLUP-based "P&L hierarchy" report: cat -> subcat -> grand. */
/* Q69. CUBE-based "matrix" report: row=region, col=channel. */
/* Q70. GROUPING SETS to merge "by tier" and "by year" in one result. */
/* Q71. Replace 3 UNION ALL queries with 1 GROUPING SETS query. */
/* Q72. Show GROUPING IDs (binary) for each row in a CUBE. */
/* Q73. Top-N within each grouping level (combine ROLLUP + windows preview). */
/* Q74. Conditional subtotal label using CASE + GROUPING(). */
/* Q75. Per region per quarter, count orders + subtotal per region + grand total. */

/* ============================================================
   SECTION D: ARRAY/STRING/JSON_AGG + custom aggregates (25)
   ------------------------------------------------------------ */
/* Q76. Per category, ARRAY_AGG(product_name) - list every product. */
/* Q77. Per region, ARRAY_AGG(store_name ORDER BY store_name). */
/* Q78. Per customer, ARRAY_AGG(order_id ORDER BY order_date DESC). */
/* Q79. Per dept, STRING_AGG(employee_name, ', ' ORDER BY hire_date). */
/* Q80. Per priority, STRING_AGG(ticket_subject, ' | ' ORDER BY created_date DESC) LIMIT-style. */
/* Q81. Per courier, JSON_AGG(JSON_BUILD_OBJECT('shipment_id', s, 'date', d)). */
/* Q82. Per campaign, JSONB_OBJECT_AGG(platform, total_spend). */
/* Q83. Per customer, JSON_AGG(orders) returning a JSON array. */
/* Q84. Per category, ARRAY_AGG(DISTINCT brand_name). */
/* Q85. Per agent, JSONB_AGG(JSON_BUILD_OBJECT('ticket', id, 'status', status)). */
/* Q86. Per store, ARRAY_AGG(role) FILTER WHERE active. */
/* Q87. Per session, ARRAY_AGG(url ORDER BY view_time) - clickstream. */
/* Q88. Per warehouse, ARRAY_AGG(product_id) FILTER WHERE quantity_on_hand < 10. */
/* Q89. Per call_reason, STRING_AGG(transcript_summary, ' --- ' ORDER BY call_date DESC). */
/* Q90. Per tier, ARRAY_AGG(member_email). */
/* Q91. BIT_OR(flags) - combine bit flags per group. */
/* Q92. BOOL_OR(is_premium) - does this group have any premium customer. */
/* Q93. BOOL_AND(is_compliant) - group fully compliant flag. */
/* Q94. Custom percent: SUM(CASE WHEN x THEN 1 ELSE 0 END) * 100.0 / COUNT(*) per group. */
/* Q95. Custom running total via CASE-CUM inside ARRAY_AGG (preview). */
/* Q96. Build a hash of group via md5(STRING_AGG(col, ',' ORDER BY col)). */
/* Q97. Build a "set diff" using two ARRAY_AGGs and array operators. */
/* Q98. ARRAY_AGG combined with WITH ORDINALITY: preserve original order. */
/* Q99. JSON_AGG to build a nested structure for an API response. */
/* Q100. Per customer, JSONB_BUILD_OBJECT('orders', JSON_AGG(...), 'reviews', JSON_AGG(...)) - full customer card. */

/* ============================================================
   END OF Aggregate Functions & Grouping - HARD LEVEL (100 QUESTIONS)
============================================================ */
