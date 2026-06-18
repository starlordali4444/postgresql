/* ============================================================
   SQL PRACTICE SET - Review & Interview Prep (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Mixed review of Weeks 1-5 topics at staff-engineer / system-design level
   Database:     RetailMart V3

   Scope (CRAZY = staff-engineer / production / architecture patterns):
     - End-to-end analytics pipelines in a single query or CTE chain
     - Production-grade dedup, reconciliation, and data quality automation
     - Full RFM + cohort + funnel in one session
     - Index strategy, MV refresh, query plan walkthroughs
     - Cross-domain RetailMart system design challenges
   Structure: 25 Conceptual + 25 End-to-end pipelines + 25 Production analytics + 25 Architecture & design
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL REVIEW - STAFF ENGINEER LEVEL (25)
   ------------------------------------------------------------ */
/* Q1.  A colleague runs NOT IN (SELECT cust_id FROM ...) and gets 0 rows unexpectedly. Walk them through exactly why NULL in the subquery causes this and write the safe alternative. */
/* Q2.  Explain the difference between ROWS BETWEEN and RANGE BETWEEN frames in window functions. Give a case where they produce different results on RetailMart data. */
/* Q3.  You need to compute a running median (not just average) by order date. Explain why window MEDIAN doesn't exist in PostgreSQL and write the workaround with PERCENTILE_CONT. */
/* Q4.  Describe the complete query execution lifecycle in PostgreSQL: parse -> rewrite -> plan -> execute. Where does the planner's cardinality estimate fit? */
/* Q5.  A LATERAL join over 50,000 customers scanning order_items 50,000 times is O(n^2). Describe two rewrite strategies to avoid this. */
/* Q6.  Explain what a "zombie tuple" is in PostgreSQL and why aggressive UPDATEs without VACUUM cause table bloat. */
/* Q7.  When should you choose a BRIN index over a B-tree? Describe the physical-layout assumption it relies on. */
/* Q8.  A partial index on sales.orders WHERE order_status = 'Processing' is 1/15th the size of a full index. Explain the tradeoff and when it breaks. */
/* Q9.  Describe the difference between an "inclusive" and "exclusive" hash join in PostgreSQL and when each appears. */
/* Q10. Explain the "streaming aggregate" vs "hash aggregate" operators in EXPLAIN and when you'd prefer each. */
/* Q11. What is a "ghost read" (phantom read) in REPEATABLE READ isolation and why does it still matter for analytics queries? */
/* Q12. Explain MVCC (Multi-Version Concurrency Control) in two sentences. Why does it mean reads never block writes? */
/* Q13. You run EXPLAIN (ANALYZE, BUFFERS) and see "Buffers: shared hit=50000 read=200". What does this tell you about cache effectiveness? */
/* Q14. A materialized view refresh is causing locking on the base table. What is CONCURRENT REFRESH and what constraint does it require? */
/* Q15. Describe the "index bloat" problem: when does a B-tree index grow larger than necessary and how do you reclaim space? */
/* Q16. Explain the difference between INCLUDE columns in a covering index and columns in the index key. When does this matter? */
/* Q17. You need to model a many-to-many relationship between customers and promotions in RetailMart. Design the junction table and explain the indexing strategy. */
/* Q18. What is "table partitioning" in PostgreSQL? Which RetailMart table would benefit most from range partitioning and on which column? */
/* Q19. A query planner ignores a perfectly good index on a column with 99% NULL values. Explain why and what index type helps. */
/* Q20. Describe how ANALYZE updates pg_statistic. Why does a freshly loaded table sometimes have terrible query plans? */
/* Q21. Explain the difference between a "correlated subquery" and a "decorrelated subquery" in PostgreSQL's planner. How does the planner transform one to the other? */
/* Q22. What is a "merge join" in PostgreSQL? What precondition must both inputs satisfy and what is the amortized cost? */
/* Q23. You need to deduplicate a 50M-row table while keeping the latest row per business key. Describe the safest production approach using a CTE and DELETE. */
/* Q24. Explain the tradeoff between a view and a CTE for code reuse in PostgreSQL. When does a CTE become a "CTE fence"? */
/* Q25. Describe a "write-heavy" column (like order_status) and explain why indexing it may hurt write throughput more than it helps reads. */

/* ============================================================
   SECTION B: END-TO-END ANALYTICS PIPELINES (25)
   ------------------------------------------------------------ */
/* Q26. Write a single CTE chain that computes the complete customer lifecycle dashboard: total_orders, total_spend, avg_order_value, days_since_last_order, loyalty_tier, RFM_score (1-5 composite), and churn_risk_flag (> 180 days inactive). */
/* Q27. Build a multi-step revenue attribution query: for each campaign in marketing.campaigns, compute the revenue from orders placed within 7 days of campaign launch (by the same customer who received an email_click). */
/* Q28. Write a "supply chain health" pipeline CTE: warehouse inventory coverage days (inventory / avg daily orders), SLA breach rate (shipments delivered late), and dead-stock flag (products with 0 orders in 90 days). */
/* Q29. Build a full cohort retention matrix using a CTE: signup_month x period_index (0-6), with cohort_size, retained_customers, and retention_pct. Return the result as a "long" table (not pivoted). */
/* Q30. Write a query that computes the complete product P&L: revenue (quantity * unit_price), cost (quantity * cost_price), gross_margin, and return_rate (returns / orders) per product, along with a running cumulative revenue rank (ABC analysis). */
/* Q31. Build a "store ops scorecard" CTE: for each store, compute (1) total revenue, (2) avg ticket resolution time (from support.tickets where resolved_date IS NOT NULL), (3) return rate, (4) top-selling category, (5) employee count - all in one CTE chain. */
/* Q32. Write a funnel query across three systems: web_events.page_views (visit) -> web_events.events where event_type = 'add_to_cart' -> sales.orders (purchase). Show customer counts and conversion rates at each step. */
/* Q33. Build a "wallet reconciliation" report: for each customer, compare customers.wallets.balance to the net of loyalty.redemptions and sales.payments credited, and flag discrepancies > Rs100. */
/* Q34. Write a "payroll audit" CTE: for each employee, compute their expected gross pay from payroll.pay_slips, compare to hr.salary_history, and flag any month where the two differ by > 5%. */
/* Q35. Build a complete "email marketing effectiveness" report: per campaign, show send count, open rate, click rate, orders placed (within 7 days), revenue, and revenue-per-email-sent - all in one CTE chain. */
/* Q36. Write a "product returns root-cause" query: join sales.returns to support.tickets on the same order_id, and for each return reason (or NULL if no ticket), compute volume, avg refund_amount, and % of total returns. */
/* Q37. Build an "analyst-grade DAU/MAU/WAU" dashboard from web_events.page_views: compute per month the daily active users (avg per day), weekly active users (avg per week), and stickiness ratios (DAU/MAU, WAU/MAU). */
/* Q38. Write a "new vs returning revenue" split: for each month, compute revenue from customers placing their first-ever order vs revenue from repeat customers. Use a CTE that identifies each customer's first order date. */
/* Q39. Build a "fraud-signal" query: flag orders where (a) gross_total > 3x the customer's historical avg order, AND (b) the order was placed within 24 hours of an address change (if available), AND (c) the order status is 'Processing'. */
/* Q40. Write a comprehensive "inventory health" report: per product per warehouse, compute current_qty, avg_daily_sales (30-day), days_of_stock, reorder_urgency (CASE: 'Critical' < 7 days / 'Low' 7-30 / 'OK' > 30), and value_at_risk (qty * cost_price). */
/* Q41. Build a "HR cost analysis" pipeline: department, total headcount, total annual payroll (12x avg net_salary), payroll as % of total company payroll, and a year-over-year payroll growth rate (using LAG on salary_history). */
/* Q42. Write an "audit trail completeness" query: for each table schema, count rows in audit.record_changes and check if the ratio of change events to base table rows is above a minimum threshold (suggesting proper auditing). */
/* Q43. Build a "customer support SLA" dashboard: per ticket_priority, compute (1) avg resolution hours, (2) % resolved within SLA (Critical < 4h, High < 24h, Medium < 72h, Low < 168h), (3) breach trend vs prior month. */
/* Q44. Write a "cross-sell opportunity" query: for each product category pair (A, B), compute the number of customers who bought A but never bought B - ranked by opportunity size. */
/* Q45. Build a "brand health" index: per brand, compute avg review rating, review_count, avg price, revenue share of its category, return rate, and a composite health_score (weighted formula of your design). */
/* Q46. Write a "peak load" analysis: from web_events.page_views and call_center.calls, identify the hours of day and days of week where both page view volume and call volume are simultaneously highest - flag the top 5 combined load windows. */
/* Q47. Build a "regional manager scorecard" CTE: for each regional manager (employee with role = 'Regional Manager'), compute total revenue across all their stores, avg store return rate, avg employee satisfaction (from hr.attendance punctuality proxy), and headcount. */
/* Q48. Write a "product lifecycle" classification: for each product, using audit.record_changes price events and order_items sales data, classify as 'Growing' (increasing revenue trend), 'Mature' (stable), 'Declining' (decreasing trend) using LAG-based month-over-month changes. */
/* Q49. Build a "loyalty program effectiveness" pipeline: per loyalty tier, compute (a) avg points_balance, (b) avg order frequency, (c) avg total spend, (d) redemption rate, (e) vs customers NOT in loyalty program - show the delta for each metric. */
/* Q50. Write a single CTE-chain that produces the "executive weekly briefing" summary: this_week_revenue, last_week_revenue, wow_growth_pct, mtd_revenue, ytd_revenue, new_customers_this_week, top_category_this_week, top_store_this_week - all in one row. */

/* ============================================================
   SECTION C: PRODUCTION ANALYTICS PATTERNS (25)
   ------------------------------------------------------------ */
/* Q51. You need a "slowly changing dimension" view for customer tier: show each customer's tier, the date they moved to that tier, and the date they left (NULL if current). Use audit.record_changes where field_name = 'tier'. */
/* Q52. Implement a "late-arriving fact" detection query: orders inserted in the last 24 hours with an order_date > 30 days in the past (late data loader). Flag them and compute how they affect monthly revenue totals. */
/* Q53. Build a "data completeness matrix": for each schema.table, compute the % of columns with > 1% NULLs, % of rows with at least one NULL, and a "completeness_score" (100 = fully populated). */
/* Q54. Write a "price elasticity" approximation: for each product, correlate price changes (from audit.record_changes) to subsequent order volume changes. Use LAG to get pre/post price and volume. */
/* Q55. Build a "support agent efficiency" query: per call center agent, compute (1) avg call duration, (2) calls per shift (8h window), (3) % calls with a matching support ticket resolved same day, (4) overall efficiency_score. */
/* Q56. Implement a "B-segment" store identification: stores ranked 11-30 by revenue (not top 10, not bottom), with their revenue, growth rate vs prior period, and the revenue gap to the top-10 cutoff. */
/* Q57. Write a "demand forecasting input" query: for each product x month, produce: units_sold, avg_daily_sold, trailing_3m_avg, trailing_12m_avg, yoy_growth, and a naive_forecast (trailing_3m_avg projected for next month). */
/* Q58. Build a "return rate anomaly detector": using a z-score approach, flag products whose return_rate is > 2 standard deviations above the category mean. */
/* Q59. Implement a "multi-touch attribution" model: for each order, identify all marketing.email_clicks within 30 days prior; distribute revenue equally across campaigns (even-touch attribution). */
/* Q60. Write a "geographic concentration risk" query: compute the Herfindahl-Hirschman Index (HHI) of revenue by store_city - SUM of (city_revenue_share)^2 - to measure geographic concentration. */
/* Q61. Build a "customer-to-customer cohort flow" query: show how many customers moved from one tier (Bronze/Silver/Gold/Platinum) to another between two consecutive years (using tier_updated_at). */
/* Q62. Write a "supply chain bullwhip" indicator: for each product, compare the coefficient of variation (CV = stddev/avg) of end-customer demand (from order_items) vs warehouse supply_chain.shipment quantities per week. */
/* Q63. Implement a "real-time order health" CTE: for each order_id in the last 24 hours, join to shipments, payments, and order_items - flag any order where one of these is missing (orphan detection). */
/* Q64. Build a "customer 360" profile query: for a given customer_id, show in a single result set: personal info, loyalty tier, RFM score, last 3 orders, open tickets, recent web events, and total lifetime value. */
/* Q65. Write a "markdown impact" analysis: from promotions joined to order_items, compute revenue with vs without promotions active, and the lift (%) per product category per promotion period. */
/* Q66. Build an "employee attrition risk" proxy: compute per employee the % of days absent (from hr.attendance), salary percentile within department, and salary_growth_rate - flag those with high absence + low salary growth as "at-risk". */
/* Q67. Implement a "product recommendation engine input": compute a customer x category affinity matrix - for each customer x category pair, compute purchase_frequency and avg_spend - the top 3 categories not yet purchased are recommendations. */
/* Q68. Write a "flash sale impact" query: identify 24-hour windows where order volume > 3x the daily average, and for those windows compute incremental revenue, return rate spike, and support ticket surge. */
/* Q69. Build a "supplier reliability" scorecard: per supplier, compute on-time delivery rate, defect rate (returns as % of order items), lead time variability (STDDEV of days from supply_chain.shipments), and a reliability_score. */
/* Q70. Write a "revenue leakage" detector: find all orders where payment_mode was COD (cash on delivery) but finance.payments shows no corresponding payment record - these are unfulfilled COD collections. */
/* Q71. Implement a "dead-stock recovery" ranking: products in warehouse inventory with 0 orders in 120 days, ranked by (current_qty x cost_price) descending - the capital tied up in dead stock. */
/* Q72. Build a "promotional ROI" model: per campaign, compute total ads_spend, revenue attributable (orders within 7 days), ROI = (revenue - spend) / spend, and payback_days (spend / daily_revenue_lift). */
/* Q73. Write a "support ticket sentiment proxy" query: since we lack NLP, use ticket subject length > 100 chars as a proxy for "detailed/frustrated" complaints. Compute % of such tickets per product category. */
/* Q74. Implement a "customer win-back" target list: customers who spent > Rs10,000 total in 2024 but placed 0 orders in 2025, ranked by their 2024 total spend descending. */
/* Q75. Build a "call center IVR bypass" analysis: calls with call_duration_seconds < 30 are likely abandoned. Compute abandoned rate by hour-of-day and identify the top 3 hours for staffing gaps. */

/* ============================================================
   SECTION D: ARCHITECTURE & SYSTEM DESIGN (25)
   ------------------------------------------------------------ */
/* Q76. Design the analytics schema for RetailMart's BI layer: which base-table queries would you materialize as MVs, what refresh cadence, and what indexes on the base tables would support fast incremental reads? */
/* Q77. The data team wants to build a "self-serve analytics" layer on RetailMart. Design a view hierarchy: raw -> cleansed -> aggregated -> business-metric views. Name 3 views per layer and their dependencies. */
/* Q78. A data engineer proposes partitioning sales.orders by order_date (monthly range). Describe the benefits, risks, and what changes to existing queries. */
/* Q79. The ops team wants to archive orders older than 3 years to a cold table. Describe the migration strategy using a CTE with a writable CTE (DELETE ... RETURNING) - and why this is done in batches. */
/* Q80. Describe a "materialized view refresh strategy" for RetailMart that minimizes lock time: which MVs can use CONCURRENT REFRESH, which cannot (due to no unique index), and what alternative is there for those? */
/* Q81. Design an "event-driven" pipeline to keep a customer_rfm_scores table up to date: what triggers an RFM recompute (new order, new return), how would you implement this with PostgreSQL triggers + a refresh_queue? */
/* Q82. The marketing team needs a campaign attribution table populated nightly. Describe the SQL pipeline (CTEs + INSERT INTO ... SELECT) and what idempotency mechanism prevents double-counting. */
/* Q83. Design a "data contract" for the sales.orders table: list the constraints (CHECK, FK, NOT NULL, UNIQUE) you would add to guarantee data quality without touching existing rows. */
/* Q84. You discover that the page_views table (500k rows, growing 10k/day) is causing the daily analytics job to take 45 minutes. Propose a partitioning + BRIN + parallel-query solution. */
/* Q85. A query joining 6 tables takes 30 seconds. Describe a systematic EXPLAIN ANALYZE-driven diagnosis: what operators would you look for, what statistics would you check, and what changes would you make? */
/* Q86. Design a "slowly changing dimension" (SCD Type 2) implementation for customers.customers.tier: what columns would you add, how would you populate valid_from / valid_to, and how would you query "tier as of a given date"? */
/* Q87. The CFO wants a "financial close" report that reconciles sales.orders, finance.payments, and finance.accounts every month-end. Design the SQL reconciliation query and describe what happens if discrepancies are found. */
/* Q88. Design an indexing strategy for the RetailMart analytics workload: list 5 specific indexes (table, columns, type, partial condition) that would have the highest impact on the most-run queries. */
/* Q89. Describe the tradeoffs between storing pre-aggregated monthly_revenue in a table vs computing it on demand from sales.orders each time. When does pre-aggregation break? */
/* Q90. A new requirement: track which analyst ran which query and when, for audit compliance. Describe how you'd use audit.api_requests or pg_stat_statements to build this, without installing extensions. */
/* Q91. The student database (accio_NN) needs to be reset between cohorts. Design a "reset script" that drops all student-created objects (tables, views, indexes in public schema) but preserves the RetailMart schemas. */
/* Q92. Describe the "write amplification" problem when adding multiple indexes to sales.order_items (374k rows, heavy insert load). Quantify the tradeoff and state which 2 indexes you would keep. */
/* Q93. The HR team wants to run ad-hoc salary analysis but must not see individual employee names or IDs (PII). Design a row-level security policy or a view-based masking approach in PostgreSQL. */
/* Q94. Design a "canary query" - a simple SQL statement you'd run each morning to validate that last night's data load into RetailMart V3 completed successfully (counts, date ranges, FK checks). */
/* Q95. The support team reports that queries against support.tickets are slow after 12 months of data growth. Describe your full investigation: pg_stat_user_indexes -> EXPLAIN ANALYZE -> index creation -> VACUUM ANALYZE. */
/* Q96. Design a "multi-tenant" extension of RetailMart where each tenant has its own schema but shares the same PostgreSQL instance. What isolation issues arise, and how does search_path help? */
/* Q97. Describe a "blue-green" deployment approach for a major schema change on sales.orders (adding a new column with a NOT NULL default). How do you avoid a long lock? */
/* Q98. The analytics team wants column-level encryption on customers.email for GDPR compliance. Describe the pgcrypto approach vs the application-level approach and the query impact of each. */
/* Q99. Design a "query budget" system: each analyst is allowed to run queries that scan at most 10M rows per day. How would you implement this using pg_stat_statements + a daily quota table? */
/* Q100. Write your personal "RetailMart mastery checklist": 10 SQL patterns from this course that you could explain in an interview in under 2 minutes each - and for each, name the RetailMart query that best demonstrates it. */
