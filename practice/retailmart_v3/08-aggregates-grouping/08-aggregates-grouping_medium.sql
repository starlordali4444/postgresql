/* ============================================================
   SQL PRACTICE SET - Aggregate Functions & Grouping (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Aggregate Functions & GROUP BY - deeper patterns
   Database:     RetailMart V3

   Scope (deeper than Easy):
     - Conditional aggregation (CASE inside SUM/COUNT/AVG)
     - Multi-column GROUP BY
     - Complex HAVING predicates
     - DATE_TRUNC group keys (monthly/weekly/quarterly)
     - DISTINCT inside aggregates
     - FILTER clause (PostgreSQL specific)
     - ROLLUP / CUBE / GROUPING SETS intro

   Structure: 25 Conceptual + 25 Conditional Aggregation + 25 Multi-key GROUP BY + 25 HAVING/FILTER/GROUPING SETS
   ============================================================ */

/* ============================================================
   SECTION A: AGGREGATE DEEPER - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Difference between COUNT(*), COUNT(col), COUNT(DISTINCT col) - give a row-set example for each. */
/* Q2.  Why does SUM(CASE WHEN x = 'A' THEN amount END) work for filtered sums while WHERE doesn't (in the same statement)? */
/* Q3.  Compare AVG(col) vs AVG(COALESCE(col, 0)) - when do they give different answers? */
/* Q4.  What's the difference between SUM(amount) and SUM(DISTINCT amount)? */
/* Q5.  Explain what FILTER (WHERE ...) does - and how it compares to CASE inside aggregates. */
/* Q6.  What happens to SUM/AVG/COUNT when the WHERE eliminates ALL rows - is the result NULL or 0? */
/* Q7.  Why must non-aggregated columns appear in GROUP BY? Show what happens if you forget. */
/* Q8.  Can you GROUP BY an expression (DATE_TRUNC(...))? Show example. */
/* Q9.  Compare GROUP BY col vs GROUP BY 1 - when is each safer? */
/* Q10. Explain HAVING vs WHERE again - but with a CASE-driven aggregate example. */
/* Q11. What does GROUP BY ROLLUP(a, b) produce that GROUP BY a, b does not? */
/* Q12. Compare GROUP BY CUBE vs GROUP BY ROLLUP - which produces MORE subtotal rows? */
/* Q13. What is GROUPING SETS - and when do you need it over CUBE/ROLLUP? */
/* Q14. Explain the GROUPING() function - what does GROUPING(col) return for subtotal rows? */
/* Q15. Why is `SELECT col, COUNT(*) FROM t` without GROUP BY an error if col isn't aggregated? */
/* Q16. Can ORDER BY reference an aggregate alias? Compare with HAVING. */
/* Q17. What's the difference between PERCENTILE_CONT and PERCENTILE_DISC? (Brief - full coverage Day 22.) */
/* Q18. Why is GROUP BY on a TIMESTAMP column rarely useful - and what's the standard fix? */
/* Q19. What does ARRAY_AGG do - give a use case. */
/* Q20. Difference between STRING_AGG and ARRAY_AGG. */
/* Q21. What does JSON_AGG produce - and when is it useful for APIs? */
/* Q22. Why does COUNT(*) often outperform COUNT(col) in PostgreSQL? */
/* Q23. Explain the "1 + GROUP BY trick" (SELECT 1 FROM t GROUP BY ...). When is this used? */
/* Q24. What is BIT_AND / BIT_OR / BOOL_AND / BOOL_OR? Give a use case for BOOL_OR. */
/* Q25. Why is GROUP BY + ORDER BY + LIMIT often a complete reporting unit? */

/* ============================================================
   SECTION B: CONDITIONAL AGGREGATION (25)
   ------------------------------------------------------------ */
/* Q26. Per order_status: COUNT(*) AND SUM(net_total) in one row using GROUP BY. */
/* Q27. Single-row summary: COUNT(*) for each status using SUM(CASE WHEN status='X' THEN 1 END). */
/* Q28. Total delivered revenue + total cancelled count in ONE row using conditional SUM/COUNT. */
/* Q29. Per customer tier, count customers AND average tenure in years. */
/* Q30. Per ticket priority, count tickets + average resolution time in hours. */
/* Q31. Per device_type, count page_views + count distinct customer_id (excludes NULL anonymous). */
/* Q32. Per role, count employees + average salary + max salary + min salary. */
/* Q33. Per call_reason, count + average call_duration + count of long calls (> 300s). */
/* Q34. Per brand_id, count products + count premium products (price > 1000) + average price. */
/* Q35. Per category (support tickets), count + percent resolved (use CASE + COUNT). */
/* Q36. Per registration year, count new customers + count of Gold/Platinum. */
/* Q37. Per region, count stores + count distinct cities. */
/* Q38. Single row: count distinct customer_ids in sales.orders AND in customers.reviews AND in support.tickets. */
/* Q39. Single row: count of orders by status using FILTER (WHERE ...) - 4 columns: delivered_count, cancelled_count, pending_count, total_count. */
/* Q40. Per platform (ads_spend), SUM amount + COUNT rows + AVG amount per spend record. */
/* Q41. Per ad campaign month, SUM ad spend + COUNT campaigns active. */
/* Q42. Per exp_cat_id, SUM amount + COUNT + AVG + STDDEV (variance check on expenses). */
/* Q43. Per pay_slip salary_month, SUM gross_salary + SUM net_salary + SUM income_tax. */
/* Q44. Per work_order line_id, SUM quantity_produced + SUM rejected_quantity + rejection rate %. */
/* Q45. Per warehouse, SUM quantity_on_hand from inventory_snapshots (latest snapshot only). */
/* Q46. Per supplier_id, COUNT products + AVG price + MAX price + MIN price. */
/* Q47. Per loyalty tier, COUNT members + AVG points_balance + MAX points_balance. */
/* Q48. Per support category, percentage of Open tickets (FILTERED count / total). */
/* Q49. Per page_view URL, count distinct customer_id + count distinct session_id. */
/* Q50. Per device_type + os combination, COUNT page_views. */

/* ============================================================
   SECTION C: MULTI-COLUMN GROUP BY + DATE BUCKETS (25)
   ------------------------------------------------------------ */
/* Q51. Per order_status AND month, COUNT orders + SUM net_total. */
/* Q52. Per customer tier AND registration year, COUNT customers. */
/* Q53. Per ticket priority AND status, COUNT tickets. */
/* Q54. Per device_type AND month, COUNT page_views. */
/* Q55. Per platform AND month, SUM ads_spend amount. */
/* Q56. Per role AND store_id, COUNT employees + AVG salary. */
/* Q57. Per brand_id AND is_premium (price > 1000), COUNT products. */
/* Q58. Per call_reason AND status, COUNT calls + SUM duration. */
/* Q59. Per campaign year AND quarter, SUM budget. */
/* Q60. Per shipment courier_name AND month, COUNT shipments. */
/* Q61. Per attendance year AND month, COUNT records + SUM (check_out - check_in) duration. */
/* Q62. Per orders status AND store, COUNT + SUM net_total. */
/* Q63. Per customer city AND tier, COUNT customers. */
/* Q64. Per refund reason AND month, COUNT returns + SUM refund_amount. */
/* Q65. Per priority AND week (DATE_TRUNC('week', created_date)), COUNT tickets. */
/* Q66. Per HTTP method AND status_code class (2xx/3xx/etc.), COUNT api_requests. */
/* Q67. Per app log level AND service_name, COUNT logs. */
/* Q68. Per region AND week, COUNT stores opened. */
/* Q69. Per fiscal_quarter (custom CASE) + brand_id, COUNT products. */
/* Q70. Per shift (CASE on EXTRACT(HOUR)) + day_of_week, COUNT calls. */
/* Q71. Per supplier_id + warehouse_id, SUM quantity from supply_chain.shipments. */
/* Q72. Per work_orders.line_id + status, COUNT + SUM quantity_produced. */
/* Q73. Per exp_cat_id + month, SUM amount. */
/* Q74. Per loyalty.tier_id + month-of-join, COUNT members. */
/* Q75. Per pay_slip salary_year + salary_month, SUM gross_salary across all employees. */

/* ============================================================
   SECTION D: HAVING / FILTER / GROUPING SETS (25)
   ------------------------------------------------------------ */
/* Q76. Show order_statuses with > 1000 orders AND SUM(net_total) > 5,000,000 (multi-condition HAVING). */
/* Q77. Show customers (GROUPed by customer_id from orders) who placed > 10 orders. */
/* Q78. Show product_ids in order_items with SUM(quantity) > 100. */
/* Q79. Show employees with SUM(salary across pay_slips) > 1,000,000 (HAVING on aggregated payroll). */
/* Q80. Show platforms in ads_spend with AVG(amount) > 5000 and COUNT > 10. */
/* Q81. Show brands with > 50 products AND AVG(price) BETWEEN 1000 AND 10000. */
/* Q82. Show stores in cities with COUNT >= 3 stores (cities to consolidate). */
/* Q83. Show tier_id from loyalty.members with > 1000 members AND AVG(points_balance) > 500. */
/* Q84. Show categories of tickets with COUNT > 500 AND resolution_rate < 50% (HAVING using CASE-COUNT ratio). */
/* Q85. Show months with > 10000 orders AND SUM(net_total) > 50,000,000. */
/* Q86. Using FILTER: count orders per status in a single row (Delivered, Cancelled, Pending, etc.) */
/* Q87. Using FILTER: count distinct customers per tier in one row of 4 columns. */
/* Q88. Using FILTER: SUM revenue per region in one row. */
/* Q89. Using ROLLUP: per order_status and month, SUM + subtotals per status + grand total. */
/* Q90. Using CUBE: per device_type AND os, COUNT page_views + all subtotals + grand total. */
/* Q91. Using GROUPING SETS: separately group by (tier) AND (registration_year) - two reports in one query. */
/* Q92. ROLLUP on (dept_id, role) for employee counts. */
/* Q93. Use GROUPING() to identify subtotal rows in a ROLLUP output. */
/* Q94. Combine FILTER + GROUP BY: per region, count delivered orders AND cancelled orders. */
/* Q95. Per platform, SUM amount FILTER WHERE spend_date >= '2025-01-01'. */
/* Q96. Per product brand, count of 5-star reviews (FILTER WHERE rating = 5). */
/* Q97. Use STRING_AGG with GROUP BY: per category, comma-separated list of ticket subjects (latest 5). */
/* Q98. Per region, top-3 stores by SUM(net_total) - needs a window function (peek at Day 16). */
/* Q99. Per customer tier, MAX, MIN, AVG of points_balance from loyalty.members. */
/* Q100. Per ticket category, percent of tickets handled by 'High' priority + percent by 'Critical' - using FILTER counts divided by total. */

/* ============================================================
   END OF Aggregate Functions & Grouping - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
