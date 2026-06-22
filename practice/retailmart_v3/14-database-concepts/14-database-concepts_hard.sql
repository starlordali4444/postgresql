/* ============================================================
   SQL PRACTICE SET - Database Concepts for Analysts (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Database Concepts - Normalization, Keys, ACID, Transactions
   Format:       100 conceptual word-problem questions (interview-grade)

   Note: Day 14 is a concepts day - no queries are run against the
   database. Answer in 3-6 sentences, or sketch the design / DDL where
   asked. Treat these as senior-analyst interview questions: justify
   tradeoffs, not just definitions.
   ============================================================ */

/* ============================================================
   SECTION A: NORMALIZATION EDGE CASES & BCNF (25)
   ------------------------------------------------------------ */
/* Q1.  Give a table that is in 3NF but not BCNF, and name the exact dependency that breaks BCNF. */
/* Q2.  Explain why decomposing to BCNF can force you to lose a functional dependency (the dependency-preservation tradeoff). */
/* Q3.  When is it defensible to stop at 3NF rather than push to BCNF? Justify with a tradeoff. */
/* Q4.  What is a multivalued dependency, and which normal form (4NF) addresses it? */
/* Q5.  Give an example where 4NF matters - a table mixing two independent multivalued facts. */
/* Q6.  Define "denormalization for read performance" and state the integrity cost you accept in return. */
/* Q7.  A star-schema fact table is deliberately not in 3NF. Explain why dimensional modeling tolerates that. */
/* Q8.  Contrast the design goals of OLTP (normalized) versus OLAP (dimensional/denormalized) systems. */
/* Q9.  Why can over-normalization specifically hurt analytical query performance? */
/* Q10. A surrogate key is added to a table that already had a solid natural key. Name a real downside. */
/* Q11. Explain how a slowly changing dimension complicates the idea of a single normalized "truth." */
/* Q12. Storing a computed column (line_total = qty * price) technically breaks 3NF. When is it worth doing anyway? */
/* Q13. Describe a case where two columns are mutually dependent (A -> B and B -> A) and what that implies for candidate keys. */
/* Q14. Explain why NULLs complicate reasoning about functional dependencies. */
/* Q15. A table looks 3NF "by inspection," but a real business rule creates a dependency the schema fails to capture. How can that happen? */
/* Q16. Tie the expectation "an analyst should read an ER diagram" back to functional dependencies and keys. */
/* Q17. Distinguish logical normalization from physical storage layout, and why both matter. */
/* Q18. When does flattening a dimension's attributes INTO a fact table make sense? */
/* Q19. A team keeps a normalized core plus a denormalized reporting layer. Name two risks of keeping them in sync. */
/* Q20. Why is "the same data in two places" acceptable in a materialized view but not in an OLTP base table? */
/* Q21. Give a case where a junction table needs its OWN attributes (e.g., enrollment date), and why that's correct. */
/* Q22. Explain how one badly chosen composite key can create both a 2NF and a BCNF problem at once. */
/* Q23. Explain the classic tradeoff: normalization saves storage but can raise JOIN/CPU cost. */
/* Q24. A stakeholder demands one flat "order + customer + product" table. Defend delivering it as a VIEW, not a base table. */
/* Q25. Summarize, in three bullets, a decision framework for "normalize vs denormalize" on an analytics team. */

/* ============================================================
   SECTION B: ISOLATION, CONCURRENCY & ANOMALIES (25)
   ------------------------------------------------------------ */
/* Q26. Map each read anomaly (dirty, non-repeatable, phantom) to the lowest isolation level that prevents it. */
/* Q27. Explain READ COMMITTED and exactly which anomaly it still permits. */
/* Q28. Explain REPEATABLE READ and which anomaly the SQL standard says it can still permit. */
/* Q29. Explain SERIALIZABLE and the guarantee it provides. */
/* Q30. PostgreSQL defaults to READ COMMITTED. What does that mean for two analysts running long reports concurrently? */
/* Q31. What is a "write skew" anomaly, and which isolation level prevents it? */
/* Q32. Explain MVCC at a high level and why, in Postgres, readers don't block writers. */
/* Q33. Why can a long analytical SELECT in Postgres see a consistent snapshot even while writes are happening? */
/* Q34. Define a "lost update," and describe how isolation or explicit locking prevents it. */
/* Q35. Two transactions each read a balance then write balance - 100. Walk through the lost-update scenario and a fix. */
/* Q36. What is SELECT ... FOR UPDATE used for, and when would an analyst-adjacent job need it? */
/* Q37. Give a concrete two-transaction deadlock example and explain how the database resolves it. */
/* Q38. Why does stronger isolation generally reduce concurrency and throughput? */
/* Q39. Distinguish a shared lock from an exclusive lock. */
/* Q40. Why might an analyst's huge, long-running report transaction interfere with maintenance or cause table bloat in Postgres? */
/* Q41. Explain why PostgreSQL's REPEATABLE READ (snapshot isolation) prevents phantom reads in practice. */
/* Q42. What is the practical risk of running every transaction at SERIALIZABLE in a high-throughput OLTP system? */
/* Q43. How does a UNIQUE constraint behave when two concurrent transactions insert the same value? */
/* Q44. Why is "retry on serialization failure" a normal application pattern under SERIALIZABLE? */
/* Q45. Give a scenario where allowing dirty reads would feed a finance dashboard a wrong number. */
/* Q46. Why are read-only replicas a common way to shield analysts from OLTP contention? */
/* Q47. Explain, without deep internals, how durability is implemented via a write-ahead log. */
/* Q48. What does flushing/fsync to disk have to do with the D in ACID? */
/* Q49. Why can a COMMIT be acknowledged to the client only after the log is durably written? */
/* Q50. Summarize the tradeoff triangle: isolation strength vs concurrency vs developer complexity. */

/* ============================================================
   SECTION C: SCHEMA DESIGN PROBLEMS (25)
   ------------------------------------------------------------ */
/* Q51. Sketch normalized DDL for "customers place orders containing many products." Name keys and foreign keys. */
/* Q52. Design "products belong to many promotions, with a promotion-specific discount." Where does the discount column live? */
/* Q53. Design "employees report to managers" (self-referencing). Show the foreign key. */
/* Q54. Design "a store stocks many products, each with a per-store quantity." What is the primary key of the stock table? */
/* Q55. Model "a customer has exactly one loyalty membership." Is it 1:1 or 1:M? Justify and sketch. */
/* Q56. Model "an order uses at most one coupon; a coupon is used by many orders." Which side holds the FK? */
/* Q57. Design a date dimension and explain three analytics-useful columns it should carry. */
/* Q58. You must keep product price history (never overwrite). Sketch a normalized design. */
/* Q59. Tickets can change status many times. Sketch the status-history table and its keys. */
/* Q60. Requirement: tag products with arbitrary tags. Design the normalized many-to-many tag schema. */
/* Q61. "An address can belong to a customer OR a store." Discuss polymorphic-FK options and a cleaner normalized alternative. */
/* Q62. Design a schema that makes it impossible to store both age and date_of_birth redundantly. */
/* Q63. Per-line tax depends on product category. Where should the category -> tax_rate mapping live to stay 3NF? */
/* Q64. Design "a campaign runs on many platforms; each platform run has its own spend." Sketch the tables. */
/* Q65. A junior proposes phone1, phone2, phone3 columns on customers. Redesign it normalized and say which NF it fixes. */
/* Q66. Model "a return is for one order and may cover several of that order's items." Sketch the keys. */
/* Q67. Design a supplier-product catalog where one product is sourced from multiple suppliers at different costs. */
/* Q68. Surrogate vs natural key for a table of Indian PIN codes - choose and justify. */
/* Q69. Sketch how FK design enforces "an order's items all belong to that same order." */
/* Q70. Reporting need: one row per (customer, month) with totals. Base table or derived/materialized object? Defend the choice. */
/* Q71. Design "products in categories, categories in parent categories" (a hierarchy). Show the self-reference. */
/* Q72. Support soft-deletes without breaking foreign keys. Sketch an approach and name one downside. */
/* Q73. "A warehouse records inventory snapshots per product per day." What is the natural composite key? */
/* Q74. "A customer has many payment methods, exactly one default." How do you enforce the single default cleanly? */
/* Q75. Critique a design that dumps everything into one "attributes" JSON column instead of typed columns, for analytics. */

/* ============================================================
   SECTION D: RETAILMART DEEP DIVE & INTEGRITY (25)
   ------------------------------------------------------------ */
/* Q76. Trace the full foreign-key chain from one sales.order_items row up to the customer and down to the product. */
/* Q77. orders.net_total could drift from SUM(order_items). Propose a periodic reconciliation an analyst could run. */
/* Q78. Argue whether customers.tier should be a FK to a tiers dimension, given its heavy use in RFM/segmentation. */
/* Q79. The Head of Logistics wants courier on every shipment row. Explain how RetailMart models courier and whether to denormalize. */
/* Q80. Explain why sales.returns using refund_amount (not return_amount) and having no cust_id is a deliberate, defensible design. */
/* Q81. If region were stored as text on stores instead of region_id, give a concrete update anomaly that could occur. */
/* Q82. Map RetailMart to a star schema: pick one fact table and four dimensions it would join to. */
/* Q83. Why is core.dim_category being flat (no parent_category_id) a reasonable simplification, and when would a hierarchy be needed? */
/* Q84. The Compliance Officer wants an audit trail of price changes. Which RetailMart structure supports change detection, and how? */
/* Q85. Describe, conceptually, how you'd verify that every order_items.prod_id exists in products.products (an integrity audit). */
/* Q86. Identify a RetailMart table where a denormalized column is justified for performance, and name the safeguard you'd add. */
/* Q87. Marketing stores platform names as free text. Propose a normalized fix and state the reporting benefit. */
/* Q88. Why does separating finance.payment_modes from orders make adding a new method (e.g., "UPI Lite") safe? */
/* Q89. loyalty.members carries tier_id while customers.customers also has tier. Is that redundancy a real problem? Discuss. */
/* Q90. State the integrity rule that should prevent a review existing for a non-existent product in customers.reviews. */
/* Q91. A stakeholder wants one big denormalized sales view for Excel users. Outline its columns and the joins that build it. */
/* Q92. Explain how splitting orders from order_items prevents an insertion anomaly when an order has many products. */
/* Q93. Why is web_events.page_views using its own view_id and view_timestamp (not reusing order keys) correct design? */
/* Q94. Discuss the integrity tradeoff of supply_chain.inventory_snapshots using a composite key and no surrogate id. */
/* Q95. The CFO wants guaranteed-correct revenue. Explain why computing from order_items with status filters can beat a stored total. */
/* Q96. Identify two 1:M relationships in RetailMart and one effectively M:N relationship with its resolving table. */
/* Q97. Propose referential integrity for "an employee belongs to exactly one store and one department." */
/* Q98. Explain why dimension tables changing rarely (dim_region, dim_brand) is what makes denormalizing them into reports relatively safe. */
/* Q99. A new analyst flattens customers + addresses + orders into one base table "to make life easy." List three concrete risks. */
/* Q100. Across the whole schema, summarize in four bullets how RetailMart balances normalization (integrity) with analyst convenience. */

/* ============================================================
   END - Database Concepts (HARD) - 100 questions
   ============================================================ */
