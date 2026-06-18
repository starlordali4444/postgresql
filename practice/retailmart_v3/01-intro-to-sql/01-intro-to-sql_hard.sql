/* ============================================================
   SQL PRACTICE SET - Introduction to SQL & Databases (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        RDBMS & PostgreSQL Internals - deeper architecture
   Database:     N/A (conceptual)

   Scope (HARD = interview/architecture level):
     - MVCC, WAL, vacuum, transaction visibility
     - ACID isolation anomalies (dirty/non-repeatable/phantom)
     - Locking model (row/page/table, advisory, deadlocks)
     - Storage layout (heap, TOAST, fillfactor, bloat)
     - Catalog vs information_schema
     - Replication & HA tradeoffs (sync/async, logical/physical)
     - Real-world scaling decisions (partitioning, sharding)

   Structure: 25 Internals + 25 Isolation/Locking + 25 Storage/Catalogs + 25 Production/HA
   Note: No SQL queries required - this is design/interview prep.
   ============================================================ */

/* ============================================================
   SECTION A: POSTGRESQL INTERNALS DEEP-DIVE (25)
   ------------------------------------------------------------ */
/* Q1.  Explain MVCC in PostgreSQL. Why doesn't UPDATE overwrite a row in place? */
/* Q2.  What are xmin and xmax on every row - and why do they matter for visibility? */
/* Q3.  Walk through what VACUUM does and why dead tuples accumulate without it. */
/* Q4.  Difference between VACUUM, VACUUM FULL, and VACUUM ANALYZE - when to use each? */
/* Q5.  What is the Write-Ahead Log (WAL) and why is it the foundation of durability? */
/* Q6.  Explain a CHECKPOINT - what's flushed and when does it trigger? */
/* Q7.  What is the shared_buffers cache vs OS page cache - why does PostgreSQL keep both? */
/* Q8.  Describe how a backend process handles a single query end-to-end (parse -> plan -> execute). */
/* Q9.  What does the planner_cost_constant family of GUCs control (seq_page_cost, random_page_cost)? */
/* Q10. Explain the difference between a logical replication slot and a physical replication slot. */
/* Q11. What is "transaction wraparound" and why is it catastrophic if VACUUM falls behind? */
/* Q12. How does HOT (Heap-Only Tuples) update optimization save work? */
/* Q13. What does the visibility map track - and how does it help index-only scans? */
/* Q14. Explain the role of the autovacuum daemon and when DBAs disable it on hot tables. */
/* Q15. What is the planner's "genetic query optimization" and when does it kick in? */
/* Q16. Why does ANALYZE matter for query plans - what statistics does it gather? */
/* Q17. Explain how pg_stat_statements helps find slow queries in production. */
/* Q18. What's the difference between a relfilenode and a relation OID - and when do they diverge? */
/* Q19. Describe the role of the wal_level GUC - what does each setting enable? */
/* Q20. What is logical decoding - how is it different from streaming replication? */
/* Q21. Explain how synchronous_commit interacts with WAL durability guarantees. */
/* Q22. What is the role of the postmaster process vs backend processes? */
/* Q23. How does PostgreSQL detect and resolve deadlocks (compared to MySQL)? */
/* Q24. What is a "bloated" table or index - how do you detect and fix it? */
/* Q25. Walk through how a SELECT sees a row inserted by an uncommitted concurrent transaction. */

/* ============================================================
   SECTION B: ISOLATION, LOCKING & CONCURRENCY (25)
   ------------------------------------------------------------ */
/* Q26. Define dirty read, non-repeatable read, phantom read - with a 2-transaction example each. */
/* Q27. Why is READ UNCOMMITTED treated as READ COMMITTED in PostgreSQL? */
/* Q28. Demonstrate a non-repeatable read at READ COMMITTED - and show why REPEATABLE READ fixes it. */
/* Q29. Explain why PostgreSQL's REPEATABLE READ is actually "snapshot isolation" - and how it differs from SQL standard. */
/* Q30. What is a serialization failure under SERIALIZABLE - give a real example. */
/* Q31. Explain Serializable Snapshot Isolation (SSI) and why it's more expensive than REPEATABLE READ. */
/* Q32. Walk through a write skew anomaly - show what isolation level prevents it. */
/* Q33. What is a "lost update" - and how do SELECT FOR UPDATE and SERIALIZABLE each prevent it? */
/* Q34. Difference between SELECT FOR UPDATE, FOR NO KEY UPDATE, FOR SHARE, and FOR KEY SHARE. */
/* Q35. Explain row-level locks vs predicate locks - why does SSI need predicate locks? */
/* Q36. What is a deadlock - show a 2-transaction example that deadlocks on row locks. */
/* Q37. How does deadlock_timeout work - and why is the default 1 second? */
/* Q38. Explain advisory locks (pg_advisory_lock) - when do you use them over row locks? */
/* Q39. What is an "intent lock" and why does PostgreSQL not expose them at the SQL level? */
/* Q40. Difference between session-level and transaction-level advisory locks. */
/* Q41. What does LOCK TABLE ... IN ACCESS EXCLUSIVE MODE block - give 3 examples. */
/* Q42. What is "lock escalation" - and why doesn't PostgreSQL do it (unlike SQL Server)? */
/* Q43. Explain "tuple-level lock contention" on a hot row - and how to design around it. */
/* Q44. What is a "queue table anti-pattern" - and why do row locks make it perform badly? */
/* Q45. How does SKIP LOCKED help build a queue table without contention? */
/* Q46. Explain why DDL takes ACCESS EXCLUSIVE - and how to do online schema changes safely. */
/* Q47. What is the role of pg_locks and pg_stat_activity in debugging contention? */
/* Q48. Walk through how SAVEPOINT interacts with subtransaction visibility. */
/* Q49. What is "transaction ID exhaustion" risk in long-running transactions? */
/* Q50. Why is two-phase commit (PREPARE TRANSACTION) rarely used outside distributed setups? */

/* ============================================================
   SECTION C: STORAGE, CATALOGS, METADATA (25)
   ------------------------------------------------------------ */
/* Q51. Walk through the PostgreSQL page layout (header + line pointers + tuples + special). */
/* Q52. What does FILLFACTOR do - and when do you tune it down to 70% or 80%? */
/* Q53. Explain TOAST - when does a value get TOASTed and what are the four storage modes? */
/* Q54. Difference between EXTERNAL and EXTENDED storage modes on a TEXT column. */
/* Q55. What is a "tuple header" and why does every row have at least 23 bytes of overhead? */
/* Q56. Explain how COLUMN order affects on-disk size (the alignment padding trick). */
/* Q57. What is the difference between pg_catalog and information_schema - and which is portable? */
/* Q58. Why is pg_class.reltuples just an estimate - and what updates it? */
/* Q59. Walk through pg_attribute - how is it different from information_schema.columns? */
/* Q60. What is a "system column" (ctid, xmin, xmax, tableoid) - and when do you query them? */
/* Q61. Explain how partitioning is stored - is a partitioned table itself a heap? */
/* Q62. Difference between LIST, RANGE, and HASH partitioning - give a RetailMart example for each. */
/* Q63. What is a "partition pruning" and how does the planner decide? */
/* Q64. Why are global indexes not supported on partitioned tables - what's the workaround? */
/* Q65. Explain TABLESPACE - when do you create one (and why most setups don't need them). */
/* Q66. What is a foreign table (FDW) - give a real RetailMart use case for postgres_fdw. */
/* Q67. Walk through how a unique constraint differs internally from a unique index. */
/* Q68. What is an exclusion constraint - give an example (booking system overlap prevention). */
/* Q69. Explain partial indexes - give 2 RetailMart cases where they save 80% of index size. */
/* Q70. What is an expression index - when would you index lower(email) or date_trunc('day', ts)? */
/* Q71. Difference between B-tree, Hash, GiST, GIN, BRIN, SP-GiST - pick the right one for 5 scenarios. */
/* Q72. Why is BRIN ideal for time-series tables - and what's its tradeoff? */
/* Q73. What does CLUSTER do - and why is it not maintained automatically? */
/* Q74. Walk through how DROP TABLE and TRUNCATE differ in WAL volume and lock duration. */
/* Q75. Explain what gets written to disk during CREATE INDEX CONCURRENTLY - and why it's slower. */

/* ============================================================
   SECTION D: PRODUCTION, HA, SCALING (25)
   ------------------------------------------------------------ */
/* Q76. Compare physical streaming replication vs logical replication - pick the right one for 3 scenarios. */
/* Q77. What is a "hot standby" - what queries can run on it and what cannot? */
/* Q78. Explain replica lag - what causes it and how do you monitor it? */
/* Q79. What is synchronous_standby_names - and what's the durability tradeoff vs async? */
/* Q80. Walk through how a failover happens - what tools (Patroni, repmgr) automate it? */
/* Q81. What is connection pooling - why is pgBouncer essential at high concurrency? */
/* Q82. Difference between session pooling, transaction pooling, statement pooling in pgBouncer. */
/* Q83. Why do prepared statements break under transaction-pooling mode - and what's the fix? */
/* Q84. What is a "thundering herd" on a connection pool - give a real RetailMart scenario. */
/* Q85. Explain horizontal vs vertical scaling - when does sharding actually win? */
/* Q86. Walk through the Citus extension's approach to distributed PostgreSQL. */
/* Q87. What is the role of read replicas - and the read-after-write consistency trap. */
/* Q88. Explain why ORDER BY id DESC LIMIT 1 on a huge table can be slow without the right index. */
/* Q89. What is the "N+1 query" problem - give a RetailMart order-display example. */
/* Q90. Walk through a backup strategy: pg_dump vs pg_basebackup vs WAL archiving - when each is right. */
/* Q91. What is PITR (point-in-time recovery) - and what does it depend on? */
/* Q92. Explain why upgrades use pg_upgrade vs pg_dump/restore - speed and downtime tradeoffs. */
/* Q93. What is a "rolling upgrade" using logical replication - when is this needed? */
/* Q94. Walk through a real production incident: long-running transaction caused 100GB of bloat. How to recover? */
/* Q95. What is the "noisy neighbor" problem on a managed Postgres (RDS/Cloud SQL) - how do you detect? */
/* Q96. Explain pg_repack and pg_squeeze - when is VACUUM FULL not enough? */
/* Q97. What is "index bloat" - how do you measure it and when do you REINDEX CONCURRENTLY? */
/* Q98. Walk through why autovacuum can fall behind on tables with very high churn - and what to tune. */
/* Q99. Explain "row-level security" (RLS) - give a real multi-tenant RetailMart case. */
/* Q100. Design question: RetailMart hits 1B orders/year. What architectural shifts do you make? */

/* ============================================================
   END OF Introduction to SQL & Databases - HARD LEVEL (100 QUESTIONS)
============================================================ */
