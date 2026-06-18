/* ============================================================
   SQL PRACTICE SET - JOINs Part 2 (Advanced) (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JOINs Part 2 - Self joins, FULL OUTER, CROSS, Set ops
   Database:     RetailMart V3

   Scope:
     - SELF JOIN basics (alias one table twice)
     - FULL OUTER JOIN basics
     - CROSS JOIN basics
     - UNION / UNION ALL
     - INTERSECT / EXCEPT
     - LATERAL JOIN (gentle intro)

   Structure: 25 Conceptual + 25 SELF JOIN + 25 FULL OUTER / CROSS + 25 Set Operations
   ============================================================ */

/* ============================================================
   SECTION A: JOINS PART 2 - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What is a SELF JOIN - and why do you need it? */
/* Q2.  Why are aliases mandatory in self-joins? */
/* Q3.  What is a FULL OUTER JOIN - when do both LEFT and RIGHT unmatched rows matter? */
/* Q4.  Compare INNER vs LEFT vs RIGHT vs FULL - which rows each preserves. */
/* Q5.  What is a CROSS JOIN - when do you actually want one? */
/* Q6.  Difference between UNION and UNION ALL - and why ALL is faster. */
/* Q7.  What is INTERSECT - when is it more readable than INNER JOIN? */
/* Q8.  What is EXCEPT - and how is it different from anti-join? */
/* Q9.  What rules must all queries in a UNION follow (column count, types)? */
/* Q10. Why does UNION sort + dedupe but UNION ALL does not? */
/* Q11. What is a LATERAL JOIN - give a one-line description. */
/* Q12. Compare LATERAL vs correlated subquery - same idea, different syntax. */
/* Q13. Can you SELF JOIN through a foreign key (manager -> employee)? */
/* Q14. Why is FULL OUTER JOIN often used in data reconciliation reports? */
/* Q15. What does CROSS JOIN with a numbers table give you? */
/* Q16. Does ORDER BY apply to each branch of UNION, or the combined result? */
/* Q17. Where do you put LIMIT in a UNION query - per branch or overall? */
/* Q18. What is "set semantics" vs "bag semantics" in SQL? */
/* Q19. Can NULLs match in INTERSECT? */
/* Q20. Why is FULL OUTER JOIN rarely used in OLTP queries? */
/* Q21. How is a SELF JOIN typically used to find pairs (e.g., "employees in the same department")? */
/* Q22. Compare CROSS JOIN vs FROM a, b - are they the same? */
/* Q23. Why is UNION often slower than a single SELECT with OR conditions? */
/* Q24. What is "generate_series" - and why does it pair so well with CROSS JOIN? */
/* Q25. When does EXCEPT ALL behave differently from EXCEPT? */

/* ============================================================
   SECTION B: SELF JOIN BASICS (25)
   ------------------------------------------------------------ */
/* Q26. Pairs of employees in the same dim_department (e1.dept_id = e2.dept_id, e1.id < e2.id). */
/* Q27. Pairs of customers in the same city. */
/* Q28. Pairs of orders placed by the same customer on the same day. */
/* Q29. Pairs of products with the same brand_id. */
/* Q30. Pairs of stores in the same region_id. */
/* Q31. List employees with the same role at different stores. */
/* Q32. Find customers who share the same email domain. */
/* Q33. List products in the same category with the same supplier_id. */
/* Q34. Find tickets with the same priority + same status - show paired ticket_ids. */
/* Q35. Pairs of campaigns running on the same platform. */
/* Q36. Pairs of pay_slips for the same employee but different salary_month. */
/* Q37. Pairs of orders by the same customer but different store_id. */
/* Q38. Pairs of reviews by the same customer on different products. */
/* Q39. Pairs of products with the same price_band (CASE-based). */
/* Q40. Pairs of warehouses in the same region (no region_id on warehouses? join via stores). */
/* Q41. SELF JOIN on customers: pairs of customers in same tier + same city. */
/* Q42. SELF JOIN: pairs of brands with same category_id. */
/* Q43. SELF JOIN: orders placed within 1 hour of each other by the same customer. */
/* Q44. SELF JOIN: shipments using the same courier_name on the same date. */
/* Q45. SELF JOIN: web_events.page_views in the same session_id. */
/* Q46. SELF JOIN: employees with same hire_date. */
/* Q47. SELF JOIN: pay_slips with same gross_salary but different employee_id. */
/* Q48. SELF JOIN: tickets created by same customer for different products. */
/* Q49. SELF JOIN: products with same supplier_id but different brand_id. */
/* Q50. SELF JOIN: campaigns with same budget but different platform. */

/* ============================================================
   SECTION C: FULL OUTER + CROSS JOIN (25)
   ------------------------------------------------------------ */
/* Q51. FULL OUTER JOIN customers and loyalty.members - show customers without loyalty AND members orphaned. */
/* Q52. FULL OUTER JOIN orders and shipments - orders without shipments + shipments without orders. */
/* Q53. FULL OUTER JOIN employees and pay_slips - employees never paid + pay_slips with no employee. */
/* Q54. FULL OUTER JOIN dim_region and stores - regions without stores + stores in no region. */
/* Q55. FULL OUTER JOIN dim_category and dim_brand - empty categories + brands with no category. */
/* Q56. FULL OUTER JOIN products and order_items - never-sold products + items pointing to deleted product. */
/* Q57. FULL OUTER JOIN warehouses and inventory_snapshots - empty warehouses + orphan snapshots. */
/* Q58. FULL OUTER JOIN tickets and support.agents - unassigned tickets + agents with no tickets. */
/* Q59. FULL OUTER JOIN ad_campaigns and ads_spend - campaigns with no spend + spend with no campaign. */
/* Q60. FULL OUTER JOIN reviews and orders - reviews not linked to order + orders never reviewed. */
/* Q61. CROSS JOIN dim_region x tiers - all (region, tier) combinations (potential customer segments). */
/* Q62. CROSS JOIN months x dim_category - all (month, category) buckets for revenue grid. */
/* Q63. CROSS JOIN device_type x os_list - all browser/device combinations. */
/* Q64. CROSS JOIN platforms x months - all reporting cells for ads_spend. */
/* Q65. CROSS JOIN dim_region x dim_brand - all marketxbrand combinations. */
/* Q66. CROSS JOIN generate_series(1, 12) x stores - month-by-store grid. */
/* Q67. CROSS JOIN order statuses x stores - every (status, store) bucket. */
/* Q68. CROSS JOIN ticket_priority x ticket_status - all priority-status combos. */
/* Q69. CROSS JOIN regions x campaigns - all targeting combinations. */
/* Q70. CROSS JOIN years x dim_department - year-by-dept HR grid. */
/* Q71. Use generate_series to build a date dimension. */
/* Q72. Build a calendar table (one row per day from 2024-01-01 to today) using generate_series. */
/* Q73. CROSS JOIN dim_category x tiers - used for cohort analysis grids. */
/* Q74. CROSS JOIN courier list x months - to see which courier-month combos had zero shipments. */
/* Q75. Single row x CROSS JOIN customers - turn a single row into N copies (uncommon but valid). */

/* ============================================================
   SECTION D: UNION / INTERSECT / EXCEPT (25)
   ------------------------------------------------------------ */
/* Q76. UNION ALL: combine customer emails and employee emails into one list (with source label). */
/* Q77. UNION ALL: all customer interactions - orders + reviews + tickets - into a single timeline. */
/* Q78. UNION: distinct cities from customers + stores combined. */
/* Q79. UNION ALL: combine domestic and international orders (if there were two tables). Use status='International' as proxy split. */
/* Q80. UNION ALL: shipment events + delivery events into one log. */
/* Q81. UNION ALL: agent activity from tickets + calls (preview for Day 11). */
/* Q82. INTERSECT: customers who BOTH placed an order AND wrote a review. */
/* Q83. INTERSECT: customers in BOTH loyalty.members AND placed >0 orders. */
/* Q84. INTERSECT: products that appear in BOTH order_items AND reviews. */
/* Q85. INTERSECT: stores with BOTH employees AND orders. */
/* Q86. EXCEPT: customers who placed orders but are NOT in loyalty.members. */
/* Q87. EXCEPT: products with order_items but NO reviews. */
/* Q88. EXCEPT: employees with no pay_slip records. */
/* Q89. EXCEPT: stores with employees but no orders. */
/* Q90. EXCEPT: brands with products but no order_items linked. */
/* Q91. UNION ALL: top 5 highest-revenue + top 5 lowest-revenue products into one report. */
/* Q92. UNION ALL: count of orders this month + count last month + count YTD as 3 labelled rows. */
/* Q93. UNION ALL: per-region revenue + a grand-total row. */
/* Q94. UNION ALL: combine three priority lists (Critical, High, Medium) with a priority_label column. */
/* Q95. UNION ALL: registered customers + guest checkouts (where cust_id IS NULL) into one list. */
/* Q96. INTERSECT ALL vs INTERSECT - show difference using a duplicate-heavy column. */
/* Q97. UNION with ORDER BY at end - sort the combined result. */
/* Q98. UNION ALL + LIMIT - get top 3 from query A + top 3 from query B as 6 rows total. */
/* Q99. UNION ALL across three time buckets - last_week, last_month, last_quarter counts. */
/* Q100. UNION ALL: tickets + reviews + calls, all reduced to (customer_id, source, created_at). */

/* ============================================================
   END OF JOINs Part 2 (Advanced) - EASY LEVEL (100 QUESTIONS)
============================================================ */
