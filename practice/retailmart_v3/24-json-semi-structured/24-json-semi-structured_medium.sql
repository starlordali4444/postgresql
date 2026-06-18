/* ============================================================
   SQL PRACTICE SET - JSON & Semi-Structured Data (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Extract+cast+aggregate, array flattening, nested documents, JSON pipelines
   Database:     RetailMart V3

   Scope (MEDIUM = joins + LATERAL unnest + tidy reshaping):
     - Operator family (->, ->>, #>, #>>, @>, ?, ?&) used together
     - jsonb_agg / jsonb_object_agg to build docs; jsonb_array_elements to flatten
     - Combine JSON with windows (16-18), percentiles/DISTINCT ON (22), pivots (21), dates (23)
   NOTE: one real JSONB column (audit.procedure_calls.input_params); all other JSON is
     CONSTRUCTED from real rows (read-only). Writes (jsonb_set/||) -> your accio_NN DB.

   Structure: 25 Conceptual + 25 Extract/cast/aggregate + 25 Arrays/nesting/flatten + 25 Pipelines & applied
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  JSONB vs JSON: which preserves key order/duplicates, which queries faster? */
/* Q2.  -> vs ->> vs #> vs #>> - a precise four-way comparison. */
/* Q3.  @> vs ? vs ?| vs ?& - the containment / key-existence family. */
/* Q4.  When does jsonb_array_elements multiply row counts (LATERAL cross-join semantics)? */
/* Q5.  Why is a ->> result always text, requiring a cast for math/sort? */
/* Q6.  jsonb_build_object vs to_jsonb(row) - when to use each. */
/* Q7.  jsonb_agg vs jsonb_object_agg - array vs keyed object. */
/* Q8.  GIN index on JSONB: jsonb_ops vs jsonb_path_ops (Day 20 concept). */
/* Q9.  Which operators does a GIN index accelerate (@>, ?, ...)? */
/* Q10. jsonb_path_query / JSONPath basics (concept). */
/* Q11. Flattening strategy: LATERAL jsonb_array_elements then extract scalars. */
/* Q12. NULL vs JSON 'null' vs a missing key - three distinct cases. */
/* Q13. Coalescing missing JSON fields with sensible defaults. */
/* Q14. Storing event payloads as JSONB: pros and cons vs wide columns. */
/* Q15. Round-tripping relational <-> JSON without losing data. */
/* Q16. jsonb_set / concatenation (||) for building/modifying (concept; writes -> accio_NN). */
/* Q17. Indexing an extracted scalar with an expression index on (doc->>'k') (Day 20). */
/* Q18. Why deeply nested JSON hurts clarity and performance. */
/* Q19. Validating JSON shape (keys present, types correct) in SQL. */
/* Q20. jsonb_strip_nulls and why it helps API payloads. */
/* Q21. Aggregating many rows into a single JSON document per group. */
/* Q22. Pretty-printing with jsonb_pretty for debugging. */
/* Q23. Extracting JSON fields and pivoting them into columns (Day 21). */
/* Q24. Combining JSON extraction with window functions (Days 16-18). */
/* Q25. When to push JSON parsing to ETL vs do it at query time. */

/* ============================================================
   SECTION B: EXTRACT, CAST & AGGREGATE (25)
   ------------------------------------------------------------ */
/* Q26. procedure_calls: extract id, join products, return proc_name + product name + price. */
/* Q27. procedure_calls: count calls per extracted id; top 10 most-referenced ids. */
/* Q28. Build api JSON; extract status_code; count by 2xx / 4xx / 5xx bands. */
/* Q29. Build api JSON; median & P95 latency per method (Day 22). */
/* Q30. Build order docs; extract net_total::numeric; revenue per extracted status. */
/* Q31. Build customer docs; group by extracted tier; counts + median spend. */
/* Q32. Build product docs; compute margin from extracted price/cost; per category. */
/* Q33. jsonb_object_agg month->revenue; extract a slice of specific months. */
/* Q34. Build review docs; avg extracted rating per product; filter > 4. */
/* Q35. Build event docs (Day 23 timestamp); bucket by extracted hour. */
/* Q36. Extract nested address city from a built customer doc; group counts. */
/* Q37. Build ticket docs; group by extracted priority; SLA% within target. */
/* Q38. Build api JSON; filter user_agent containing 'Mobile'; count. */
/* Q39. Build per-store doc; extract numeric revenue; rank stores (Day 16). */
/* Q40. Build a doc with two numerics; compute their ratio; filter on threshold. */
/* Q41. Extract ->>'method' and pivot counts into columns (Day 21). */
/* Q42. Build order doc with nested payment; extract #>>'{payment,mode}'. */
/* Q43. jsonb_agg an ordered array of a customer's order dates; read last with ->-1. */
/* Q44. Cast extracted dates; compute gaps between them (Day 23 + JSON). */
/* Q45. Build region doc with a nested KPI object; read median via path. */
/* Q46. Count rows where a built doc ? 'discount' (optional key present). */
/* Q47. Extract array length per built customer-orders doc; show its distribution. */
/* Q48. Build doc; apply jsonb_strip_nulls; compare key counts before/after. */
/* Q49. Build api JSON; group by method x status band (Day 21 pivot). */
/* Q50. Build doc; extract + COALESCE a missing field with a default. */

/* ============================================================
   SECTION C: ARRAYS, NESTING & FLATTENING (25)
   ------------------------------------------------------------ */
/* Q51. Nested order doc {order, items:[{prod,qty,amt}]}; unnest; revenue per prod. */
/* Q52. Customer doc with orders array; unnest; count orders; verify vs base table. */
/* Q53. Region->stores->orders 2-level nest; flatten to (region, store, count). */
/* Q54. Top-N products per category as a jsonb array (window + jsonb_agg). */
/* Q55. Unnest items; group by prod_id; total qty; compare to a direct aggregate. */
/* Q56. @> containment: order docs containing item prod_id = X. */
/* Q57. ?& multiple required keys present across docs. */
/* Q58. #> navigate to a nested items array; jsonb_array_length. */
/* Q59. brand->products->reviews 3-level doc; deep path to a rating. */
/* Q60. jsonb_array_elements WITH ORDINALITY to keep element position. */
/* Q61. Unnest a month->value object via jsonb_each; cast; SUM. */
/* Q62. Build a per-customer tag array (derived flags); unnest; count by tag. */
/* Q63. Aggregate order_items to an array, then re-aggregate SUM from the array (round-trip). */
/* Q64. Build a nested doc; extract a deep path #>>'{a,b,c}'. */
/* Q65. Filter docs where a nested numeric (cast) exceeds a threshold. */
/* Q66. jsonb_object_agg prod->qty per order; extract a specific prod's qty. */
/* Q67. Build a customer-360 with arrays of orders, reviews, tickets; count each. */
/* Q68. Unnest two arrays from the same doc independently (two LATERAL calls). */
/* Q69. Build a jsonb array of {month, revenue} per region; unnest; MoM (Day 18). */
/* Q70. Containment query: which docs contain {"tier":"Gold"}. */
/* Q71. Build a nested doc; jsonb_object_keys to list its dynamic fields. */
/* Q72. Flatten api-log JSON into typed columns (the lab, via constructed JSON). */
/* Q73. Unnest + pivot: items array -> one column per category (Day 21). */
/* Q74. Build doc; compute an array aggregate (avg of unnested amounts). */
/* Q75. Reconstruct an order total by summing unnested item amounts; reconcile. */

/* ============================================================
   SECTION D: PIPELINES & APPLIED (25)
   ------------------------------------------------------------ */
/* Q76. API export: per order nested {order, items[], payment, customer}. */
/* Q77. Flatten that export back; verify row counts match the base joins. */
/* Q78. Customer-360 doc per customer with latest order (Day 22) + median spend. */
/* Q79. Build month-keyed revenue object per region (jsonb_object_agg); read the trend. */
/* Q80. Time-series JSON payload: date->revenue last 90 days (Day 23) as one object. */
/* Q81. Error-rate API report: build api JSON; % 4xx/5xx per endpoint. */
/* Q82. Latency SLO JSON: per method P50/P95/P99 (Day 22) as a jsonb object. */
/* Q83. Top-customers JSON array for an API response (rank + jsonb_agg). */
/* Q84. Catalog export: per product {price, in_promo, margin} with booleans. */
/* Q85. Audit-change doc from record_changes; filter price changes > 50% (cast). */
/* Q86. Nested region->KPIs doc with median, P95, order count (Day 22). */
/* Q87. Funnel-ish counts as a JSON object (web_events stages). */
/* Q88. Sparkline payload: per category monthly-units jsonb array (Day 23). */
/* Q89. Build doc; validate required keys (? checks); flag invalid docs. */
/* Q90. Containment filter to find docs matching a complex criterion (@>). */
/* Q91. Per-customer cadence doc (median gap, Day 22+23) embedded as JSON. */
/* Q92. Reshape: unpivot KPIs to long, build a {metric,value} array (Day 21 + JSON). */
/* Q93. Build api JSON; peak-hour error analysis (Day 23 hour + JSON). */
/* Q94. Export a top-10 stores leaderboard as a jsonb array with rank + median. */
/* Q95. Customer segment doc: tier + RFM-ish NTILE scores (Day 16) as JSON. */
/* Q96. Build nested order doc; @> to find orders containing a returned item. */
/* Q97. JSON time-bucket: 15-min slots (Day 23) -> counts as a JSON object. */
/* Q98. Reconcile: JSON-built totals vs SQL aggregates; assert equality. */
/* Q99. Build a paginated API response shape {data:[...], meta:{count,page}}. */
/* Q100. Exec dashboard JSON: per region {median_aov, p95, orders, latest_order} array (Day 22+23). */
