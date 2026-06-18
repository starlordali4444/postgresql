/* ============================================================
   SQL PRACTICE SET - JOINs Part 1 (Foundations) (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JOINs Part 1 - deeper INNER, LEFT, anti-joins
   Database:     RetailMart V3

   Scope (deeper than Easy):
     - JOIN gotchas: ON vs WHERE, fan-out, NULL behavior
     - Multi-table chains (3-5 tables)
     - JOIN + GROUP BY + HAVING combinations
     - Anti-join variations (LEFT + IS NULL, NOT EXISTS preview)
     - LEFT JOIN preserving rows while computing aggregates

   Structure: 25 Conceptual + 25 INNER JOIN w/ filter+group + 25 LEFT edge cases + 25 Multi-table chains
   ============================================================ */

/* ============================================================
   SECTION A: JOIN DEEPER - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why does putting a right-table filter in WHERE silently turn a LEFT JOIN into an INNER JOIN? */
/* Q2.  What is "fan-out" in JOINs - and how do you detect it? */
/* Q3.  Why does COUNT(*) on a LEFT JOIN over-count when measuring left rows? */
/* Q4.  Compare COUNT(left.id) vs COUNT(DISTINCT left.id) vs COUNT(*) in a LEFT JOIN. */
/* Q5.  Does JOIN order (A JOIN B JOIN C vs A JOIN C JOIN B) affect the RESULT? Performance? */
/* Q6.  Compare JOIN ... ON vs JOIN ... USING - which collapses the duplicate column in the result? */
/* Q7.  Why is `JOIN orders ON 1 = 1` not the same as CROSS JOIN - what does it produce? */
/* Q8.  When does an INNER JOIN drop rows you didn't expect - name three causes. */
/* Q9.  Explain how a LEFT JOIN handles three rows in the left and one in the right matching one of them. */
/* Q10. Why does ANSI SQL recommend explicit JOIN syntax over comma-separated FROM clauses? */
/* Q11. What is a "Cartesian explosion" and how do you accidentally cause one? */
/* Q12. Compare LEFT JOIN + WHERE right.key IS NULL vs NOT EXISTS - which is more readable, which is faster? */
/* Q13. Why does the PostgreSQL planner choose Hash Join vs Nested Loop based on row counts? */
/* Q14. When does INNER JOIN's row count equal the smaller table's row count - and when does it not? */
/* Q15. Why is `JOIN customers c1 JOIN customers c2 ON c1.id != c2.id` typically an interview red flag? */
/* Q16. Explain why aliases (e1/e2/c1/c2) are MANDATORY in self-joins. */
/* Q17. Compare INNER JOIN vs SEMI JOIN (which PostgreSQL implements via EXISTS internally). */
/* Q18. What is an "anti semi join"? When does PostgreSQL use it? */
/* Q19. Why is the result of a JOIN with NULL keys deterministic - they never match? */
/* Q20. Explain why JOIN order matters less when JOINs are INNER but more for OUTER JOINs. */
/* Q21. What does "EQUI JOIN" mean vs "non-equi JOIN"? Give a real RetailMart non-equi example. */
/* Q22. Why is `LEFT JOIN ... ON a.x = b.x AND b.y = 5` different from `LEFT JOIN ... ON a.x = b.x WHERE b.y = 5`? */
/* Q23. Compare USING (col) vs NATURAL JOIN - and why NATURAL JOIN is dangerous. */
/* Q24. How does the GROUP BY interact with multi-table JOINs - what counts as a "row" being grouped? */
/* Q25. Why must INNER JOIN with aggregates often be wrapped in a CTE for readability? */

/* ============================================================
   SECTION B: INNER JOIN + FILTER + GROUP BY (25)
   ------------------------------------------------------------ */
/* Q26. Per region (via stores), COUNT orders + SUM net_total. */
/* Q27. Per category, COUNT products. */
/* Q28. Per dim_brand, COUNT products + AVG price. */
/* Q29. Per dim_department, COUNT employees + AVG salary. */
/* Q30. Per tier (from loyalty.tiers JOIN loyalty.members), COUNT members + AVG points_balance. */
/* Q31. Per customer (JOIN orders), COUNT lifetime orders + SUM total spend. */
/* Q32. Per support agent (JOIN tickets), COUNT tickets resolved + AVG resolution time. */
/* Q33. Per product, SUM quantity sold (JOIN order_items). */
/* Q34. Per region (3-table JOIN: orders -> stores -> regions), SUM revenue. */
/* Q35. Per warehouse, SUM quantity_on_hand (JOIN inventory_snapshots latest). */
/* Q36. Per supplier (JOIN supply_chain.shipments), SUM quantity shipped. */
/* Q37. Per category (JOIN products -> dim_brand -> dim_category), SUM revenue from order_items. */
/* Q38. Per month + region (JOIN orders + stores + region + DATE_TRUNC), SUM net_total. */
/* Q39. Per courier_name (JOIN shipments -> orders), AVG delivery duration. */
/* Q40. Per agent_id (JOIN call_center.calls -> stores.employees), total call_duration. */
/* Q41. Per warehouse (3-table JOIN), TOP 3 products by quantity_on_hand. (Window function preview.) */
/* Q42. Per dim_department + store_id, COUNT employees + AVG salary. */
/* Q43. Per page_view device_type + customer's tier (JOIN page_views -> customers), COUNT page_views. */
/* Q44. Per platform + month (JOIN ads_spend -> campaigns), SUM amount. */
/* Q45. Per category + ticket_status (JOIN tickets), COUNT. */
/* Q46. Per ticket category + day_of_week (JOIN nothing - single table CASE), COUNT. */
/* Q47. Per region (JOIN dim_region -> stores -> orders), TOP 10 by revenue. */
/* Q48. Per brand_name (JOIN brand -> products -> order_items), SUM net_amount. */
/* Q49. Per category_name (JOIN to dim_category), SUM revenue. */
/* Q50. Per region_name + tier (JOIN orders, stores, regions, customers), COUNT distinct customers. */

/* ============================================================
   SECTION C: LEFT JOIN EDGE CASES + ANTI-JOIN (25)
   ------------------------------------------------------------ */
/* Q51. Show ALL departments with COUNT of employees (departments with 0 should appear as 0). */
/* Q52. Show ALL brands with COUNT of products. */
/* Q53. Show ALL stores with COUNT of orders (zero-order stores should appear as 0). */
/* Q54. Show ALL customers with COUNT of orders (use LEFT JOIN + COUNT right table column). */
/* Q55. Show ALL products with SUM of net_amount from order_items (zero-sale products show 0). */
/* Q56. Show ALL tiers with COUNT of members. */
/* Q57. Show ALL employees with COUNT of resolved tickets. */
/* Q58. Show ALL customers with COUNT of reviews (zero-review customers show 0). */
/* Q59. Show ALL regions with SUM revenue (zero-revenue regions appear with 0). */
/* Q60. Show ALL warehouses with SUM(quantity_on_hand). */
/* Q61. Show ALL campaigns with SUM ad_spend amount. */
/* Q62. Find customers who NEVER placed an order (anti-join). */
/* Q63. Find products NEVER ordered. */
/* Q64. Find stores with NO orders ever. */
/* Q65. Find brands with NO products. */
/* Q66. Find suppliers whose products were NEVER ordered (3-table anti-join). */
/* Q67. Find employees who NEVER appeared in support.tickets as agent. */
/* Q68. Find customers who placed orders but NEVER wrote a review. */
/* Q69. Find customers who NEVER had any interaction (orders, reviews, tickets, calls). */
/* Q70. Find orders with NO shipment record. */
/* Q71. Find orders with NO payment record. */
/* Q72. Find tickets that were NEVER assigned to an agent (agent_id IS NULL). */
/* Q73. Find warehouses that NEVER received a supply_chain.shipment. */
/* Q74. Find products that have inventory_snapshots but NO recent shipments (90 days). */
/* Q75. Find customers in loyalty.members but with NO redemptions. */

/* ============================================================
   SECTION D: MULTI-TABLE CHAINS (4-5 TABLES) (25)
   ------------------------------------------------------------ */
/* Q76. Order receipt: order_id, customer name, store name, product name, qty, amount (5 tables). */
/* Q77. Per customer, total spend + count of distinct stores ordered from (3 tables). */
/* Q78. Per region, count distinct customers, count distinct stores, sum revenue (4 tables). */
/* Q79. Per category, top product by units sold (5 tables + window preview). */
/* Q80. Per ticket, customer name + agent name + store of agent (4 tables). */
/* Q81. Per call, customer name + agent name + agent's store (4 tables). */
/* Q82. Per work_order, product name + production line name + days to complete (3 tables). */
/* Q83. Per page_view, customer first_name + os + device_type (2 tables - single JOIN). */
/* Q84. Per ad_spend, campaign_name + spend month + platform (2 tables). */
/* Q85. Per refund (return), order_date + customer name + product name (4 tables). */
/* Q86. Per shipment, courier_name + order's customer + store city (4 tables). */
/* Q87. Per pay_slip, employee name + department name + store_name (3 tables). */
/* Q88. Per loyalty member, customer name + tier name + lifetime orders (4 tables). */
/* Q89. Per expense, expense category name + amount + month (2 tables). */
/* Q90. Per inventory snapshot, warehouse name + product name + brand name + category name (5 tables). */
/* Q91. Per supplier, product count + supplier city + total quantity_shipped (3 tables). */
/* Q92. Customer 360deg: customer name, lifetime orders, total spend, count of reviews, count of tickets (4 LEFT JOINs + aggregates). */
/* Q93. Store 360deg: store name, region name, employee count, order count, revenue (5 tables - handle fan-out with subqueries). */
/* Q94. Per agent_id, count tickets handled + count calls handled (UNION of two sources) - preview Day 11. */
/* Q95. Top 10 categories by revenue (5 tables: order_items -> products -> dim_brand -> dim_category + orders). */
/* Q96. Top 10 cities by total customer spend (4 tables). */
/* Q97. Top 10 suppliers by total quantity shipped to warehouses (3 tables). */
/* Q98. Per audit.api_requests endpoint, COUNT + AVG response_time (single table - but include AVG of response_time_ms grouped). */
/* Q99. Per call_reason, AVG sentiment_score from transcripts (3 tables: calls, transcripts, sentiment scope). */
/* Q100. Full order trace: order_id + customer + store + payment + shipment + first item product (6 tables, mix INNER + LEFT). */

/* ============================================================
   END OF JOINs Part 1 (Foundations) - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
