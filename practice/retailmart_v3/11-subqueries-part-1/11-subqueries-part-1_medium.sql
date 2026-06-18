/* ============================================================
   SQL PRACTICE SET - Subqueries Part 1 (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Subqueries Part 1 - deeper
   Database:     RetailMart V3

   Scope (deeper than Easy):
     - Multi-level nested subqueries
     - Subqueries with JOIN inside
     - Correlated subqueries (intro)
     - Subquery in FROM (derived tables)
     - HAVING with subquery
     - Subquery + GROUP BY
     - Subquery performance pitfalls

   Structure: 25 Conceptual + 25 IN/EXISTS deeper + 25 Subquery in FROM + 25 HAVING subqueries
   ============================================================ */

/* ============================================================
   SECTION A: SUBQUERIES DEEPER - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why is a correlated subquery slower than an uncorrelated one? */
/* Q2.  When does the planner rewrite a subquery to a JOIN? */
/* Q3.  Compare derived table (FROM subquery) vs CTE. */
/* Q4.  Why is "subquery returns more than one row" common with =? */
/* Q5.  Explain LIMIT 1 inside a subquery - when needed. */
/* Q6.  Why use ORDER BY inside subquery with LIMIT 1? */
/* Q7.  Compare uncorrelated EXISTS (constant) vs correlated EXISTS. */
/* Q8.  Compare WHERE x IN (...) vs WHERE x = ANY(VALUES (...)). */
/* Q9.  Compare WHERE x IN (subq) vs JOIN ... - same result, different plan. */
/* Q10. When does NOT IN return 0 rows surprisingly? */
/* Q11. Why is NOT EXISTS NULL-safe? */
/* Q12. Compare SELECT scalar vs JOIN aggregate - fan-out implications. */
/* Q13. Why is "subquery in FROM" called a "derived table" or "inline view"? */
/* Q14. Explain "lateral subquery" vs "subquery in FROM". */
/* Q15. Compare HAVING WHERE filter vs subquery. */
/* Q16. Why must derived tables have aliases? */
/* Q17. Compare HAVING SUM(x) > (subq) vs WHERE (with pre-aggregate). */
/* Q18. What is "subquery flattening"? */
/* Q19. Why does putting an aggregate in WHERE error? */
/* Q20. Compare scalar subquery in SELECT vs adding to GROUP BY. */
/* Q21. What is "subquery factoring" - same as CTE. */
/* Q22. Explain why subqueries in SELECT can hide N+1 query patterns. */
/* Q23. Compare subquery in WHERE = (single value) vs IN (set). */
/* Q24. Why does ORDER BY with scalar subquery hurt performance. */
/* Q25. Walk through how planner decides Hash Semi-Join vs Nested Loop. */

/* ============================================================
   SECTION B: IN / EXISTS DEEPER (25)
   ------------------------------------------------------------ */
/* Q26. Find customers with orders AND reviews - combine 2 EXISTS. */
/* Q27. Find customers with orders BUT no reviews. */
/* Q28. Find customers with orders in 2024 AND 2025. */
/* Q29. Find products with reviews in last 30 days AND price > 1000. */
/* Q30. Find stores with employees AND orders AND inventory. */
/* Q31. Find brands present in BOTH 'Electronics' AND 'Apparel' categories. */
/* Q32. Find customers in cities WITH at least one store. */
/* Q33. Find products of suppliers in 'Mumbai' AND shipped in last 60 days. */
/* Q34. Find tickets created by customers with > 5 orders. */
/* Q35. Find pay_slips for employees in stores with > 10 employees. */
/* Q36. Find orders by customers who are loyalty members. */
/* Q37. Find orders by customers WHO are NOT loyalty members. */
/* Q38. Find products in categories with > 100 products. */
/* Q39. Find products in brands with avg_price > 5000. */
/* Q40. Find customers in tiers with > 1000 members. */
/* Q41. Find orders shipped by couriers with avg_delivery_time < 3 days. */
/* Q42. Find ad spend rows for campaigns active in March 2025. */
/* Q43. Find reviews on products with > 5 sales. */
/* Q44. Find tickets on products that have ever been returned. */
/* Q45. Find calls regarding products with low ratings. */
/* Q46. Find page_views in sessions that ended with a purchase. */
/* Q47. EXISTS with multiple correlated columns. */
/* Q48. NOT EXISTS for a complex predicate (subquery JOIN). */
/* Q49. Nested EXISTS: customers who reviewed products they returned. */
/* Q50. EXISTS + DISTINCT - when redundant. */

/* ============================================================
   SECTION C: SUBQUERY IN FROM (DERIVED TABLE) (25)
   ------------------------------------------------------------ */
/* Q51. Derived table: (SELECT cust_id, SUM(net_total) AS total FROM orders GROUP BY cust_id) AS s. */
/* Q52. Filter derived: WHERE total > 50000. */
/* Q53. Join derived with customers. */
/* Q54. Join 3 derived tables. */
/* Q55. Top-N from a derived. */
/* Q56. Derived with GROUP BY + HAVING. */
/* Q57. Derived with window function (preview). */
/* Q58. Derived with UNION ALL. */
/* Q59. Derived with EXCEPT. */
/* Q60. Derived returning multiple columns. */
/* Q61. Derived using DISTINCT ON. */
/* Q62. Derived used in CASE expression. */
/* Q63. Derived used in scalar context. */
/* Q64. Derived used twice - performance implications. */
/* Q65. Derived inside another derived (nested). */
/* Q66. Subquery with ORDER BY + LIMIT for top-N. */
/* Q67. Subquery in LEFT JOIN. */
/* Q68. Subquery in RIGHT JOIN. */
/* Q69. Subquery in FULL OUTER JOIN. */
/* Q70. Subquery aliasing columns explicitly. */
/* Q71. Derived used in window function PARTITION BY. */
/* Q72. Derived with no GROUP BY but aggregate. */
/* Q73. Replace nested derived with CTE - same result, more readable. */
/* Q74. Derived returning JSON. */
/* Q75. Derived built from a UNION across schemas. */

/* ============================================================
   SECTION D: HAVING WITH SUBQUERY (25)
   ------------------------------------------------------------ */
/* Q76. HAVING SUM(net_total) > (SELECT AVG(SUM(net_total)) FROM ...). */
/* Q77. HAVING COUNT(*) > (SELECT AVG count) - find above-average. */
/* Q78. HAVING SUM > 10 x AVG. */
/* Q79. HAVING SUM > 2 x prior period. */
/* Q80. HAVING with EXISTS. */
/* Q81. HAVING with NOT EXISTS. */
/* Q82. HAVING with correlated subquery. */
/* Q83. HAVING based on another table's stats. */
/* Q84. HAVING with multiple conditions (AND/OR). */
/* Q85. HAVING comparing two aggregates from same query. */
/* Q86. HAVING per-region: revenue > region's avg. */
/* Q87. HAVING per-category: AVG > overall AVG. */
/* Q88. HAVING with CASE-based COUNT. */
/* Q89. HAVING for outlier detection. */
/* Q90. HAVING SUM(qty FILTER WHERE) > N. */
/* Q91. HAVING with date-based subquery. */
/* Q92. HAVING + GROUP BY ROLLUP. */
/* Q93. HAVING + GROUP BY CUBE. */
/* Q94. HAVING + complex CASE in COUNT. */
/* Q95. HAVING + percentile threshold. */
/* Q96. HAVING + median threshold. */
/* Q97. HAVING + max threshold. */
/* Q98. HAVING + min threshold. */
/* Q99. HAVING + COUNT distinct > N. */
/* Q100. Combine HAVING + subquery + window + ROLLUP in one mega query. */

/* ============================================================
   END OF Subqueries Part 1 - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
