/* ============================================================
   SQL PRACTICE SET - Review & Interview Prep (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Mixed review of Weeks 1-5 topics at interview-hard level
   Database:     RetailMart V3

   Scope (HARD = interview-grade, performance-aware, multi-step):
     - CTE chains with 3+ steps
     - Window function combinations (nested ranks, frame aggregates)
     - Query plan reasoning + index design
     - Statistical aggregates, cohort, funnel, RFM at scale
     - Data quality patterns + reconciliation
   Structure: 25 Conceptual + 25 Advanced joins/CTEs + 25 Analytics & window + 25 Performance & design
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL REVIEW (25)
   ------------------------------------------------------------ */
/* Q1.  What is the difference between RANK() and DENSE_RANK() when two rows tie at position 3? */
/* Q2.  Explain the "window frame" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW vs RANGE BETWEEN. When does RANGE give a different result? */
/* Q3.  A query uses NOT IN (subquery). What happens if the subquery returns even one NULL? Rewrite it safely. */
/* Q4.  What is the difference between a lateral join and a correlated subquery? When is LATERAL more efficient? */
/* Q5.  Why can a query with LIMIT 1 still do a full table scan? What addition fixes this? */
/* Q6.  Explain a hash join vs a merge join: when does PostgreSQL choose each? */
/* Q7.  What is a "covering index" and how would you use one for a common RetailMart query? */
/* Q8.  When does ANALYZE help the query planner? What does it do? */
/* Q9.  What is a partial index? Give a RetailMart use-case where one would dramatically reduce index size. */
/* Q10. What does "seq scan" on a large table in EXPLAIN mean for the query? When is it actually fine? */
/* Q11. Explain the difference between a view and a materialized view from a query-planning perspective. */
/* Q12. What is a BRIN index and for which RetailMart column would you choose it over B-tree? */
/* Q13. Why does GROUP BY an expression (like EXTRACT(YEAR FROM order_date)) prevent index-only scans? */
/* Q14. What is the difference between PERCENTILE_CONT and PERCENTILE_DISC? */
/* Q15. Explain a "funnel with conversion rate" query: how would you handle users who skip steps? */
/* Q16. What is the "cohort triangle" and why are future cells always NULL? */
/* Q17. What is 3NF? Name one table in RetailMart that intentionally violates it for denormalization. */
/* Q18. What is optimistic locking and why might an analyst care? */
/* Q19. What is a "bitmap index scan" in PostgreSQL EXPLAIN output? */
/* Q20. When would you use DISTINCT ON instead of ROW_NUMBER for dedup? What are the tradeoffs? */
/* Q21. Explain the performance risk of a correlated subquery in SELECT over a large dataset. How do you rewrite it? */
/* Q22. What does VACUUM and AUTOVACUUM do in PostgreSQL? Why does it matter post-bulk-load? */
/* Q23. What is "cardinality estimation" in a query plan and why does it affect join order? */
/* Q24. Explain the difference between INTERSECT and an INNER JOIN on the same key. */
/* Q25. What is a "cumulative distribution" and how does CUME_DIST() compute it? */

/* ============================================================
   SECTION B: ADVANCED JOINS, CTEs & SUBQUERIES (25)
   ------------------------------------------------------------ */
/* Q26. The VP of Sales asks: "Which customers bought products from at least 3 different categories in a single order?" Write the query using a CTE and GROUP BY. */
/* Q27. Build a "customer activity heatmap": for each customer, count orders per day-of-week; pivot to 7 columns using FILTER. */
/* Q28. Find the top 3 products by revenue per category that have also received at least 5 reviews with average rating >= 4.0. */
/* Q29. Using a CTE chain, compute: (1) each store's monthly revenue, (2) each store's 3-month moving average revenue, (3) flag stores where the latest month's revenue is below their 3-month MA. */
/* Q30. The Head of Logistics: "Which warehouse-product pairs have inventory below their historical average snapshot quantity?" Use a CTE with window function. */
/* Q31. Find customers who placed their first order within 7 days of registration (using MIN(order_date) grouped by cust_id joined to customers.registration_date). */
/* Q32. The CFO wants a "sales bridge": revenue in January 2025, then monthly deltas to December 2025, ending with a 12-month total. Use LAG and running SUM in a CTE. */
/* Q33. Find all products that are in inventory at a warehouse but whose store has placed zero orders for them in the last 90 days. */
/* Q34. Using a multi-step CTE: compute monthly ticket resolution rate (resolved within 48h), then identify months where this dropped more than 10% from the prior month. */
/* Q35. The Marketing Director: "For each campaign, show the revenue from orders placed within 7 days of the campaign start_date." Join marketing.campaigns to sales.orders on date range. */
/* Q36. Build a "customer segmentation" query: classify customers as 'New' (registered < 6 months ago), 'Active' (ordered in last 30 days), 'Lapsed' (ordered 30-180 days ago), 'Churned' (no order in 180+ days). */
/* Q37. Find employees whose salary (from payroll.pay_slips) has increased every single year in salary_history (strictly monotone). Use a window function approach. */
/* Q38. The Store Ops Manager: "Which stores have a higher return rate than the company-wide average?" Use two CTEs. */
/* Q39. Compute the "product affinity" matrix: for each pair of product categories, how many orders contain items from both? */
/* Q40. Using LATERAL, get each customer's top 3 order items by unit_price * quantity across all orders. */
/* Q41. Find orders where the sum of order_items exceeds the orders.gross_total by more than 1% (reconciliation). */
/* Q42. Build a multi-level CTE: (1) daily page_view counts per customer, (2) 7-day rolling distinct active customers, (3) MAU vs DAU stickiness ratio by month. */
/* Q43. The Compliance Officer wants: all cases where a support ticket was opened and closed on the same day, and the customer placed a return on that same day. */
/* Q44. Find "power customers": those in the top 10% by spend AND top 10% by order frequency AND who have reviewed at least one product. */
/* Q45. Compute each employee's tenure in complete years (from joining_date to today) and their salary per year of tenure. */
/* Q46. Using a CTE, compute the Lorenz curve data points (cumulative % of customers vs cumulative % of revenue) for the first 10 deciles. */
/* Q47. Find stores that have at least one product category where they sell a product but hold zero inventory in their linked warehouse. */
/* Q48. Write a query that computes, for each call center agent, their average handle time and their percentile rank among all agents. */
/* Q49. Find the "cold-start" problem: customers who placed exactly 1 order (ever) and have been inactive for > 90 days. */
/* Q50. Compute weekly order cohort retention for the first 4 weeks (signup_week x weeks_since_signup). */

/* ============================================================
   SECTION C: ANALYTICS & WINDOW FUNCTIONS (25)
   ------------------------------------------------------------ */
/* Q51. Compute a 12-month rolling revenue sum and compare each month's revenue to the 12-month rolling median. */
/* Q52. Build a full RFM model: score each customer 1-5 on Recency, Frequency, and Monetary using NTILE(5), then assign a segment label (Champions / Loyal / At-Risk / Lost / New). */
/* Q53. Compute the "churn rate" per month: customers who ordered in month M-1 but not in month M. */
/* Q54. Show the product price history from audit.record_changes: for each price event, show the old_price, new_price, and % change using LAG. */
/* Q55. Compute each store's market share (% of company revenue) by year, and its change from the prior year (LAG). */
/* Q56. Use PERCENTILE_CONT(0.25) and PERCENTILE_CONT(0.75) to compute IQR for order net_total per category. Flag outliers (outside 1.5xIQR). */
/* Q57. Build a "day-of-week seasonality" report: average revenue per day-of-week, with a CASE to label Mon-Sun, sorted by avg revenue. */
/* Q58. Compute the "recency score" for each customer: 5 if last order within 30 days, 4 if 31-60, 3 if 61-90, 2 if 91-180, 1 if > 180 days. */
/* Q59. For each product, compute the "30-day sell-through rate": units sold in last 30 days / current inventory quantity. */
/* Q60. Show the top 5 employees per department by total gross pay (from pay_slips) using DENSE_RANK. */
/* Q61. Compute monthly customer acquisition cost: total ads_spend / new_customers per month. */
/* Q62. Build a cohort retention table: signup_month x period (0-6 months), showing % of cohort still ordering each month. */
/* Q63. Using CUME_DIST(), show what % of products have a price below each product's price. */
/* Q64. Compute a "basket size distribution": for each order, count distinct products; then bucket into 1 / 2-3 / 4-6 / 7+ items using CASE; show % of orders in each bucket. */
/* Q65. Using a window ROWS BETWEEN 2 PRECEDING AND 2 PRECEDING, extract the value from exactly 2 rows before (same as LAG(2, 0) but via frame). */
/* Q66. Show a "day-over-day" order volume comparison for the last 30 days vs the same 30 days a year prior. */
/* Q67. Compute the Gini coefficient approximation for customer spending (2 * CUME_DIST integral). */
/* Q68. For each product category, show the revenue contribution at P25, Median, P75 of individual order values. */
/* Q69. Build a "supply chain SLA" report: % of supply_chain.shipments delivered within 3 days of the expected delivery date. */
/* Q70. Find the "revenue cliff": the month where revenue dropped the most in absolute terms (using LAG). */
/* Q71. Compute each loyalty member's "tier upgrade date" - the date they first crossed the points threshold for their current tier, using cumulative SUM of points. */
/* Q72. Show the "hour-of-day" call volume pattern from call_center.calls using EXTRACT(HOUR FROM call_start_time). */
/* Q73. Compute a "product cannibalization" index: for pairs of products in the same category, what % of customers bought both? */
/* Q74. Build a funnel: page views -> add to cart (web_events.events where event_type = 'add_to_cart') -> purchase; show conversion rates. */
/* Q75. Using ROLLUP, compute revenue totals by region, by store within region, and grand total in a single query. */

/* ============================================================
   SECTION D: PERFORMANCE & DESIGN (25)
   ------------------------------------------------------------ */
/* Q76. The DBA reports that the query "SELECT * FROM sales.orders WHERE EXTRACT(YEAR FROM order_date) = 2025" is slow even with an index on order_date. Explain why and rewrite it to use the index. */
/* Q77. Design an index strategy for the query: SELECT * FROM sales.order_items WHERE prod_id = X ORDER BY unit_price DESC LIMIT 10. */
/* Q78. A query joining orders (150k rows) to order_items (375k rows) to products (6k rows) is slow. Describe what EXPLAIN ANALYZE output would reveal and what you'd fix. */
/* Q79. The query SELECT * FROM customers.customers WHERE LOWER(email) = 'x@gmail.com' won't use the email index. What index type solves this? */
/* Q80. Explain why SELECT COUNT(*) FROM a large table is slow in PostgreSQL without pg_stat_user_tables. What's the fast alternative? */
/* Q81. A materialized view on a 500k-row join is refreshed every hour. Describe the cost and suggest CONCURRENT REFRESH. When is it safe? */
/* Q82. Write a query that benefits from a partial index: only index 'Returned' orders on sales.orders(order_date). Show the query and the index DDL. */
/* Q83. The query optimizer chooses a Seq Scan instead of an index scan. Name 3 reasons why this might be the right choice. */
/* Q84. Write the DDL for a composite index that covers the query: SELECT * FROM sales.order_items WHERE prod_id = X AND order_id > 1000 ORDER BY unit_price. */
/* Q85. Describe the performance impact of a LATERAL join over all 50,000 customers vs bounding the outer set first. */
/* Q86. A query uses ORDER BY random() LIMIT 10 to sample data. Explain the performance problem and suggest a better approach with TABLESAMPLE. */
/* Q87. The query "SELECT * FROM web_events.page_views WHERE view_timestamp BETWEEN x AND y" scans a 500k-row table. What index type and any partition design would help? */
/* Q88. Design a view-based analytics layer for RetailMart: what views would you create and what indexes on the base tables would support them? */
/* Q89. Explain the difference between a Hash Aggregate and a Group Aggregate in EXPLAIN output. When does PostgreSQL choose each? */
/* Q90. A query plan shows "Sort (cost=... rows=... width=...)" with a high cost before a Limit. How do you push the sort work down using an index? */
/* Q91. Write a BRIN index DDL for web_events.page_views on view_timestamp. When would a BRIN outperform a B-tree here? */
/* Q92. The Compliance Officer wants a query that runs in < 2 seconds on 500k page_views filtered by customer_id and view_timestamp range. Design the index. */
/* Q93. Explain why "SELECT DISTINCT ON (cust_id) * FROM sales.orders ORDER BY cust_id, order_date DESC" requires a sort - and how an index could eliminate it. */
/* Q94. Describe the dangers of force-pushing DML (UPDATE/DELETE) inside a CTE against a production table. What safeguards exist? */
/* Q95. A query with 5-level CTE chain is slow. How would you identify the bottleneck CTE? (EXPLAIN ANALYZE wrapping each CTE.) */
/* Q96. The query planner uses nested loops when you expect a hash join on a large table. Name the parameter that controls the planner's memory assumptions. */
/* Q97. Why does adding an ORDER BY to a subquery (not the outer query) not guarantee the outer query sees rows in that order in PostgreSQL? */
/* Q98. Describe the FILLFACTOR storage parameter: how would you set it on sales.orders to improve UPDATE performance? */
/* Q99. Write a query that identifies "hot" pages in a table via pg_catalog.pg_stats - which columns have the highest correlation and why does that matter for index scans? */
/* Q100. Design a full "analytics refresh pipeline": 3 CTEs producing a product_performance MV, a customer_segments MV, and a store_kpis MV - describe the REFRESH order and explain why order matters. */
