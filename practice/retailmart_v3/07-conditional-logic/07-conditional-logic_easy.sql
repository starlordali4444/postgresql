/* ============================================================
   SQL PRACTICE SET - Conditional Logic & Derived Columns (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Conditional Logic & Derived Columns
   Database:     RetailMart V3

   Scope:
     - CASE WHEN (Simple and Searched)
     - COALESCE (first non-NULL)
     - NULLIF (turn a value into NULL)
     - CAST and :: (type conversions)
     - Single-table queries; no JOINs / GROUP BY yet

   Structure: 10 Conceptual + 30 CASE + 30 COALESCE+NULLIF + 30 CAST
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (10)
   ------------------------------------------------------------ */
/* Q1.  Difference between Simple CASE and Searched CASE - give an example of each. */
/* Q2.  What happens if NONE of the WHEN clauses match and there's no ELSE? */
/* Q3.  Can CASE return different data types from different WHEN branches? */
/* Q4.  Why is ORDER of WHEN clauses important in Searched CASE? */
/* Q5.  Difference between COALESCE and NULLIF in one sentence each. */
/* Q6.  What does COALESCE(a, b, c, 'default') do? */
/* Q7.  When does NULLIF(x, 0) help - and what real problem does it solve? */
/* Q8.  Difference between CAST(x AS INT) and x::INT - are they equivalent? */
/* Q9.  Why does casting '12.5' to INT fail? */
/* Q10. What does ::TEXT do to a number? Why might you need it before concatenation? */

/* ============================================================
   SECTION B: CASE WHEN ON V3 DATA (30)
   ------------------------------------------------------------ */
/* Q11. Map customer tier ('Gold','Silver','Bronze','Platinum') to a friendly label using Simple CASE. */
/* Q12. Classify products into 'Cheap' (<100), 'Mid' (<1000), 'Premium' (>=1000) using Searched CASE on price. */
/* Q13. Bucket orders by net_total: 'Small'(<500), 'Medium'(<5000), 'Large'(>=5000). */
/* Q14. Classify employees by salary: 'Junior'(<30K), 'Mid'(<60K), 'Senior'(>=60K). */
/* Q15. Bucket support tickets by priority into a numeric urgency score: Critical=4, High=3, Medium=2, Low=1. */
/* Q16. Map order_status to a binary 'Active' (Pending, Processing, Shipped, Out for Delivery) vs 'Closed' (Delivered, Returned, Cancelled, Failed). */
/* Q17. Label customer reviews: 'Positive' if rating >= 4, 'Neutral' if rating = 3, 'Negative' if rating < 3. */
/* Q18. Classify pay_slips: 'High Tax' if income_tax > 10000, 'Mid' if > 5000, else 'Low'. */
/* Q19. Label hr.attendance by check-in: if check_in IS NULL -> 'Absent', else 'Present'. */
/* Q20. Label web_events.page_views by device: 'Mobile' or 'Tablet' = 'Touch', 'Desktop' = 'Desktop'. */
/* Q21. Classify campaigns by budget: <50K 'Small', <200K 'Medium', else 'Large'. */
/* Q22. Categorize call duration: <60s 'Short', <300s 'Medium', else 'Long'. */
/* Q23. Label loyalty members: points_balance < 500 'Starter', < 2000 'Engaged', else 'VIP'. */
/* Q24. Map api_requests.status_code: 2xx->'OK', 3xx->'Redirect', 4xx->'Client Error', 5xx->'Server Error'. */
/* Q25. Bucket application_logs by level: 'ERROR' or 'FATAL' -> 'Alert'; 'WARN' -> 'Caution'; else 'Info'. */
/* Q26. Label products as 'Made by Top Brand' if brand_id IN (1,2,3,4,5), else 'Other'. */
/* Q27. Label customers as 'New' if registration_date >= CURRENT_DATE - 30, else 'Existing'. */
/* Q28. Bucket orders by month-of-year using CASE on EXTRACT(MONTH FROM order_date): 1-3 'Q1', 4-6 'Q2', etc. */
/* Q29. Day-of-week label for orders: 0/6 -> 'Weekend', else 'Weekday' (EXTRACT(DOW)). */
/* Q30. Mark shipments 'In Transit' if delivered_date IS NULL else 'Delivered'. */
/* Q31. Mark tickets 'Open' if resolved_date IS NULL else 'Resolved'. */
/* Q32. Label employees as 'In-Store' if store_id IS NOT NULL else 'HQ'. */
/* Q33. Tag work_orders by quantity_produced: <500 'Small Batch', <2000 'Mid', else 'Large'. */
/* Q34. Tag expenses as 'Major' if amount > 100000, 'Standard' if > 10000, else 'Minor'. */
/* Q35. Build a 'is_weekend' boolean using CASE: returns TRUE/FALSE on order_date. */
/* Q36. Tag customers by tier ranking in numeric form: Platinum=4, Gold=3, Silver=2, Bronze=1. */
/* Q37. Show product_id and a 'Premium' boolean: TRUE if price > 5000. */
/* Q38. Categorize hr.attendance entries by check-in HOUR: <9 'Early', <12 'Morning', <17 'Afternoon', else 'Late'. */
/* Q39. Label page_views by hour-of-day: <6 'Night', <12 'Morning', <18 'Afternoon', else 'Evening'. */
/* Q40. CASE expression returning the LARGER of net_total and 1000 per order (use CASE WHEN ... THEN ... ELSE). */

/* ============================================================
   SECTION C: COALESCE + NULLIF (30)
   ------------------------------------------------------------ */
/* Q41. Show customer_id with phone, replacing NULL phones with 'NOT PROVIDED'. */
/* Q42. Show ticket resolved_date or '0001-01-01' if NULL using COALESCE. */
/* Q43. Show shipment delivered_date with 'PENDING' label if NULL (note: COALESCE needs compatible types). */
/* Q44. Show customer email or 'no-email@retailmart.com' fallback. */
/* Q45. Show employee store_id or 0 if NULL. */
/* Q46. For sales.shipments, show delivered_date or shipped_date (whichever exists first). */
/* Q47. Show customer's tier_updated_at OR registration_date (fallback chain). */
/* Q48. Show ticket resolved_date OR created_date + INTERVAL '7 days' as estimated resolution. */
/* Q49. For api_requests, show user_agent OR 'unknown'. */
/* Q50. For page_views, show customer_id::TEXT OR 'anonymous' label. */
/* Q51. NULLIF on products.price - if a (hypothetical) zero price exists, return NULL so division won't fail. */
/* Q52. NULLIF on call_duration_seconds - if zero, return NULL. */
/* Q53. Safe percentage: SELECT 100.0 * x / NULLIF(y, 0) - demo with order quantity / unit_price. */
/* Q54. Safe margin: products.products with (price - cost_price) / NULLIF(price, 0). */
/* Q55. Safe ratio of resolved to total for tickets: just write the per-row expression, NULL-safe. */
/* Q56. COALESCE chain for a customer's display contact: COALESCE(phone, email, 'NO_CONTACT'). */
/* Q57. Loyalty members: COALESCE(points_balance, 0) - show every customer in the 'members' table with 0 default. */
/* Q58. Reviews: COALESCE(rating, 0) - show every review with 0 if no rating. */
/* Q59. Returns: COALESCE(refund_amount, 0) - fallback for unrefunded returns. */
/* Q60. Marketing campaigns: COALESCE(end_date, '2099-12-31') - open-ended campaigns get a sentinel future date. */
/* Q61. Show every shipment with a 'duration' that's delivered_date - shipped_date OR 'N/A'. (Two CASTs needed.) */
/* Q62. Show every ticket subject COALESCE(subject, '(empty subject)'). */
/* Q63. For sales.orders, show payment_mode_id OR -1 if NULL. */
/* Q64. For finance.expenses, COALESCE(description, 'No description provided'). */
/* Q65. For products.products, COALESCE(supplier_id, 0) - show every product with a fallback supplier. */
/* Q66. NULLIF on text: NULLIF(TRIM(subject), '') in tickets - converts whitespace-only subjects to NULL. */
/* Q67. Show customer first_name normalized: COALESCE(NULLIF(TRIM(first_name), ''), 'Unknown'). */
/* Q68. Safe division: page_views per customer ID, dividing 1 by NULLIF(customer_id, 0). */
/* Q69. Build a fallback chain for product price: COALESCE(price, cost_price, 0). */
/* Q70. For sales.shipments, courier_name with fallback: COALESCE(courier_name, 'Unknown Courier'). */

/* ============================================================
   SECTION D: CAST / TYPE CONVERSIONS (30)
   ------------------------------------------------------------ */
/* Q71. Cast order_id (INT) to TEXT and concatenate: 'Order ' || order_id::TEXT. */
/* Q72. Cast price (NUMERIC) to INT to round down - products.products. */
/* Q73. Cast net_total to a 2-decimal NUMERIC (ROUND alternative) - sales.orders. */
/* Q74. Cast registration_date (DATE) to TEXT in 'YYYY-MM-DD' format via TO_CHAR (the proper way). */
/* Q75. Cast text '2025-01-15' to DATE explicitly using ::DATE. */
/* Q76. Cast '12.50' to NUMERIC. */
/* Q77. Cast '12.50' to NUMERIC(10,2). */
/* Q78. Cast a field to TEXT using ::TEXT (web_events.events.event_type). */
/* Q79. Cast api_requests.status_code (INT) to TEXT before concatenation. */
/* Q80. Cast call_duration_seconds to interval: (call_duration_seconds || ' seconds')::INTERVAL. */
/* Q81. Cast quantity_produced (INT) to NUMERIC to get a decimal in division: quantity_produced::NUMERIC / 100. */
/* Q82. Cast amount (NUMERIC) to INT for finance.expenses for a simplified summary. */
/* Q83. Cast TIMESTAMP to DATE - sales.shipments.shipped_date is already DATE; pick a TIMESTAMP column: web_events.page_views.view_timestamp::DATE. */
/* Q84. Cast attendance check_in (TIMESTAMP) to TIME using ::TIME. */
/* Q85. Cast attendance check_in to DATE. */
/* Q86. Cast a string '1' to BOOLEAN... actually BOOLEAN expects 't' or 'true' - try (value = 'true')::BOOLEAN. Or simpler: 'true'::BOOLEAN. */
/* Q87. Cast a NUMERIC like 0.85 to TEXT with TO_CHAR(0.85, '0.00%') for percent display. */
/* Q88. Cast products.price to BIGINT (no precision needed for whole-number price). */
/* Q89. Cast '100' to INT explicitly using CAST syntax: CAST('100' AS INT). */
/* Q90. Show TO_CHAR with format 'FM99,99,999' for Indian-style price grouping on products.price. */
/* Q91. Cast text '99.99' to NUMERIC and add 0.01 - result should be 100.00. */
/* Q92. Show TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI:SS') - current timestamp as ISO-ish string. */
/* Q93. Cast review_date to TEXT using ::TEXT (default formatting). */
/* Q94. Cast customer_id (INT) to TEXT and pad with leading zeros using LPAD: LPAD(customer_id::TEXT, 8, '0'). */
/* Q95. Cast salary (NUMERIC) to INT - drop the decimal. */
/* Q96. For sales.orders, cast net_total to INT and prefix with 'Rs': 'Rs' || net_total::INT. */
/* Q97. Cast text to JSONB: '{"role": "admin"}'::JSONB. */
/* Q98. Cast UUID to TEXT for display in a report. */
/* Q99. Cast '2025' (text) to INT - should be 2025. */
/* Q100. Build a display: order_id::TEXT || ' (' || TO_CHAR(net_total, 'FMRs99,99,999') || ')' for invoice-like label. */

/* ============================================================
   END OF Conditional Logic & Derived Columns - EASY LEVEL (100 QUESTIONS)
============================================================ */
