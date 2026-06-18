/* ============================================================
   SQL PRACTICE SET - Window Functions Part 1: Ranking & Bucketing (EASY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        OVER(), PARTITION BY, ROW_NUMBER / RANK / DENSE_RANK, NTILE
   Database:     RetailMart V3

   Scope (EASY = one concept per question, mostly single-table):
     - The OVER() clause; PARTITION BY; ORDER BY inside a window
     - ROW_NUMBER vs RANK vs DENSE_RANK
     - NTILE for bucketing; basic Top-N per group
   (Aggregation/frames are Day 17; LAG/LEAD are Day 18 - not used here.)

   Structure: 25 Conceptual + 25 ROW_NUMBER + 25 RANK/DENSE_RANK + 25 NTILE/Top-N
   ============================================================ */

/* ============================================================
   SECTION A: CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What does a window function do that GROUP BY does not? */
/* Q2.  Explain the OVER() clause - what does an empty OVER() mean? */
/* Q3.  What does PARTITION BY do inside OVER()? */
/* Q4.  What does ORDER BY inside OVER() control for ranking functions? */
/* Q5.  Define ROW_NUMBER() - is it ever tied? */
/* Q6.  Define RANK() - what happens to the number after a tie? */
/* Q7.  Define DENSE_RANK() - how does it differ from RANK() after ties? */
/* Q8.  Give a one-line summary of ROW_NUMBER vs RANK vs DENSE_RANK on tied values. */
/* Q9.  What does NTILE(4) do? */
/* Q10. Why must a ranking window function have an ORDER BY inside OVER()? */
/* Q11. Can you use a window function in a WHERE clause directly? Why not? */
/* Q12. What is the usual workaround to filter on a window result (e.g. rn = 1)? */
/* Q13. Do window functions remove rows like GROUP BY does? */
/* Q14. What is a "partition" vs a "group" conceptually? */
/* Q15. After ROW_NUMBER() OVER (ORDER BY x), what is the first row's number? */
/* Q16. How do NULLs in the window ORDER BY sort by default (ASC)? */
/* Q17. What does PARTITION BY region, category mean (two-level partition)? */
/* Q18. Is ROW_NUMBER deterministic when the ORDER BY has ties? How to fix? */
/* Q19. What is the "Top-N per group" pattern in one sentence? */
/* Q20. Why is ROW_NUMBER preferred over RANK for deduplication? */
/* Q21. What does NTILE return when rows don't divide evenly into buckets? */
/* Q22. Can the same query have two window functions with different OVER() clauses? */
/* Q23. Conceptually, in what order does a window function run vs WHERE and GROUP BY? */
/* Q24. What's the difference between RANK() and ROW_NUMBER() output ranges? */
/* Q25. Name one analyst use-case each for ROW_NUMBER, RANK, and NTILE. */

/* ============================================================
   SECTION B: ROW_NUMBER (25)
   ------------------------------------------------------------ */
/* Q26. Number all orders by order_date (newest first) with ROW_NUMBER. */
/* Q27. Number products by price descending. */
/* Q28. Number customers by registration_date ascending. */
/* Q29. Assign a row number to employees ordered by salary descending. */
/* Q30. Number orders within each customer by order_date (PARTITION BY cust_id). */
/* Q31. Number products within each brand by price descending. */
/* Q32. Number reviews within each product by review_date descending. */
/* Q33. Number employees within each store by salary descending. */
/* Q34. Get the single most recent order per customer (rn = 1 pattern). */
/* Q35. Get the cheapest product per brand (ROW_NUMBER, rn = 1). */
/* Q36. Get the latest review per customer. */
/* Q37. Number tickets within each priority by created_date. */
/* Q38. Number stores within each region by square_ft descending. */
/* Q39. Number calls within each customer by call_start_time. */
/* Q40. Add a global row number to a SELECT of the 50 highest-value orders. */
/* Q41. Number payments within each order by payment_date. */
/* Q42. Number shipments within each courier by shipped_date. */
/* Q43. Get the first (earliest) order per store using ROW_NUMBER. */
/* Q44. Number addresses within each customer (is_default first). */
/* Q45. Number ads_spend rows within each platform by amount descending. */
/* Q46. Use ROW_NUMBER to label "1st, 2nd, 3rd..." purchase per customer. */
/* Q47. Number products within each supplier by product_name. */
/* Q48. Get the highest-paid employee per department (rn = 1). */
/* Q49. Number orders per store by net_total descending. */
/* Q50. Deduplicate customers by email, numbering duplicates by registration_date desc. */

/* ============================================================
   SECTION C: RANK / DENSE_RANK (25)
   ------------------------------------------------------------ */
/* Q51. RANK products by price descending (whole table). */
/* Q52. DENSE_RANK products by price descending; compare to Q51's gaps. */
/* Q53. RANK employees by salary within each department. */
/* Q54. DENSE_RANK orders by net_total within each customer. */
/* Q55. RANK stores by total square_ft within each region. */
/* Q56. Show ROW_NUMBER, RANK, and DENSE_RANK side by side for products by price. */
/* Q57. RANK customers by tier then registration_date. */
/* Q58. DENSE_RANK products within each brand by price. */
/* Q59. RANK reviews by rating within each product (ties expected). */
/* Q60. Find the rank of a specific product's price among all products. */
/* Q61. RANK ticket priorities by created_date within each status. */
/* Q62. DENSE_RANK employees by salary (whole company) - count distinct salary levels. */
/* Q63. RANK orders by order_date within each store. */
/* Q64. DENSE_RANK brands by number of products (rank a pre-aggregated set). */
/* Q65. RANK calls by duration within each agent. */
/* Q66. Show why RANK skips numbers after a tie using rating data. */
/* Q67. RANK products by cost_price within each category (via brand->category). */
/* Q68. DENSE_RANK customers by points_balance (loyalty.members). */
/* Q69. RANK shipments by delivery time (delivered_date - shipped_date) within courier. */
/* Q70. RANK pay_slips by net_salary within each salary_year. */
/* Q71. Find products tied at the same RANK by price within a brand. */
/* Q72. DENSE_RANK order statuses by frequency. */
/* Q73. RANK regions by store count. */
/* Q74. RANK employees by salary descending and keep only rank <= 3 per department. */
/* Q75. Compare RANK vs DENSE_RANK on customer tiers (lots of ties). */

/* ============================================================
   SECTION D: NTILE & TOP-N (25)
   ------------------------------------------------------------ */
/* Q76. NTILE(4) to split products into 4 price quartiles. */
/* Q77. NTILE(10) to split customers into spend deciles (join orders). */
/* Q78. NTILE(3) to split employees into low/mid/high salary bands. */
/* Q79. Label NTILE(4) buckets as Q1..Q4 with a CASE. */
/* Q80. NTILE(5) on order net_total; show the boundary values per bucket. */
/* Q81. Top-3 highest-paid employees per department (ROW_NUMBER <= 3). */
/* Q82. Top-3 products by price per brand. */
/* Q83. Top-2 most recent orders per customer. */
/* Q84. Top-5 stores by revenue per region (rank pre-aggregated revenue). */
/* Q85. Bottom-3 products by price per brand (ascending rank). */
/* Q86. NTILE(4) of customers by registration_date (signup cohorts by quartile). */
/* Q87. Second-highest-priced product overall (rn = 2). */
/* Q88. Second-highest salary per department. */
/* Q89. NTILE(100) to approximate percentile rank of order values. */
/* Q90. Top-1 review (highest rating, latest) per product. */
/* Q91. NTILE(4) of products by cost_price within each brand. */
/* Q92. Top-3 longest calls per agent. */
/* Q93. Top-N with a deterministic tie-break (ROW_NUMBER vs RANK choice). */
/* Q94. NTILE(2) to split orders into "above/below median" halves. */
/* Q95. Top-10 customers by points_balance, numbered. */
/* Q96. Bucket stores into 4 size tiers with NTILE on square_ft. */
/* Q97. Top-3 brands by product count. */
/* Q98. NTILE(4) of employees by salary within each store. */
/* Q99. Keep only the 3rd-ranked product by price per brand (exactly nth). */
/* Q100. Build spend quartile labels per customer (NTILE(4) + CASE) - RFM preview. */

/* ============================================================
   END OF Window Functions Part 1 - EASY LEVEL (100 QUESTIONS)
============================================================ */
