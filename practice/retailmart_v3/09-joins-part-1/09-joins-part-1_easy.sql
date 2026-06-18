/* ============================================================
   SQL PRACTICE SET - JOINs Part 1 (Foundations) (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JOINs Part 1 - INNER, LEFT, RIGHT
   Database:     RetailMart V3

   Scope:
     - INNER JOIN (only matching rows on both sides)
     - LEFT JOIN  (all rows from left + matches from right + NULLs)
     - RIGHT JOIN (mirror of LEFT)
     - Anti-join pattern (LEFT JOIN + WHERE right.key IS NULL)
     - 2- and 3-table chains; no FULL OUTER / SELF / CROSS yet

   Structure: 10 Conceptual + 30 INNER + 30 LEFT + 30 RIGHT/Multi-table
   ============================================================ */

/* ============================================================
   SECTION A: JOIN CONCEPTUAL (10)
   ------------------------------------------------------------ */
/* Q1.  Difference between INNER JOIN and LEFT JOIN in one sentence. */
/* Q2.  When does LEFT JOIN produce NULLs in the result? */
/* Q3.  Why is RIGHT JOIN considered redundant - what's the equivalent LEFT JOIN trick? */
/* Q4.  What is the anti-join pattern? Write it conceptually. */
/* Q5.  Why must JOIN have an ON clause - what happens without it? */
/* Q6.  What's the difference between JOIN ... ON and JOIN ... USING? */
/* Q7.  In a LEFT JOIN, when WHERE filters the right-side column, what silently happens? */
/* Q8.  Why does COUNT(*) over-count on a LEFT JOIN when measuring left-side rows? */
/* Q9.  What's a foreign-key path - give the path from sales.order_items to core.dim_category. */
/* Q10. Why is qualifying every column (alias.column) considered best practice in JOIN queries? */

/* ============================================================
   SECTION B: INNER JOIN - 2 TABLES (30)
   ------------------------------------------------------------ */
/* Q11. Show every order with the customer's first name. JOIN sales.orders + customers.customers. */
/* Q12. Show every order with the store's name. JOIN sales.orders + stores.stores. */
/* Q13. Show every order_item with its product's name. JOIN sales.order_items + products.products. */
/* Q14. Show every employee with their department name. JOIN stores.employees + core.dim_department. */
/* Q15. Show every store with its region name. JOIN stores.stores + core.dim_region. */
/* Q16. Show every product with its brand name. JOIN products.products + core.dim_brand. */
/* Q17. Show every brand with its category name. JOIN core.dim_brand + core.dim_category. */
/* Q18. Show every review with the customer's full name. JOIN customers.reviews + customers.customers. */
/* Q19. Show every ticket with the customer's email. JOIN support.tickets + customers.customers. */
/* Q20. Show every ticket with the agent's name (employee). JOIN support.tickets + stores.employees. */
/* Q21. Show every loyalty member with their tier name. JOIN loyalty.members + loyalty.tiers. */
/* Q22. Show every loyalty redemption with the customer's name. */
/* Q23. Show every payment with the order_status. JOIN sales.payments + sales.orders. */
/* Q24. Show every shipment with the order's net_total. JOIN sales.shipments + sales.orders. */
/* Q25. Show every return with the order_date. JOIN sales.returns + sales.orders. */
/* Q26. Show every call with the customer name. JOIN call_center.calls + customers.customers. */
/* Q27. Show every call with the agent name. JOIN call_center.calls + stores.employees. */
/* Q28. Show every supply-chain shipment with the warehouse name. JOIN supply_chain.shipments + supply_chain.warehouses. */
/* Q29. Show every supply-chain shipment with the supplier name. JOIN supply_chain.shipments + products.suppliers. */
/* Q30. Show every inventory snapshot with the warehouse name. JOIN supply_chain.inventory_snapshots + supply_chain.warehouses. */
/* Q31. Show every work_order with the production line name. JOIN manufacture.work_orders + manufacture.production_lines. */
/* Q32. Show every transcript with the call_reason. JOIN call_center.transcripts + call_center.calls. */
/* Q33. Show every pay_slip with the employee's first name. JOIN payroll.pay_slips + stores.employees. */
/* Q34. Show every attendance entry with the employee's role. */
/* Q35. Show every expense with its category_name. JOIN finance.expenses + core.dim_expense_category. */
/* Q36. Show every order with the customer tier (Bronze/Silver/Gold/Platinum). */
/* Q37. Show every page_view with the customer's first_name (skip anonymous ones - INNER JOIN drops them automatically). */
/* Q38. Show every ad_spend record with the campaign name. JOIN marketing.ads_spend + marketing.campaigns. */
/* Q39. Show every order with the store's CITY (orders + stores). */
/* Q40. Show every customer review with the product name (reviews + products). */

/* ============================================================
   SECTION C: LEFT JOIN (30)
   Topics: preserve all left rows; NULL for unmatched right; anti-joins
   ------------------------------------------------------------ */
/* Q41. ALL customers + a left join to sales.orders - show order_id (will be NULL for never-ordered customers). */
/* Q42. ALL products + LEFT JOIN to sales.order_items - flag products NEVER ordered (oi.order_item_id IS NULL). */
/* Q43. ALL employees + LEFT JOIN to support.tickets (as agent). */
/* Q44. ALL stores + LEFT JOIN to sales.orders - find stores with NO orders. */
/* Q45. ALL customers + LEFT JOIN to customers.reviews - find customers who NEVER reviewed. */
/* Q46. ALL customers + LEFT JOIN to support.tickets - find customers who NEVER raised a ticket. */
/* Q47. ALL customers + LEFT JOIN to loyalty.members - non-members appear with NULL tier_id. */
/* Q48. ALL orders + LEFT JOIN to sales.shipments - find orders without shipments. */
/* Q49. ALL orders + LEFT JOIN to sales.payments - find orders not yet paid. */
/* Q50. ALL orders + LEFT JOIN to sales.returns - find orders NEVER returned. */
/* Q51. ALL products + LEFT JOIN to customers.reviews - find products with NO reviews. */
/* Q52. ALL employees + LEFT JOIN to hr.attendance - find employees with NO attendance entries. */
/* Q53. ALL warehouses + LEFT JOIN to supply_chain.inventory_snapshots - find warehouses with NO inventory data. */
/* Q54. ALL warehouses + LEFT JOIN to supply_chain.shipments. */
/* Q55. ALL campaigns + LEFT JOIN to marketing.ads_spend - campaigns with no spend? */
/* Q56. ALL production_lines + LEFT JOIN to manufacture.work_orders. */
/* Q57. ALL departments + LEFT JOIN to stores.employees - departments with NO employees. */
/* Q58. ALL regions + LEFT JOIN to stores.stores - regions with NO stores. */
/* Q59. ALL brands + LEFT JOIN to products.products - brands with NO products. */
/* Q60. ALL categories + LEFT JOIN to core.dim_brand - categories with NO brands. */
/* Q61. ALL tiers + LEFT JOIN to loyalty.members - tiers with no members. */
/* Q62. ALL expense_categories + LEFT JOIN to finance.expenses. */
/* Q63. ALL suppliers + LEFT JOIN to products.products - suppliers with no products. */
/* Q64. Anti-join: products NEVER ordered (LEFT JOIN + WHERE order_item_id IS NULL). */
/* Q65. Anti-join: customers NEVER ordered. */
/* Q66. Anti-join: customers NEVER reviewed any product. */
/* Q67. Anti-join: orders NEVER shipped. */
/* Q68. Anti-join: customers NOT in loyalty program. */
/* Q69. Anti-join: tickets NEVER resolved (use ticket.resolved_date IS NULL - single table; but show LEFT JOIN style for practice). */
/* Q70. Anti-join: employees with NO ticket assignments. */

/* ============================================================
   SECTION D: RIGHT JOIN + MULTI-TABLE (30)
   Topics: RIGHT JOIN basics, then 3-table INNER chains
   ------------------------------------------------------------ */
/* Q71. RIGHT JOIN customers.customers RIGHT JOIN sales.orders - all orders, with customer info. */
/* Q72. RIGHT JOIN stores.stores RIGHT JOIN sales.orders - same idea. */
/* Q73. RIGHT JOIN products.products RIGHT JOIN sales.order_items - every item with product info. */
/* Q74. RIGHT JOIN: same as Q71 but rewritten as a LEFT JOIN. */
/* Q75. RIGHT JOIN: same as Q72 but rewritten as a LEFT JOIN. */
/* Q76. JOIN sales.orders + customers.customers + stores.stores: order_id, customer name, store name. */
/* Q77. JOIN sales.order_items + products.products + sales.orders: item_id, product_name, order_date. */
/* Q78. JOIN products.products + core.dim_brand + core.dim_category: product, brand, category. */
/* Q79. JOIN stores.employees + stores.stores + core.dim_region: employee, store, region. */
/* Q80. JOIN stores.employees + core.dim_department + stores.stores: employee, dept_name, store_name. */
/* Q81. JOIN loyalty.members + customers.customers + loyalty.tiers: member name, tier name, points. */
/* Q82. JOIN sales.orders + customers.customers + customers.addresses: order_id, customer, city. */
/* Q83. JOIN call_center.calls + customers.customers + stores.employees: customer, agent, duration. */
/* Q84. JOIN support.tickets + customers.customers + stores.employees: customer, agent, subject. */
/* Q85. JOIN customers.reviews + customers.customers + products.products: customer, product, rating. */
/* Q86. JOIN sales.returns + sales.orders + products.products: return, order_date, product. */
/* Q87. JOIN supply_chain.shipments + supply_chain.warehouses + products.suppliers: shipment, warehouse, supplier. */
/* Q88. JOIN manufacture.work_orders + manufacture.production_lines + products.products: work_order_id, line, product. */
/* Q89. JOIN payroll.pay_slips + stores.employees + stores.stores: pay_slip, employee, store. */
/* Q90. JOIN hr.attendance + stores.employees + core.dim_department: attendance, employee, department. */
/* Q91. JOIN marketing.ads_spend + marketing.campaigns + ... bonus: just 2 tables. spend, campaign name. */
/* Q92. JOIN finance.expenses + core.dim_expense_category + (where amount > 50000). */
/* Q93. JOIN audit.application_logs + (no FK needed, single table - but show with a JOIN to a synthetic literal - skip). Instead: JOIN audit.api_requests + ... single-table query (acceptable). */
/* Q94. JOIN call_center.transcripts + call_center.calls + customers.customers: transcript_id, customer, sentiment_score. */
/* Q95. JOIN web_events.events + web_events.page_views + customers.customers: event, customer, page_url. */
/* Q96. JOIN loyalty.redemptions + customers.customers + loyalty.members + loyalty.tiers: customer, tier, redemption reward. */
/* Q97. JOIN sales.orders + customers.customers + stores.stores + core.dim_region: order, customer, store, region. */
/* Q98. JOIN sales.order_items + products.products + core.dim_brand + core.dim_category + sales.orders: item, product, brand, category, order_date. */
/* Q99. JOIN sales.orders + customers.customers + sales.payments: order_id, customer, payment_mode. */
/* Q100. JOIN sales.orders + customers.customers + sales.shipments + stores.stores: full order trace (customer + courier + store). */

/* ============================================================
   END OF JOINs Part 1 (Foundations) - EASY LEVEL (100 QUESTIONS)
============================================================ */
