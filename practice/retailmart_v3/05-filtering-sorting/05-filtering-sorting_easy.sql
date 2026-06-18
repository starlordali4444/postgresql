/* ============================================================
   SQL PRACTICE SET - Filtering & Sorting (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Filtering & Sorting Basics
   Database:     RetailMart V3 (16 schemas, 55 tables)

   Scope:
     - Clauses: SELECT, WHERE, AND, OR, NOT, BETWEEN, IN,
                LIKE, ILIKE, IS NULL, ORDER BY, LIMIT, OFFSET, DISTINCT
     - Single-table queries only - NO JOINs / GROUP BY yet
     - Use schema-qualified table names: sales.orders, customers.customers

   Structure: 10 Conceptual + 30 SELECT/WHERE + 30 Operators + 30 Sort/Limit
   Every WHERE value used below exists in the actual V3 seed data.

   Each question is a real-world scenario. Translate the
   business need into a SQL query.
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL QUESTIONS (10)
   ------------------------------------------------------------ */
/* Q1.  Your junior asks "what does the WHERE clause do?" - explain in one line. */
/* Q2.  In an interview, you're asked: AND vs OR - which has higher precedence and why does it matter? */
/* Q3.  A teammate is debating whether BETWEEN 1 AND 10 includes the boundary numbers. What do you tell them? */
/* Q4.  When would you choose IN over chaining many OR conditions? */
/* Q5.  A student writes `WHERE name LIKE 'samsung%'` and gets zero rows. Why - and what should they have used? */
/* Q6.  A query `WHERE phone = NULL` returns nothing even though some phones look empty. Explain. */
/* Q7.  Why do experienced engineers always add ORDER BY even when data "looks sorted"? */
/* Q8.  In ORDER BY, what is the default sort direction if you don't specify ASC or DESC? */
/* Q9.  Explain what LIMIT 10 OFFSET 20 returns - and which page (10-per-page) the user is viewing. */
/* Q10. Write out the standard clause order: SELECT, FROM, WHERE, ORDER BY, LIMIT - and then the EXECUTION order. */

/* ============================================================
   SECTION B: SELECT + BASIC WHERE (30)
   ------------------------------------------------------------ */
/* Q11. The Customer Service team is exporting the full customer master list. Pull every column from customers.customers. */
/* Q12. Marketing wants a contact list - show first_name and email from customers.customers. */
/* Q13. The catalog team needs product_id, product_name, and price from products.products for a price-list PDF. */
/* Q14. The Finance Director wants order_id, cust_id, and net_total from sales.orders for a revenue audit. */
/* Q15. HR is building an employee directory. Show employee_id, first_name, and role from stores.employees. */
/* Q16. The premium catalog team wants every product priced ABOVE 500. */
/* Q17. The 'value zone' team wants products priced BELOW 100. */
/* Q18. A pricing analyst is testing - find any product whose price equals exactly 999.99. */
/* Q19. Marketing is launching a satisfaction survey for completed purchases. Pull all delivered orders from sales.orders. */
/* Q20. The Ops team wants to ignore cancellations - show all orders that are NOT 'Cancelled'. */
/* Q21. Loyalty wants the 'Gold tier' contact list. Filter customers.customers where tier = 'Gold'. */
/* Q22. Re-engagement campaign: customers whose tier is NOT 'Bronze' (everyone above entry level). */
/* Q23. The CHRO wants senior employees - salary > 50000. */
/* Q24. HR is reviewing entry-level pay - show employees whose salary is below 30000. */
/* Q25. Store Operations wants the Mumbai locations - stores.stores where city = 'Mumbai'. */
/* Q26. The expansion team wants every store outside Delhi - city != 'Delhi'. */
/* Q27. Support escalation list: pull all tickets with priority = 'High'. */
/* Q28. The support manager wants the open queue - tickets where status = 'Open'. */
/* Q29. Loyalty wants 'big point holders' - members with points_balance above 1000. */
/* Q30. CX wants all 5-star reviews for the marketing landing page - reviews with rating = 5. */
/* Q31. The Quality team wants reviews flagged as unhappy - rating < 3. */
/* Q32. HR is doing an attendance audit. Pull hr.attendance records for the date '2025-01-15'. */
/* Q33. The CMO wants every high-budget campaign - budget above 100000. */
/* Q34. The CFO wants large expenses for the audit - finance.expenses where amount > 50000. */
/* Q35. DevOps is chasing production errors - application_logs where level = 'ERROR'. */
/* Q36. The API team wants 500-error rows - audit.api_requests where status_code = 500. */
/* Q37. The Web Analytics team wants only the mobile page views - device_type = 'Mobile'. */
/* Q38. Production wants the 'Completed' work-orders list - manufacture.work_orders where status = 'Completed'. */
/* Q39. The call-center supervisor wants 'long calls' - call_duration_seconds above 300 (5+ minutes). */
/* Q40. Payroll is reviewing high-paid net salaries - pay_slips where net_salary > 10000. */

/* ============================================================
   SECTION C: BETWEEN / IN / LIKE / IS NULL (30)
   ------------------------------------------------------------ */
/* Q41. The pricing team wants the mid-tier range - products priced BETWEEN 200 AND 1000. */
/* Q42. The 'edge case' pricing review - products NOT priced between 100 and 500 (either cheaper or more expensive). */
/* Q43. The H1 review meeting needs orders placed between January and June 2025. */
/* Q44. The CHRO wants the salary 'middle band' - employees earning BETWEEN 40000 AND 80000. */
/* Q45. Loyalty wants Gold + Silver tier customers - use IN. */
/* Q46. Exclusion list: customers whose tier is NOT IN ('Bronze', 'Platinum'). */
/* Q47. The Ops dashboard wants orders that are either Delivered or Shipped - use IN. */
/* Q48. Escalation queue: tickets whose priority is IN ('High', 'Critical'). */
/* Q49. Catalog audit - products whose name STARTS WITH 'A'. */
/* Q50. Marketing wants every 'Pro' line product - product_name CONTAINS 'Pro'. */
/* Q51. The premium 'Pro' tier suffix - product_name ENDS WITH 'Pro'. */
/* Q52. The Gmail-first email campaign - customers whose email ends with '@gmail.com'. */
/* Q53. Same for Yahoo users - email ends with '@yahoo.com'. */
/* Q54. HR wants every 'Manager' across roles - role contains 'Manager'. */
/* Q55. The Sales org tree - employees whose role STARTS WITH 'Sales'. */
/* Q56. Customer call wants to find 'Priya' (any casing) - first_name ILIKE 'priya%'. */
/* Q57. Catalog wants every Samsung product (any casing) - product_name ILIKE 'samsung%'. */
/* Q58. A reporting quirk - customers whose first_name has 'a' as the SECOND letter (LIKE '_a%'). */
/* Q59. Logistics wants the 'in transit' list - sales.shipments where delivered_date IS NULL. */
/* Q60. Same logistics dashboard - already-delivered shipments where delivered_date IS NOT NULL. */
/* Q61. Privacy report: anonymous page-view sessions - web_events.page_views where customer_id IS NULL. */
/* Q62. Logged-in user page views - customer_id IS NOT NULL. */
/* Q63. The support queue 'still open' - tickets where resolved_date IS NULL. */
/* Q64. The support team wants closed tickets - resolved_date IS NOT NULL. */
/* Q65. The CFO wants the post-2025 order book - orders where order_date >= '2025-01-01'. */
/* Q66. Finance wants campaigns with very specific budget amounts - budget IN (100000, 200000, 500000). */
/* Q67. The merchandising shortlist - products whose brand_id is in (1, 2, 3, 4, 5). */
/* Q68. Call analytics - calls where call_reason IN ('Complaint', 'Inquiry'). */
/* Q69. Acquisition team wants customers who joined IN 2024 - registration_date BETWEEN '2024-01-01' AND '2024-12-31'. */
/* Q70. CFO wants only 2025 orders - use order_date >= '2025-01-01' AND order_date < '2026-01-01'. */

/* ============================================================
   SECTION D: ORDER BY + LIMIT + OFFSET + DISTINCT (30)
   ------------------------------------------------------------ */
/* Q71. The premium catalog needs the 10 most expensive products for the homepage. */
/* Q72. The 'budget products' carousel - 10 cheapest products. */
/* Q73. The DBA wants the 5 most recent orders for a smoke test. */
/* Q74. Historical review - the 5 earliest orders ever placed. */
/* Q75. CHRO wants the top 10 highest-paid employees for the compensation review. */
/* Q76. HR wants the 10 lowest-paid employees for the minimum-wage compliance check. */
/* Q77. Marketing wants the newest customers first - sort by registration_date DESC. */
/* Q78. Customer Service wants the directory alphabetically - by first_name. */
/* Q79. Store Ops wants every store ordered by city for the regional review. */
/* Q80. The CFO wants the 20 highest-value orders by net_total. */
/* Q81. Catalog ordering - products sorted by price DESC, then by product_name ASC (tie-break). */
/* Q82. Sort employees by salary DESC, then by first_name ASC. */
/* Q83. The call-center supervisor wants the 5 longest support calls. */
/* Q84. Web analytics wants the 10 most recent page_views. */
/* Q85. HR wants the 20 most recent attendance records. */
/* Q86. The CFO wants the top 10 refund_amount returns for the loss review. */
/* Q87. The CMO wants the 5 highest-budget campaigns. */
/* Q88. Production wants the top 10 work_orders by quantity_produced. */
/* Q89. Loyalty wants the 5 OLDEST customers - earliest registration_date. */
/* Q90. Logistics wants shipments sorted by delivered_date with the in-transit ones at the bottom (NULLS LAST). */
/* Q91. Support wants tickets sorted by resolved_date with unresolved ones at the TOP (NULLS FIRST). */
/* Q92. The pagination test - PAGE 1 (rows 1-10) of customers ordered by customer_id. */
/* Q93. PAGE 2 (rows 11-20) of customers ordered by customer_id. */
/* Q94. PAGE 3 of the price-DESC product list, 20 per page (rows 41-60). */
/* Q95. PAGE 5 of the high-value orders list (20 per page, rows 81-100), sorted by net_total DESC. */
/* Q96. The Web Analytics team wants the distinct device types - what unique values exist? */
/* Q97. Loyalty wants the list of all tier names (no duplicates). */
/* Q98. The Ops team wants every distinct order_status that has appeared. */
/* Q99. Store Ops wants the alphabetical list of distinct cities. */
/* Q100. Support wants the alphabetical list of distinct ticket categories. */

/* ============================================================
   END OF Filtering & Sorting - EASY LEVEL (100 QUESTIONS)
   ------------------------------------------------------------
   Tips:
   - Use ONLY single-table SELECT queries - no JOINs yet
   - Always qualify tables with their schema (sales.orders, customers.customers)
   - Practice writing queries from scratch - don't peek at answers
   - When stuck, re-read the Day 5 slides before reaching out for help
============================================================ */
