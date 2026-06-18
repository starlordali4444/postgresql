/* ============================================================
   SQL PRACTICE SET - JSON & Semi-Structured Data (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        JSONB operators (->, ->>, #>, #>>, @>, ?), jsonb_array_elements, building JSON
   Database:     RetailMart V3

   Scope (EASY = one concept per question):
     - Extract scalars with -> / ->> ; navigate paths with #> / #>>
     - Build JSON from rows with to_jsonb / jsonb_build_object / jsonb_agg
     - Unnest arrays with jsonb_array_elements; cast extracted values for math
   NOTE ON DATA: RetailMart is relational. The ONLY native JSONB column is
     audit.procedure_calls.input_params (shape {"id": <int>}). For everything
     else we CONSTRUCT JSONB from real rows (to_jsonb / jsonb_build_object /
     jsonb_agg) and then operate on it - fully read-only, and exactly how nested
     API/event payloads are rehearsed. (jsonb_set/||/- writes -> your accio_NN DB.)

   Structure: 25 Conceptual + 25 Extract/Build basics + 25 Arrays & nesting + 25 Combined/pipelines
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  Difference between JSON and JSONB (storage, dedup keys, ordering, indexing). */
/* Q2.  What does -> return (jsonb) vs ->> (text)? */
/* Q3.  When do you use ->> vs -> in SELECT / WHERE? */
/* Q4.  What do #> and #>> do (path access by array of keys)? */
/* Q5.  What does the @> containment operator test? */
/* Q6.  What does the ? operator test (top-level key existence)? */
/* Q7.  What does jsonb_array_elements do to an array? */
/* Q8.  Difference between jsonb_array_elements and jsonb_array_elements_text. */
/* Q9.  What does jsonb_build_object(k1,v1,k2,v2,...) construct? */
/* Q10. What does to_jsonb(value-or-row) do? */
/* Q11. What does jsonb_agg(expr) aggregate? */
/* Q12. What does to_jsonb of a whole row produce? */
/* Q13. Why must you cast (json ->> 'x')::numeric before doing math? */
/* Q14. What is jsonb_object_keys used for? */
/* Q15. What does jsonb_path_query do (concept)? */
/* Q16. Why is JSONB better than text for storing semi-structured data? */
/* Q17. Where does nested JSON come from in real pipelines (APIs, event streams)? */
/* Q18. What does "flattening" nested JSON into rows mean? */
/* Q19. Why might you GIN-index a JSONB column (Day 20 tie-in, concept)? */
/* Q20. Name RetailMart's one real JSONB column and how we simulate the rest. */
/* Q21. What does jsonb_build_array(...) build? */
/* Q22. Difference between a JSON object {} and a JSON array []. */
/* Q23. How do NULLs appear in JSON (SQL NULL vs JSON null)? */
/* Q24. What do jsonb_each / jsonb_each_text return? */
/* Q25. Why does ->> on a missing key return NULL instead of erroring? */

/* ============================================================
   SECTION B: EXTRACT & BUILD BASICS (25)
   ------------------------------------------------------------ */
/* Q26. From audit.procedure_calls: extract input_params->>'id' as text. */
/* Q27. Cast that extracted id to integer; return call_id + id. */
/* Q28. Count procedure_calls where input_params ? 'id' (key present). */
/* Q29. Join the extracted id back to products.products on product_id. */
/* Q30. Build a JSON per order: jsonb_build_object('order_id',..,'net_total',..,'status',..). */
/* Q31. Build to_jsonb(o.*) for the first 10 orders. */
/* Q32. From a built order JSON, extract ->>'status'. */
/* Q33. Build an api-request JSON from audit.api_requests (method, status_code, latency, user_agent). */
/* Q34. From that built JSON, extract method and status_code back out. */
/* Q35. Cast a built JSON field (->>'net_total')::numeric and SUM it. */
/* Q36. Build a customer JSON {id, name, tier} from customers.customers. */
/* Q37. Extract tier from the built customer JSON and group counts. */
/* Q38. Build a product JSON {prod_id, price, cost} and compute margin from extracted fields. */
/* Q39. Build a store JSON with a nested address object (jsonb_build_object inside). */
/* Q40. Use ->> to pull a field and filter rows where it equals a value. */
/* Q41. Build a review JSON {rating, date} and extract rating::int. */
/* Q42. Build jsonb with a NULL value; observe the resulting JSON null. */
/* Q43. COALESCE an extracted ->> value with a default. */
/* Q44. Build order JSON and extract via path #>>'{status}'. */
/* Q45. Count distinct extracted ->>'method' from built api JSON. */
/* Q46. Build a ticket JSON {priority, subject}; group by extracted priority. */
/* Q47. Extract two fields and concatenate into one label. */
/* Q48. Build an employee JSON {name, dept}; filter by extracted dept. */
/* Q49. Round-trip: row -> to_jsonb -> ->> a column -> compare to the original column. */
/* Q50. Build JSON and check optional-key existence with ? . */

/* ============================================================
   SECTION C: ARRAYS & NESTING (25)
   ------------------------------------------------------------ */
/* Q51. Aggregate order_items into a jsonb array per order (jsonb_agg). */
/* Q52. Build a nested order document {order_id, items:[...]} (jsonb_build_object + jsonb_agg). */
/* Q53. Unnest that items array with jsonb_array_elements (one row per item). */
/* Q54. Count items per order via jsonb_array_length on the built array. */
/* Q55. Build a customer document with an orders array. */
/* Q56. Extract the first array element with ->0. */
/* Q57. jsonb_array_elements_text on a built array of labels/tags. */
/* Q58. Group by a nested field after unnesting (e.g. item prod_id). */
/* Q59. Build {region, stores:[...]} nested document per region. */
/* Q60. SUM a numeric field across unnested array elements. */
/* Q61. Build a per-product review array; compute avg rating from unnested. */
/* Q62. Use #> to navigate into a nested object path (returns jsonb). */
/* Q63. Use #>> to navigate into a nested path (returns text). */
/* Q64. Build a 2-level nested doc (region->store->count); read a deep path. */
/* Q65. Filter built docs with @> containment (e.g. contains {"status":"Delivered"}). */
/* Q66. Check key existence with ? across built documents. */
/* Q67. List keys of a built order object with jsonb_object_keys. */
/* Q68. Build an array of distinct payment modes as jsonb. */
/* Q69. Unnest a built monthly-revenue array into rows. */
/* Q70. Build {customer, order_count, total}; extract numeric for sorting. */
/* Q71. Aggregate the top-5 products per category into a jsonb array. */
/* Q72. Build nested {brand, products:[{prod_id,price}]}; unnest two levels. */
/* Q73. jsonb_agg with ORDER BY inside (an ordered array). */
/* Q74. Build a jsonb array of order dates per customer. */
/* Q75. Count keys in a built object (jsonb_object_keys + count). */

/* ============================================================
   SECTION D: COMBINED / PIPELINES (25)
   ------------------------------------------------------------ */
/* Q76. Build a per-order nested JSON {order, items[], payment} (API-export shape). */
/* Q77. Flatten that document back into a relational row set. */
/* Q78. Per customer: build a "customer-360" JSON (profile + order count + latest order, Day 22). */
/* Q79. Aggregate orders into a jsonb array per customer; keep only those with >5 orders. */
/* Q80. Build api-request JSON; extract status_code; group error (>=400) vs ok. */
/* Q81. Build api JSON; cast latency; compute median latency per method (Day 22). */
/* Q82. Build event JSON from web_events; bucket by extracted hour (Day 23). */
/* Q83. Round-trip pipeline: rows -> jsonb_agg -> unnest -> re-aggregate; verify totals. */
/* Q84. Build monthly revenue as a jsonb object keyed by month (jsonb_object_agg). */
/* Q85. Extract values from that month-keyed object for specific months. */
/* Q86. Build a region->metrics nested doc with median + P95 inside (Day 22). */
/* Q87. Per category: jsonb array of monthly units (Day 23) for a sparkline payload. */
/* Q88. Build a ticket document; filter where priority is Critical via ->>. */
/* Q89. Construct a JSON export of the top-10 customers by spend (API response). */
/* Q90. Build a product-catalog JSON {prod_id, name, price, in_promo?} with a boolean. */
/* Q91. Use @> to find built order docs containing a specific item prod_id. */
/* Q92. Build nested store->employees doc; count employees via jsonb_array_length. */
/* Q93. Cast and SUM a jsonb array of line amounts to reconstruct the order total. */
/* Q94. Build a JSON time-series payload (date->revenue) for the last 30 days (Day 23). */
/* Q95. Per customer: latest order as JSON (DISTINCT ON, Day 22) embedded in a profile doc. */
/* Q96. Build JSON with computed margin; filter where margin < 0.2. */
/* Q97. jsonb_object_agg of region->revenue; extract the max-revenue region. */
/* Q98. Build an audit-change document {table, col, old, new} from record_changes. */
/* Q99. From procedure_calls: extract id, join products, build enriched JSON with product name. */
/* Q100. Executive JSON export: per region {median_aov, p95_aov, orders} array (Day 22 + JSON). */
