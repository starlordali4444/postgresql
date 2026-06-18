/* ============================================================
   SQL PRACTICE SET - Introduction to SQL & Databases (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Introduction to SQL & Databases - deeper reasoning
   Format:       100 multi-part / tradeoff / scenario questions

   Note: Day 1 has no installation yet. Medium goes deeper than
   Easy - interview-style reasoning, design tradeoffs, edge cases.
   Answer each in 3-5 sentences with concrete examples.
   ============================================================ */

/* ============================================================
   SECTION A: SQL'S PLACE IN THE STACK - DEEPER (25)
   ------------------------------------------------------------ */
/* Q1.  Compare SQL vs pandas for analyzing a 100 GB dataset - which wins and why? Give 2 reasons per side. */
/* Q2.  Your manager wants real-time dashboards. Argue for SQL on a database vs Python loading CSVs. */
/* Q3.  When would you choose a graph database OVER SQL - give a concrete RetailMart-flavoured example. */
/* Q4.  Defend the statement: "SQL skills are MORE valuable in the LLM era." Three concrete arguments. */
/* Q5.  A startup founder says "we don't need SQL; MongoDB + ChatGPT can handle everything." Push back with 3 specific gaps. */
/* Q6.  Explain to a non-technical CEO why analysts shouldn't share Excel files via email. Use the lens of correctness, audit, scale. */
/* Q7.  Compare a Data Analyst's SQL work to a Data Engineer's SQL work - where do they overlap, where do they diverge? */
/* Q8.  In an interview you're asked: "tell me about a time SQL beat a Python solution at your job." Make up a plausible scenario. */
/* Q9.  Walk through what happens when you click "Send" on an order at amazon.in - how many SQL queries (roughly) and why? */
/* Q10. Why do some teams prefer DBT over hand-written SQL pipelines - what specific problem does it solve? */
/* Q11. Why does the same SQL query give different EXECUTION PLANS on PostgreSQL vs MySQL vs SQL Server? */
/* Q12. Compare "Excel for analysis" vs "SQL for analysis" using the four lenses: scale, correctness, repeatability, audit. */
/* Q13. A junior asks: "why do interviewers care about SQL when AI can write it?" - three real reasons. */
/* Q14. Defend why a data scientist who "only does ML" still must know SQL - three concrete examples from a typical workflow. */
/* Q15. List five industries where SQL knowledge translates directly into salary uplift - with one role per industry. */
/* Q16. Explain the difference between "data" and "information" using a RetailMart example. */
/* Q17. A business stakeholder asks: "give me yesterday's revenue." Walk through what an analyst's SQL workflow looks like end-to-end. */
/* Q18. Why is it harder to scale a TEAM of analysts on Excel than on SQL? */
/* Q19. Compare SQL declarative style vs Python imperative style with a "find top 10 customers" example. */
/* Q20. A teammate proposes storing everything in TEXT columns because "we can parse later." Counter-argue with three problems. */
/* Q21. Trace the path of a customer's purchase from app click -> database -> analyst dashboard. Where does SQL appear? */
/* Q22. Explain what a "data swamp" is and how disciplined SQL design prevents it. */
/* Q23. Why do most SaaS startups eventually consolidate to PostgreSQL even if they started on MongoDB? */
/* Q24. Define "OLTP" and "OLAP" - and where in RetailMart V3 are queries of each type likely to run? */
/* Q25. The CTO asks: "if we hired ONE engineer who knows EITHER Python OR SQL deeply, which is more valuable for our analyst team?" Defend your answer. */

/* ============================================================
   SECTION B: DBMS TRADEOFFS & DATABASE TYPES - DEEPER (25)
   ------------------------------------------------------------ */
/* Q26. Compare PostgreSQL vs MySQL for a fintech startup with strict accounting needs. Pick one and defend it. */
/* Q27. When would you choose SQLite over PostgreSQL? Two concrete cases. */
/* Q28. Why is Snowflake (columnar warehouse) chosen for analytics even though PostgreSQL also works? */
/* Q29. Compare an OLTP DB (handles online orders) vs an OLAP warehouse (handles BI reports). Give two architectural differences. */
/* Q30. A startup uses BigQuery for analytics + PostgreSQL for production. Explain why both exist. */
/* Q31. Why do banks insist on ACID - what specifically goes wrong if even one of the 4 properties is violated? */
/* Q32. Compare "primary database with read replicas" vs "shared-nothing distributed DB" - when does each win? */
/* Q33. Argue why Redis is NOT a replacement for PostgreSQL even though Redis is faster. */
/* Q34. Explain "eventual consistency" and why most analyst tools can't tolerate it well. */
/* Q35. RetailMart V3 has 16 schemas. What if all 55 tables were dumped in one 'public' schema - list 4 things that would get worse. */
/* Q36. Why is PostgreSQL preferred over MS SQL Server for an open-source-friendly startup? Three reasons. */
/* Q37. Compare row-oriented vs columnar storage with a "monthly revenue per category" query example. */
/* Q38. Why does PostgreSQL allow MULTIPLE NULLs in a UNIQUE column but only ONE PRIMARY KEY? */
/* Q39. Why do some DBs (Oracle, SQL Server) cost millions while PostgreSQL is free - what do you actually pay for? */
/* Q40. Compare DBaaS (AWS RDS) vs self-hosted PostgreSQL on EC2 - three tradeoffs. */
/* Q41. Why is "horizontal scaling" hard for relational databases compared to NoSQL ones? */
/* Q42. Explain in plain English what a "database transaction" is using a Paytm UPI transfer as the example. */
/* Q43. Argue: "All NoSQL adopters end up needing SQL eventually." Defend with two concrete startup case-types. */
/* Q44. Why do most analytics SQL queries run on a REPLICA of the OLTP DB instead of the OLTP DB itself? */
/* Q45. What is a "database view" - and why is it a useful primitive even though you could just paste the SELECT? */
/* Q46. Explain what "MVCC" means in PostgreSQL - a one-paragraph plain-English answer. */
/* Q47. Compare "logical replication" vs "physical replication" - when would you pick each? */
/* Q48. Why does almost every modern web app use a connection POOL (pgbouncer, RDS Proxy) instead of opening direct DB connections? */
/* Q49. A startup chooses NoSQL because "schemas slow them down." Six months later they regret it - what's the typical pain point? */
/* Q50. Why do some teams adopt "schema migrations" as a discipline even on small DBs? */

/* ============================================================
   SECTION C: SQL DIALECT & COMPONENT TRADEOFFS (25)
   ------------------------------------------------------------ */
/* Q51. Classify and EXPLAIN: which is more dangerous in production - DROP TABLE or TRUNCATE TABLE - and why? */
/* Q52. A junior runs DELETE FROM orders without WHERE. Walk through what could/should have stopped them. */
/* Q53. Defend the design choice that ALTER TABLE locks the table in older PostgreSQL versions - what tradeoff was being made? */
/* Q54. Why is GRANT/REVOKE at the SCHEMA level often more useful than at the TABLE level? */
/* Q55. Compare COMMIT and ROLLBACK with an INSERT example - what does each do at the byte level? */
/* Q56. Why do some teams BAN truncate in production scripts entirely? */
/* Q57. Compare SQL standard ANSI types vs PostgreSQL extensions (TEXT, JSONB, UUID, ARRAY). Which is portable, which is power? */
/* Q58. Explain why TRUNCATE doesn't fire row-level triggers but DELETE does. */
/* Q59. A team's INSERT is suddenly slow. List 5 things that could be the cause. */
/* Q60. Compare auto-commit mode vs explicit BEGIN/COMMIT - when does each surprise junior developers? */
/* Q61. Why is INSERT ... ON CONFLICT (upsert) more useful than try-catch-update flow in app code? */
/* Q62. Walk through what happens if you forget the WHERE on an UPDATE in a 5-million-row table. */
/* Q63. Compare "INSERT INTO ... SELECT" vs "COPY FROM file" for loading 1 million rows - when does each win? */
/* Q64. Why is "GRANT ALL TO PUBLIC" considered a security anti-pattern? */
/* Q65. Explain what SAVEPOINT does inside a transaction. Give a use case. */
/* Q66. Compare implicit (auto-commit) vs explicit transactions. Which is safer for analysts running ad-hoc queries? */
/* Q67. Why do schema-prefixed names (sales.orders) become essential as a company's database grows? */
/* Q68. A teammate insists on storing dates as VARCHAR. Convince them to use DATE/TIMESTAMP with 3 arguments. */
/* Q69. Defend why PostgreSQL allows quoted identifiers like "Customer" - and why most teams ban them anyway. */
/* Q70. Explain in plain English why a query that worked yesterday "suddenly" fails today - list 5 plausible causes. */
/* Q71. Compare CREATE TABLE AS SELECT vs CREATE TABLE then INSERT - when does each shine? */
/* Q72. Why is using a NUMERIC type more "correct" than FLOAT for money, even though FLOAT is faster? */
/* Q73. Explain "column ordering" in CREATE TABLE - does the order matter? Defend your answer. */
/* Q74. Compare CHECK constraints vs application-side validation. Where should the rule live? */
/* Q75. Why do most production DBs add CREATED_AT / UPDATED_AT columns to almost every table? */

/* ============================================================
   SECTION D: RETAILMART V3 LEVEL-2 (25)
   ------------------------------------------------------------ */
/* Q76. Defend the choice to split sales.orders (fact) from sales.order_items (fact detail) into two tables. */
/* Q77. Why is products.products kept separate from core.dim_brand AND core.dim_category? Defend this 3-table model. */
/* Q78. The RetailMart designer says "stores.employees + payroll.pay_slips is a deliberate split." What real problem does the split solve? */
/* Q79. Why is web_events.page_views in its OWN schema (not customers or sales)? Defend the design. */
/* Q80. RetailMart has both sales.payments AND finance.payments - why two tables for "payments"? */
/* Q81. customers.customers has a 'tier' column AND there's also loyalty.tiers + loyalty.members. Why both? */
/* Q82. Why does customers.addresses have an is_default boolean - what design problem does it solve? */
/* Q83. The hr.attendance table has check_in AND check_out as separate columns (not duration). Defend why. */
/* Q84. Why is core.dim_date pre-populated as a calendar dimension instead of just using EXTRACT()? */
/* Q85. The audit.application_logs table has a 'level' column - argue why this is better than a separate 'severity_id' FK. */
/* Q86. Compare denormalized sales.orders.gross_total vs computing it on the fly from order_items. Why does RetailMart keep both? */
/* Q87. Why does call_center.transcripts store transcript_text as TEXT - what tradeoff vs JSONB? */
/* Q88. Why is supply_chain.shipments a separate schema from sales.shipments? They have similar names - explain the design intent. */
/* Q89. Defend the use of TIMESTAMP without timezone in some V3 tables vs TIMESTAMPTZ in others. */
/* Q90. Why are dim_* tables (dim_brand, dim_region, dim_date) in 'core' but customers/products/sales aren't? */
/* Q91. The PK of supply_chain.inventory_snapshots is (warehouse_id, product_id, snapshot_date) - explain this composite key design. */
/* Q92. Why does products.products NOT have a "category" column directly - what's the design tradeoff? */
/* Q93. Compare the size of customers.customers (~50K rows) vs sales.orders (~150K rows) - why are they sized this way? */
/* Q94. Why does loyalty.members have customer_id AS its primary key, not a separate member_id? */
/* Q95. The CHRO asks: "should we add a dept_name VARCHAR to stores.employees?" Defend yes or no. */
/* Q96. RetailMart has 16 schemas. Explain why a single "permissions" table doesn't exist - instead, schemas ARE the permission boundary. */
/* Q97. Why does audit.api_requests have request_id as TEXT (not INT)? */
/* Q98. The data model has multiple "id" columns: cust_id (sales.orders) vs customer_id (customers.customers). Defend (or critique) this inconsistency. */
/* Q99. Why is core.dim_category just (category_id, category_name) - only 2 columns? */
/* Q100. By Day 30, what 5 RetailMart facts should an analyst know cold? Name them. */

/* ============================================================
   END OF Introduction to SQL & Databases - MEDIUM LEVEL (100 QUESTIONS)
============================================================ */
