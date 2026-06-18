/* ============================================================
   SQL PRACTICE SET - Aggregate Functions & Grouping (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Aggregate Functions & GROUP BY
   Database:     RetailMart V3

   Scope:
     - Aggregates: COUNT, SUM, AVG, MIN, MAX, STRING_AGG
     - GROUP BY (single column)
     - HAVING vs WHERE
     - Single- or single-grouped queries; no JOINs yet

   Structure: 10 Conceptual + 30 Aggregates + 30 GROUP BY + 30 HAVING/STRING_AGG
   ============================================================ */

/* ============================================================
   SECTION A: AGGREGATE / GROUP BY - CONCEPTUAL (10)
   ------------------------------------------------------------ */
/* Q1.  Difference between COUNT(*) and COUNT(column_name). */
/* Q2.  What does COUNT(DISTINCT col) return? */
/* Q3.  Does AVG include NULLs in the denominator? Why does it matter? */
/* Q4.  What does SUM return on an empty result set - 0 or NULL? */
/* Q5.  Difference between WHERE and HAVING - give an example of each. */
/* Q6.  Why can't WHERE filter on COUNT(*)? */
/* Q7.  Rule: every non-aggregated SELECT column must appear in GROUP BY - why? */
/* Q8.  What is STRING_AGG and when is it useful? */
/* Q9.  Does STRING_AGG respect order? How do you control the order of concatenation? */
/* Q10. Why is MIN/MAX valid on dates and strings, not just numbers? */

/* ============================================================
   SECTION B: SINGLE-NUMBER AGGREGATES (NO GROUP BY) (30)
   ------------------------------------------------------------ */
/* Q11. How many customers does RetailMart have? */
/* Q12. How many orders has RetailMart processed in total? */
/* Q13. How many delivered orders? (filter then COUNT). */
/* Q14. How many customer reviews exist? */
/* Q15. How many distinct cities do stores operate in? */
/* Q16. How many distinct order_status values are in sales.orders? */
/* Q17. How many distinct customer tiers exist? */
/* Q18. How many products have a price above 1000? */
/* Q19. How many tickets are currently 'Open'? */
/* Q20. How many support tickets have NEVER been resolved? */
/* Q21. What is the TOTAL revenue across all delivered orders? (SUM net_total). */
/* Q22. What is the AVERAGE order net_total across all orders? */
/* Q23. What is the AVERAGE salary across all employees? */
/* Q24. What is the AVERAGE product price across the catalog? */
/* Q25. What is the AVERAGE customer review rating? */
/* Q26. What is the highest salary in the company? */
/* Q27. What is the lowest salary in the company? */
/* Q28. What is the most expensive product price? */
/* Q29. What is the cheapest product price (above 0)? */
/* Q30. What is the LATEST order date in sales.orders? */
/* Q31. What is the EARLIEST order date in sales.orders? */
/* Q32. What is the AVERAGE call_duration_seconds across all calls? */
/* Q33. What is the MAX refund_amount in sales.returns? */
/* Q34. What is the SUM of all marketing.campaigns budgets? */
/* Q35. What is the AVERAGE finance.expenses amount? */
/* Q36. What is the TOTAL finance.expenses amount for 2025? */
/* Q37. What is the SUM of all payroll.pay_slips.net_salary? (Total salary payout.) */
/* Q38. What is the MAX loyalty.members.points_balance? */
/* Q39. What is the MIN loyalty.members.points_balance? */
/* Q40. Get all 5 stats (count, sum, avg, min, max) of net_total on sales.orders in one row. */

/* ============================================================
   SECTION C: GROUP BY - SINGLE COLUMN (30)
   ------------------------------------------------------------ */
/* Q41. Count orders per order_status (sales.orders). */
/* Q42. Count customers per tier (customers.customers). */
/* Q43. Count tickets per priority. */
/* Q44. Count tickets per status. */
/* Q45. Count page_views per device_type. */
/* Q46. Count application_logs per level. */
/* Q47. Count api_requests per method. */
/* Q48. Count api_requests per status_code (interesting distribution). */
/* Q49. Count employees per role. */
/* Q50. Count stores per city. */
/* Q51. Count products per brand_id. */
/* Q52. Count reviews per rating (1 through 5). */
/* Q53. Count returns per reason. */
/* Q54. Count ads_spend rows per platform. */
/* Q55. SUM net_total per order_status. */
/* Q56. SUM salary per role (employees). */
/* Q57. AVG net_total per order_status. */
/* Q58. AVG salary per dept_id (employees). */
/* Q59. AVG rating per category in support tickets. */
/* Q60. SUM budget per campaign month (DATE_TRUNC('month', start_date)). */
/* Q61. Count orders per order_date month (DATE_TRUNC('month', order_date)). */
/* Q62. Count customers per registration year (EXTRACT(YEAR FROM registration_date)). */
/* Q63. Count calls per call_reason. */
/* Q64. SUM call_duration_seconds per agent_id (which agent talks the most?). */
/* Q65. Count attendance entries per employee_id. */
/* Q66. Count tickets per customer_id. */
/* Q67. SUM refund_amount per return reason. */
/* Q68. SUM amount per exp_cat_id (finance.expenses). */
/* Q69. MAX salary per dept_id. */
/* Q70. MIN price per brand_id. */

/* ============================================================
   SECTION D: HAVING + STRING_AGG (30)
   ------------------------------------------------------------ */
/* Q71. List order statuses with more than 1,000 orders (GROUP BY ... HAVING COUNT > 1000). */
/* Q72. List cities with more than 5 stores (HAVING COUNT > 5). */
/* Q73. List tiers with more than 5,000 customers. */
/* Q74. List brands with more than 100 products. */
/* Q75. List employee roles with more than 50 people. */
/* Q76. List rating values where there are 1000+ reviews. */
/* Q77. List call_reasons with more than 500 calls. */
/* Q78. List page_view device_types with more than 100,000 views. */
/* Q79. List api_request methods with more than 1,000 hits. */
/* Q80. List ticket priorities where >= 1000 tickets exist. */
/* Q81. Per role, only roles whose AVG salary > 50000. */
/* Q82. Per brand_id, only brands whose AVG product price > 1000. */
/* Q83. Per order_status, only statuses whose SUM net_total > 1,000,000. */
/* Q84. Per registration year, only years with > 5,000 new customers. */
/* Q85. Per month, only months with more than 5,000 orders. */
/* Q86. Per dept_id, only departments where SUM salary > 10,000,000. */
/* Q87. Per campaign month, only months with total budget > 1,000,000. */
/* Q88. Per platform (ads_spend), only platforms with SUM amount > 1,000,000. */
/* Q89. Per category (tickets), only categories with more than 500 tickets. */
/* Q90. Per exp_cat_id, only categories with sum amount > 5,000,000. */
/* Q91. STRING_AGG: comma-separated list of distinct order_status from sales.orders. */
/* Q92. STRING_AGG: comma-separated list of distinct cities from stores.stores. */
/* Q93. STRING_AGG: comma-separated list of distinct tiers from customers.customers, alphabetised. */
/* Q94. STRING_AGG: per role, list ALL employee first_names joined by ', '. */
/* Q95. STRING_AGG DISTINCT: per call_reason, distinct status values. */
/* Q96. STRING_AGG: per priority, all ticket subjects (LIMIT to a small group). */
/* Q97. STRING_AGG: per device_type, distinct OS values (web_events.page_views). */
/* Q98. STRING_AGG: per dept_id, list of employee first names ordered alphabetically. */
/* Q99. STRING_AGG: per brand_id, list of product names (might be long - verify on a small sample). */
/* Q100. STRING_AGG with ORDER BY inside: per ticket category, subjects ordered by created_date. */

/* ============================================================
   END OF Aggregate Functions & Grouping - EASY LEVEL (100 QUESTIONS)
============================================================ */
