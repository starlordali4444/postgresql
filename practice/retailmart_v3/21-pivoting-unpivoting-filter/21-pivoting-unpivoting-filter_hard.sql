/* ============================================================
   SQL PRACTICE SET - Pivoting, Unpivoting & FILTER (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Pivot reports with margins, ratios, GROUPING SETS, unpivot
   Database:     RetailMart V3

   Scope (HARD = production pivot reports):
     - Matrices with row/column/grand totals; derived ratios in pivots
     - GROUPING SETS/ROLLUP for subtotals; multi-metric pivots; tidy unpivot
   (Dynamic columns = crosstab/tablefunc -> accio_NN; JSON pivot is Day 24.)

   Structure: 25 Conceptual + 25 Pivot reports + 25 Ratios/GROUPING SETS + 25 Unpivot/reshape
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Build a pivot with row totals, column totals, and a grand total - approaches. */
/* Q2.  GROUPING SETS vs UNION ALL for subtotal rows - tradeoffs. */
/* Q3.  ROLLUP for hierarchical subtotals (region -> store). */
/* Q4.  CUBE for all-combination subtotals - when it's appropriate. */
/* Q5.  GROUPING() to label subtotal vs detail rows. */
/* Q6.  Percent-of-row vs percent-of-column vs percent-of-grand-total. */
/* Q7.  Derived ratios inside a pivot (return rate, conversion) - placement. */
/* Q8.  Why FILTER keeps multi-metric pivots readable vs nested CASE. */
/* Q9.  When dynamic pivot is unavoidable (unknown categories) -> crosstab/app. */
/* Q10. jsonb_object_agg for a dynamic key->value "pivot" (concept; JSON is Day 24). */
/* Q11. Unpivot a wide table robustly (UNION ALL vs LATERAL VALUES). */
/* Q12. Avoiding double counting when pivoting over a fan-out join. */
/* Q13. Pivot stability when categories may be missing in some periods. */
/* Q14. Combining a pivot with a window % (Day 17) for share columns. */
/* Q15. ROLLUP ordering and NULL placement of subtotal rows. */
/* Q16. Performance: pivot over a pre-aggregated CTE vs raw facts. */
/* Q17. When to pivot in SQL vs ship long format to the BI layer. */
/* Q18. Multi-grain pivot (counts and revenue) without two passes. */
/* Q19. Pivot booleans (bool_or) into capability flags. */
/* Q20. Reshape: unpivot then re-pivot on a new axis. */
/* Q21. Handling division-by-zero in ratio pivots (NULLIF). */
/* Q22. Grand-total reconciliation (row totals sum to grand total). */
/* Q23. Why GROUPING SETS can replace several UNION ALL queries. */
/* Q24. Designing a pivot that a finance team can paste into a sheet. */
/* Q25. A correctness checklist for pivot+subtotal reports. */

/* ============================================================
   SECTION B: PIVOT REPORTS WITH TOTALS (25)
   ------------------------------------------------------------ */
/* Q26. SCENARIO: CFO wants region x payment_mode revenue with row totals, column totals, grand total. */
/* Q27. Store x quarter revenue with a yearly total column. */
/* Q28. Category x month units with an annual total column and monthly total row. */
/* Q29. Region x status order counts with grand total (GROUPING SETS). */
/* Q30. Brand x price-band counts with brand totals. */
/* Q31. Agent x priority ticket counts with agent totals and grand total. */
/* Q32. Region x tier revenue with ROLLUP subtotals. */
/* Q33. Product x rating review counts with product total. */
/* Q34. Department x role headcount with department + company totals. */
/* Q35. Courier x month avg-delivery matrix with overall column. */
/* Q36. Region -> store revenue ROLLUP (hierarchical subtotals). */
/* Q37. Category -> brand revenue ROLLUP. */
/* Q38. Month x status revenue with monthly and status totals (CUBE). */
/* Q39. Platform x quarter spend with platform totals. */
/* Q40. Store x weekday revenue with weekend vs weekday subtotals. */
/* Q41. Warehouse x category stock with warehouse totals. */
/* Q42. Cohort-year x following-year orders with cohort totals. */
/* Q43. City x tier customers with city totals (via addresses). */
/* Q44. Region x season revenue with grand total and GROUPING() labels. */
/* Q45. Brand x customer-tier revenue with totals. */
/* Q46. Status x month order counts transposed with totals. */
/* Q47. Product x quarter revenue with product annual total. */
/* Q48. Region x payment_mode counts AND revenue interleaved with totals. */
/* Q49. Reconcile: verify row totals sum to the grand total. */
/* Q50. Deliver a finance-ready region x month revenue sheet with all margins. */

/* ============================================================
   SECTION C: RATIOS & GROUPING SETS (25)
   ------------------------------------------------------------ */
/* Q51. Region x status counts with each as % of region (row %). */
/* Q52. Region x status counts with each as % of status (column %). */
/* Q53. Category x month units with % of grand total per cell. */
/* Q54. Return rate matrix: returned units / delivered units per category x month. */
/* Q55. Conversion-ish matrix: orders / customers per region x tier. */
/* Q56. Store x quarter revenue indexed to Q1 = 100 (no LAG; ratio to FILTER Q1). */
/* Q57. Brand price-band counts as % of brand (row %) with brand totals. */
/* Q58. Agent priority counts as % of agent tickets. */
/* Q59. Region tier revenue with % of region and % of company. */
/* Q60. ROLLUP region->store revenue with subtotal % of region. */
/* Q61. GROUPING SETS to produce detail + region subtotal + grand total in one query. */
/* Q62. CUBE over (region, status) with all margin combinations. */
/* Q63. Product rating mix as % per product with avg rating column. */
/* Q64. Courier on-time % per month per courier (FILTER ratio matrix). */
/* Q65. Category returned/delivered with return-rate column (NULLIF guard). */
/* Q66. Month status mix as % of month AND running cumulative (with window). */
/* Q67. Region x tier with both count and revenue and revenue-per-customer. */
/* Q68. Platform quarter spend as % of platform and % of total. */
/* Q69. Store weekday revenue share (% of store week). */
/* Q70. GROUPING() to tag which rows are subtotals in a ROLLUP. */
/* Q71. Department role headcount % with company total row. */
/* Q72. Cohort retention matrix as % of cohort size (GROUPING SETS friendly). */
/* Q73. Warehouse category stock % of warehouse and of company. */
/* Q74. Region x season revenue with % of region annual. */
/* Q75. Build a mix-and-margin report: counts, row %, subtotal, grand total. */

/* ============================================================
   SECTION D: UNPIVOT & RESHAPE (25)
   ------------------------------------------------------------ */
/* Q76. SCENARIO: A wide quarterly KPI export must become tidy (entity, metric, period, value). */
/* Q77. Unpivot pay_slip components into long (slip, component, amount) and validate the sum = gross. */
/* Q78. Unpivot revenue_summary into (date, metric, value). */
/* Q79. Unpivot email_clicks into a funnel (campaign, stage, count) and compute drop-off. */
/* Q80. Unpivot order totals (gross/discount/net) and verify gross-discount=net. */
/* Q81. Reshape: pivot regionxstatus, then unpivot back, prove round-trip equality. */
/* Q82. Unpivot a 12-month wide row into a tidy month series via LATERAL VALUES. */
/* Q83. Unpivot product price/cost/margin into (kind, amount). */
/* Q84. Unpivot tax_brackets to long and chart the rate curve. */
/* Q85. Unpivot ads metrics into (metric, value) per campaign. */
/* Q86. Build an EAV table from several customer attributes. */
/* Q87. Unpivot shipment lifecycle dates into events with type labels. */
/* Q88. Unpivot a pivoted matrix produced earlier (columns -> rows). */
/* Q89. Tidy a funnel matrix into long stages with conversion %. */
/* Q90. Unpivot loyalty tier thresholds (min/max) to long. */
/* Q91. Reshape monthly wide -> long -> re-pivot by quarter. */
/* Q92. Unpivot using unnest over two parallel arrays (labels, values). */
/* Q93. Unpivot then GROUP BY metric to get cross-entity totals. */
/* Q94. Unpivot store KPIs (revenue, orders, aov) to long for comparison. */
/* Q95. Validate an unpivot: long-form sum equals wide-form total. */
/* Q96. Reshape a wide cohort grid into tidy (cohort, month_since, retained). */
/* Q97. Unpivot a regionxquarter pivot to (region, quarter, revenue). */
/* Q98. Produce a tidy metrics table for a dashboard from 6 aggregate columns. */
/* Q99. Note crosstab()/tablefunc (accio_NN) for the dynamic-column case. */
/* Q100. Deliver both a pivoted finance sheet AND its tidy long-format source. */

/* ============================================================
   END OF Pivoting, Unpivoting & FILTER - HARD LEVEL (100 QUESTIONS)
============================================================ */
