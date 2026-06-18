/* ============================================================
   SQL PRACTICE SET - Filtering & Sorting (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Filtering & Sorting - staff-level predicate craft
   Database:     RetailMart V3

   Scope (CRAZY = production-grade filtering, NO later-topic tools):
     - Three-valued (NULL) logic, IS DISTINCT FROM, De Morgan
     - Set-based filters: EXISTS / NOT EXISTS / IN / ANY / ALL, relational division
     - Keyset pagination & deterministic ORDER BY
     - Top-N, "greatest-per-group" and dedup WITHOUT window functions
       (window functions are Day 16-18; indexing is Day 20 - not used here)

   Structure: 25 Conceptual + 25 Predicates/NULLs + 25 Set filters + 25 Pagination/Top-N
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Explain SQL three-valued logic (TRUE/FALSE/UNKNOWN) and how WHERE treats UNKNOWN. */
/* Q2.  Why does x = NULL never match, and what should you use instead? */
/* Q3.  Explain IS DISTINCT FROM and why it is "NULL-safe equality". */
/* Q4.  Why can NOT IN (subquery) return zero rows when the subquery has a NULL? */
/* Q5.  Compare EXISTS vs IN - semantics, NULL-safety, and how planners treat them. */
/* Q6.  State De Morgan's laws and why they matter when negating compound predicates. */
/* Q7.  Explain AND/OR precedence: how is "a OR b AND c" parsed? */
/* Q8.  Why prefer half-open ranges (>= start AND < end) over BETWEEN for dates? */
/* Q9.  Why are deep OFFSETs slow, and what does the engine actually do? */
/* Q10. Describe keyset pagination and why it beats OFFSET for large pages. */
/* Q11. What are the default NULL orderings for ASC and DESC, and how do you override? */
/* Q12. Compare DISTINCT vs DISTINCT ON - which row does DISTINCT ON keep? */
/* Q13. Show that x IN (a,b,c) equals x = ANY(ARRAY[a,b,c]). */
/* Q14. Explain x = ALL(subquery) and > ALL(subquery) - when is each true? */
/* Q15. Explain < ANY(subquery) and > ANY(subquery) in terms of MIN/MAX. */
/* Q16. Two ways to express relational division ("matches ALL of a set"). */
/* Q17. Compare NOT EXISTS vs LEFT JOIN ... IS NULL for anti-joins. */
/* Q18. What makes a predicate "sargable", and how does it shape how you write WHERE? */
/* Q19. Expand the row-constructor comparison (a,b) > (1,2). */
/* Q20. What does COLLATE "C" do to ORDER BY, vs a locale collation? */
/* Q21. Why is ORDER BY RANDOM() expensive, and what is the cheaper sampling option? */
/* Q22. Compare col = (scalar subquery) vs col IN (subquery) - cardinality rules. */
/* Q23. Compare SIMILAR TO, POSIX ~, and LIKE prefix vs suffix matching. */
/* Q24. Why does a stable/paginated sort need a unique tie-breaker column? */
/* Q25. Does the written order of WHERE predicates change the result or the plan? */

/* ============================================================
   SECTION B: COMPLEX PREDICATES & NULL LOGIC (25)
   ------------------------------------------------------------ */
/* Q26. Find customers whose phone is missing (NULL or empty string). */
/* Q27. Find shipments where delivered_date differs from shipped_date, NULL-safely. */
/* Q28. Find Returned-or-Cancelled orders over 5000 (mind OR/AND precedence). */
/* Q29. Find orders that are NOT (Delivered AND under 1000) - apply De Morgan. */
/* Q30. Find March-2025 orders using a half-open date range. */
/* Q31. Find promotions overlapping the window 2025-06-01..2025-06-30. */
/* Q32. Find orders whose net_total is zero, treating NULL as zero via COALESCE. */
/* Q33. Find orders whose status is none of Delivered/Shipped/Out for Delivery. */
/* Q34. Find customers whose email begins with 'a' (case-insensitive). */
/* Q35. Find customers whose email local-part contains a digit (regex). */
/* Q36. Find customers whose name contains a non-ASCII character. */
/* Q37. Find customers who have a tier but no tier_updated_at timestamp. */
/* Q38. Find products priced 1000-5000 but excluding exactly 1999. */
/* Q39. Find orders where gross_total - discount_amount exceeds 10000. */
/* Q40. Find customers whose tier is anything other than Platinum (include NULLs). */
/* Q41. Find addresses with a valid 6-digit numeric pincode. */
/* Q42. Find reviews that are unrated (NULL) or rated below 2. */
/* Q43. Find customers whose email does NOT end in .com/.in/.net/.org. */
/* Q44. Find 2025+ orders with net_total between 2000 and 8000. */
/* Q45. Find order_items with positive quantity but non-positive net_amount (data smell). */
/* Q46. Find tickets unresolved for more than 30 days (created_date is a timestamp). */
/* Q47. Find Critical/High tickets using = ANY over an array. */
/* Q48. Find customers whose first_name has leading/trailing whitespace. */
/* Q49. Find orders where "Cancelled" and "net_total = 0" disagree (XOR-style). */
/* Q50. Rank products by margin %, guarding against price = 0 division. */

/* ============================================================
   SECTION C: SET-BASED FILTERS - EXISTS / IN / ANY / ALL / DIVISION (25)
   ------------------------------------------------------------ */
/* Q51. Customers who placed at least one order (EXISTS). */
/* Q52. Products that never sold (NOT EXISTS). */
/* Q53. Customers not in loyalty.members - NULL-safe with NOT EXISTS. */
/* Q54. Orders placed by Platinum-tier customers (IN subquery). */
/* Q55. Products priced above every product of brand 5 (> ALL). */
/* Q56. Members whose tier rank is below at least one Mumbai member (< ANY). */
/* Q57. Orders whose status is in a VALUES list (= ANY, read-only - no config table). */
/* Q58. Products that have at least one 5-star review (correlated EXISTS). */
/* Q59. Customers who reviewed but never ordered (EXISTS + NOT EXISTS). */
/* Q60. Orders containing products from brands that have more than 100 products. */
/* Q61. Customers who bought from ALL of categories {1,2,3} (HAVING COUNT DISTINCT). */
/* Q62. Customers present in orders AND reviews AND tickets (chained EXISTS). */
/* Q63. Orders above the global average net_total (scalar subquery). */
/* Q64. Products priced above their own brand's average (correlated scalar). */
/* Q65. Orders by the top-10 highest-spending customers (IN aggregated subquery). */
/* Q66. Stores that have never had a Returned order (NOT EXISTS). */
/* Q67. Tickets opened on a day with >100 ERROR/FATAL log entries (audit subquery). */
/* Q68. Customers who live in a city that has a store (city via addresses). */
/* Q69. Products priced above at least one brand's average price (> ANY). */
/* Q70. Customers with no orders - NOT IN made safe by filtering NULLs. */
/* Q71. Customers with at least one order over 50,000 (correlated EXISTS, inequality). */
/* Q72. Customers who bought every product of brand 5 (division via count subquery). */
/* Q73. Customers with 10+ orders using a derived table in FROM. */
/* Q74. Customers who ordered but never returned anything (EXISTS + NOT EXISTS). */
/* Q75. Brands whose every product is priced under 20000 (> ALL guarantee). */

/* ============================================================
   SECTION D: PAGINATION, ORDERING & TOP-N WITHOUT WINDOW FUNCTIONS (25)
   ------------------------------------------------------------ */
/* Q76. Page 100 (size 50) of orders by id using OFFSET - the slow way. */
/* Q77. The same page using keyset pagination (order_id > last_seen). */
/* Q78. Forward page using a composite (order_date, order_id) cursor. */
/* Q79. Backward (previous) page using keyset - flip comparison and ORDER BY. */
/* Q80. Top orders by net_total, keeping NULLs last. */
/* Q81. Sort tickets by custom priority weight (CASE), then newest first. */
/* Q82. Top-20 customers by revenue with a deterministic tie-break. */
/* Q83. Latest order per customer using DISTINCT ON. */
/* Q84. Most-recent review per product using DISTINCT ON. */
/* Q85. Sort customers by name using COLLATE "C" (byte order). */
/* Q86. Sort customers by email domain, then full email. */
/* Q87. Sort phone numbers (TEXT) numerically, not lexically. */
/* Q88. Top-3 orders per customer WITHOUT a window function (correlated count). */
/* Q89. The single highest-value order per customer via correlated NOT EXISTS. */
/* Q90. Products selling above the median units sold (PERCENTILE_CONT, no window). */
/* Q91. The second-highest-priced product per brand WITHOUT a window function. */
/* Q92. Paginate customers on a stable (registration_date, customer_id) cursor. */
/* Q93. Order reviews by review-text length, longest first. */
/* Q94. Top-10 stores by revenue with a deterministic tie-break. */
/* Q95. Bottom-10 products by margin (ORDER BY ASC + LIMIT). */
/* Q96. Earliest order per store using DISTINCT ON ascending. */
/* Q97. Paginate customers with >50k revenue by customer_id cursor (HAVING + ORDER BY). */
/* Q98. The 50 most recent still-open Critical tickets. */
/* Q99. Take a ~1% random sample of orders efficiently (TABLESAMPLE). */
/* Q100. Latest DELIVERED order per customer over 5000, newest first - no window functions. */

/* ============================================================
   END OF Filtering & Sorting - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
