/* ============================================================
   SQL PRACTICE SET - Conditional Logic & Derived Columns (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Conditional Logic - advanced (CASE/COALESCE/NULLIF/CAST)
   Database:     RetailMart V3

   Scope (HARD):
     - Nested CASE / multi-condition WHEN
     - CASE inside JOIN / GROUP BY / ORDER BY
     - COALESCE chains with type coercion
     - NULLIF for div-by-zero protection
     - Conditional aggregation patterns
     - Boolean expressions and short-circuit
     - Type cast pitfalls
     - Real-world tiering/scoring logic

   Structure: 25 Conceptual + 25 Multi-branch CASE + 25 NULL safety + 25 Business scoring/tier logic
   ============================================================ */

/* ============================================================
   SECTION A: CONDITIONAL LOGIC - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Compare simple CASE WHEN val=X vs searched CASE WHEN cond. */
/* Q2.  Explain how CASE short-circuits - first match wins. */
/* Q3.  Why does CASE inside a WHERE clause defeat indexes? */
/* Q4.  Can CASE return different types per branch? */
/* Q5.  What does CASE return when no WHEN matches and no ELSE - NULL. */
/* Q6.  COALESCE(a, b, c, d) - what determines the chosen value? */
/* Q7.  COALESCE return type - promotion rules across branches. */
/* Q8.  When does COALESCE(NULL, NULL, NULL) = NULL - and how to convert to default value. */
/* Q9.  NULLIF(a, b) returns NULL if a=b else a - what's the prime use case? */
/* Q10. Why does NULLIF protect against division by zero (NULLIF(denom, 0))? */
/* Q11. Compare CAST(x AS numeric) vs x::numeric - same result. */
/* Q12. What happens when CAST fails on garbage input? */
/* Q13. Why is CAST inside WHERE often non-sargable? */
/* Q14. Explain implicit vs explicit casting - and when implicit fails. */
/* Q15. Why does '1' + 1 fail in strict modes but auto-cast in Postgres? */
/* Q16. Compare TRUE/FALSE/NULL three-valued logic (Boolean ternary). */
/* Q17. Explain WHERE col AND NOT col1 - how NULL propagates. */
/* Q18. Compare IS TRUE / IS FALSE / IS UNKNOWN - and when each is needed. */
/* Q19. Why is GREATEST(NULL, 5) NULL-safe in some dialects but not others - check Postgres behavior. */
/* Q20. What is the ELSE-fallback hierarchy: COALESCE > CASE? */
/* Q21. Explain how CASE drives "conditional aggregation" (SUM CASE WHEN ...). */
/* Q22. Why is CASE in ORDER BY useful for custom sort priorities? */
/* Q23. Compare CASE in SELECT (per-row) vs HAVING (after grouping). */
/* Q24. What is BOOL_AND / BOOL_OR - aggregate boolean reducers. */
/* Q25. Explain why CASE NULL behaviour is symmetrical: CASE NULL WHEN NULL ... never matches (use IS NULL). */

/* ============================================================
   SECTION B: MULTI-BRANCH CASE (25)
   ------------------------------------------------------------ */
/* Q26. Per order, classify net_total: <100 = 'tiny', <500 = 'small', <2000 = 'medium', else 'large'. */
/* Q27. Per ticket priority + status, classify into action queue (Critical+Open = '1-act-now', etc.). */
/* Q28. Per customer, classify tier_id + city to "VIP-metro", "Mid-metro", etc. */
/* Q29. Per product, classify by price band AND brand reputation. */
/* Q30. Per employee, classify role + tenure into seniority level. */
/* Q31. Per call_duration, bucket into short/medium/long with custom thresholds. */
/* Q32. Per page_view URL, classify visit type (landing, product, checkout, other). */
/* Q33. Per shipment, classify delivery_age (on_time, late, very_late). */
/* Q34. Per pay_slip, classify bonus eligibility (>10% over base). */
/* Q35. Per ad spend, classify ROI band (low/med/high). */
/* Q36. Per review, classify sentiment (rating + review_text length). */
/* Q37. Per warehouse snapshot, classify stock status (low/healthy/excess). */
/* Q38. Per loyalty member, classify status (Bronze new, Silver active, etc.). */
/* Q39. Per campaign, classify lifecycle (planning/active/completed/closed). */
/* Q40. Per inventory_snapshot, flag risk (qty < reorder_level). */
/* Q41. Per customer, derive "lifecycle_stage" (new/active/dormant/churned) based on last_order_date. */
/* Q42. Nested CASE: classify by region THEN city THEN tier. */
/* Q43. Per refund, classify reason category (product issue/shipping/wrong item/other). */
/* Q44. Per support call, classify shift (morning/afternoon/evening/night) by hour. */
/* Q45. Per fiscal quarter, classify orders into seasonality buckets. */
/* Q46. CASE inside JOIN ON: join orders to staff schedule based on hour-of-day. */
/* Q47. CASE inside ORDER BY: sort by priority CASE WHEN ... THEN 1 ... END. */
/* Q48. CASE inside GROUP BY: bucket revenues then group by bucket. */
/* Q49. CASE inside SUM: conditional total of net_total for delivered orders. */
/* Q50. CASE returning JSONB: build a per-row JSON object based on conditions. */

/* ============================================================
   SECTION C: NULL SAFETY & TYPE COERCION (25)
   ------------------------------------------------------------ */
/* Q51. Use COALESCE to default missing tier_id to 0. */
/* Q52. Use COALESCE to display "Unknown" for missing city. */
/* Q53. Use NULLIF to safely divide net_total by total_units (0 -> NULL). */
/* Q54. Compute conversion rate with NULLIF: visits / NULLIF(orders, 0). */
/* Q55. Use COALESCE chain: phone -> mobile -> office -> 'No phone'. */
/* Q56. Compute "effective tier": COALESCE(loyalty.tier_id, customer.tier_id, 1). */
/* Q57. Compute customer age, default 0 when DOB missing. */
/* Q58. Cast TEXT date to DATE - handle parse errors with try-catch via regex pre-check. */
/* Q59. Cast TEXT price to NUMERIC - first strip currency symbols. */
/* Q60. Cast IP as INET - only if regex matches. */
/* Q61. Use CASE-in-ON: LEFT JOIN orders on (CASE WHEN o.status='Active' THEN o.cust_id END) = c.id. */
/* Q62. Use IS DISTINCT FROM for nullable equality (vs =). */
/* Q63. Use IS NOT DISTINCT FROM to detect "same or both NULL". */
/* Q64. Boolean reduction: BOOL_OR(is_active) per group. */
/* Q65. Boolean reduction: BOOL_AND(is_valid) per group. */
/* Q66. Compute "% delivered" using FILTER + COUNT. */
/* Q67. Convert empty string to NULL: NULLIF(col, ''). */
/* Q68. Convert 0 to NULL before dividing. */
/* Q69. CASE to safely cast '123abc' -> return NULL when not numeric. */
/* Q70. GREATEST(salary, min_wage) - floor a value. */
/* Q71. LEAST(due_date, deadline) - cap a value. */
/* Q72. BOOL_AND on NULL - what does it return? (Hint: depends on rows.) */
/* Q73. Test predicate IS UNKNOWN: WHERE (col1 = col2) IS NOT TRUE. */
/* Q74. NULLIF stacked: NULLIF(NULLIF(col, ''), 'N/A'). */
/* Q75. Verify GREATEST(NULL, 5) = 5 in Postgres (skips NULLs). */

/* ============================================================
   SECTION D: BUSINESS SCORING/TIER LOGIC (25)
   ------------------------------------------------------------ */
/* Q76. Customer "VIP score" = points*0.5 + lifetime_orders*1 + (tier_id*100). */
/* Q77. Tier upgrade rule: if points > 1000 AND lifetime_orders > 20 -> Gold. */
/* Q78. Risk score for tickets: 100 - resolution_hours * 5 (CASE for negative). */
/* Q79. Fraud-flag: large net_total AND new customer (< 30 days). */
/* Q80. Churn risk: last_order > 90 days AND tier = 'Bronze'. */
/* Q81. Reorder suggestion: stock < threshold AND velocity > 5/week. */
/* Q82. Employee performance: tickets_resolved * 2 + reviews_received - escalations * 3. */
/* Q83. Shipment efficiency score: 100 - delivery_days * 10. */
/* Q84. Campaign success: ROI = (revenue - spend) / spend, conditional buckets. */
/* Q85. Customer health index: combination of orders + reviews + tickets. */
/* Q86. Product profitability: (price - cost) / cost; tier = high/med/low. */
/* Q87. Store performance index: revenue * 0.5 + orders * 0.3 + avg_review * 100. */
/* Q88. Inventory turnover ratio: COGS / avg_inventory; CASE for unhealthy ranges. */
/* Q89. Support agent workload score: open_tickets + (urgent_tickets * 3). */
/* Q90. Multi-channel engagement score: orders + reviews + tickets + calls (with weights). */
/* Q91. Build a "next best action" CASE: if churn_risk='high' -> call; if tickets_unresolved > 2 -> support. */
/* Q92. Build a "promotion eligibility" CASE for employees. */
/* Q93. Build a "loyalty next-tier" CASE: how many points needed to advance. */
/* Q94. Build a "refund auto-approval" CASE based on customer LTV. */
/* Q95. Build a "delivery SLA" CASE: by tier and product price. */
/* Q96. Build a "discount tier" CASE based on order_total. */
/* Q97. Build a "geo-zone shipping cost" CASE based on city. */
/* Q98. Build a "subscription tier" CASE: monthly orders + avg_basket. */
/* Q99. Build a "credit score-equivalent" CASE: orders / refunds ratio. */
/* Q100. Single-query 360deg customer dashboard with 10 derived CASE columns. */

/* ============================================================
   END OF Conditional Logic & Derived Columns - HARD LEVEL (100 QUESTIONS)
============================================================ */
