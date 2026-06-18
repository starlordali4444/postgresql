/* ============================================================
   SQL PRACTICE SET - Pivoting, Unpivoting & FILTER (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Multi-dimensional pivots, percent-of-row/column, unpivot
   Database:     RetailMart V3

   Scope (MEDIUM = joins + multi-condition FILTER + tidy unpivot):
     - Two-dimensional pivot matrices; row/column percentages
     - Unpivot via UNION ALL and unnest; round-tripping
   (Dynamic columns via crosstab() = tablefunc extension -> accio_NN.)

   Structure: 25 Conceptual + 25 Multi-dim pivot + 25 Percent-of-total + 25 Unpivot/tidy
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Why does a two-dimensional pivot need GROUP BY on the row key only? */
/* Q2.  How to add a row total to a pivot (extra SUM without FILTER). */
/* Q3.  How to add a grand total / column total (UNION or GROUPING SETS). */
/* Q4.  Percent-of-row: divide each cell by the row's total. */
/* Q5.  Percent-of-column: divide each cell by a window/subquery column total. */
/* Q6.  Why FILTER conditions are independent per aggregate. */
/* Q7.  How to pivot a count and a sum in the same query. */
/* Q8.  When to COALESCE pivot cells to 0. */
/* Q9.  Unpivot with UNION ALL: structure and the label column. */
/* Q10. Unpivot with unnest over parallel ARRAYs of names/values. */
/* Q11. Why dynamic pivot (unknown categories) needs crosstab or app code. */
/* Q12. GROUPING SETS vs manual pivot for subtotals. */
/* Q13. Pivot then compute a derived ratio column (e.g. return rate). */
/* Q14. Why high-cardinality pivots are usually a BI-tool job. */
/* Q15. Round-trip: pivot then unpivot should recover the long form. */
/* Q16. Conditional aggregation with AVG FILTER vs SUM/COUNT FILTER. */
/* Q17. How to pivot booleans (bool_or/bool_and) into yes/no columns. */
/* Q18. Pivoting dates into period buckets (month/quarter) columns. */
/* Q19. Why pivot output column names must be static identifiers. */
/* Q20. How to keep a pivot stable when a category has zero rows. */
/* Q21. Difference between unpivot via UNION ALL vs via a VALUES + JOIN. */
/* Q22. Percent-of-grand-total in a 2-D matrix. */
/* Q23. Adding both row % and column % to the same matrix. */
/* Q24. When jsonb_object_agg gives a "pivot-like" dynamic result (concept; JSON is Day 24). */
/* Q25. A checklist for building a correct pivot report. */

/* ============================================================
   SECTION B: MULTI-DIMENSIONAL PIVOTS (25)
   ------------------------------------------------------------ */
/* Q26. Region (rows) x order_status (columns) order-count matrix. */
/* Q27. Month (rows) x payment_mode (columns) revenue matrix. */
/* Q28. Brand (rows) x price-band (columns) product-count matrix. */
/* Q29. Store (rows) x quarter (columns) revenue matrix. */
/* Q30. Category (rows) x month (columns) units matrix (one year). */
/* Q31. Agent (rows) x priority (columns) ticket-count matrix. */
/* Q32. Region (rows) x tier (columns) customer-count matrix. */
/* Q33. Product (rows) x rating (columns) review-count matrix. */
/* Q34. Courier (rows) x on-time/late (columns) shipment matrix. */
/* Q35. Department (rows) x role (columns) headcount matrix. */
/* Q36. Store (rows) x weekday (columns) revenue matrix. */
/* Q37. Region (rows) x payment_mode (columns) revenue + row total. */
/* Q38. Brand (rows) x customer-tier (columns) revenue matrix. */
/* Q39. Category (rows) x returned/delivered (columns) units matrix. */
/* Q40. Month (rows) x status (columns) order-count + grand total row. */
/* Q41. Warehouse (rows) x category (columns) stock matrix. */
/* Q42. Cohort-year (rows) x following-year (columns) order-count matrix. */
/* Q43. Platform (rows) x quarter (columns) spend matrix. */
/* Q44. Region (rows) x season (columns) revenue matrix. */
/* Q45. Store (rows) x net_total-band (columns) order-count matrix. */
/* Q46. City (rows) x tier (columns) customer-count matrix (via addresses). */
/* Q47. Product (rows) x month (columns) revenue with a row total. */
/* Q48. Agent (rows) x status (columns) avg-resolution-hours matrix. */
/* Q49. Region x status matrix with both counts and revenue (interleaved). */
/* Q50. Build a category x quarter revenue matrix with row & column totals. */

/* ============================================================
   SECTION C: PERCENT-OF-TOTAL PIVOTS (25)
   ------------------------------------------------------------ */
/* Q51. Region x status order-count with each cell as % of the region's total. */
/* Q52. Month x payment_mode revenue with each cell as % of the month. */
/* Q53. Brand price-band counts as % of brand total. */
/* Q54. Store quarter revenue as % of the store's year. */
/* Q55. Category month units as % of the category's annual units. */
/* Q56. Agent priority counts as % of the agent's tickets. */
/* Q57. Region tier counts as % of the region's customers. */
/* Q58. Product rating counts as % of the product's reviews. */
/* Q59. Courier on-time % per courier (FILTER ratio). */
/* Q60. Department role headcount as % of department. */
/* Q61. Store weekday revenue as % of the store's week. */
/* Q62. Region status counts as % of the GRAND total (column-total denominator). */
/* Q63. Brand tier revenue as % of brand total. */
/* Q64. Category returned units as % of category delivered units (return rate). */
/* Q65. Month status counts as % of all orders that month AND all-time. */
/* Q66. Warehouse category stock as % of warehouse total. */
/* Q67. Cohort following-year orders as % of cohort size (retention-ish). */
/* Q68. Platform quarter spend as % of platform total. */
/* Q69. Region season revenue as % of region annual. */
/* Q70. Store net_total-band counts as % of store orders. */
/* Q71. City tier as % of city customers. */
/* Q72. Product month revenue as % of product annual. */
/* Q73. Region x status: show count, row %, and column % together. */
/* Q74. Category x quarter revenue with % of grand total per cell. */
/* Q75. Build a status mix report: per region, each status count and % of region. */

/* ============================================================
   SECTION D: UNPIVOT & TIDY (25)
   ------------------------------------------------------------ */
/* Q76. Unpivot revenue_summary metrics (total_revenue, total_orders, avg_order_value) to rows. */
/* Q77. Unpivot pay_slip components into (component, amount) per slip. */
/* Q78. Unpivot a region's Q1..Q4 revenue (from a pivot) back to long. */
/* Q79. Unpivot email_clicks (sent/opened/clicked) to (stage, count) per campaign. */
/* Q80. Unpivot order totals (gross/discount/net) to (kind, amount). */
/* Q81. Unpivot product price & cost_price to (kind, amount). */
/* Q82. Unpivot tax_brackets numeric columns to long. */
/* Q83. Unpivot using unnest over ARRAY[...] of labels and values. */
/* Q84. Unpivot a wide monthly KPI mock (revenue_summary by date) to (date, metric, value). */
/* Q85. Unpivot a customer's contact fields to (channel, value). */
/* Q86. Unpivot shipment dates (shipped/delivered) to events with a type label. */
/* Q87. Unpivot a store's open/close-era flags to rows. */
/* Q88. Round-trip: pivot regionxstatus then unpivot; verify counts match. */
/* Q89. Tidy a wide funnel (page/cart/checkout counts) into long stages. */
/* Q90. Unpivot then aggregate (sum the long form) to validate the pivot. */
/* Q91. Unpivot ads metrics into (metric, value) for charting. */
/* Q92. Unpivot a 12-month wide row into a tidy month series. */
/* Q93. Unpivot using LATERAL (VALUES ...) instead of UNION ALL. */
/* Q94. Unpivot product attributes into an EAV (entity-attribute-value) shape. */
/* Q95. Build a tidy (region, metric, value) table from several aggregates. */
/* Q96. Unpivot then pivot on a different axis (reshape). */
/* Q97. Compare UNION ALL unpivot vs unnest unpivot readability. */
/* Q98. Unpivot loyalty tier thresholds (min/max points) to long. */
/* Q99. Note crosstab() (tablefunc, accio_NN) for dynamic unknown-column pivots. */
/* Q100. Deliver a tidy long-format metrics table ready for a BI tool. */

/* ============================================================
   END OF Pivoting, Unpivoting & FILTER - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
