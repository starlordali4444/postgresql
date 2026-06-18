/* ============================================================
   SQL PRACTICE SET - Pivoting, Unpivoting & FILTER (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Conditional aggregation (CASE in aggregates), FILTER, unpivot
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - FILTER (WHERE ...) clause vs CASE-inside-aggregate
     - Simple pivots (rows -> columns) with a fixed set of categories
     - Simple unpivot with UNION ALL
   (Dynamic pivot via crosstab() needs the tablefunc extension -> accio_NN.)

   Structure: 25 Conceptual + 25 FILTER + 25 CASE-pivot + 25 Unpivot
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does "pivoting" mean (rows -> columns)? */
/* Q2.  What does the FILTER (WHERE ...) clause do on an aggregate? */
/* Q3.  Rewrite SUM(CASE WHEN c THEN x END) as SUM(x) FILTER (WHERE c). */
/* Q4.  Why is FILTER cleaner/clearer than CASE-inside-aggregate? */
/* Q5.  What does "conditional aggregation" mean? */
/* Q6.  Why must pivot columns be a known/fixed set in plain SQL? */
/* Q7.  How is dynamic pivot done (crosstab/tablefunc) - and why it needs an extension? */
/* Q8.  What does "unpivoting" mean (columns -> rows)? */
/* Q9.  How does UNION ALL unpivot a wide table into long format? */
/* Q10. When should you pivot in SQL vs leave it to the BI tool? */
/* Q11. Why does COUNT(*) FILTER (WHERE c) count only matching rows? */
/* Q12. What does a pivot's GROUP BY key become (the row label)? */
/* Q13. How do you get a percent-of-row-total in a pivot? */
/* Q14. Why might pivoted NULLs need COALESCE(..., 0)? */
/* Q15. Can you mix FILTER with GROUP BY? (yes - show the shape) */
/* Q16. Difference between SUM(x) FILTER (WHERE c) and SUM(x) WHERE c. */
/* Q17. What is unnest() and how can it help unpivot arrays? */
/* Q18. Why is a "category x month" matrix a classic pivot? */
/* Q19. How many output columns does a pivot of N categories produce? */
/* Q20. What's the risk of pivoting a high-cardinality column? */
/* Q21. How do you pivot a count vs a sum? */
/* Q22. Why is FILTER evaluated per aggregate (independent conditions)? */
/* Q23. How do you label unpivoted rows with the source column name? */
/* Q24. When is GROUPING SETS/ROLLUP a better fit than a manual pivot? */
/* Q25. Name two analyst reports that are pivots and two that are unpivots. */

/* ============================================================
   SECTION B: FILTER CLAUSE (25)
   ------------------------------------------------------------ */
/* Q26. Count of Delivered vs Cancelled orders using two FILTERed COUNTs. */
/* Q27. Revenue from Delivered orders only via SUM(net_total) FILTER. */
/* Q28. Per store: count of each order_status in separate FILTERed columns. */
/* Q29. Per customer: count of orders and count of Returned orders (FILTER). */
/* Q30. Per product: count of 5-star vs 1-star reviews (FILTER). */
/* Q31. Per agent: open vs resolved ticket counts (FILTER). */
/* Q32. Per region: total revenue and revenue from Gold/Platinum customers (FILTER). */
/* Q33. Per month: revenue and order count (FILTER by date range). */
/* Q34. Count of customers with vs without a phone (FILTER IS NULL). */
/* Q35. Per brand: count of products above vs below Rs5000 (FILTER). */
/* Q36. Per store: revenue this year vs last year (two FILTERs). */
/* Q37. Per courier: on-time vs late delivery counts (FILTER on day diff). */
/* Q38. Per department: count of high earners (salary>50000) via FILTER. */
/* Q39. Per platform: spend in Q1 vs Q2 (FILTER by date). */
/* Q40. Per customer: count of orders in each tier of net_total (3 FILTERs). */
/* Q41. % of orders Delivered = COUNT FILTER / COUNT(*). */
/* Q42. Per category: revenue and units (FILTER not needed) plus returned units (FILTER). */
/* Q43. Per region: count of stores opened before vs after 2023 (FILTER). */
/* Q44. Per product: avg rating and count of negative reviews (FILTER). */
/* Q45. Per store: weekday vs weekend revenue (FILTER on DOW). */
/* Q46. Count of payments by each payment_mode using FILTER. */
/* Q47. Per agent: calls under 60s vs over 300s (FILTER). */
/* Q48. Per customer: spend on Delivered vs spend on Returned (FILTER). */
/* Q49. Per month: new customers (FILTER by registration month). */
/* Q50. Combine FILTER columns into one summary row per store. */

/* ============================================================
   SECTION C: CASE-BASED PIVOT (25)
   ------------------------------------------------------------ */
/* Q51. Revenue by month with one column per payment_mode (FILTER pivot). */
/* Q52. Order count by region with one column per status. */
/* Q53. Per brand: count of products in price bands (value/mid/premium) as columns. */
/* Q54. Per store: revenue per quarter (Q1..Q4 columns). */
/* Q55. Per category: units sold per month (Jan..Dec columns) for one year. */
/* Q56. Per agent: ticket counts per priority (Critical/High/Medium/Low columns). */
/* Q57. Per region: customer counts per tier (Bronze..Platinum columns). */
/* Q58. Per product: review counts per rating (1..5 columns). */
/* Q59. Per courier: shipment counts per status as columns. */
/* Q60. Per department: headcount per role as columns. */
/* Q61. Per store: order counts per weekday (Mon..Sun columns). */
/* Q62. Per platform: spend per quarter as columns. */
/* Q63. Revenue per region x payment_mode matrix (region rows, mode columns). */
/* Q64. Per month: counts of each order_status as columns. */
/* Q65. Per brand: revenue per tier-of-customer as columns. */
/* Q66. Per warehouse: stock per category as columns (via product->brand). */
/* Q67. Per customer cohort (reg year): order counts per following year. */
/* Q68. Per store: this-year vs last-year revenue as two columns. */
/* Q69. Per category: returned vs delivered units as columns. */
/* Q70. Pivot with COALESCE to show 0 instead of NULL in empty cells. */
/* Q71. Per region: avg order value per quarter as columns. */
/* Q72. Per product: units in each season (spring/summer/...) as columns. */
/* Q73. Per agent: avg resolution hours per priority as columns. */
/* Q74. Per store: count of orders per net_total band as columns + row total. */
/* Q75. Build a clean "status x month" pivot for the ops team. */

/* ============================================================
   SECTION D: UNPIVOT & PERCENT-OF-ROW (25)
   ------------------------------------------------------------ */
/* Q76. Unpivot a 4-quarter KPI (one row, 4 cols) into 4 rows via UNION ALL. */
/* Q77. Unpivot revenue_summary-style columns into (metric, value) rows. */
/* Q78. Unpivot pay_slip components (basic, hra, pf, tax...) into long format. */
/* Q79. Unpivot a region's Q1..Q4 revenue into (quarter, revenue). */
/* Q80. Unpivot email_clicks (sent, opened, clicked) into (stage, count). */
/* Q81. Unpivot a product's price and cost_price into (kind, amount). */
/* Q82. Unpivot order totals (gross, discount, net) into rows. */
/* Q83. Pivot then add a percent-of-row-total column per status. */
/* Q84. Per region status-pivot with each status as % of the region's orders. */
/* Q85. Pivot revenue by payment_mode with a row total and per-mode %. */
/* Q86. Unpivot a wide "monthly_kpis" mock (use revenue_summary) to long. */
/* Q87. Unpivot using unnest over an ARRAY of values. */
/* Q88. Unpivot shipment date columns (shipped, delivered) into events. */
/* Q89. Percent-of-row pivot: brand price-band counts as % of brand total. */
/* Q90. Unpivot a customer's contact fields (email, phone) into (channel, value). */
/* Q91. Pivot orders-by-week-by-status, then % per status within each week. */
/* Q92. Unpivot tax_brackets columns into long format. */
/* Q93. Percent-of-column-total in a region x status pivot. */
/* Q94. Unpivot a wide quarterly sales row into a tidy long table. */
/* Q95. Pivot tier counts per region and show each tier's % of region. */
/* Q96. Unpivot then re-pivot (round-trip) to verify equivalence. */
/* Q97. Build a long-format metric table from several aggregate columns. */
/* Q98. Pivot with both row totals and column totals (manual margins). */
/* Q99. Note when to use crosstab() (tablefunc, accio_NN) for dynamic columns. */
/* Q100. Build a category x quarter revenue matrix with row & column totals. */

/* ============================================================
   END OF Pivoting, Unpivoting & FILTER - EASY LEVEL (100 QUESTIONS)
============================================================ */
