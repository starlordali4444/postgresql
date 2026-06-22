/* ============================================================
   SQL PRACTICE SET - Database Concepts for Analysts (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Database Concepts - Normalization, Keys, ACID, Transactions
   Format:       100 conceptual word-problem questions

   Note: Day 14 is a concepts day - no queries are run against the
   database. Answer each question in 1-4 sentences (or sketch a small
   table / DDL where asked). The "Applied" section reasons about the
   real RetailMart V3 schema. Practice explaining each idea the way
   you would in an interview.
   ============================================================ */

/* ============================================================
   SECTION A: KEYS & RELATIONSHIPS (25)
   ------------------------------------------------------------ */
/* Q1.  In plain English, what is a primary key and what one rule must its values always satisfy? */
/* Q2.  What is a foreign key, and what does it enforce between two tables? */
/* Q3.  A teammate asks how a PRIMARY KEY differs from a UNIQUE constraint. Give the key difference. */
/* Q4.  What is a composite (multi-column) primary key? Give a realistic example. */
/* Q5.  Define a natural key and a surrogate key, with one example of each. */
/* Q6.  Why do most tables use an auto-generated id as the primary key instead of a real-world value? */
/* Q7.  Can a single table have more than one foreign key? Give an example. */
/* Q8.  What is a candidate key, and how does it relate to the primary key? */
/* Q9.  Explain a one-to-many relationship using a customer-and-orders example. */
/* Q10. Explain a many-to-many relationship using students and courses. */
/* Q11. Explain a one-to-one relationship and give a sensible example. */
/* Q12. What does "referential integrity" mean, in one sentence? */
/* Q13. Conceptually, what should happen if you try to delete a customer who still has orders? */
/* Q14. Give a one-line description of ON DELETE CASCADE versus ON DELETE RESTRICT. */
/* Q15. Why can a primary key column never be NULL? */
/* Q16. Can a foreign key value be NULL? If so, what would that NULL mean in business terms? */
/* Q17. In a foreign-key relationship, what do we mean by the "parent" table versus the "child" table? */
/* Q18. How do you physically model a many-to-many relationship in a relational database? */
/* Q19. Email is unique per customer, yet customer_id is the primary key. Explain why that choice makes sense. */
/* Q20. What is a self-referencing foreign key? Give an example (hint: employees and managers). */
/* Q21. What is a lookup (dimension) table? Name one from RetailMart. */
/* Q22. Why do surrogate keys stay stable even when a natural value like email or phone changes? */
/* Q23. In one sentence, what is the difference between a key and an index? */
/* Q24. What is an "orphan" row, and which mechanism prevents it? */
/* Q25. Why do we split data across several related tables instead of one very wide table? */

/* ============================================================
   SECTION B: NORMALIZATION BASICS (25)
   ------------------------------------------------------------ */
/* Q26. In plain English, what does "normalizing" a database mean? */
/* Q27. Name two concrete problems normalization is designed to prevent. */
/* Q28. What is data redundancy, and why is storing the same fact in many places risky? */
/* Q29. Define an "update anomaly" with a short example. */
/* Q30. Define an "insertion anomaly" with a short example. */
/* Q31. Define a "deletion anomaly" with a short example. */
/* Q32. State what First Normal Form (1NF) requires, in one sentence. */
/* Q33. Give an example of a column value that violates 1NF. */
/* Q34. What does it mean for a value to be "atomic"? */
/* Q35. State what Second Normal Form (2NF) requires, building on 1NF. */
/* Q36. In intuitive terms, what is a "partial dependency"? */
/* Q37. State what Third Normal Form (3NF) requires, in one sentence. */
/* Q38. In intuitive terms, what is a "transitive dependency"? */
/* Q39. Explain the mnemonic "the key, the whole key, and nothing but the key." */
/* Q40. What is a functional dependency, written A -> B, in plain English? */
/* Q41. True or false: a table in 3NF is automatically in 2NF and 1NF. Explain. */
/* Q42. Why is it risky to store city, state, pincode AND a derived "region" label all in one row? */
/* Q43. Give an everyday example where the same address copied into 5 places caused an inconsistency. */
/* Q44. What does "denormalization" mean? */
/* Q45. Name one legitimate reason to deliberately denormalize. */
/* Q46. Why are reporting and analytics tables often denormalized on purpose? */
/* Q47. Is more normalization always better? Answer in one line. */
/* Q48. What is a "repeating group," and which normal form forbids it? */
/* Q49. Why does normalizing a design usually result in MORE tables? */
/* Q50. How does normalization explain why analysts write so many JOINs? */

/* ============================================================
   SECTION C: TRANSACTIONS & ACID (25)
   ------------------------------------------------------------ */
/* Q51. What is a database transaction, in plain English? */
/* Q52. What does COMMIT do? */
/* Q53. What does ROLLBACK do? */
/* Q54. Spell out what each letter of ACID stands for. */
/* Q55. Explain Atomicity using the classic bank-transfer example. */
/* Q56. Explain Consistency in one sentence. */
/* Q57. Explain Isolation in one sentence. */
/* Q58. Explain Durability in one sentence. */
/* Q59. Why is "move money from account A to account B" the textbook example of atomicity? */
/* Q60. If the power fails halfway through a transaction, which ACID property protects your data? */
/* Q61. Which ACID property ensures two simultaneous users don't corrupt each other's work? */
/* Q62. What is an "all-or-nothing" operation? */
/* Q63. Give a RetailMart example where two writes should happen in one transaction. */
/* Q64. What does BEGIN (or START TRANSACTION) do? */
/* Q65. After a successful COMMIT, can you still ROLLBACK that work? One line. */
/* Q66. Name one reason a transaction might be rolled back automatically. */
/* Q67. What is a "partial update," and why is it dangerous? */
/* Q68. What is the difference between auto-commit mode and an explicit transaction? */
/* Q69. In plain English, what is a constraint, and how does it support the "C" in ACID? */
/* Q70. How does a NOT NULL constraint protect data quality? */
/* Q71. How does a CHECK constraint protect data quality? Give an example. */
/* Q72. How does a UNIQUE constraint protect data quality? */
/* Q73. Why are transactions especially important for an e-commerce checkout? */
/* Q74. Once a payment app says "payment successful," what does Durability promise the user? */
/* Q75. In one sentence, why do analysts mostly read (SELECT) and rarely manage transactions themselves? */

/* ============================================================
   SECTION D: APPLIED TO RETAILMART V3 (25)
   ------------------------------------------------------------ */
/* Q76. What is the primary key of customers.customers? */
/* Q77. A customer can have several addresses. Which table holds them, and which key connects them? */
/* Q78. customers.customers has no city column. Which table holds city, and how do you connect the two? */
/* Q79. sales.order_items refers to two parent tables. Name both and the keys involved. */
/* Q80. sales.order_items stores prod_id. What does that column point to? */
/* Q81. sales.returns has no cust_id. Describe the path you'd follow to find who returned an item. */
/* Q82. What kind of relationship exists between sales.orders and sales.order_items? */
/* Q83. core.dim_region is a lookup table. What does stores.stores.region_id point to? */
/* Q84. Why does RetailMart store region_id in stores instead of the text "North" directly? */
/* Q85. customers.tier holds text like "Gold"/"Silver". Is that a normalization smell? Briefly discuss. */
/* Q86. Is a customer's full name stored as a column, or derived? If derived, from what? */
/* Q87. Which key connects loyalty.members back to a customer? */
/* Q88. State the primary key of products.products and how order_items links to it. */
/* Q89. Give one one-to-many relationship in RetailMart and name the keys on both sides. */
/* Q90. Orders and products are effectively many-to-many. Which table resolves that relationship? */
/* Q91. Why does RetailMart separate brand and category into core.dim_brand and core.dim_category? */
/* Q92. support.tickets stores customer_id. What relationship does that represent? */
/* Q93. In stores.employees, which column links an employee to a department, and what does it reference? */
/* Q94. Is order_date stored once on the order, or repeated on each line item? Which is the correct design? */
/* Q95. orders carries a net_total (a derived sum of its items). Is that denormalization? When is it safe? */
/* Q96. Name two RetailMart tables that look well-normalized (3NF) and say why. */
/* Q97. Name one RetailMart field that looks denormalized, and explain the tradeoff behind it. */
/* Q98. Sketch how you'd add a many-to-many "which products appear in which promotions" relationship. */
/* Q99. Why is the surrogate customer_id a better primary key than using email in customers.customers? */
/* Q100. Pick any RetailMart table: state its primary key, one foreign key, and the real-world entity it models. */

/* ============================================================
   END - Database Concepts (EASY) - 100 questions
   ============================================================ */
