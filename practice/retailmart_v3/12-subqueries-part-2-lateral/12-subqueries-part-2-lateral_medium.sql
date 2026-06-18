/* ============================================================
   SQL PRACTICE SET - Subqueries Part 2 (Correlated & LATERAL) (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Subqueries Part 2 - Correlated & LATERAL (deeper)
   Database:     RetailMart V3

   Structure: 25 Conceptual + 25 Correlated deeper + 25 LATERAL chains + 25 LATERAL + window combos
   ============================================================ */

/* ============================================================
   SECTION A: DEEPER CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  When does Postgres unnest a correlated subquery to a JOIN? */
/* Q2.  Why does LATERAL fan out the outer row? */
/* Q3.  LATERAL with a subquery referencing 2 outer FROM items. */
/* Q4.  Compare LATERAL JOIN ON TRUE vs CROSS JOIN LATERAL. */
/* Q5.  LATERAL inside view definition - when problematic. */
/* Q6.  Why is "Nested Loop with LATERAL" the common plan? */
/* Q7.  Compare LATERAL to apply (SQL Server). */
/* Q8.  LATERAL with parameterized subquery. */
/* Q9.  Multi-LATERAL chain - each refers to previous. */
/* Q10. LATERAL + GROUP BY parent - interaction. */
/* Q11. LATERAL inside FROM (subquery). */
/* Q12. LATERAL inside RETURNING (INSERT/UPDATE). */
/* Q13. Compare LATERAL with COMPOSITE TYPE. */
/* Q14. LATERAL returning derived rows from function. */
/* Q15. Why is LATERAL slow without right index? */
/* Q16. LATERAL + window inside subquery. */
/* Q17. Compare LATERAL + LIMIT 1 vs DISTINCT ON. */
/* Q18. LATERAL semantic: 1 evaluation per outer row. */
/* Q19. LATERAL doesn't propagate ORDER BY of subquery to outer query. */
/* Q20. LATERAL with row constructor return. */
/* Q21. LATERAL + UNION ALL. */
/* Q22. LATERAL + EXISTS. */
/* Q23. LATERAL + NOT EXISTS. */
/* Q24. LATERAL with conditional subquery. */
/* Q25. LATERAL with recursive CTE inside. */

/* ============================================================
   SECTION B: CORRELATED DEEPER (25)
   ------------------------------------------------------------ */
/* Q26. Correlated SELECT with 5 metrics per customer. */
/* Q27. Correlated MIN/MAX. */
/* Q28. Correlated PERCENTILE per group. */
/* Q29. Correlated COUNT FILTER. */
/* Q30. Correlated with multi-column join. */
/* Q31. Correlated AS view-like inline. */
/* Q32. Correlated subquery with EXISTS chain. */
/* Q33. Correlated NOT EXISTS chain. */
/* Q34. Correlated in HAVING. */
/* Q35. Correlated in ORDER BY. */
/* Q36. Correlated in WHERE returning 0 or 1. */
/* Q37. Correlated returning ARRAY. */
/* Q38. Correlated returning JSON. */
/* Q39. Correlated returning composite type. */
/* Q40. Correlated for "find prior event". */
/* Q41. Correlated for "find next event". */
/* Q42. Correlated for "is currently active". */
/* Q43. Correlated for "is delinquent". */
/* Q44. Correlated for "is fraud-risk". */
/* Q45. Correlated for "tier-upgrade eligible". */
/* Q46. Correlated for "churn-risk". */
/* Q47. Correlated for "loyalty member". */
/* Q48. Correlated for "lifetime stage". */
/* Q49. Correlated for "premium-customer flag". */
/* Q50. Correlated for "geo-zone tag". */

/* ============================================================
   SECTION C: LATERAL CHAINS (25)
   ------------------------------------------------------------ */
/* Q51. LATERAL 1 -> LATERAL 2 (sequential dependency). */
/* Q52. LATERAL 1 -> LATERAL 2 -> LATERAL 3. */
/* Q53. LATERAL with parent + grandparent ref. */
/* Q54. LATERAL with multiple subqueries in one row. */
/* Q55. LATERAL with conditional return. */
/* Q56. LATERAL with CTE inside subquery. */
/* Q57. LATERAL with set ops inside. */
/* Q58. LATERAL with window inside. */
/* Q59. LATERAL with aggregate + group inside. */
/* Q60. LATERAL with EXISTS + CASE. */
/* Q61. LATERAL with derived calendar. */
/* Q62. LATERAL with date series. */
/* Q63. LATERAL with array_agg. */
/* Q64. LATERAL with jsonb_object_agg. */
/* Q65. LATERAL with multi-column ORDER BY. */
/* Q66. LATERAL "top-3 per group + total". */
/* Q67. LATERAL "first non-null". */
/* Q68. LATERAL with NULL handling. */
/* Q69. LATERAL "is_above_avg" via inline. */
/* Q70. LATERAL with multi-table subquery JOIN. */
/* Q71. LATERAL with EXCEPT inside. */
/* Q72. LATERAL with UNION inside. */
/* Q73. LATERAL with HAVING inside. */
/* Q74. LATERAL with GROUP BY ROLLUP inside. */
/* Q75. LATERAL with PERCENTILE inside. */

/* ============================================================
   SECTION D: LATERAL + WINDOW COMBO (25)
   ------------------------------------------------------------ */
/* Q76. LATERAL with ROW_NUMBER inside subquery. */
/* Q77. LATERAL with RANK inside. */
/* Q78. LATERAL with NTILE. */
/* Q79. LATERAL with LAG/LEAD. */
/* Q80. LATERAL with FIRST_VALUE / LAST_VALUE. */
/* Q81. LATERAL with PERCENT_RANK. */
/* Q82. LATERAL with CUME_DIST. */
/* Q83. LATERAL with running SUM. */
/* Q84. LATERAL with running AVG. */
/* Q85. LATERAL with moving window. */
/* Q86. LATERAL with partition-by-customer + ORDER BY. */
/* Q87. LATERAL with "first event in window". */
/* Q88. LATERAL with "n-th event in window". */
/* Q89. LATERAL with "last event in window". */
/* Q90. LATERAL with "delta vs previous". */
/* Q91. LATERAL with "delta vs first". */
/* Q92. LATERAL with "rank within group". */
/* Q93. LATERAL with "rank within tier + region". */
/* Q94. LATERAL with "percentile within cohort". */
/* Q95. LATERAL "year-over-year compare". */
/* Q96. LATERAL "month-over-month compare". */
/* Q97. LATERAL "rolling 7-day". */
/* Q98. LATERAL "rolling 30-day". */
/* Q99. LATERAL "rolling 90-day". */
/* Q100. LATERAL + 5-metric per-row computation. */

/* ============================================================
   END OF Subqueries Part 2 (Correlated & LATERAL) - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
