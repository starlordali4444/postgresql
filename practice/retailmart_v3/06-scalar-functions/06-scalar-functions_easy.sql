/* ============================================================
   SQL PRACTICE SET - Scalar Functions (String & Date) (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Scalar Functions - String & Date
   Database:     RetailMart V3

   Scope:
     - String: UPPER, LOWER, INITCAP, LENGTH, SUBSTRING,
               TRIM, CONCAT / ||, REPLACE, POSITION, SPLIT_PART, LEFT, RIGHT
     - Date:   NOW(), CURRENT_DATE, CURRENT_TIMESTAMP, AGE,
               EXTRACT, DATE_TRUNC, TO_CHAR, interval math
     - Single-table queries; no JOINs / GROUP BY yet

   Structure: 10 Conceptual + 30 String + 30 Date + 30 Mixed
   ============================================================ */

/* ============================================================
   SECTION A: STRING & DATE - CONCEPTUAL (10)
   ------------------------------------------------------------ */
/* Q1.  Difference between UPPER, LOWER, and INITCAP - give one example each. */
/* Q2.  What does LENGTH return for a NULL value? */
/* Q3.  When would you use SUBSTRING vs SPLIT_PART? */
/* Q4.  Difference between || (concat operator) and CONCAT function for NULL handling. */
/* Q5.  What does TRIM remove by default? */
/* Q6.  Difference between NOW() and CURRENT_DATE. */
/* Q7.  Why does subtracting two dates give an "interval" - and how do you convert it to integer days? */
/* Q8.  When would you use DATE_TRUNC vs EXTRACT? */
/* Q9.  Why does TO_CHAR(date, 'Day') give a name padded with spaces - and how do you fix it? */
/* Q10. Does AGE() with one argument compare to TODAY, or another date? */

/* ============================================================
   SECTION B: STRING FUNCTIONS ON V3 DATA (30)
   ------------------------------------------------------------ */
/* Q11. The Customer Service team wants all customer names in UPPERCASE. Show customer_id, first_name, last_name in UPPER case. */
/* Q12. Show customer first_name in lower case. */
/* Q13. Show customer full_name using INITCAP and concatenation: 'firstname lastname' (proper case). */
/* Q14. Show product_name as UPPER from products.products. */
/* Q15. Show LENGTH of every product_name (number of characters). */
/* Q16. Show the LENGTH of every customer's email. */
/* Q17. Extract the FIRST 5 characters of product_name using LEFT. */
/* Q18. Extract the LAST 4 characters of every customer phone using RIGHT (the masking pattern). */
/* Q19. Use SUBSTRING to grab characters 1 to 3 of product_name. */
/* Q20. Use SPLIT_PART to extract the domain of every customer email (the part after '@'). */
/* Q21. Use SPLIT_PART to extract the username of every customer email (the part before '@'). */
/* Q22. Find the POSITION of '@' in every customer email. */
/* Q23. Show product_name with all double spaces replaced by single space using REPLACE. */
/* Q24. Use TRIM to clean up whitespace around support ticket subjects. */
/* Q25. Concatenate first_name and last_name with a space between, alias as full_name (customers.customers). */
/* Q26. The CHRO wants every employee's full name + role joined as 'Aarav Sharma - Store Manager'. */
/* Q27. Show every customer's email in lower case (data hygiene step). */
/* Q28. Concatenate 'Order #' with order_id (cast as text) for a friendly display. */
/* Q29. Build a customer code like 'CUST-' || customer_id for ticket templates. */
/* Q30. For products, build a display string 'PRODUCT: ' || product_name. */
/* Q31. Show employees where role contains 'Manager' (LIKE). */
/* Q32. Show only the part of product_name AFTER the first space (use POSITION + SUBSTRING). */
/* Q33. Show only the FIRST WORD of every product_name using SPLIT_PART. */
/* Q34. Mask every customer email: keep first 2 chars, then 'XXX', then domain. (e.g., 'pr***@gmail.com'). */
/* Q35. Show every customer's first_name with the length next to it. */
/* Q36. UPPER + TRIM combo - clean up support ticket subjects. */
/* Q37. Show the role of every employee with leading/trailing spaces removed. */
/* Q38. From customers.customers email, get domain only - useful for domain-distribution reports later. */
/* Q39. Concatenate city + state for stores.stores: 'city, state' format (note: stores.stores doesn't have state - use 'India' as the literal second part). */
/* Q40. Build a 'Hi <first_name>!' greeting string per customer for the email campaign. */

/* ============================================================
   SECTION C: DATE FUNCTIONS ON V3 DATA (30)
   ------------------------------------------------------------ */
/* Q41. Show the current date (server side). */
/* Q42. Show the current timestamp with timezone. */
/* Q43. Show customer_id and registration_date EXTRACT(YEAR) - what year did they register? */
/* Q44. Show order_id and EXTRACT(MONTH FROM order_date) for each order. */
/* Q45. Show order_id and EXTRACT(DAY FROM order_date) per order. */
/* Q46. Show order_id and EXTRACT(DOW FROM order_date) - day-of-week number. */
/* Q47. Show order_id and EXTRACT(QUARTER FROM order_date). */
/* Q48. Bucket each order to the first day of its month using DATE_TRUNC. */
/* Q49. Bucket each order to its week using DATE_TRUNC('week', order_date). */
/* Q50. Bucket each order to its year using DATE_TRUNC. */
/* Q51. Show every order_date formatted as 'DD-Mon-YYYY' using TO_CHAR. */
/* Q52. Show every registration_date formatted as 'YYYY-MM-DD' explicitly. */
/* Q53. Show day-of-week NAME for each order_date using TO_CHAR(order_date, 'FMDay'). */
/* Q54. Show month NAME for each order_date using TO_CHAR(order_date, 'FMMonth'). */
/* Q55. How many DAYS ago was each order placed? (CURRENT_DATE - order_date). */
/* Q56. Use AGE() to show each customer's account age. */
/* Q57. Extract just the years portion of each customer's account age. */
/* Q58. Compute "days since shipment" for sales.shipments where shipped_date IS NOT NULL. */
/* Q59. Compute delivery duration (delivered_date - shipped_date) for delivered shipments. */
/* Q60. Compute ticket resolution time (resolved_date - created_date) for resolved tickets. */
/* Q61. Show only orders placed in the LAST 30 days (use INTERVAL). */
/* Q62. Show orders placed in the LAST 7 days. */
/* Q63. Show customers registered in the LAST 90 days. */
/* Q64. Show tickets created in the LAST 24 hours. */
/* Q65. Use DATE_TRUNC and TO_CHAR together to label each order's month like 'Mar 2025'. */
/* Q66. Show shipments where shipped_date is in calendar year 2025. */
/* Q67. Show calls from call_center.calls that started in January 2025. */
/* Q68. Show hr.attendance for any Saturday (EXTRACT(DOW) = 6). */
/* Q69. Show every payroll pay_slip where the payment_date falls in Q1 of 2025. */
/* Q70. Compute the customer's tenure in YEARS only: EXTRACT(YEAR FROM AGE(registration_date)). */

/* ============================================================
   SECTION D: MIXED STRING + DATE (30)
   ------------------------------------------------------------ */
/* Q71. Build a label per order: '#' || order_id || ' on ' || TO_CHAR(order_date, 'DD-Mon-YYYY'). */
/* Q72. Show customer full name (INITCAP) + 'registered on ' + formatted registration_date. */
/* Q73. Show employee full name + 'joined on ' + TO_CHAR(joining_date, 'Mon YYYY'). */
/* Q74. Build a product label: UPPER(product_name) || ' - Rs' || price for the price catalog. */
/* Q75. Build a ticket label: subject (trimmed + INITCAP) + ' (created ' + TO_CHAR(created_date, 'DD-Mon HH24:MI') + ')'. */
/* Q76. Show stores.stores with store_name (INITCAP) + ' in ' + city. */
/* Q77. Build an employee greeting: 'Hi ' || INITCAP(first_name) || ', you joined us ' || EXTRACT(YEAR FROM AGE(joining_date)) || ' years ago.'. */
/* Q78. Make a customer thank-you string: 'Thank you ' || INITCAP(first_name) || '! Member since ' || EXTRACT(YEAR FROM registration_date). */
/* Q79. Build an order display: 'Order ' || order_id || ' placed on ' || TO_CHAR(order_date, 'FMDay, DD Mon YYYY'). */
/* Q80. Customer tenure bucket: TO_CHAR(EXTRACT(YEAR FROM AGE(registration_date)), 'FM00') || ' years'. */
/* Q81. Build a shipment label: courier_name (UPPER) + ' - ' + TO_CHAR(shipped_date, 'DD/MM/YYYY') for sales.shipments. */
/* Q82. Build a call duration label: 'Call ' || call_id || ': ' || call_duration_seconds || 's'. */
/* Q83. Format each campaign with name (INITCAP) and budget (TO_CHAR(budget, 'FM99,99,999')). */
/* Q84. Show every customer's email in lower case + their domain (SPLIT_PART) + length of email. */
/* Q85. Show product_name + length-of-name + first-3-chars. */
/* Q86. Build an employee tenure display: 'EMP-' || employee_id::TEXT || ': ' || first_name || ' (' || EXTRACT(YEAR FROM AGE(joining_date)) || ' yrs)'. */
/* Q87. Show every order_id with its month-name + year: '#' || order_id || ' in ' || TO_CHAR(order_date, 'FMMonth YYYY'). */
/* Q88. Trim+INITCAP the ticket subject and prefix with 'TICKET-' || ticket_id. */
/* Q89. Build a 'days since last activity' indicator for every shipment: CURRENT_DATE - shipped_date with a ' days ago' suffix. */
/* Q90. Show every customer's account age in 'Y years M months' format using AGE + EXTRACT. */
/* Q91. Concat region info: 'Order from store ' || store_id || ' on ' || TO_CHAR(order_date, 'YYYY-MM-DD'). */
/* Q92. For every page_view, build a session label: 'Session ' || session_id || ' viewed ' || page_url + ' at ' + TO_CHAR(view_timestamp, 'HH24:MI:SS'). */
/* Q93. For every call_center.calls row, build a string 'Call #' || call_id || ' by agent ' || agent_id || ' at ' || TO_CHAR(call_start_time, 'DD-Mon HH24:MI'). */
/* Q94. Show every loyalty member with their tier_id and 'joined ' || EXTRACT(YEAR FROM AGE(join_date)) || ' years ago'. */
/* Q95. Build a customer display: customer_id, INITCAP(first_name || ' ' || last_name), and EXTRACT(YEAR FROM AGE(registration_date)) || ' yrs as customer'. */
/* Q96. For each work order, show 'WO-' || work_order_id || ' produced ' || quantity_produced || ' units on ' || TO_CHAR(end_timestamp, 'DD-Mon-YYYY'). */
/* Q97. For each expense, show 'Exp #' || expense_id || ' - Rs' || amount || ' on ' || TO_CHAR(expense_date, 'DD-Mon-YYYY'). */
/* Q98. For every customer review, show 'REVIEW ' || review_id || ': ' || rating || '* on ' || TO_CHAR(review_date, 'DD-Mon-YYYY'). */
/* Q99. Show every API request: status_code || ' ' || method || ' ' || endpoint + ' at ' + TO_CHAR(timestamp, 'HH24:MI:SS'). */
/* Q100. Build a 'days remaining in current month' utility: (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' - 1 day) - CURRENT_DATE. */

/* ============================================================
   END OF Scalar Functions (String & Date) - EASY LEVEL (100 QUESTIONS)
============================================================ */
