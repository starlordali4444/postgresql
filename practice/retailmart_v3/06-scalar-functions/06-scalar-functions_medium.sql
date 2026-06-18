/* ============================================================
   SQL PRACTICE SET - Scalar Functions (String & Date) (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Scalar Functions - nested + business-flavored
   Database:     RetailMart V3

   Scope (deeper than Easy):
     - Nested string functions, regex (~, ~*, REGEXP_REPLACE)
     - REGEXP_MATCH, REGEXP_SPLIT_TO_TABLE basics
     - Multi-step date math, fiscal periods, interval arithmetic
     - TO_CHAR format specifiers (FM, 99G99G999, etc.)
     - AGE vs subtract, JUSTIFY_INTERVAL
     - String + date combinations for invoice/email templating

   Structure: 25 Conceptual + 25 Nested Strings + 25 Complex Date Math + 25 Mixed Production Patterns
   ============================================================ */

/* ============================================================
   SECTION A: STRING / DATE DEEPER CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does NULL || 'abc' return - and how do you avoid the NULL trap? */
/* Q2.  Difference between SUBSTRING and SUBSTR in PostgreSQL. */
/* Q3.  Compare LIKE '%abc%' vs the regex operator ~ 'abc' - which is case-insensitive? */
/* Q4.  Explain LATERAL vs subqueries in the context of expanding REGEXP_MATCHES result. */
/* Q5.  What does TO_CHAR(num, '99G99G999') do - what's the G? */
/* Q6.  Compare TO_CHAR(date, 'Mon') vs 'FMMon' - what's the difference in output? */
/* Q7.  Why is EXTRACT(EPOCH FROM ...) needed when AGE() returns an interval? */
/* Q8.  What does JUSTIFY_INTERVAL do? */
/* Q9.  Compare TO_DATE('2025-01-15', 'YYYY-MM-DD') vs '2025-01-15'::DATE. */
/* Q10. Why does NOW() inside a transaction always return the SAME time? */
/* Q11. Explain CURRENT_TIMESTAMP vs STATEMENT_TIMESTAMP vs CLOCK_TIMESTAMP. */
/* Q12. What's the difference between AGE(d1) and AGE(d1, d2)? */
/* Q13. Why is DATE_TRUNC('week', date) potentially confusing for Indian users (week starts when?). */
/* Q14. Compare INTERVAL '1 month' vs adding 30 days - when do they differ? */
/* Q15. What does the TIMEZONE function do - give a use case. */
/* Q16. Explain LPAD and RPAD with one example each. */
/* Q17. What's the difference between OVERLAY and SUBSTRING? */
/* Q18. What does REGEXP_REPLACE do - give one cleaning use case. */
/* Q19. Compare REGEXP_MATCHES (returns text[]) vs REGEXP_MATCH (returns text). */
/* Q20. When would you use REGEXP_SPLIT_TO_TABLE vs REGEXP_SPLIT_TO_ARRAY? */
/* Q21. Why is `STRPOS(text, substring)` sometimes preferred over `POSITION(substring IN text)`? */
/* Q22. Explain what FORMAT() does - give a SQL injection-safe example. */
/* Q23. Difference between TO_NUMBER('1,234.50', '9,999.99') and '1234.50'::NUMERIC. */
/* Q24. Why does LENGTH on a TEXT with multi-byte characters return character count, not bytes - and where's the byte-count? */
/* Q25. How do you find the WEEK NUMBER of a date in PostgreSQL? What's the difference between 'WW' and 'IW'? */

/* ============================================================
   SECTION B: NESTED STRING FUNCTIONS (25)
   ------------------------------------------------------------ */
/* Q26. Show customer's full_name with first character of each part capitalized + collapse multiple spaces (nested INITCAP + REGEXP_REPLACE). */
/* Q27. Mask email middle: 'abXXc@domain.com' style - keep first 2, mask middle, keep '@domain'. */
/* Q28. Standardize phone numbers: strip spaces, dashes, '+91 ' prefix. */
/* Q29. Extract username AND domain from email as TWO columns. */
/* Q30. Format product_name as TITLE Case with no trailing whitespace. */
/* Q31. Combine first_name + last_name into a single email-username pattern: 'first.last'. */
/* Q32. Build an SKU-like code from product_name: UPPER(LEFT(product_name, 3)) || '-' || product_id::TEXT. */
/* Q33. Remove all non-digit characters from phone using REGEXP_REPLACE. */
/* Q34. Remove HTML tags from a ticket subject (if any) using REGEXP_REPLACE. */
/* Q35. Count vowels in a customer's first_name. */
/* Q36. Reverse a string: use REVERSE(text). */
/* Q37. Determine if a customer's email is from a "free" provider (gmail/yahoo/outlook). */
/* Q38. Build a name initials display from first_name + last_name: 'P.S.' style. */
/* Q39. Truncate a long support ticket subject to 50 chars + '...' if longer. */
/* Q40. Build a slug from product_name: lowercase, replace non-alphanumeric with '-'. */
/* Q41. Find products whose name has more than 30 characters using LENGTH. */
/* Q42. Find customers whose first_name and last_name are exact duplicates (case-insensitive). */
/* Q43. Show product_name with every '-' replaced by ' ' and the result INITCAP'd. */
/* Q44. Strip a country-code prefix from phone: if it starts with '+91 ', remove it. */
/* Q45. Generate a 10-character random-looking suffix per product (use MD5 + LEFT). */
/* Q46. Build a 6-char short_code from full email using MD5: LEFT(MD5(email), 6). */
/* Q47. Validate (via LIKE / regex) every email contains exactly ONE '@'. */
/* Q48. Find customer first_names that contain non-ASCII characters. */
/* Q49. Extract the area-code from a phone string assumed to be '+91 9876543210': characters 5-7. */
/* Q50. Build a CSV-style "Last, First" display from first_name + last_name. */

/* ============================================================
   SECTION C: COMPLEX DATE MATH (25)
   ------------------------------------------------------------ */
/* Q51. Show every customer's tenure in 'Y years M months D days' format. */
/* Q52. Compute the LAST day of the month of each order_date. */
/* Q53. Compute the FIRST day of the QUARTER for each order. */
/* Q54. Show day-of-year (1-365) for each order. */
/* Q55. Show week-of-year (1-52) using ISO week number for each order. */
/* Q56. Compute "days until next renewal" for each loyalty member assuming renewal_date = join_date + 1 year. */
/* Q57. Show every shipment's delivery delay (delivered - shipped) in DAYS as a numeric. */
/* Q58. Show every ticket's resolution time in HOURS as a numeric. */
/* Q59. Show employees with their tenure bucketed: < 1 yr 'New', < 3 yrs 'Mid', else 'Veteran'. */
/* Q60. Show every order placed at month-end (last 3 days of the month). */
/* Q61. Show every order placed on a Friday. */
/* Q62. Show every employee who joined on the FIRST of any month. */
/* Q63. Show every customer registered exactly N years ago today (anniversary report). */
/* Q64. Convert an attendance check_in (TIMESTAMP) to "minutes after midnight". */
/* Q65. Bucket api_requests by hour-of-day and count per hour (just GROUP BY hour). */
/* Q66. Find the SAME date a year ago for each order_date (date - INTERVAL '1 year'). */
/* Q67. Compute working days between shipped_date and delivered_date - approximate using day-of-week (subtract weekends). */
/* Q68. Show every order_date formatted as 'Q1-2025', 'Q2-2025' etc. */
/* Q69. Show every order placed in the LAST FISCAL YEAR (assume FY = April to March). */
/* Q70. Compute days between two timestamps with millisecond precision. */
/* Q71. Show the start of the ISO week for each order_date. */
/* Q72. Build a list of all DATES in the most recent 30 days (use generate_series). */
/* Q73. Find every TICKET resolved on a weekend. */
/* Q74. Find any work_order with an end_timestamp earlier than its start_timestamp (data quality bug). */
/* Q75. Compute how MANY days each order is from the median order date (advanced). */

/* ============================================================
   SECTION D: PRODUCTION PATTERNS - INVOICE/EMAIL/REPORT (25)
   ------------------------------------------------------------ */
/* Q76. Build a customer welcome email subject: 'Welcome ' || INITCAP(first_name) || '! Your member ID is CUST-' || customer_id. */
/* Q77. Build an invoice header line: 'INVOICE #' || order_id || ' - ' || INITCAP(c.first_name || ' ' || c.last_name) || ' - ' || TO_CHAR(o.order_date, 'DD-Mon-YYYY'). */
/* Q78. Build a shipment status line: 'Shipment ' || shipment_id || ' from ' || INITCAP(courier_name) || ' - ' || CASE WHEN delivered_date IS NULL THEN 'IN TRANSIT (since ' || TO_CHAR(shipped_date, 'DD Mon') || ')' ELSE 'DELIVERED on ' || TO_CHAR(delivered_date, 'DD Mon') END. */
/* Q79. Build a renewal reminder: 'Hi ' || first_name || ', your loyalty membership renews on ' || TO_CHAR(join_date + INTERVAL '1 year', 'DD Mon YYYY'). */
/* Q80. Build a ticket aging label: 'Open since ' || EXTRACT(DAY FROM CURRENT_TIMESTAMP - created_date) || ' days' for unresolved tickets. */
/* Q81. Build a salary slip line: 'Net Rs' || TO_CHAR(net_salary, 'FM99,99,999.00') || ' for ' || salary_month || ' ' || salary_year. */
/* Q82. Build a return notice: 'Return ' || return_id || ' for Rs' || TO_CHAR(refund_amount, 'FM99,99,999') || ' processed on ' || TO_CHAR(return_date, 'DD-Mon-YYYY'). */
/* Q83. Build a marketing campaign label: campaign_name || ' (Rs' || TO_CHAR(budget, 'FM99,99,999') || ', ' || TO_CHAR(start_date, 'Mon YYYY') || ')'. */
/* Q84. Build an expense report line: 'Expense ' || expense_id || ': Rs' || TO_CHAR(amount, 'FM99,99,999.00') || ' on ' || TO_CHAR(expense_date, 'DD-Mon-YYYY') || ' - ' || description. */
/* Q85. Build a customer activity stamp: 'Customer ' || customer_id || ' joined ' || EXTRACT(YEAR FROM AGE(registration_date)) || 'y ' || EXTRACT(MONTH FROM AGE(registration_date)) || 'm ago'. */
/* Q86. Build a call log: 'Call ' || call_id || ' (' || call_duration_seconds || 's) at ' || TO_CHAR(call_start_time, 'DD-Mon HH24:MI'). */
/* Q87. Build a page-view event: 'PV-' || view_id || ': ' || page_url || ' on ' || device_type || ' (' || os || ')'. */
/* Q88. Build a review summary: '*' || REPEAT('*', rating - 1) || ' on ' || TO_CHAR(review_date, 'DD Mon YYYY'). */
/* Q89. Build a work_order tag: 'WO#' || work_order_id || ' (' || quantity_produced || ' produced, ' || rejected_quantity || ' rejected)'. */
/* Q90. Build a transcript snippet: LEFT(transcript_text, 100) || '...' if longer than 100 else transcript_text. */
/* Q91. Build a search-friendly product slug for URL: LOWER(REGEXP_REPLACE(product_name, '[^a-zA-Z0-9]+', '-', 'g')) || '-' || product_id. */
/* Q92. Build a customer JSON summary as text: '{"id":' || customer_id || ',"name":"' || first_name || '","tier":"' || tier || '"}'. */
/* Q93. Build a 'last seen' label using AGE for each customer: based on most recent page_view. (Single-table tip: use a placeholder MAX timestamp.) */
/* Q94. Build a 'days since hire' label per employee. */
/* Q95. Build a fiscal-year label (FY24, FY25) for each order_date assuming FY = April-March. */
/* Q96. Build a date-bucket label per order: 'today' / 'yesterday' / 'this_week' / 'this_month' / 'older'. */
/* Q97. Build a 'shipped-but-not-delivered for X days' label per shipment. */
/* Q98. Build a 'high-value' flag string per order: order_id + ' [HIGH]' if net_total > 10000 else order_id + ' [normal]'. */
/* Q99. Build a sentiment summary per call: 'Call ' || call_id || ' - sentiment ' || CASE WHEN sentiment_score >= 0.5 THEN 'positive' WHEN sentiment_score <= -0.5 THEN 'negative' ELSE 'neutral' END (from transcripts joined to calls). */
/* Q100. Build an aging report: every unresolved ticket with 'Ticket ' || ticket_id || ' open ' || (CURRENT_DATE - created_date::DATE) || ' days; priority ' || priority. */

/* ============================================================
   END OF Scalar Functions (String & Date) - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
