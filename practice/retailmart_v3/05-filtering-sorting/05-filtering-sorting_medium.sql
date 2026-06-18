/* ============================================================
   SQL PRACTICE SET - Filtering & Sorting (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Filtering & Sorting - deeper patterns
   Database:     RetailMart V3

   Scope (deeper than Easy):
     - AND/OR/NOT precedence, parentheses
     - NULL semantics: IS DISTINCT FROM, IS NOT TRUE, three-valued logic
     - Complex LIKE/ILIKE with multiple wildcards + escape characters
     - ORDER BY: NULLS FIRST/LAST, multi-column mixed direction
     - DISTINCT ON intro
     - Pagination corner cases

   Structure: 25 Conceptual + 25 Complex WHERE + 25 Pattern Matching + 25 Sort/Pagination
   ============================================================ */

/* ============================================================
   SECTION A: FILTERING DEEPER - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  In WHERE A AND B OR C - which is evaluated first, AND or OR? */
/* Q2.  Why is `WHERE NOT (col = 5)` different from `WHERE col != 5` when col can be NULL? */
/* Q3.  What does the three-valued logic of SQL mean - TRUE / FALSE / what? */
/* Q4.  Explain why `WHERE col = NULL` returns no rows but `WHERE col IS NULL` does. */
/* Q5.  What's the difference between `IS DISTINCT FROM` and `!=`? */
/* Q6.  In `WHERE x IN (1, 2, NULL)` - does the NULL match anything? */
/* Q7.  In `WHERE x NOT IN (1, 2, NULL)` - what's the surprising result and why? */
/* Q8.  Explain the difference between `IS TRUE` and `= TRUE` on a BOOLEAN column. */
/* Q9.  Compare `WHERE col LIKE '%abc%'` vs `WHERE position('abc' IN col) > 0` - same result, but which is faster on a large table? */
/* Q10. What's the cost of `WHERE LOWER(col) = 'priya'` - and why does it disable a regular index? */
/* Q11. Why is `BETWEEN '2025-01-01' AND '2025-01-31'` slightly different from `>= AND <` when col has TIME parts? */
/* Q12. Explain what ESCAPE means in `LIKE '50\%' ESCAPE '\'`. */
/* Q13. Difference between `ORDER BY 1` and `ORDER BY col_name` - which is safer for production? */
/* Q14. In multi-column ORDER BY, does each column have its own ASC/DESC? Show example. */
/* Q15. What does `NULLS FIRST` vs `NULLS LAST` control? */
/* Q16. What is the default position of NULLs in ASC vs DESC ORDER BY? */
/* Q17. Difference between `LIMIT 10` and `FETCH FIRST 10 ROWS ONLY`. */
/* Q18. Why is `OFFSET 1000000 LIMIT 10` slow - and what's the alternative for pagination? */
/* Q19. Difference between `DISTINCT` and `DISTINCT ON (col)`. */
/* Q20. Why might `SELECT DISTINCT *` be misleading on a table with TIMESTAMP columns? */
/* Q21. What is "keyset pagination" and why is it faster than offset pagination? */
/* Q22. Explain the precedence of AND/OR/NOT - give a query where missing parens changes the result. */
/* Q23. What does `<>` mean - same as `!=`? */
/* Q24. Compare `WHERE col1 = col2` vs `WHERE col1 IS NOT DISTINCT FROM col2` on NULLable columns. */
/* Q25. Why might `SELECT * FROM t LIMIT 5` give different rows each time (without ORDER BY)? */

/* ============================================================
   SECTION B: COMPLEX WHERE - MULTI-CONDITION (25)
   ------------------------------------------------------------ */
/* Q26. Marketing wants Gold customers in Mumbai OR Delhi who registered in 2024. Show the precedence-correct query. */
/* Q27. Support wants Critical OR High priority tickets that are still 'Open'. */
/* Q28. The CMO wants customers whose tier is Gold or Platinum AND whose phone starts with '+91 9'. */
/* Q29. Show orders that are NOT Delivered AND NOT Cancelled AND placed in 2025. */
/* Q30. Find products priced > 1000 AND cost_price > 500 AND brand_id NOT IN (1, 2). */
/* Q31. Find employees with salary > 50000 AND (role LIKE '%Manager%' OR role LIKE '%Director%'). */
/* Q32. Find call_center.calls longer than 600 seconds AND with call_reason IN ('Complaint', 'Inquiry'). */
/* Q33. Find sales.shipments where delivered_date IS NULL AND shipped_date < CURRENT_DATE - 7 (stale in-transit). */
/* Q34. Find tickets created in the last 7 days AND priority IN ('High','Critical') AND resolved_date IS NULL. */
/* Q35. Find page_views from anonymous users (customer_id IS NULL) AND device_type = 'Mobile' AND view_timestamp >= CURRENT_DATE - 30. */
/* Q36. Find expenses > 100000 in 2025 AND exp_cat_id IN (1, 2, 3, 4, 5). */
/* Q37. Find loyalty members with points_balance BETWEEN 500 AND 5000 AND join_date < CURRENT_DATE - INTERVAL '1 year'. */
/* Q38. Find returns where refund_amount > 5000 OR reason LIKE '%Defective%'. */
/* Q39. Find audit.application_logs at level 'ERROR' or 'FATAL' AND timestamp >= CURRENT_DATE - 1. */
/* Q40. Find api_requests where status_code = 500 AND endpoint LIKE '/api/v2/%' AND response_time_ms > 1000. */
/* Q41. Find products with price > 5000 AND (brand_id IS NULL OR brand_id IN (1, 2)). */
/* Q42. Find customers in tier Gold OR Platinum AND registered in 2024 OR 2025 - show the parenthesization needed. */
/* Q43. Find employees whose salary > 80000 AND role NOT LIKE '%Intern%' AND store_id IS NOT NULL. */
/* Q44. Find orders placed on weekends (Saturday/Sunday) with net_total > 10000. */
/* Q45. Find tickets where status = 'Open' AND priority IN ('High','Critical') AND age (CURRENT_TIMESTAMP - created_date) > INTERVAL '24 hours'. */
/* Q46. Find product_reviews where rating BETWEEN 1 AND 2 (negative) AND review_date >= CURRENT_DATE - 30. */
/* Q47. Find shipments where status = 'Delivered' AND (delivered_date - shipped_date) > INTERVAL '7 days' (slow deliveries). */
/* Q48. Find customers using IS DISTINCT FROM: WHERE tier IS DISTINCT FROM 'Bronze' (includes NULL tier!). */
/* Q49. Find rows using IS NOT TRUE on a BOOLEAN: stores.stores WHERE (some_boolean) IS NOT TRUE - captures FALSE OR NULL. */
/* Q50. Find orders where (CURRENT_DATE - order_date) BETWEEN 7 AND 30 (week-to-month-old orders). */

/* ============================================================
   SECTION C: COMPLEX LIKE / ILIKE / IS NULL (25)
   ------------------------------------------------------------ */
/* Q51. Customers whose first_name starts with 'A' or 'B' or 'C' using ILIKE. */
/* Q52. Customers whose email ends with @gmail.com OR @yahoo.com using two LIKEs joined by OR. */
/* Q53. Products with 'Pro' in the name but NOT ending in 'Pro'. */
/* Q54. Customers whose first_name has EXACTLY 4 letters (use LENGTH). */
/* Q55. Products with name matching the LIKE pattern '_ _ _%' (at least 3 chars with two embedded). */
/* Q56. Find any email that contains a literal underscore '_' character (use ESCAPE). */
/* Q57. Customers with phone starting '+91 90', '+91 91', or '+91 99'. */
/* Q58. Products whose name has the second character as 'a' (case-insensitive). */
/* Q59. Stores whose city contains exactly one space. */
/* Q60. Employees whose email is in the form 'first.last@retailmart.com' - pattern match. */
/* Q61. Customers whose email does NOT use a Gmail or Yahoo domain. */
/* Q62. Products whose name contains a digit (use ~ regex operator). */
/* Q63. Customers whose first_name contains exactly two vowels (advanced - use regexp_matches or LENGTH tricks). */
/* Q64. Shipments where delivered_date IS NULL AND status != 'Cancelled' (truly pending). */
/* Q65. Tickets where resolved_date IS NULL AND priority = 'Critical' AND created_date < CURRENT_DATE - 2 (overdue critical). */
/* Q66. Customers whose phone IS NOT NULL AND LENGTH(phone) != 14 (incorrectly formatted Indian phone with +91). */
/* Q67. Products whose supplier_id IS NULL AND price > 5000 (high-value, no supplier - data quality issue). */
/* Q68. Page_views where customer_id IS NULL AND device_type = 'Mobile' (anonymous mobile users for retargeting). */
/* Q69. Payments where order_id IS NOT NULL AND amount IS NULL (audit anomaly). */
/* Q70. Customers whose tier_updated_at IS DISTINCT FROM registration_date (those who upgraded tiers). */
/* Q71. Returns whose refund_amount IS NULL (returns awaiting refund processing). */
/* Q72. Employees whose store_id IS NULL OR dept_id IS NULL (incomplete records). */
/* Q73. Customers whose email matches '%@%.%' (basic email shape check). */
/* Q74. Products whose product_name has a '%' sign in it (LIKE with ESCAPE). */
/* Q75. Tickets whose subject starts with a digit (e.g., '500-something'). */

/* ============================================================
   SECTION D: SORTING + PAGINATION (25)
   ------------------------------------------------------------ */
/* Q76. Top 10 products by price DESC, tie-broken by product_name ASC. */
/* Q77. Bottom 10 employees by salary, tie-broken by joining_date DESC (most recent hire first within a tie). */
/* Q78. Orders sorted by order_date DESC NULLS LAST, then net_total DESC. */
/* Q79. Customers ordered by registration_date DESC - paginated to page 4 (20 per page). */
/* Q80. Products ordered by price DESC - get page 7 (rows 121-140) using LIMIT/OFFSET. */
/* Q81. Page 1 of high-value orders (net_total > 5000), sorted by order_date DESC, 25 per page. */
/* Q82. Top 5 cities by store count (need GROUP BY - single line). */
/* Q83. Most recent 10 support tickets across all priorities. */
/* Q84. Most recent 5 page_views per device_type - use DISTINCT ON. */
/* Q85. Most recent 1 order per customer using DISTINCT ON (cust_id) ... ORDER BY cust_id, order_date DESC. */
/* Q86. Get the 50th most expensive product (ORDER BY price DESC LIMIT 1 OFFSET 49). */
/* Q87. Get the 100th oldest customer registration. */
/* Q88. Top 3 customer tiers by member count. */
/* Q89. Sorted list of distinct courier_names from sales.shipments. */
/* Q90. Top 10 longest-running calls in the last 30 days. */
/* Q91. Orders sorted with NULL net_total at the bottom even in DESC sort. */
/* Q92. List products with the SAME price (handles ties): order by price DESC then product_id ASC for a stable order. */
/* Q93. Top 10 stores by opening_date (oldest first). */
/* Q94. Most recent 20 ad_spend rows per platform. */
/* Q95. Show 5 page_views - but PAGE 1 of MOBILE users only, ordered by view_timestamp DESC. */
/* Q96. Pagination using KEYSET (not OFFSET): orders WHERE order_date < last_seen_date ORDER BY order_date DESC LIMIT 20. */
/* Q97. Top 5 brand_ids by product count. */
/* Q98. Top 10 customers by registration_date DESC, excluding any with NULL first_name. */
/* Q99. Top 10 finance.expenses by amount DESC, only from 2025. */
/* Q100. Show the 25 most recently shipped shipments (where shipped_date IS NOT NULL). */

/* ============================================================
   END OF Filtering & Sorting - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
