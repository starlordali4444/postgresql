/* ============================================================
   SQL PRACTICE SET - Review & Interview Prep (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Mixed review of Weeks 1-5 topics at interview-drill level
   Database:     RetailMart V3

   Scope (MEDIUM = multi-table, gotchas, interview-screen level):
     - Multi-table joins with filtering and aggregation
     - CTEs for readability, correlated subqueries
     - Window functions with partitions and frames
     - Pivoting with FILTER, percentile aggregates
     - Data quality pattern queries
   Structure: 25 Conceptual + 25 Joins/CTEs/subqueries + 25 Window & analytics + 25 Mixed patterns
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL REVIEW (25)
   ------------------------------------------------------------ */
/* Q1.  Explain the difference between INNER JOIN and LEFT JOIN with a real scenario from RetailMart. */
/* Q2.  When does a LEFT JOIN produce NULL on the right side? Give a RetailMart example. */
/* Q3.  What is the difference between a correlated subquery and a regular subquery? */
/* Q4.  Why can you not use a window function directly in a WHERE clause? */
/* Q5.  What is the difference between ROW_NUMBER and RANK when rows tie? */
/* Q6.  Explain PARTITION BY vs ORDER BY inside a window function. */
/* Q7.  What does the FILTER clause on an aggregate do? */
/* Q8.  Why is PERCENTILE_CONT(0.5) more robust than AVG for skewed data? */
/* Q9.  What is the difference between EXISTS and IN when checking membership? */
/* Q10. How do you detect the "top-N per group" pattern? What SQL structure does it use? */
/* Q11. What is a lateral join and when would you use one instead of a correlated subquery? */
/* Q12. What is a materialized view's main limitation compared to a regular view? */
/* Q13. Why does using functions on indexed columns in WHERE break index usage? */
/* Q14. What is the difference between a clustered index (PostgreSQL heap) and a BRIN index? */
/* Q15. Explain the "anti-join" pattern: when to use LEFT JOIN ... IS NULL vs NOT EXISTS. */
/* Q16. When would you use UNION ALL instead of UNION? What is the performance difference? */
/* Q17. What is the difference between 1NF, 2NF, and 3NF? Which normal form is RetailMart? */
/* Q18. What is a transaction and why does ACID matter for order processing? */
/* Q19. What does EXPLAIN ANALYZE's "actual rows" vs "estimated rows" gap tell you? */
/* Q20. Why does a hash join appear in EXPLAIN when the smaller table fits in memory? */
/* Q21. What is a "funnel" query and what SQL constructs implement it? */
/* Q22. What is an RFM score? How would you compute it from sales.orders? */
/* Q23. What is cohort retention and how is it different from total active users? */
/* Q24. What does IS DISTINCT FROM do that <> does not? */
/* Q25. Name two common data-quality checks you would automate on customers.customers. */

/* ============================================================
   SECTION B: JOINS, CTEs & SUBQUERIES (25)
   ------------------------------------------------------------ */
/* Q26. The DBA needs the top 5 product categories by total revenue (quantity * unit_price from order_items joined to products). Show category_name and total_revenue. */
/* Q27. Find all customers who have placed orders but have never written a review. Use an anti-join. */
/* Q28. The CFO wants a year-month breakdown of total net_total, count of orders, and average net_total - but only for 'Delivered' orders. */
/* Q29. Using a CTE, first compute each store's total sales, then rank stores by sales within their region. Return store_id, region, total_sales, and rank. */
/* Q30. The Head of Logistics wants to see products that are in inventory (products.inventory) but have never appeared in any order_item. */
/* Q31. Find the customer who spent the most in 2025 and show their name, email, and total spend. */
/* Q32. Using a CTE, compute each customer's order count. Then find customers whose order count is above the overall average. */
/* Q33. Find the 3 most-reviewed products per category using ROW_NUMBER in a CTE. */
/* Q34. The Support Team Lead wants all customers with more than 3 open (unresolved) tickets. */
/* Q35. Show each employee, their department name, and whether their salary is above or below the department average (correlated subquery or window function). */
/* Q36. Find months (year-month) where total returns exceeded total revenue by more than 5%. */
/* Q37. The Marketing Director wants the campaign with the highest click-through rate (email_clicks.clicked / email_clicks.sent). */
/* Q38. Using LATERAL, get the last 2 orders per customer (limit to top 100 customers by spend to keep it fast). */
/* Q39. Find pairs of customers who share the same shipping address (via customers.addresses - same city and address_line1). */
/* Q40. Produce a "store scorecard" CTE: store_id, total_orders, total_revenue, distinct_customers, return_rate (returns / orders). */
/* Q41. Using EXISTS, find products that have been purchased by at least one Gold-tier customer. */
/* Q42. Find the first order date for each customer using a correlated subquery in SELECT. */
/* Q43. The Compliance Officer wants all orders where the shipment was delivered before the order date (data anomaly). */
/* Q44. Show each product's revenue contribution as a % of its category's total revenue. */
/* Q45. Find employees who earn more than their direct manager (use stores.employees self-join via manager_id). */
/* Q46. Using a recursive-free CTE, compute cumulative monthly revenue ordered by month. */
/* Q47. Show brands with zero products priced above 10,000 (anti-join or HAVING). */
/* Q48. The VP of Sales wants the day-of-week with the highest average net_total across all time. */
/* Q49. Find customers who placed orders in both January and February 2025. */
/* Q50. Show each warehouse's inventory value (SUM of quantity * price from inventory snapshots joined to products). */

/* ============================================================
   SECTION C: WINDOW FUNCTIONS & ANALYTICS (25)
   ------------------------------------------------------------ */
/* Q51. Compute month-over-month revenue growth % using LAG(total_revenue, 1). */
/* Q52. For each customer, identify their highest-value order using FIRST_VALUE ranked by net_total DESC. */
/* Q53. Compute a 7-day rolling average of daily order count. */
/* Q54. Use DENSE_RANK to find the top 3 selling products per category by units sold. */
/* Q55. Bucket customers into 5 equal groups by total spend using NTILE(5). */
/* Q56. Compute the 90th-percentile order value per store using PERCENTILE_CONT(0.9). */
/* Q57. Show for each order: net_total, same-customer previous order's net_total (LAG), and the difference. */
/* Q58. Using FILTER, compute - in one query - total orders, delivered orders, and returned orders per store. */
/* Q59. Pivot the order status distribution by year: columns for Delivered / Returned / Cancelled counts. */
/* Q60. Compute a 30-day rolling SUM of net_total per store using ROWS BETWEEN 29 PRECEDING AND CURRENT ROW. */
/* Q61. Find the product with the steepest price increase in audit.record_changes using LAG on price by product. */
/* Q62. Compute each customer's "days since last order" as of the data's max date. */
/* Q63. Show employees ranked by salary within their department, and flag those in the bottom 20% (NTILE). */
/* Q64. Using PERCENT_RANK(), show each product's relative position by price within its brand. */
/* Q65. Compute a running count of distinct customers who have placed at least one order, by month. */
/* Q66. Show each page_view's view_timestamp and the gap (in seconds) to the previous view for the same customer (LAG on view_timestamp). */
/* Q67. Using LEAD, show each call and whether the next call by the same agent is longer or shorter. */
/* Q68. Compute the daily active users (DAU) from web_events.page_views grouped by date. */
/* Q69. Compute the "stickiness" ratio: DAU / MAU per month from web_events. */
/* Q70. Show average salary by department alongside the company-wide average in the same row. */
/* Q71. For each product category, compute MEDIAN price (PERCENTILE_CONT) and compare to AVG. */
/* Q72. Compute the quarter-over-quarter revenue growth rate using LAG(revenue, 3) on monthly data. */
/* Q73. Show the top and bottom 1 product per category by average review rating (FIRST_VALUE / LAST_VALUE). */
/* Q74. Add a "days to next reorder needed" column per product: days_until_reorder based on reorder_level and current quantity. */
/* Q75. Compute CAGR (Compound Annual Growth Rate) of order revenue from earliest to latest year. */

/* ============================================================
   SECTION D: MIXED INTERVIEW PATTERNS (25)
   ------------------------------------------------------------ */
/* Q76. Write the canonical "top-N per group" query: top 3 products by revenue per category. */
/* Q77. Write a dedup query using ROW_NUMBER to keep only the most-recently-registered customer per email. */
/* Q78. The Finance team needs a reconciliation: for each order, compare SUM(order_items.unit_price * quantity) to orders.net_total and flag mismatches. */
/* Q79. Write a funnel query: count customers who (a) viewed a page, (b) placed an order, (c) placed a second order. Show conversion % at each step. */
/* Q80. Rewrite an IN subquery as EXISTS: find customers who have at least one 'Returned' order. */
/* Q81. Write the median + P90 + P95 of order net_total in a single query using PERCENTILE_CONT. */
/* Q82. Pivot: show for each month, total revenue split by payment mode (UPI / Card / COD / Wallet) using FILTER. */
/* Q83. Simulate an EXPLAIN ANALYZE output interpretation: if Seq Scan rows = 50000 but only 10 rows match, what would you add? */
/* Q84. Write a data-quality scorecard: for customers.customers, count % rows with NULL phone, % with duplicate email, % with price < cost. */
/* Q85. Write a cohort retention query: for each signup_month, show retention at month 0, 1, 2, 3. */
/* Q86. Build an RFM query: score each customer on Recency (days since last order), Frequency (order count), Monetary (total spend) using NTILE(5). */
/* Q87. Detect slow-moving products: items in inventory > 90 days with zero orders. */
/* Q88. Write a period-over-period growth table: year, month, revenue, prev_month_revenue, growth_pct. */
/* Q89. Find the "champion" customers: RFM quintile 5-5-5 (best on all three dimensions). */
/* Q90. Write a query that computes each store's revenue as a % of its region's total revenue. */
/* Q91. Find products whose review count dropped > 20% in the last 3 months vs the prior 3 months. */
/* Q92. Using a single CTE chain (no temp tables), compute: daily_orders -> monthly_totals -> YoY_growth. */
/* Q93. Find customers who were active (ordered) in both 2024 and 2025. */
/* Q94. Write a query to detect price anomalies: products whose price changed by > 50% in a single audit.record_changes event. */
/* Q95. The DBA asks: for which columns on sales.orders would a B-tree index NOT help? Why? */
/* Q96. Compute the "customer lifetime value" (CLV): average total spend per customer cohort (signup_month). */
/* Q97. Flag all shipments where the delivered_date is before the shipped_date (impossible). */
/* Q98. Write a UNION query combining the top 10 customers by order count and top 10 by total spend (may overlap). */
/* Q99. Explain and write: why does LEFT JOIN + IS NULL = NOT EXISTS in the anti-join pattern? Show both forms. */
/* Q100. The interviewer asks: "In one query, show for each category: total revenue, revenue rank, % of overall revenue, and MoM growth for the latest month." Write it. */
