/* ============================================================
   SQL PRACTICE SET - Introduction to SQL & Databases (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        RDBMS - System design & architecture deep-dives
   Database:     N/A (system design)

   Scope (CRAZY = staff-level system design interviews):
     - Multi-region active-active design
     - Time-series at petabyte scale
     - Multi-tenant isolation strategies
     - Distributed transactions
     - Schema evolution at scale
     - Disaster recovery design
     - Cost-vs-correctness tradeoffs

   Structure: 25 Distributed/Sharding + 25 Time-series + 25 Multi-tenant + 25 Disaster/Scale
   ============================================================ */

/* ============================================================
   SECTION A: DISTRIBUTED, SHARDING, CONSENSUS (25)
   ------------------------------------------------------------ */
/* Q1.  Design RetailMart for 100M monthly active users - what becomes the bottleneck first? */
/* Q2.  Walk through a sharding strategy for sales.orders - pros/cons of customer_id vs order_id vs date as shard key. */
/* Q3.  Explain Citus's distribution table types: distributed, reference, local - when each. */
/* Q4.  Why is "cross-shard JOIN" a planning nightmare - and how do you avoid it? */
/* Q5.  How do you maintain referential integrity across shards (or do you)? */
/* Q6.  Compare 2-phase commit vs Saga pattern for distributed transactions. */
/* Q7.  What is "eventual consistency" - give a RetailMart scenario where it's OK. */
/* Q8.  Explain the CAP theorem in the context of a multi-region Postgres deployment. */
/* Q9.  When does linearizability matter for sales.orders - checkouts, deductions, audit? */
/* Q10. Walk through a "split-brain" scenario during failover - what prevents it? */
/* Q11. Explain RAFT consensus - and how Patroni uses it for leader election. */
/* Q12. Why is "quorum read/write" the foundation of distributed correctness? */
/* Q13. Compare strong vs eventual consistency for a customer's "lifetime spend" counter. */
/* Q14. Walk through how Aurora / Spanner / CockroachDB differ from vanilla Postgres replication. */
/* Q15. Why is logical replication the right tool for "blue-green" upgrade - but not for HA? */
/* Q16. Design a "hot replica routing" strategy: connection pool decides primary vs replica. */
/* Q17. Compare statement-level vs read-your-writes consistency for a checkout flow. */
/* Q18. What is "fence token" - and where does it appear in distributed locks? */
/* Q19. Walk through a "thundering herd" caused by cache eviction in a 4-shard cluster. */
/* Q20. Design a cross-region "global" customer table with regional sales.orders. */
/* Q21. Compare ISO/SQL standards for distributed semantics vs Postgres-specific guarantees. */
/* Q22. How does Vitess (MySQL) compare to Citus (Postgres) for OLTP scaling? */
/* Q23. Walk through CRDT-based counters - when can they replace Postgres SUM aggregations? */
/* Q24. What is "isolation downgrade" in distributed systems - give a real example. */
/* Q25. Design a "global feature flag" service that serves 100k QPS - Postgres backend? */

/* ============================================================
   SECTION B: TIME-SERIES AT SCALE (25)
   ------------------------------------------------------------ */
/* Q26. Design ingestion for 1B page_views per day - what's the schema, partitioning, retention? */
/* Q27. Walk through TimescaleDB vs vanilla Postgres partitioning - when each pays off. */
/* Q28. Why is BRIN ideal for time-series, but useless after VACUUM FULL? */
/* Q29. Design a "rolling window" retention policy: keep 90 days hot, 1 year warm, 7 years cold. */
/* Q30. Walk through a continuous aggregate (materialized view refreshed incrementally). */
/* Q31. Compare downsampling strategies: per-minute -> per-hour -> per-day rollups. */
/* Q32. Design a "real-time analytics" pipeline: orders -> Kafka -> ClickHouse, with Postgres as ledger. */
/* Q33. Why does ORDER BY ts DESC LIMIT 1 on a TB-scale table need a B-tree even if BRIN exists? */
/* Q34. Design index strategy for "hot last 24h" vs "cold last 5y" queries. */
/* Q35. Walk through autovacuum tuning for a 50M rows/day inserts table. */
/* Q36. Explain why HOT updates are critical for telemetry tables. */
/* Q37. Design partition pruning verification - automated test for SLA breach detection. */
/* Q38. Walk through "cold partition" archival to S3 via foreign data wrapper. */
/* Q39. Why is partition-wise JOIN important - when does PG12+ do it automatically? */
/* Q40. Compare "fact table denormalized" vs "star schema" for analytic queries. */
/* Q41. Design a "log compaction" job that deduplicates a high-churn event table. */
/* Q42. Walk through "Lambda architecture" - batch + stream + serving layers. */
/* Q43. Why is timezone-aware time-series tricky - design a single-tz solution. */
/* Q44. Design a "time-bucket sliding" query for last 24h, last 7d, last 30d, served in <100ms. */
/* Q45. Walk through "data tiering" - automated movement from hot SSD -> warm SSD -> cold S3. */
/* Q46. Compare ORC vs Parquet vs Postgres for analytic time-series. */
/* Q47. Why is "out-of-order ingest" hard to handle in partitioned time-series? */
/* Q48. Design a "late-arriving event" merge into existing partitions. */
/* Q49. Walk through "schema evolution" in append-only time-series tables. */
/* Q50. Design a "tagged time-series" table for IoT-like events (metric_name, tags, value, ts). */

/* ============================================================
   SECTION C: MULTI-TENANT ISOLATION (25)
   ------------------------------------------------------------ */
/* Q51. Compare row-level vs schema-level vs database-level isolation for multi-tenant. */
/* Q52. Walk through Postgres RLS (Row-Level Security) - show a complete tenant rule. */
/* Q53. Why is "tenant_id column on every table" the standard pattern? */
/* Q54. Design noisy-neighbor mitigation when one tenant runs 10x the queries of others. */
/* Q55. Walk through per-tenant connection pool exhaustion - how to limit. */
/* Q56. Compare statement_timeout vs idle_in_transaction_timeout per role. */
/* Q57. Design a "tenant onboarding" flow that creates schema, seeds tables, sets RLS in <1s. */
/* Q58. Walk through "tenant exit / GDPR delete" - cascading deletes across 50 tables. */
/* Q59. Why is pg_dump --schema=tenant_001 a bad idea at scale? */
/* Q60. Design a logical replication setup for cross-region tenant isolation. */
/* Q61. Compare workspace isolation in BigQuery vs Postgres schemas. */
/* Q62. Walk through "shared schema, separate database" tradeoffs. */
/* Q63. Design "noisy tenant detection" - auto-throttle by query count + CPU. */
/* Q64. Walk through pg_hint_plan for tenant-specific plan tuning. */
/* Q65. Design a billing/usage accounting system based on pg_stat_statements. */
/* Q66. Compare RLS vs application-side WHERE - security audit risk. */
/* Q67. Walk through column-level access control with grants + views. */
/* Q68. Design an "export tenant data" pipeline that hits replicas only. */
/* Q69. Walk through "tenant tier sizing" - small/medium/large with different SLAs. */
/* Q70. Design a "tenant compaction" job that merges small tenants into shared schema for cost. */
/* Q71. Walk through encryption-at-rest options (TDE) - and column-level encryption (pgcrypto). */
/* Q72. Design a "tenant audit log" that survives DROP DATABASE. */
/* Q73. Walk through "data residency" requirements - design region-pinned tenants. */
/* Q74. Compare AWS RDS multi-tenant patterns vs Aurora Serverless. */
/* Q75. Design a "tenant migration" plan that moves a tenant from one region to another with zero downtime. */

/* ============================================================
   SECTION D: DISASTER, SCALE, COST (25)
   ------------------------------------------------------------ */
/* Q76. Design a backup strategy that supports 5min RPO + 30min RTO. */
/* Q77. Walk through PITR drill - recover to "5 minutes before that bug shipped". */
/* Q78. Why is "Schrodinger's backup" common - backups exist but recovery untested? */
/* Q79. Design a "logical backup + WAL streaming" hybrid. */
/* Q80. Walk through a real "100GB bloat from long transaction" recovery. */
/* Q81. Compare pg_repack vs VACUUM FULL - production vs midnight tradeoffs. */
/* Q82. Design a "schema migration" pipeline using pg_repack to avoid downtime. */
/* Q83. Walk through "zero-downtime ADD COLUMN with default" pre-PG11 vs PG11+. */
/* Q84. Design a "zero-downtime rename" of a hot column. */
/* Q85. Walk through "zero-downtime FK addition" using NOT VALID + VALIDATE. */
/* Q86. Walk through dropping a column on a billion-row table without locking. */
/* Q87. Compare RDS / Aurora / Cloud SQL / Crunchy / Neon pricing tradeoffs. */
/* Q88. Design a "cost-aware" indexing policy: bytes-per-query justified. */
/* Q89. Walk through "ghost" indexes - created, never used, but still cost write amplification. */
/* Q90. Design an "index audit" job that flags unused indexes weekly. */
/* Q91. Walk through "WAL bloat" caused by replication slot held by dead subscriber. */
/* Q92. Design "automatic failover with sanity check" - what conditions block promotion? */
/* Q93. Walk through "data divergence after failover" - how do you reconcile? */
/* Q94. Design an "audit trail" that survives data corruption. */
/* Q95. Compare "synchronous_commit = local" vs "remote_apply" for write-heavy workloads. */
/* Q96. Walk through a "wal_size_runaway" - when does WAL refuse to recycle? */
/* Q97. Design a "checkpoint storm" mitigation strategy. */
/* Q98. Walk through "max_wal_senders saturation" - how to detect and fix. */
/* Q99. Compare Postgres 16 vs 17 vs 18 release-note highlights you'd care about as a DBA. */
/* Q100. Design RetailMart's "next-3-year scale plan": today=10K orders/day, target=10M/day. Specific architectural milestones at 100K, 1M, 10M. */

/* ============================================================
   END OF Introduction to SQL & Databases - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
