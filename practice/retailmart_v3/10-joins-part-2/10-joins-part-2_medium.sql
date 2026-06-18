/* ============================================================
   SQL PRACTICE SET - JOINs Part 2 (Advanced) (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JOINs Part 2 - Self joins, FULL OUTER, CROSS, Set ops (deeper)
   Database:     RetailMart V3

   Scope (deeper than Easy):
     - SELF JOIN gotchas (self-cross, hierarchical patterns)
     - FULL OUTER + COALESCE for clean reconciliation
     - CROSS JOIN with generate_series for grids / dense reports
     - UNION ALL + GROUP BY for multi-source consolidations
     - INTERSECT/EXCEPT patterns
     - LATERAL preview

   Structure: 25 Conceptual + 25 SELF JOIN deeper + 25 FULL OUTER + CROSS grids + 25 Set ops + LATERAL preview
   ============================================================ */

/* ============================================================
   SECTION A: SET OPS + SELF JOIN - CONCEPTUAL DEEPER (25)
   ------------------------------------------------------------ */
/* Q1.  Why is "self-join + GROUP BY" usually slower than a window function (preview)? */
/* Q2.  How does a self-join scale with N - and when do you avoid it? */
/* Q3.  When does FULL OUTER JOIN produce duplicate rows - and how do you collapse them with COALESCE? */
/* Q4.  Why is CROSS JOIN with generate_series the standard way to "fill in missing dates"? */
/* Q5.  Compare UNION ALL vs JOIN - when can the same answer be expressed either way? */
/* Q6.  Why does UNION (without ALL) require a SORT step - and how does that affect plans? */
/* Q7.  Compare EXCEPT vs NOT IN vs NOT EXISTS - three flavors of anti-join. */
/* Q8.  What's the catch with INTERSECT and NULL columns? */
/* Q9.  Why is FULL OUTER JOIN often the "reconciliation report" tool of choice? */
/* Q10. Explain what LATERAL JOIN does - and how it differs from a normal subquery. */
/* Q11. Why does LATERAL let you reference outer-row columns inside the subquery? */
/* Q12. When does the planner choose Hash Join vs Merge Join vs Nested Loop for self-joins? */
/* Q13. Compare LEFT JOIN LATERAL vs INNER JOIN LATERAL - when does each row get dropped? */
/* Q14. Why is SELF JOIN over a tiny table OK but a Cartesian on huge tables disastrous? */
/* Q15. Explain why ORDER BY in a UNION must appear ONLY at the end. */
/* Q16. What does GROUP BY 1 do in a UNION - does it apply to all branches? */
/* Q17. Why does generate_series often appear inside CROSS JOIN LATERAL? */
/* Q18. Compare CROSS JOIN unnest(array) vs LATERAL unnest(array). */
/* Q19. Why does UNION ALL preserve duplicates and how is that useful for "stacked timelines"? */
/* Q20. Walk through how SELF JOIN can compute "next event per row" before window functions. */
/* Q21. Why does FULL OUTER JOIN often require COALESCE on JOIN keys? */
/* Q22. Compare INTERSECT vs INNER JOIN ON all-columns - when are they equivalent? */
/* Q23. Why is EXCEPT sometimes preferred over LEFT JOIN ... IS NULL for "find missing" reports? */
/* Q24. What is "set semantics drift" - when a UNION quietly drops rows you wanted to keep? */
/* Q25. Why is FULL OUTER JOIN the standard "audit table mismatch" tool? */

/* ============================================================
   SECTION B: SELF JOIN - DEEPER PATTERNS (25)
   ------------------------------------------------------------ */
/* Q26. For each order, find the customer's PREVIOUS order (self-join on cust_id + ORDER BY). */
/* Q27. For each shipment, find the next shipment by the same courier_name. */
/* Q28. For each pay_slip, find the same employee's prior month pay_slip. */
/* Q29. For each ticket, find prior ticket by same customer (same cust_id). */
/* Q30. For each call, find prior call by same agent_id. */
/* Q31. For each review, find prior review by same customer for same product_id. */
/* Q32. For each page_view, find prior page_view in same session. */
/* Q33. Pairs of customers in same city, same tier - show how many such pairs exist. */
/* Q34. Find pairs of orders by same customer where time-difference < 1 hour. */
/* Q35. Self-join orders with itself: COUNT of repeat-day customers. */
/* Q36. For each campaign, find another campaign of same platform with higher budget. */
/* Q37. For each product, find another product of same brand with higher price. */
/* Q38. For each employee, find another employee of same role with higher salary. */
/* Q39. For each store, find another store in same region with higher order count. */
/* Q40. For each warehouse, find another warehouse in same region with higher quantity_on_hand. */
/* Q41. SELF JOIN employees: find employees whose hire_date is exactly N days after another employee. */
/* Q42. SELF JOIN orders: customers with 2+ orders within 7 days. */
/* Q43. SELF JOIN tickets: customers with 2+ tickets in same week. */
/* Q44. SELF JOIN reviews: customers who wrote 2 reviews on different products with same rating. */
/* Q45. SELF JOIN inventory: products whose quantity_on_hand at one warehouse = at another. */
/* Q46. SELF JOIN customers: pairs from same city with different tiers (cross-tier in same city). */
/* Q47. SELF JOIN orders: chains of 3+ same-day orders by same customer. */
/* Q48. SELF JOIN page_views: sessions where two page_views had same url. */
/* Q49. SELF JOIN tickets: ticket pairs from same customer where one is Critical and another Low. */
/* Q50. SELF JOIN products: products with same supplier_id and same category. */

/* ============================================================
   SECTION C: FULL OUTER + CROSS JOIN GRIDS (25)
   ------------------------------------------------------------ */
/* Q51. Full reconciliation: customers vs orders - show 4 buckets (both / customer only / order only / never). */
/* Q52. Full reconciliation: employees vs pay_slips - find pay_slips orphaned to deleted employees. */
/* Q53. Full reconciliation: orders vs payments - orders without payments + payments without orders. */
/* Q54. Full reconciliation: orders vs shipments - count of each side mismatch. */
/* Q55. Full reconciliation: loyalty.members vs customers - orphan members? */
/* Q56. Per region x month grid: SUM revenue (CROSS JOIN regions x month_series LEFT JOIN orders). */
/* Q57. Per platform x month grid: SUM ad spend (no zeros missing). */
/* Q58. Per ticket priority x month grid: COUNT tickets (zero-cell rows preserved). */
/* Q59. Per device_type x week grid: COUNT page_views. */
/* Q60. Per category x tier grid: COUNT distinct customers. */
/* Q61. Per courier x month grid: COUNT shipments. */
/* Q62. Per warehouse x day grid (last 7 days): quantity_on_hand. */
/* Q63. Per dim_department x month grid: total payroll. */
/* Q64. Per dim_region x dim_category grid: SUM revenue. */
/* Q65. Per status x month grid: order counts (all status x month combos shown). */
/* Q66. Use generate_series(2024-01-01, 2026-02-26, '1 month') + CROSS JOIN regions to build monthxregion target frame. */
/* Q67. CROSS JOIN tiers x dim_department to get "tier presence" matrix. */
/* Q68. CROSS JOIN dim_brand x dim_region: revenue matrix. */
/* Q69. CROSS JOIN courier list x order_status: shipment frequencies. */
/* Q70. CROSS JOIN log_level x service_name: counts. */
/* Q71. Build a calendar dimension (generate_series for dates) + week_of_year + is_weekend column. */
/* Q72. CROSS JOIN customers x campaigns to simulate "all campaigns reachable per customer" cell. */
/* Q73. CROSS JOIN dim_region x tiers x months - 3-dim grid for executive dashboard. */
/* Q74. CROSS JOIN every supplier x product to find supplier-product gaps. */
/* Q75. CROSS JOIN orders x generate_series - explode 1 order row into N (e.g., per installment). */

/* ============================================================
   SECTION D: UNION / INTERSECT / EXCEPT / LATERAL (25)
   ------------------------------------------------------------ */
/* Q76. UNION ALL: all touchpoints per customer (orders, reviews, tickets, calls) into one event stream. */
/* Q77. UNION ALL + GROUP BY: count of distinct customers across orders + reviews + tickets (deduped). */
/* Q78. UNION ALL: combined revenue stream from orders + ads_spend (sign-flip for spend). */
/* Q79. UNION ALL: combine top-5 best categories + bottom-5 worst categories with a label column. */
/* Q80. INTERSECT: customers who placed orders AND wrote reviews AND opened tickets. */
/* Q81. EXCEPT: products in inventory_snapshots but never in order_items. */
/* Q82. EXCEPT: customers ordered but never reviewed. */
/* Q83. EXCEPT: employees in stores.employees but not in pay_slips. */
/* Q84. INTERSECT: stores having BOTH employees AND orders AND inventory_snapshots. */
/* Q85. EXCEPT ALL vs EXCEPT: show difference on a duplicated cust_id list. */
/* Q86. UNION ALL: monthly revenue + monthly cost + monthly profit as separate rows with metric label. */
/* Q87. UNION ALL: registered + guest checkouts into uniform customer_id list. */
/* Q88. UNION ALL + ROLLUP-like: per-region totals + grand total via UNION. */
/* Q89. UNION ALL: rolling 12-week window built from 12 SELECTs (preview window functions). */
/* Q90. UNION ALL: ticket history + call history into a "support contact timeline" per customer. */
/* Q91. LATERAL: per customer, latest 3 orders (LATERAL with LIMIT 3 + ORDER BY). */
/* Q92. LATERAL: per product, latest review (LATERAL with LIMIT 1). */
/* Q93. LATERAL: per region, top 5 stores by revenue. */
/* Q94. LATERAL: per category, top 3 products by units sold. */
/* Q95. LATERAL with generate_series: explode orders into N installment rows. */
/* Q96. LATERAL: per customer, count distinct products purchased. */
/* Q97. LATERAL: per store, employee with highest salary. */
/* Q98. LATERAL: per courier_name, last 5 shipments. */
/* Q99. UNION ALL across 4 schemas (orders, reviews, tickets, calls) producing a unified "customer activity" denormalized feed. */
/* Q100. EXCEPT + LATERAL combined: find customers with orders but no reviews of those exact products. */

/* ============================================================
   END OF JOINs Part 2 (Advanced) - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
