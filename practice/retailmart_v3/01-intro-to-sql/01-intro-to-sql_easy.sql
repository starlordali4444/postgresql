/* ============================================================
   SQL PRACTICE SET - Introduction to SQL & Databases (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Introduction to SQL & Databases
   Format:       100 conceptual word-problem questions

   Note: Day 1 is concept-only - no installation yet, no queries.
   Answer each question in 1-3 sentences. Practice articulating
   your understanding the way you'd explain it in an interview.
   ============================================================ */

/* ============================================================
   SECTION A: DATA, SQL & ROLES (25)
   ------------------------------------------------------------ */
/* Q1.  Your friend asks "what's the difference between data and information?" - give a one-line answer with an example. */
/* Q2.  A non-technical hiring manager asks "what is SQL?" - describe it in 30 seconds. */
/* Q3.  Explain why Excel is not enough once a company crosses ~1 million rows. */
/* Q4.  Why is SQL called a "declarative" language? Contrast with imperative code. */
/* Q5.  A new joiner asks: "do data engineers and data analysts use the same SQL?" - answer. */
/* Q6.  Name three job roles where SQL is a daily-use skill, and what each uses it for. */
/* Q7.  In an interview, you're asked: "is SQL still relevant in the AI era?" - argue yes. */
/* Q8.  Your manager says "we use NoSQL, why should I care about SQL?" - give one counter-argument. */
/* Q9.  Explain in plain English what a "query" is. */
/* Q10. Why do almost all BI tools (Power BI, Tableau, Looker, Metabase) speak SQL under the hood? */
/* Q11. Your team lead asks why we structure data into ROWS and COLUMNS instead of free text. Explain. */
/* Q12. What does it mean when someone says "SQL is the lingua franca of data"? */
/* Q13. A friend is comparing Python pandas vs SQL - name one strength of each. */
/* Q14. In a hiring panel, you're asked: "rank these by importance for a data analyst - Excel, SQL, Python, BI tool." Defend your order. */
/* Q15. Why does the same SQL query usually run faster on a database than the equivalent loop in Python? */
/* Q16. Explain to a junior - what's the difference between "structured" and "unstructured" data, with one example of each? */
/* Q17. Your CTO says "every analyst should learn SQL." Give two reasons that justify this rule. */
/* Q18. A bootcamp peer says "I'll just use ChatGPT to write SQL" - push back with one strong argument. */
/* Q19. Name 4 industries where SQL is core to the daily workflow. */
/* Q20. Explain how SQL skills transfer across MySQL, PostgreSQL, BigQuery, Snowflake - what stays constant? */
/* Q21. A student asks: "is SQL hard?" - answer honestly, naming the easy and the hard parts. */
/* Q22. Why do data scientists who "only care about ML" still need to know SQL? */
/* Q23. Your friend wonders why companies don't just dump everything into one giant Excel file. List two real problems with that. */
/* Q24. Explain what "data engineering" is in one sentence - and where SQL fits in that role. */
/* Q25. Name 5 things that are EASY in SQL but PAINFUL in Excel. */

/* ============================================================
   SECTION B: DBMS vs RDBMS & DATABASE TYPES (25)
   ------------------------------------------------------------ */
/* Q26. Your interviewer asks: "what does DBMS stand for, and what does it actually DO?" Answer in 2 sentences. */
/* Q27. Explain the R in RDBMS - what does "relational" mean? */
/* Q28. Give 3 examples of well-known relational databases used by Indian companies. */
/* Q29. Give 3 examples of well-known NON-relational (NoSQL) databases. */
/* Q30. A teammate confuses "database" and "DBMS" - explain the difference. */
/* Q31. Why does an RDBMS enforce a schema before you can insert data? */
/* Q32. Name two scenarios where a NoSQL database is a BETTER choice than an RDBMS. */
/* Q33. What does "ACID" stand for, and why does it matter for banking systems? */
/* Q34. Your CTO asks "why are we paying for Oracle instead of using free PostgreSQL?" - give one valid reason a big company might choose Oracle. */
/* Q35. Explain "concurrency" - why an RDBMS must handle many users writing at once. */
/* Q36. What's the difference between a "primary database" (OLTP) and a "data warehouse" (OLAP)? */
/* Q37. A junior asks: "why don't we use MongoDB for accounting?" - give one solid reason. */
/* Q38. Name 3 cloud-managed RDBMS services (Indian / global). */
/* Q39. In an interview, you're asked: "what's the difference between SQL and MySQL?" Answer. */
/* Q40. Why is PostgreSQL favored for analytics + data science over MySQL? Name two reasons. */
/* Q41. Your team is choosing between SQLite and PostgreSQL for a new app. Pick one and justify in 2 sentences. */
/* Q42. Explain "client-server" architecture in databases. */
/* Q43. Why can multiple users connect to the same RDBMS at the same time without corrupting data? */
/* Q44. Your friend opens an Excel file and asks "is this a database?" - answer with the distinction. */
/* Q45. Name 3 ways an RDBMS protects against data loss. */
/* Q46. What is "replication" in databases and why do banks use it? */
/* Q47. Explain "horizontal scaling" vs "vertical scaling" in your own words. */
/* Q48. Why are columnar databases (Snowflake, BigQuery, Redshift) preferred for analytics? */
/* Q49. Explain in 1 sentence what a "key-value store" is. */
/* Q50. Why are graph databases (Neo4j) useful for social-network and fraud-detection problems? */

/* ============================================================
   SECTION C: SQL COMPONENTS - DDL/DML/DCL/TCL (25)
   ------------------------------------------------------------ */
/* Q51. Expand each acronym: DDL, DML, DCL, TCL - and one sentence on what each is FOR. */
/* Q52. Classify: CREATE TABLE - DDL, DML, DCL, or TCL? */
/* Q53. Classify: INSERT INTO - DDL, DML, DCL, or TCL? */
/* Q54. Classify: UPDATE - DDL, DML, DCL, or TCL? */
/* Q55. Classify: DELETE - DDL, DML, DCL, or TCL? */
/* Q56. Classify: ALTER TABLE - DDL, DML, DCL, or TCL? */
/* Q57. Classify: DROP TABLE - DDL, DML, DCL, or TCL? */
/* Q58. Classify: TRUNCATE TABLE - DDL, DML, DCL, or TCL? */
/* Q59. Classify: GRANT - DDL, DML, DCL, or TCL? */
/* Q60. Classify: REVOKE - DDL, DML, DCL, or TCL? */
/* Q61. Classify: COMMIT - DDL, DML, DCL, or TCL? */
/* Q62. Classify: ROLLBACK - DDL, DML, DCL, or TCL? */
/* Q63. Classify: SAVEPOINT - DDL, DML, DCL, or TCL? */
/* Q64. Classify: SELECT - DML, DCL, or something else? */
/* Q65. Your teammate runs DROP TABLE in production by mistake. Can it be rolled back? Why or why not? */
/* Q66. Why is TRUNCATE faster than DELETE on a huge table - but riskier? */
/* Q67. What's the difference between DROP TABLE and DELETE FROM TABLE? */
/* Q68. In a banking system, why does a money transfer use BEGIN, COMMIT, ROLLBACK? */
/* Q69. A junior asks: "do I need to commit after every SELECT?" - answer. */
/* Q70. Explain why GRANT and REVOKE exist - what real-world problem do they solve? */
/* Q71. Which SQL command would you use to give the analytics team read-only access to a table? */
/* Q72. Which SQL command would you use to add a new column to an existing table? */
/* Q73. Which SQL command would you use to permanently remove a customer record? */
/* Q74. Which SQL command would you use to permanently destroy a whole table including its structure? */
/* Q75. Explain the difference between DELETE and TRUNCATE in two sentences. */

/* ============================================================
   SECTION D: DATABASE / SCHEMA / TABLE & RETAILMART (25)
   ------------------------------------------------------------ */
/* Q76. Define a "database" in your own words. */
/* Q77. Define a "schema" in your own words - and how it differs from a database. */
/* Q78. Define a "table" - what is the smallest meaningful unit of data inside it? */
/* Q79. Define a "row" and a "column" with a one-line example each. */
/* Q80. Your manager says "RetailMart has 16 schemas." What does that mean in practical terms? */
/* Q81. Why does RetailMart split data into schemas like sales, customers, products, hr - instead of dumping everything into one schema? */
/* Q82. Give two reasons a company would put customer data and HR data in SEPARATE schemas. */
/* Q83. Name 5 RetailMart schemas you remember from class. */
/* Q84. Why are dimension tables (dim_brand, dim_region, dim_category) separated from fact tables (orders, order_items)? */
/* Q85. Explain the difference between a fact table and a dimension table in plain English. */
/* Q86. What is a "primary key" - explain by pointing at any RetailMart table. */
/* Q87. What is a "foreign key" - explain how sales.orders.cust_id is one. */
/* Q88. Explain what "schema-qualified name" means - and why we write customers.customers, not just customers. */
/* Q89. Your script breaks because you wrote SELECT * FROM orders. What's missing? */
/* Q90. A teammate says "PostgreSQL is case-sensitive". When does that matter for SQL queries? */
/* Q91. Why do databases use NULL instead of empty string for missing values? */
/* Q92. RetailMart has 55 tables. Name 5 things you can do with that many tables that you can't do in one Excel sheet. */
/* Q93. The CTO asks "how many distinct schemas does RetailMart V3 have?" - answer the number and name 5 of them. */
/* Q94. Explain in one sentence what an "index" is - pretend you're teaching a class 10 student. */
/* Q95. A junior asks "what's the difference between a database and a table?" - answer. */
/* Q96. Explain why a query like SELECT * FROM customers might be slow on a table with 50 million rows. */
/* Q97. Name 2 reasons to use PostgreSQL 18 over PostgreSQL 12 for this course. */
/* Q98. What does "RetailMart V3" mean - what's the difference from V1 or V2? */
/* Q99. Your teammate asks "is pgAdmin the database?" - explain what pgAdmin actually is. */
/* Q100. By end of class today, what THREE things must you be able to explain about RetailMart to pass a quick verbal check? */

/* ============================================================
   END OF Introduction to SQL & Databases - EASY LEVEL (100 CONCEPTUAL QUESTIONS)
   ------------------------------------------------------------
   Tips:
   - Write your answers in 1-3 sentences each
   - Practice saying them ALOUD - interviews are verbal
   - Use the RetailMart V3 schema names, not generic placeholders
   - Day 1 is foundation; weak answers here = weak answers all month
============================================================ */
