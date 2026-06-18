/* ============================================================
   SQL PRACTICE SET - Data Quality, Deduplication & Cleansing (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Duplicate detection, NULL strategies, regex/text standardization, anomaly flags
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - Find dupes: GROUP BY ... HAVING COUNT(*) > 1; ROW_NUMBER for keep-which-row
     - NULL strategies: COALESCE, NULLIF, IS DISTINCT FROM, IS NULL clusters
     - Standardize text: LOWER, TRIM, REGEXP_REPLACE; pattern match ~ / ~*
     - Anomaly flags: thresholds, percentage-change ratios, suspicious values
   NOTE ON DATA: RetailMart batch 26 is mostly clean - duplicate-detection queries
     often return zero rows (that IS the correct "audit passed" outcome). The point
     is the QUERY SHAPE. Where edge cases exist (review_text free-text, record_changes
     price events) we use those. Writes (UPDATE/DELETE to dedupe) -> your accio_NN DB.

   Structure: 25 Conceptual + 25 Duplicate detection + 25 NULLs & text standardization + 25 Anomaly flags & reconciliation
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does it mean for a row to be a "duplicate" (logical key vs full row)? */
/* Q2.  Why is GROUP BY key HAVING COUNT(*) > 1 the canonical dupe-detector? */
/* Q3.  ROW_NUMBER OVER (PARTITION BY key ORDER BY recency) - what does it produce? */
/* Q4.  Why does ROW_NUMBER let you keep the "best" row when deduping? */
/* Q5.  Difference between DISTINCT and DISTINCT ON (Day 22 tie-in). */
/* Q6.  What does COALESCE(a, b, c) return? */
/* Q7.  What does NULLIF(a, b) return? */
/* Q8.  What does IS DISTINCT FROM do that <> does not? */
/* Q9.  Three NULL strategies in cleansing: drop / replace / flag. */
/* Q10. Why is LOWER + TRIM the minimum for free-text equality? */
/* Q11. What does REGEXP_REPLACE(s, pat, repl) do? */
/* Q12. ~ vs ~* - case-sensitive vs case-insensitive regex match. */
/* Q13. Why are phone numbers a classic standardization target (formats vary)? */
/* Q14. Why is email a common duplicate key (with variants like trailing spaces)? */
/* Q15. What is a "missing-value cluster" and why flag it? */
/* Q16. What does it mean for a value to be "suspicious" (outside expected range)? */
/* Q17. Why is a > 50% price change a likely data-entry error? */
/* Q18. What does "canonicalization" mean for free-text keys? */
/* Q19. How does Day 22 DISTINCT ON pick the "right" row per dedup key? */
/* Q20. Why dedup in a view/CTE (not by DELETE) when the table is read-only? */
/* Q21. What's the difference between data cleansing and data validation? */
/* Q22. Why is COUNT(*) different from COUNT(col) under NULLs? */
/* Q23. What is "reconciliation" between two near-duplicate lists? */
/* Q24. Why do anomaly flags need a BASELINE (mean / median / percentile)? */
/* Q25. Name three RetailMart quality checks worth automating (per CONTEXT). */

/* ============================================================
   SECTION B: DUPLICATE DETECTION (25)
   ------------------------------------------------------------ */
/* Q26. Find customer emails that appear more than once (GROUP BY HAVING). */
/* Q27. Find customers sharing the same (first_name, last_name) - likely homonyms. */
/* Q28. Find products with duplicate names within the same brand. */
/* Q29. Find suppliers with the same name (case-insensitive via LOWER). */
/* Q30. Find stores with the same (city, address) - possible duplicates. */
/* Q31. Find orders with same (cust_id, order_date, net_total) - likely double-submit. */
/* Q32. Find reviews where (customer_id, product_id) appears twice. */
/* Q33. Find tickets with the same (customer_id, subject) opened twice. */
/* Q34. Find payments with same (order_id, amount) appearing twice. */
/* Q35. Find page_views with same (customer_id, page_url, view_timestamp). */
/* Q36. Find brand names that differ only by trailing whitespace. */
/* Q37. Find customer emails that differ only by case (LOWER). */
/* Q38. Per duplicate-email group: rank rows with ROW_NUMBER ORDER BY registration_date DESC. */
/* Q39. Keep only the most-recently-registered row per duplicate email (filter rn=1). */
/* Q40. Per duplicate (first_name, last_name): keep the row with the most orders. */
/* Q41. Use DISTINCT ON (Day 22) to keep the latest customer per email. */
/* Q42. Count dupe groups for emails vs phones - which has more issues? */
/* Q43. Find duplicate product (name, brand_id) across suppliers. */
/* Q44. Find duplicate inventory snapshots (warehouse_id, prod_id, snapshot_date). */
/* Q45. Find duplicate work_orders by (production_line_id, started_at). */
/* Q46. Find addresses with same (customer_id, address_line1). */
/* Q47. Find pay_slips with same (employee_id, salary_month, salary_year). */
/* Q48. Detect duplicate review_text per product (verbatim copies). */
/* Q49. Detect duplicate review_text per product after LOWER+TRIM canonicalization. */
/* Q50. Use ROW_NUMBER to identify the "loser" rows that would be deleted in dedup. */

/* ============================================================
   SECTION C: NULL STRATEGIES & TEXT STANDARDIZATION (25)
   ------------------------------------------------------------ */
/* Q51. Replace NULL review_text with '(no comment)' via COALESCE. */
/* Q52. Replace NULL error_message in record_changes with '(none)'. */
/* Q53. Use NULLIF to convert empty string '' to NULL for review_text. */
/* Q54. Count rows where order_status IS DISTINCT FROM 'Delivered' (NULL-safe). */
/* Q55. Standardize review_text: TRIM + LOWER. */
/* Q56. Standardize brand name: TRIM both ends. */
/* Q57. Use REGEXP_REPLACE to collapse multi-space runs in review_text to single space. */
/* Q58. Strip leading/trailing punctuation from review_text. */
/* Q59. Standardize email: LOWER + TRIM, then compare to original to spot dirty rows. */
/* Q60. Use ~ to match products.name starting with 'iPhone'. */
/* Q61. Use ~* (case-insensitive) to match brand names containing 'samsung'. */
/* Q62. Find review_text containing only whitespace via ~ '^\s*$'. */
/* Q63. Find emails NOT matching a simple email pattern with !~. */
/* Q64. Replace digits in review_text with '#' via REGEXP_REPLACE. */
/* Q65. Extract only digits from a phone with REGEXP_REPLACE(phone, '\D', '', 'g'). */
/* Q66. Standardize phone to E.164-ish: '+91' + last-10 digits (concept query). */
/* Q67. Find customer first_names with leading/trailing spaces (TRIM <> orig). */
/* Q68. Count NULL clusters: customers with NULL phone, by registration year (Day 23). */
/* Q69. Backfill NULL region (concept): COALESCE(region, 'Unknown'). */
/* Q70. Per category: COUNT(*) vs COUNT(price) - measure missing prices. */
/* Q71. Show rows where two columns are "different" using IS DISTINCT FROM. */
/* Q72. Standardize store address: TRIM + collapse spaces + LOWER. */
/* Q73. Reviews: show original vs cleaned (LOWER+TRIM+single-spaced) side-by-side. */
/* Q74. Find customers whose first_name is all uppercase (~ '^[A-Z]+$'). */
/* Q75. Find products whose name contains non-ASCII characters (regex). */

/* ============================================================
   SECTION D: ANOMALY FLAGS & RECONCILIATION (25)
   ------------------------------------------------------------ */
/* Q76. Flag orders where gross_total > 100000 (suspicious threshold). */
/* Q77. Flag orders where discount_amount > gross_total (impossible). */
/* Q78. Flag products where price < cost_price (negative margin). */
/* Q79. From record_changes: find price-change events with > 50% jump (likely error). */
/* Q80. From record_changes: find salary-change events with > 30% jump. */
/* Q81. Flag pay_slips with net_salary < 1000 or > 200000 (outside expected range). */
/* Q82. Flag reviews with rating outside 1..5 (data-integrity check). */
/* Q83. Flag tickets where resolved_date < created_date (impossible). */
/* Q84. Flag shipments where delivered_date < shipped_date (impossible). */
/* Q85. Flag orders where order_date < customer registration_date (impossible per business rule). */
/* Q86. Count rows failing each rule above as a single "data quality scorecard". */
/* Q87. Reconcile two product-name lists: same after LOWER+TRIM but differ verbatim. */
/* Q88. Reconcile brand names across suppliers: same after canonicalization. */
/* Q89. Find customers with the same (LOWER(email), phone) - alternate dedup key. */
/* Q90. Per region: % customers with a NULL phone (missing-value cluster check). */
/* Q91. Per category: % products with NULL description (concept check). */
/* Q92. Flag a price change > 50% in audit.record_changes joined to products.name. */
/* Q93. Flag orders with status 'Delivered' but no payment row (consistency check). */
/* Q94. Flag stores with zero orders (orphan rows). */
/* Q95. Flag products with no inventory anywhere (catalog ghosts). */
/* Q96. Flag employees with NULL department (assignment gap). */
/* Q97. Reconcile order_items SUM(quantity*unit_price) vs orders.net_total per order. */
/* Q98. Reconcile finance.payments total vs sales.payments total per order_id. */
/* Q99. Find customer addresses whose city is misspelt vs the canonical list (LOWER+TRIM). */
/* Q100. One-screen DQ scorecard: % failed per rule across the customer/orders tables. */
