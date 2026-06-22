/* ============================================================
   SQL PRACTICE SET - Database Concepts for Analysts (MEDIUM LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Database Concepts - Normalization, Keys, ACID, Transactions
   Format:       100 conceptual word-problem questions

   Note: Day 14 is a concepts day - no queries are run against the
   database. Answer in 2-5 sentences, or sketch the corrected table
   structure / DDL where asked. The "Applied" section reasons about the
   real RetailMart V3 schema.
   ============================================================ */

/* ============================================================
   SECTION A: NORMALIZING SAMPLE TABLES (25)
   ------------------------------------------------------------ */
/* Q1.  A junior built Orders(order_id, customer_name, item1, item2, item3). Which normal form does it break, and why? */
/* Q2.  Rewrite the table in Q1 (sketch) into a design that satisfies 1NF. */
/* Q3.  Sales(order_id, product_id, product_name, qty) repeats product_name on every line. Which NF is violated and which dependency causes it? */
/* Q4.  Fix the Sales table in Q3 by decomposing it - name the resulting tables and their keys. */
/* Q5.  Enrollment(student_id, course_id, student_name, grade) has PK (student_id, course_id). student_name depends only on student_id. Name the violation. */
/* Q6.  Decompose the Enrollment table in Q5 to reach 2NF. */
/* Q7.  Employee(emp_id, dept_id, dept_name): dept_name depends on dept_id, which depends on emp_id. Name the dependency type and the NF violated. */
/* Q8.  Decompose the Employee table in Q7 to reach 3NF. */
/* Q9.  A customers sheet stores "9876543210, 9123456780" in a single phone cell. Which NF does it break, and how do you fix it? */
/* Q10. A table stores order_id plus a JSON blob of all items in one column. Is that 1NF? Discuss the tradeoff for analytics. */
/* Q11. Invoice(invoice_id, customer_id, customer_gstin, line_no, item, amount) with PK (invoice_id, line_no): identify the partial dependency. */
/* Q12. Why does a table whose primary key is a single column automatically avoid 2NF (partial-dependency) problems? */
/* Q13. A reporting table repeats region_name on every row for speed. Which NF does it break, and why might that be acceptable here? */
/* Q14. Spot the transitive dependency in Book(book_id, publisher_id, publisher_city). */
/* Q15. Product(prod_id, category_id, category_name, gst_rate) where gst_rate depends on category. Name the NF violated and the fix. */
/* Q16. A column "address" holds "12 MG Road, Pune, 411001, MH". Is that atomic? How would you normalize it, and what's the tradeoff? */
/* Q17. Two rows describe the same customer with "Bengaluru" vs "Bangalore". Which anomaly does this risk, and how does normalization help? */
/* Q18. A junior says "one big table means I never JOIN." Give two concrete risks of that approach. */
/* Q19. Orders(order_id, coupon_code, coupon_discount_pct) where discount depends on the coupon. Name the dependency and the NF it breaks. */
/* Q20. Convert a many-to-many "students <-> courses" design into three tables; name every key. */
/* Q21. Shipment(shipment_id, courier_name, courier_phone): spot the transitive dependency and propose the fix. */
/* Q22. Why can a table that is only in 1NF still suffer update anomalies? Give an example. */
/* Q23. Sketch a table that is in 2NF but NOT 3NF, then show its 3NF version. */
/* Q24. A teammate normalized so aggressively that a simple report needs 7 joins. What tradeoff did they hit? */
/* Q25. Given a denormalized "wide" sales export, list the ordered steps you'd take to bring it to 3NF. */

/* ============================================================
   SECTION B: FUNCTIONAL DEPENDENCIES & DECOMPOSITION (25)
   ------------------------------------------------------------ */
/* Q26. Write the functional dependency that captures "each order belongs to exactly one customer." */
/* Q27. List the functional dependencies in Orders(order_id, customer_id, order_date). */
/* Q28. What is the difference between a "fully functional dependency" and a partial one? */
/* Q29. Given (A,B) -> C and A -> D, which dependency is partial, and why? */
/* Q30. What is a "determinant"? Identify it in product_id -> product_name. */
/* Q31. If A -> B and B -> C, what can you infer, and what is that inference rule called? */
/* Q32. Why does a transitive dependency A -> B -> C violate 3NF? */
/* Q33. Decompose R(emp_id, project_id, hours, emp_name), given emp_name depends only on emp_id. */
/* Q34. What is a "lossless" decomposition, in one sentence? */
/* Q35. Why is it a problem if a decomposition loses information when you re-join the pieces? */
/* Q36. Student(roll_no, email, dept, dept_hod) with email unique. List the candidate keys. */
/* Q37. If every non-key attribute depends on the whole key and nothing else, which normal form is guaranteed? */
/* Q38. State BCNF in one sentence and explain how it is stricter than 3NF. */
/* Q39. Give a short example of a table that is in 3NF but not in BCNF. */
/* Q40. Why should analysts understand functional dependencies even if they never design schemas? */
/* Q41. A table stores both "age" and "date_of_birth". What dependency/quality problem is that, and what's the fix? */
/* Q42. Identify the determinant for the junction table order_items(order_id, prod_id, qty). */
/* Q43. What does it mean to say the primary key "functionally determines" every other column? */
/* Q44. Course(course_id, instructor, instructor_email): which dependency makes this not 3NF? */
/* Q45. Describe, step by step, how you'd check on paper whether a table is in 2NF. */
/* Q46. Describe, step by step, how you'd check on paper whether a table is in 3NF. */
/* Q47. Why does adding a surrogate key sometimes hide a real dependency problem instead of fixing it? */
/* Q48. Given (store_id, product_id) -> stock and store_id -> store_region, classify each dependency. */
/* Q49. Decompose the table in Q48 to remove the partial dependency. */
/* Q50. Restate the BCNF rule "every determinant must be a candidate key" in plain words. */

/* ============================================================
   SECTION C: TRANSACTIONS IN PRACTICE (25)
   ------------------------------------------------------------ */
/* Q51. Sketch a transaction (BEGIN ... COMMIT) for "insert one order, then insert its three line items." */
/* Q52. In the Q51 example, what should happen if the third item insert fails? */
/* Q53. A CHECK constraint requires quantity > 0. A bulk insert includes one row with quantity = 0. What happens to that statement? */
/* Q54. Two cashiers sell the last unit of a product at the same instant. Which ACID property is being tested? */
/* Q55. Explain a "dirty read" in plain English with a short scenario. */
/* Q56. Explain a "non-repeatable read" with a short scenario. */
/* Q57. Explain a "phantom read" with a short scenario. */
/* Q58. A nightly job updates 1,000,000 rows in one transaction and crashes at row 500,000. What state is the table left in? */
/* Q59. Why might you split that 1M-row update into smaller batches instead of one giant transaction? */
/* Q60. What is a deadlock, in one sentence, and what typically resolves it? */
/* Q61. A FOREIGN KEY blocks inserting an order_item for a non-existent order. Which ACID property does that support? */
/* Q62. The CFO asks "can a half-finished refund leave the books unbalanced?" Answer using Atomicity. */
/* Q63. Why is it safe to ROLLBACK after an error, but impossible to ROLLBACK after COMMIT? */
/* Q64. What does a SAVEPOINT let you do inside a transaction? */
/* Q65. Why do long-running transactions hurt concurrency for other users? */
/* Q66. When a constraint violation occurs mid-transaction, what is the typical outcome for the statement versus the whole transaction? */
/* Q67. Explain how a UNIQUE constraint stops two customers registering the same email even under concurrent inserts. */
/* Q68. Why must "place order" be atomic across inventory, order, and payment writes? */
/* Q69. A developer disables constraints "for speed" during a load. Which ACID guarantee did they weaken, and what's the risk? */
/* Q70. Describe optimistic versus pessimistic concurrency control at a high level. */
/* Q71. Why are most SELECT-only workloads safe to run without an explicit transaction? */
/* Q72. Name the four standard isolation levels from weakest to strongest. */
/* Q73. Which isolation level prevents dirty reads but still allows non-repeatable reads? */
/* Q74. Which isolation level prevents all three classic read anomalies? */
/* Q75. Why is the strongest isolation level not used by default for every workload? */

/* ============================================================
   SECTION D: RETAILMART SCHEMA ANALYSIS (25)
   ------------------------------------------------------------ */
/* Q76. The VP of Sales wants region on every order row. Explain how RetailMart derives region today (stores.region_id -> core.dim_region) and the tradeoff of denormalizing it. */
/* Q77. orders.net_total is a stored sum of its order_items. Argue when recomputing from items is safer than trusting the stored total. */
/* Q78. A junior wants to add customer_city to customers.customers "to avoid a join." Critique this against 3NF. */
/* Q79. customers.tier is stored as text. Propose a normalized alternative and give one pro and one con. */
/* Q80. Why is sales.order_items a textbook junction table? Name its likely composite key. */
/* Q81. The DBA asks you to state the referential-integrity rule that must hold between order_items and orders. */
/* Q82. sales.returns links to an order rather than directly to a customer. Explain the design reasoning. */
/* Q83. core.dim_date exists as a separate dimension. What normalization and analytics benefits does a date dimension provide? */
/* Q84. What transitive-dependency risk appears if products stored brand_name AND category_name as text instead of brand_id? */
/* Q85. Explain why storing first_name and last_name separately (not one full_name) is the more flexible, 1NF-friendly choice. */
/* Q86. loyalty.members has no member_id, only customer_id. What does that imply about the members-to-customer relationship? */
/* Q87. The CHRO wants a manager hierarchy, but stores.employees has no manager_id. Sketch how you'd model it in a normalized way. */
/* Q88. supply_chain.inventory_snapshots uses a composite key with no single snapshot_id. Explain why a composite key fits here. */
/* Q89. Why does keeping payment modes in finance.payment_modes (mode_id) instead of free text on orders reduce anomalies? */
/* Q90. A report needs brand AND category names for each product. Trace the normalized join path products -> dim_brand -> dim_category. */
/* Q91. Argue for and against adding a denormalized monthly_sales summary table for dashboards. */
/* Q92. The Compliance Officer asks whether deleting a customer should delete their orders. Discuss CASCADE vs RESTRICT for RetailMart. */
/* Q93. Which RetailMart tables are "fact" tables and which are "dimension" tables? Give two of each. */
/* Q94. Why is a surrogate prod_id a better key than using the product name in products.products? */
/* Q95. Identify one place in RetailMart where a genuine 1:1 relationship could exist, and how you'd model it. */
/* Q96. Explain how foreign keys across sales, customers, and products keep RetailMart consistent. */
/* Q97. A stakeholder wants reviews linked to both a product and a customer. Which columns on customers.reviews support that? */
/* Q98. Why might the analytics layer (views / materialized views) deliberately denormalize RetailMart for query speed? */
/* Q99. Give an example of an update anomaly that the customers/addresses split prevents. */
/* Q100. Audit any three RetailMart tables and label each as 3NF or intentionally denormalized, with a one-line reason. */

/* ============================================================
   END - Database Concepts (MEDIUM) - 100 questions
   ============================================================ */
