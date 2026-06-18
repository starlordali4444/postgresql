/* ============================================================
   SQL PRACTICE SET - Review & Interview Prep (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Mixed review of Weeks 1-5 topics at interview-drill level
   Database:     RetailMart V3

   Scope (EASY = one concept revisited, single-table or simple join):
     - SELECT / WHERE / ORDER BY / LIMIT fundamentals
     - Aggregate functions, GROUP BY, HAVING
     - Basic joins (INNER, LEFT)
     - CASE / COALESCE / NULLIF
     - Simple window functions (ROW_NUMBER, RANK, LAG)
   Structure: 25 Conceptual + 25 Foundations drill + 25 Joins & aggregates + 25 Window & conditional
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL REVIEW (25)
   ------------------------------------------------------------ */
/* Q1.  What is the difference between WHERE and HAVING? */
/* Q2.  When would you choose LEFT JOIN over INNER JOIN? */
/* Q3.  What does GROUP BY do to rows? */
/* Q4.  What is the difference between COUNT(*) and COUNT(col)? */
/* Q5.  What does DISTINCT do? How is it different from GROUP BY? */
/* Q6.  What does ORDER BY without a LIMIT mean for performance? */
/* Q7.  What is a primary key and what does it guarantee? */
/* Q8.  What is a foreign key and what does it enforce? */
/* Q9.  What does NULL represent in a database? */
/* Q10. What does COALESCE(a, b, c) return? */
/* Q11. What is a CTE (WITH clause) and why use it over a subquery? */
/* Q12. What does ROW_NUMBER() OVER (PARTITION BY x ORDER BY y) produce? */
/* Q13. What is the difference between ROW_NUMBER, RANK, and DENSE_RANK? */
/* Q14. What does LAG(col, 1) do inside a window function? */
/* Q15. What is an index and why does it speed up queries? */
/* Q16. What does EXPLAIN ANALYZE tell you that EXPLAIN alone does not? */
/* Q17. What is a materialized view and how is it different from a regular view? */
/* Q18. When would you use PERCENTILE_CONT vs AVG for a "central" metric? */
/* Q19. What is the difference between UNION and UNION ALL? */
/* Q20. What does a self-join do? Give one RetailMart use-case. */
/* Q21. What is the EXISTS operator used for? */
/* Q22. What is a correlated subquery? */
/* Q23. What does NULLIF(a, b) return? */
/* Q24. What is 1NF (First Normal Form)? */
/* Q25. What does ACID stand for and why does it matter? */

/* ============================================================
   SECTION B: FOUNDATIONS DRILL (25)
   ------------------------------------------------------------ */
/* Q26. List the top 10 most expensive products by price. */
/* Q27. Count total customers by tier (Bronze / Silver / Gold / Platinum). */
/* Q28. Find all orders placed in January 2025 (order_date range). */
/* Q29. Show customer first_name, last_name, email for customers who registered after 2024-06-01. */
/* Q30. Count orders per order_status; sort by count descending. */
/* Q31. Find the average net_total of all 'Delivered' orders. */
/* Q32. Find products where price > 5000 and category is 'Electronics'. */
/* Q33. List all distinct order statuses in sales.orders. */
/* Q34. Find the 5 employees with the highest current_salary. */
/* Q35. Count support tickets per priority; sort highest-priority first. */
/* Q36. Find all products with NULL description. */
/* Q37. Show the 10 stores with the most orders (join orders to stores). */
/* Q38. Find customers whose phone IS NULL. */
/* Q39. Count page views per device_type. */
/* Q40. Show the total refund_amount from sales.returns by month. */
/* Q41. Find brands with more than 50 products. */
/* Q42. List all campaigns sorted by start_date ascending. */
/* Q43. Count employees per department (join employees to dim_department). */
/* Q44. Find products whose price < cost_price (negative margin). */
/* Q45. Show total ads spend per platform from marketing.ads_spend. */
/* Q46. Count call center calls per call_type. */
/* Q47. List work_orders with status 'In Progress'. */
/* Q48. Find all warehouses in the 'North' region. */
/* Q49. Show loyalty members whose points_balance > 10000. */
/* Q50. Count audit.application_logs rows per log_level. */

/* ============================================================
   SECTION C: JOINS & AGGREGATES (25)
   ------------------------------------------------------------ */
/* Q51. For each customer, show their name and total number of orders (LEFT JOIN so zero-order customers appear). */
/* Q52. Show the top 5 products by total units sold (sum order_items.quantity). */
/* Q53. Find the average order net_total per store (join orders to stores). */
/* Q54. For each brand, count the number of products and their average price. */
/* Q55. List customers who have placed at least one 'Returned' order. */
/* Q56. Find the top 3 categories by total revenue (order_items.quantity * unit_price). */
/* Q57. Show the number of support tickets per customer; list top 10. */
/* Q58. Find all products that have never been ordered (LEFT JOIN anti-join pattern). */
/* Q59. For each store, show the count of employees (join employees to stores). */
/* Q60. Show total ads_spend per campaign from marketing.ads_spend. */
/* Q61. Find customers who have reviewed at least 3 products. */
/* Q62. Count shipments per carrier from sales.shipments. */
/* Q63. For each category, show average product price and average cost_price. */
/* Q64. Show total redemptions per loyalty tier. */
/* Q65. Find employees whose salary_history shows more than one salary change. */
/* Q66. Count web_events.page_views per page_url; show top 10. */
/* Q67. Find the month with the highest total order revenue. */
/* Q68. Show the number of returns per product category. */
/* Q69. For each warehouse, count distinct products with inventory snapshots. */
/* Q70. Find campaigns that generated zero ad spend. */
/* Q71. Show total payment amount per payment mode (join to finance.payment_modes). */
/* Q72. Count calls resolved within 5 minutes (call_duration_seconds <= 300). */
/* Q73. Find the top 5 customers by total spend (sum of orders.net_total). */
/* Q74. Show average review rating per product category. */
/* Q75. Find all products sold by stores in the 'South' region. */

/* ============================================================
   SECTION D: WINDOW FUNCTIONS & CONDITIONALS (25)
   ------------------------------------------------------------ */
/* Q76. Rank customers by total spend using DENSE_RANK(). */
/* Q77. For each product, show its price and its rank within its category by price. */
/* Q78. Compute month-over-month order count change using LAG. */
/* Q79. Add a running total of net_total for each customer's orders sorted by order_date. */
/* Q80. Use NTILE(4) to bucket products into price quartiles. */
/* Q81. Use ROW_NUMBER to find the most recent order per customer. */
/* Q82. Use FIRST_VALUE to get each employee's first salary in salary_history. */
/* Q83. Classify products: CASE WHEN price > 10000 THEN 'Premium' WHEN price > 3000 THEN 'Mid' ELSE 'Budget'. */
/* Q84. Add a 'tier_label' column: CASE on customers.tier for a custom label. */
/* Q85. Use COALESCE to replace NULL phone with 'Not provided'. */
/* Q86. Use NULLIF to turn a '0' review rating into NULL. */
/* Q87. Compute a 3-row moving average of daily order count using AVG OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW). */
/* Q88. Show each order's net_total and the same-customer previous order's net_total (LAG). */
/* Q89. For each employee, show their salary and the department average salary (AVG OVER PARTITION BY dept_id). */
/* Q90. Use PERCENT_RANK() to show each product's relative price position within its brand. */
/* Q91. Show SUM of net_total for the last 30 days from each order date (window frame). */
/* Q92. Use CASE to categorize order status into 'Active', 'Closed', 'Problem'. */
/* Q93. Find the 2nd-highest priced product per category using DENSE_RANK = 2. */
/* Q94. Use LEAD to show for each call the duration of the next call by the same agent. */
/* Q95. Classify customers by points_balance: CASE tiers (0-999 / 1000-4999 / 5000+). */
/* Q96. Show month, total revenue, and cumulative revenue using SUM() OVER (ORDER BY month). */
/* Q97. Use FILTER clause to count 'Delivered' and 'Returned' orders in the same row. */
/* Q98. Find the bottom 5 employees by salary using RANK() and filtering rank <= 5. */
/* Q99. Show each ticket's created_date and the time difference to the next ticket by the same customer (LEAD). */
/* Q100. Write a single query that shows: customer_id, total_orders, total_spent, spending_rank (RANK), and tier label (CASE on tier). */
