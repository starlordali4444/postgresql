/* ============================================================
   SQL PRACTICE SET - Conditional Logic & Derived Columns (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Conditional Logic - nested + multi-tool combinations
   Database:     RetailMart V3

   Scope (deeper than Easy):
     - Nested CASE (CASE within CASE)
     - CASE inside aggregates (peek at Day 8)
     - COALESCE chains (3+ args), with NULLIF for "treat-as-NULL" tricks
     - CAST chains, USING in ALTER TABLE casts (review)
     - Combined CASE + COALESCE + NULLIF + CAST in production patterns

   Structure: 25 Conceptual + 25 Nested CASE + 25 COALESCE/NULLIF chains + 25 Production combos
   ============================================================ */

/* ============================================================
   SECTION A: CONDITIONAL LOGIC DEEPER - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Compare CASE in WHERE vs CASE in SELECT - when does each shine? */
/* Q2.  What's the difference between Simple CASE and Searched CASE - give example of each. */
/* Q3.  Can a CASE return different DATA TYPES from different WHEN branches? */
/* Q4.  Explain CASE inside SUM - what does SUM(CASE WHEN ... THEN net_total END) compute? */
/* Q5.  Compare COALESCE(a, b, c) vs CASE WHEN a IS NOT NULL THEN a WHEN b IS NOT NULL THEN b ELSE c END. */
/* Q6.  Why is NULLIF(x, 0) commonly used in a division denominator? */
/* Q7.  Explain CAST('12.5' AS INT) vs '12.5'::INT - same result? */
/* Q8.  What is the difference between :: (PostgreSQL cast) and CAST (SQL-standard)? */
/* Q9.  Why does casting '2025-13-01'::DATE fail - what's the rule for valid dates? */
/* Q10. What's the type-conversion priority of CASE: if branches return TEXT and INT mixed, what does the optimizer do? */
/* Q11. Explain how CASE evaluates short-circuit: does it eval all branches or stop at first match? */
/* Q12. Why is `CASE WHEN x = NULL THEN 'a'` always FALSE - and what should you use instead? */
/* Q13. Compare COALESCE(a, b) and a IS DISTINCT FROM b - when do they relate? */
/* Q14. Why is NULLIF useful for sentinel values like empty string? */
/* Q15. Can CAST happen implicitly - give two cases when PostgreSQL silently casts. */
/* Q16. Difference between IS NULL and = NULL - why does the second never work? */
/* Q17. Compare CAST(x AS TEXT) vs x::TEXT vs TO_CHAR(x, ...) - when do you choose each? */
/* Q18. What happens if all WHEN branches in a CASE return NULL but there's no ELSE? */
/* Q19. Why is GREATEST(a, b, c) related to MAX in spirit but different in scope? */
/* Q20. Can you nest CASE inside CASE - give a use case. */
/* Q21. What happens when COALESCE arguments include different types (INT, TEXT)? */
/* Q22. When does CAST silently truncate vs error? Example: NUMERIC -> INT vs TEXT -> INT. */
/* Q23. Why does NULLIF(NULL, 0) return NULL, not 0? */
/* Q24. Compare CASE expression vs COALESCE for readability - which is preferred for fallback chains? */
/* Q25. Why is CAST(price AS NUMERIC(10,2)) safer than CAST(price AS NUMERIC) in production? */

/* ============================================================
   SECTION B: NESTED + COMBINED CASE (25)
   ------------------------------------------------------------ */
/* Q26. Classify customers into 'Premium' (Gold/Platinum) -> further into 'Loyal' (registered >= 3 yrs) vs 'New Premium' (< 3 yrs). Use NESTED CASE. */
/* Q27. Classify orders: high-value (> 10000) AND Delivered -> 'A'; high-value AND not delivered -> 'B'; low-value AND Delivered -> 'C'; else 'D'. */
/* Q28. Bucket products: brand IS NULL -> 'Unknown brand'; ELSE bucket by price (cheap/mid/premium). */
/* Q29. Combine CASE + LIKE: classify employees by role pattern: contains 'Manager' -> 'Mgr'; contains 'Engineer' -> 'Eng'; else 'Other'. */
/* Q30. Combine CASE + EXTRACT(DOW): label each order_date as 'Weekend' (DOW IN 0,6) or weekday name. */
/* Q31. Build a customer "lifecycle stage" label using 3+ conditions: tier + registration_date + (assume) order count > N. */
/* Q32. Show every ticket with a 'severity_score' INT: priority=Critical->4, High->3, Medium->2, Low->1, else 0. */
/* Q33. Show every order with an 'urgency_label': order_status='Delivered' -> 'Done'; 'Pending' -> 'Urgent if > 7 days old' else 'OK'; etc. */
/* Q34. Conditional aggregation preview: SUM(CASE WHEN order_status='Delivered' THEN net_total END) AS delivered_revenue from sales.orders. */
/* Q35. Conditional COUNT: COUNT(CASE WHEN rating = 5 THEN 1 END) AS five_stars from customers.reviews. */
/* Q36. Show every employee with bracket: salary < 30K -> 'Junior'; < 60K -> 'Mid'; < 100K -> 'Senior'; else 'Executive'. */
/* Q37. Build a 'safety score' from sales.shipments using CASE: delivered same day as shipped -> 5; 1-2 days -> 4; 3-7 days -> 3; > 7 days -> 2; not delivered -> 1. */
/* Q38. Bucket product reviews using BOTH rating and length(comment): 5-star with long comment -> 'Detailed praise'; 5-star with no comment -> 'Quick like'; etc. */
/* Q39. Conditional aggregation: SUM of net_total only for orders placed on weekends. */
/* Q40. Use CASE inside ORDER BY: sort by priority custom order (Critical first, then High, Medium, Low). */
/* Q41. Show every customer with their tier_rank: Bronze=1, Silver=2, Gold=3, Platinum=4 - useful as a sort key. */
/* Q42. Build a hierarchical label: combine tier + registration year as a label like 'Gold-2024'. */
/* Q43. Use CASE to show only specific months by name (filter via WHERE doesn't quite fit - use CASE in SELECT to label 'Q1', 'Q2', 'Q3', 'Q4'). */
/* Q44. Build a 'days_to_action' field: if status='Delivered' return delivered_date - order_date; else CURRENT_DATE - order_date. */
/* Q45. Show every order with a 'paid_status' derived from sales.payments via a subquery + CASE (paid in full, partial, unpaid). */
/* Q46. Compute the GREATEST of three: GREATEST(price, cost_price, 100) from products.products. */
/* Q47. Compute the LEAST of three: LEAST(price, cost_price, 100). */
/* Q48. Use CASE to detect "this row is the FIRST order of its customer" - show ticket_id with a Y/N marker (correlated subquery for MIN). */
/* Q49. Build a CASE that converts hr.attendance check_in into a shift label: < 6am 'Night', < 12pm 'Morning', < 6pm 'Day', else 'Evening'. */
/* Q50. Combine CASE + INTERVAL: tag every ticket as 'Fast' if resolved within 1 hour, 'Same Day' if same day, 'Slow' otherwise. */

/* ============================================================
   SECTION C: COALESCE / NULLIF CHAINS (25)
   ------------------------------------------------------------ */
/* Q51. For each customer, prefer phone, fall back to email, fall back to 'NO CONTACT' - single COALESCE chain. */
/* Q52. For each shipment, show "delivered_date OR shipped_date + 5 days OR CURRENT_DATE" - three-level COALESCE. */
/* Q53. For each loyalty member, show next_tier_threshold using COALESCE on points_balance vs benchmarks. */
/* Q54. NULLIF(LENGTH(TRIM(subject)), 0) - convert empty/whitespace-only subjects to NULL on tickets. */
/* Q55. NULLIF(price, 0) prevents divide-by-zero in margin calc. */
/* Q56. Safe percentage: 100.0 * good_count / NULLIF(total_count, 0) - apply to a real RetailMart aggregate. */
/* Q57. COALESCE multiple email columns into one preferred email (real-world: contact_email, billing_email, alt_email). */
/* Q58. Replace ALL "" with NULL on the fly: NULLIF(TRIM(col), '') for every text column you select. */
/* Q59. COALESCE(t.tier_name, 'No Tier') for customers who aren't loyalty members. */
/* Q60. COALESCE(refund_amount, 0) for returns awaiting refund. */
/* Q61. Show every customer's tier OR 'Standard' if NULL - single-line. */
/* Q62. COALESCE inside a SUM: SUM(COALESCE(refund_amount, 0)) so NULLs count as 0. */
/* Q63. NULLIF(end_date, '9999-12-31') - turn sentinel dates back into NULL. */
/* Q64. COALESCE on JSONB key access: payload->>'city' OR 'unknown'. */
/* Q65. Triple COALESCE: city from addresses -> city from store -> 'India' as final fallback. */
/* Q66. Build "Hello [name]!" greeting using COALESCE first_name, last_name, email, 'Guest'. */
/* Q67. NULLIF for whitespace-only emails: NULLIF(TRIM(email), ''). */
/* Q68. For payments, COALESCE(amount, 0) AS amount when amount might be NULL. */
/* Q69. For employees, COALESCE(store_id::TEXT, 'HQ') so HQ staff get a label, not NULL. */
/* Q70. COALESCE customer tier_updated_at OR registration_date AS effective_change_date. */
/* Q71. Show shipments with: status if not NULL, else 'In Transit' if shipped_date IS NOT NULL, else 'Unknown'. */
/* Q72. For tickets, COALESCE category, 'General' AS effective_category. */
/* Q73. For finance.expenses, COALESCE(description, 'No description') for display. */
/* Q74. For api_requests, COALESCE(user_agent, 'unknown') AS ua. */
/* Q75. NULLIF + COALESCE combo: COALESCE(NULLIF(TRIM(first_name), ''), 'Unknown') AS clean_first. */

/* ============================================================
   SECTION D: CAST + PRODUCTION COMBOS (25)
   ------------------------------------------------------------ */
/* Q76. Build an invoice string with multiple CASTs: 'Order #' || order_id::TEXT || ' (Rs' || net_total::TEXT || ')'. */
/* Q77. Cast products.price to ROUND-friendly NUMERIC(10,2). */
/* Q78. Cast view_timestamp::DATE to bucket page_views by date. */
/* Q79. Use ::INTERVAL to cast '300 seconds' for a call into an interval. */
/* Q80. Combine ::DATE + ::TIME on hr.attendance check_in for separate display. */
/* Q81. Use TO_CHAR(price, 'FMRs99,99,999.00') to display Indian-style currency. */
/* Q82. Use TO_CHAR(order_date, 'FMDay, DD Mon YYYY') for a friendly date display. */
/* Q83. Show every employee's age_in_years using EXTRACT(YEAR FROM AGE(joining_date))::INT. */
/* Q84. Show every customer with their preferred display name: full name OR email OR 'Customer #' || customer_id. */
/* Q85. Combine CASE + CAST: bucket products by price, return a labeled string. */
/* Q86. Build a "stock alert" line per product: 'PRODUCT-' || product_id::TEXT || ': ' || product_name || ' is ' || CASE WHEN in_stock THEN 'IN STOCK' ELSE 'OUT' END. */
/* Q87. Build an order summary: order_id, customer name (INITCAP), net_total (FORMATTED), status (UPPER), date (TO_CHAR). */
/* Q88. Build a ticket aging banner: 'AGING ' || (CURRENT_DATE - created_date::DATE)::TEXT || ' DAYS - PRIORITY ' || UPPER(priority) for open tickets. */
/* Q89. Build a customer status row: tier (COALESCE), tenure (years), and a SAFE-divided "points-per-year" using NULLIF. */
/* Q90. Build a 'risk' flag for sales.shipments combining CASE + NULLIF: high risk if delayed > 14 days AND not yet delivered. */
/* Q91. Cast loyalty.members.points_balance to BIGINT to support summed totals over many customers. */
/* Q92. Combine CASE + CAST + COALESCE: show every payment with amount (COALESCE 0), mode (CASE in-store/online), and date (TO_CHAR). */
/* Q93. Build a refund_request_age in days using CASE on refund_amount IS NULL plus date arithmetic. */
/* Q94. For each customer, compute a "spend tier" using a single CASE on a (hypothetical) total_spend, with NULLIF for missing data. */
/* Q95. Show every employee with a 'shift' classification using CASE on EXTRACT(HOUR FROM check_in), and treat NULL check_in as 'Absent'. */
/* Q96. Show every product with 'margin_pct' = ROUND(100.0 * (price - cost_price) / NULLIF(price, 0), 2) - safe division. */
/* Q97. Compute the 'pay component split' per pay_slip: basic %, hra %, allowances %, taxes %, net % using NULLIF(gross, 0). */
/* Q98. For each application_log, build a severity_int = CASE level WHEN 'FATAL' THEN 5 WHEN 'ERROR' THEN 4 WHEN 'WARN' THEN 3 WHEN 'INFO' THEN 2 ELSE 1 END. */
/* Q99. For each api_request, compute a status_category (2xx/3xx/4xx/5xx) using CASE on status_code. */
/* Q100. Combine ALL TOOLS: For each order, show order_id, INITCAP customer name, net_total formatted, status uppercased, and 'days since' as INT - with NULL-safety throughout. */

/* ============================================================
   END OF Conditional Logic & Derived Columns - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
