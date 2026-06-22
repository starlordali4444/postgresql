/* ============================================================
   SQL PRACTICE SET - Database Concepts for Analysts (CRAZY HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Database Concepts - Normalization, Keys, ACID, Transactions
   Format:       100 conceptual word-problem questions (staff-engineer grade)

   Note: Day 14 is a concepts day - no queries are run against the
   database. These are open-ended, system-design-style prompts. Answer
   with reasoning and tradeoffs, sketching schemas/DDL where useful.
   There is rarely a single "right" answer - defend your choices.
   ============================================================ */

/* ============================================================
   SECTION A: NORMALIZATION & MODELING AT SCALE (25)
   ------------------------------------------------------------ */
/* Q1.  Designing RetailMart's analytics layer: argue for a Kimball star schema versus a fully normalized 3NF warehouse, with tradeoffs. */
/* Q2.  Explain how a wide denormalized fact plus columnar storage can beat a normalized model for analytics - and when it doesn't. */
/* Q3.  Design a Type-2 slowly-changing dimension for customer tier history: sketch keys, effective dates, and a current flag. */
/* Q4.  When do Type 1, Type 2, and Type 3 SCDs each make sense for a customer dimension? Give a rule of thumb. */
/* Q5.  A team proposes an EAV (entity-attribute-value) table to allow "any attribute." Critique it for analytics and offer an alternative. */
/* Q6.  How do normalization decisions change when storage is cheap but JOINs over billions of rows are expensive? */
/* Q7.  You must serve OLTP correctness and OLAP speed on the same data. Describe a normalized-base -> denormalized-marts architecture and its sync risk. */
/* Q8.  Give concrete criteria for choosing a JSONB column over typed normalized columns. */
/* Q9.  Explain "one fact per grain" and why mixing grains in a single fact table is a modeling error. */
/* Q10. Design a bridge table for orders-to-promotions where multiple promos can stack; how do you avoid double-counting revenue? */
/* Q11. How would you model returns so that net revenue is always reconstructable without double-subtracting? */
/* Q12. Explain the point-in-time-correctness risk of denormalizing customer tier onto every order row when tier changes over time. */
/* Q13. Why is classifying measures as additive / semi-additive / non-additive a modeling concern adjacent to normalization? */
/* Q14. Design a conformed-dimension strategy so sales and supply_chain share one product dimension. */
/* Q15. A denormalized reporting table drifts from source after a backfill. Design reconciliation plus alerting. */
/* Q16. Explain when surrogate keys are mandatory in a warehouse even though source systems already have natural keys. */
/* Q17. Defend or reject the maxim "normalize until it hurts, then denormalize until it works." */
/* Q18. How do late-arriving facts (an order_item inserted days later) break naive denormalized aggregates, and how do you guard against it? */
/* Q19. Explain idempotency in an ETL upsert and why it matters for consistency at the pipeline level. */
/* Q20. Design a schema that supports both "current price" and "price as of order date" without contradiction. */
/* Q21. Why can blindly adding indexes to "fix" a denormalized table create write-amplification problems? */
/* Q22. Distinguish normalization (logical) from partitioning/sharding (physical scaling) and explain why they're orthogonal. */
/* Q23. A product belongs to multiple categories. Show the M:N design and explain the revenue-by-category allocation problem it creates. */
/* Q24. How would you model multi-currency orders correctly, avoiding storing only a converted total? */
/* Q25. List a staff-level five-point checklist you always apply when reviewing a teammate's schema change. */

/* ============================================================
   SECTION B: CONCURRENCY, MVCC & DURABILITY (DEEP) (25)
   ------------------------------------------------------------ */
/* Q26. Explain PostgreSQL MVCC: how row versions (xmin/xmax) let readers and writers avoid blocking each other. */
/* Q27. Why does MVCC create dead tuples, and what is VACUUM's job? Tie it to long analyst transactions. */
/* Q28. A long-running reporting transaction holds back the xmin horizon. Explain the bloat and vacuum consequences. */
/* Q29. Explain snapshot isolation and how it differs from true serializability. */
/* Q30. What is Serializable Snapshot Isolation (SSI) in Postgres, and what kind of conflict does it detect? */
/* Q31. Give a write-skew example (e.g., two on-call doctors) and explain why only SERIALIZABLE prevents it. */
/* Q32. Explain how READ COMMITTED can produce a non-repeatable read between two SELECTs in one transaction. */
/* Q33. Walk through how SELECT ... FOR UPDATE plus a re-check eliminates a lost update. */
/* Q34. Distinguish row-level from table-level locks and when each is acquired. */
/* Q35. Describe a deadlock cycle across three transactions and how the detector breaks it. */
/* Q36. Why is application-level retry the correct response to a serialization_failure (SQLSTATE 40001)? */
/* Q37. Explain how the write-ahead log guarantees durability and enables crash recovery (redo). */
/* Q38. What are checkpoints, and what is the tradeoff between checkpoint frequency and recovery time? */
/* Q39. Explain synchronous versus asynchronous replication and the durability/latency tradeoff. */
/* Q40. With async replicas, what consistency anomaly can an analyst hit reading a replica right after a write? */
/* Q41. Explain "read your own writes" consistency and why it can break on a lagging replica. */
/* Q42. Why does a UNIQUE index (not merely a check) enforce uniqueness correctly under concurrency? */
/* Q43. How do advisory locks differ from row locks, and give one legitimate use case. */
/* Q44. State the double-booking problem and three distinct ways to prevent it (unique constraint, locking, serializable). */
/* Q45. Explain why COUNT(*) can differ between two reads under READ COMMITTED but not under REPEATABLE READ. */
/* Q46. How can an analyst's accidental "BEGIN" with no COMMIT (idle-in-transaction) harm a production database? */
/* Q47. Explain why chunked writes improve throughput but sacrifice all-or-nothing semantics across chunks. */
/* Q48. Describe how you'd make a multi-step ETL atomic across staging and final tables. */
/* Q49. Why is "exactly once" hard in distributed pipelines, and how does idempotent upsert approximate it? */
/* Q50. Summarize how isolation, durability, and replication interact when you promise "the dashboard is never wrong." */

/* ============================================================
   SECTION C: CONSISTENCY, DISTRIBUTED & TRADEOFFS (25)
   ------------------------------------------------------------ */
/* Q51. State the CAP theorem and what it forces you to sacrifice during a network partition. */
/* Q52. Contrast strong versus eventual consistency with a concrete e-commerce example. */
/* Q53. Why do many analytics systems accept eventual consistency while checkout cannot? */
/* Q54. Contrast BASE with ACID and say where each is the right fit. */
/* Q55. A microservice split puts orders and inventory in separate databases. How is cross-service atomicity lost, and what pattern recovers it? */
/* Q56. Explain the saga pattern and compensating transactions using an order/payment/inventory flow. */
/* Q57. Why can't a distributed system trivially provide single-node ACID across services? */
/* Q58. Explain two-phase commit and why it is often avoided in practice. */
/* Q59. What is the transactional outbox pattern, and which consistency problem does it solve? */
/* Q60. An event pipeline double-processes a message. Which property saves the aggregates, and how? */
/* Q61. Explain why "the dashboard number depends on which replica you hit," and how to make it deterministic. */
/* Q62. Discuss the tradeoff of pre-aggregating via materialized views versus always computing from raw for correctness. */
/* Q63. When is "good enough, 5-minutes-stale" the right consistency target for an executive dashboard? */
/* Q64. How do late or out-of-order events break windowed aggregates, and what mitigations exist (watermarks/grace)? */
/* Q65. Why does duplicating data across services trade integrity for availability and latency? */
/* Q66. Explain the limit of referential integrity: a FK works inside one database but not across two services. Implication? */
/* Q67. How would you guarantee a financial report ties out exactly given an eventually-consistent source? */
/* Q68. Explain idempotency keys for a "retry payment" button and the anomaly they prevent. */
/* Q69. Why does read-after-write matter when an analyst inserts a fix then immediately re-queries a replica? */
/* Q70. A normalized OLTP source feeds a denormalized warehouse via CDC. What consistency guarantee does CDC actually give? */
/* Q71. Why is wall-clock time unreliable for ordering events across distributed nodes, and what is used instead? */
/* Q72. Explain the reconciliation pattern: periodic full re-compute to correct drift in incremental aggregates. */
/* Q73. When does a single source of truth become impossible, and how do you choose the authoritative source? */
/* Q74. Why should analysts know whether they're querying the OLTP primary, a replica, or the warehouse? */
/* Q75. Summarize the spectrum from ACID-strong to eventually-consistent and where RetailMart's analytics layer should sit. */

/* ============================================================
   SECTION D: RETAILMART END-TO-END AUDIT & DESIGN CRITIQUE (25)
   ------------------------------------------------------------ */
/* Q76. Run a normalization audit of customers + addresses + orders + order_items: rate each table's normal form and justify. */
/* Q77. Define RetailMart's canonical revenue (which table, which status filters, how returns are handled) and explain why it's authoritative. */
/* Q78. Propose a Type-2 history design so RetailMart can answer "what tier was this customer ON the order date?" */
/* Q79. Design a guardrail to keep orders.net_total consistent with order_items (constraint vs trigger vs scheduled check) and pick one per OLTP/analytics context. */
/* Q80. Map RetailMart into a full sales star schema: state the fact grain, the measures, and every dimension. */
/* Q81. Critique keeping customers.tier as text versus a tier dimension, weighing reporting, integrity, and SCD needs. */
/* Q82. Design how RetailMart can expose a denormalized one-row-per-order-line mart without corrupting the normalized base. */
/* Q83. The analytics layer builds 76 views + 13 materialized views. Explain the refresh/consistency risks and how you'd schedule and monitor them. */
/* Q84. A monthly-sales materialized view drifts after a backfill of late orders. Design detection plus correction. */
/* Q85. Audit RetailMart's denormalized fields (net_total, any cached labels) and classify each as safe or risky, with reasoning. */
/* Q86. Model multi-warehouse inventory so "stock as of a date" is reconstructable; tie it to inventory_snapshots' composite key. */
/* Q87. The Compliance Officer needs an immutable audit log of refunds. Design it (append-only, keys) and state the durability requirement. */
/* Q88. Explain how you'd guarantee a dashboard's "total customers" matches the OLTP source despite replication lag. */
/* Q89. Two reports disagree on revenue by Rs 2 Cr. Walk through a systematic root-cause using normalization and consistency concepts. */
/* Q90. Design a reconciliation job that flags rows where SUM(order_items) != orders.net_total, and define what to alert on. */
/* Q91. Critique using customer email as a cross-system join key instead of a stable surrogate customer_id. */
/* Q92. order_date is a DATE (no time). Explain the consistency implication for "orders per hour" and name the correct alternative source. */
/* Q93. Propose a conformed product dimension so sales, supply_chain, and manufacture all agree on what a product is. */
/* Q94. Design point-in-time-correct revenue-by-region assuming a store could change region over time. */
/* Q95. Marketing wants attribution joining web_events to orders. Discuss the key and consistency challenges (session_id, customer_id, timing). */
/* Q96. Explain why "delete a customer" is dangerous in RetailMart, and design a compliant anonymization that preserves referential integrity. */
/* Q97. Build the case for a separate read replica or warehouse for analysts, citing the MVCC/bloat and isolation issues from earlier sections. */
/* Q98. A stakeholder wants real-time AND always-correct AND cheap dashboards. Use CAP/consistency tradeoffs to explain why they must choose. */
/* Q99. Propose a five-point weekly data-integrity test suite for RetailMart (FK orphans, total drift, duplicate keys, NULL keys, status sanity). */
/* Q100. Write a one-paragraph design philosophy for RetailMart that balances integrity, performance, and analyst usability at a staff-engineer level. */

/* ============================================================
   END - Database Concepts (CRAZY HARD) - 100 questions
   ============================================================ */
