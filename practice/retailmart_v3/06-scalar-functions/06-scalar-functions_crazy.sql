/* ============================================================
   SQL PRACTICE SET - Scalar Functions (String & Date) (CRAZY LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Scalar Functions - advanced string & date (built-ins)
   Database:     RetailMart V3

   Scope (CRAZY = staff-level scalar functions, built-ins only):
     - Advanced POSIX regex (captures, backreferences, splits, SIMILAR TO)
     - String transformation & formatting (translate/overlay/format/encode/to_char)
     - Date/time mastery (to_char/AGE/EXTRACT/generate_series/intervals/zones)
     - Full-text search QUERIES (to_tsvector/to_tsquery/ts_rank - core built-ins)
   Extension-only techniques (pg_trgm %/<->, fuzzystrmatch levenshtein/soundex,
   pgcrypto digest/crypt) are shown as "run in your accio_NN DB" notes - they
   need extensions not enabled on the shared read-only RetailMart. Persisting a
   tsvector column / GIN index is a Day-20 (indexing) task, also done in accio_NN.

   Structure: 25 Regex + 25 String transform + 25 Date/time + 25 FTS & matching toolkit
   ============================================================ */

/* ============================================================
   SECTION A: ADVANCED REGEX (25)
   ------------------------------------------------------------ */
/* Q1.  Validate e-mail shape with an anchored POSIX pattern. */
/* Q2.  Capture the e-mail domain with regexp_match. */
/* Q3.  Extract a leading +country-code from a phone (capture group). */
/* Q4.  Split a full name into a token array on whitespace. */
/* Q5.  Extract ALL hashtags from a review (global flag). */
/* Q6.  Find names containing a doubled letter (backreference). */
/* Q7.  Strip every non-digit from a phone. */
/* Q8.  Mask a phone keeping first 3 + last 2 (replacement backrefs). */
/* Q9.  Emails whose local part contains a digit. */
/* Q10. Emails NOT ending in .com/.net/.org/.in (negated match). */
/* Q11. SIMILAR TO: a single capitalised word. */
/* Q12. Slugify a ticket subject (non-word runs -> '-'). */
/* Q13. Subjects containing the same word twice (word-boundary + backref). */
/* Q14. Count vowels in a name via length difference. */
/* Q15. First whitespace token of the full name. */
/* Q16. Palindrome check over a VALUES list (reverse). */
/* Q17. Names containing a non-ASCII character. */
/* Q18. Valid 6-digit pincode (addresses). */
/* Q19. SUBSTRING(... FROM pattern) to capture the domain. */
/* Q20. Capitalise the first letter via regexp_replace. */
/* Q21. Case-insensitive keyword match in review text (~*). */
/* Q22. Word count per review via regexp split + array_length. */
/* Q23. Extract all numbers from free text. */
/* Q24. Anchored alternation to validate an order status. */
/* Q25. Find product names with leading/trailing whitespace. */

/* ============================================================
   SECTION B: STRING TRANSFORMATION & FORMATTING (25)
   ------------------------------------------------------------ */
/* Q26. Build a display name with concat_ws + NULLIF. */
/* Q27. Build a log line with format() positional specifiers. */
/* Q28. Zero-pad an order id to width 10 (lpad). */
/* Q29. Strip a set of characters in one pass (translate). */
/* Q30. Mask an email by position (overlay). */
/* Q31. Normalise a city name with initcap+lower (addresses). */
/* Q32. left/right slicing of an email. */
/* Q33. Email domain via split_part (no regex). */
/* Q34. string_to_array / array_to_string round-trip. */
/* Q35. encode/decode hex round-trip. */
/* Q36. encode/decode base64 round-trip. */
/* Q37. URL-safe base64 via translate. */
/* Q38. Built-in md5() email fingerprint (no pgcrypto). */
/* Q39. Currency-style numeric formatting with to_char. */
/* Q40. Text bar chart of orders per store (repeat). */
/* Q41. ascii()/chr() round-trip. */
/* Q42. starts_with() + length filter on emails. */
/* Q43. btrim/ltrim/rtrim variants. */
/* Q44. Extract the TLD via reverse + split. */
/* Q45. Locate '@' with position(). */
/* Q46. Normalise a phone to +91XXXXXXXXXX. */
/* Q47. Clean a name: collapse whitespace + initcap. */
/* Q48. Human date label via to_char. */
/* Q49. Compose a lowercase search blob from several columns. */
/* Q50. Compare char_length vs octet_length (multibyte). */

/* ============================================================
   SECTION C: DATE/TIME MASTERY (25)
   ------------------------------------------------------------ */
/* Q51. AT TIME ZONE round-trip on a real timestamp (calls). */
/* Q52. Convert a timestamptz literal to a wall-clock in another zone. */
/* Q53. Last business day of the current month. */
/* Q54. Quarter of a date shifted back 3 months. */
/* Q55. ISO week vs US week. */
/* Q56. Epoch (with fraction) to timestamp. */
/* Q57. Month-over-month revenue via FILTER. */
/* Q58. make_date / make_timestamp constructors. */
/* Q59. justify_interval on 90 days. */
/* Q60. Leap-year test via the calendar rule. */
/* Q61. Format an interval as HHh MMm SSs. */
/* Q62. 15-minute bucket of a real timestamp (page_views). */
/* Q63. Round a timestamp to the nearest 5 minutes. */
/* Q64. DST-aware arithmetic on timestamptz. */
/* Q65. Convert an order DATE to a zoned date. */
/* Q66. Show two timestamptz literals are the same instant. */
/* Q67. Business-day count in a month (weekends excluded). */
/* Q68. Generate a full year of dates. */
/* Q69. Next Monday from today (ISODOW). */
/* Q70. Previous Friday from today. */
/* Q71. Quarterly date series. */
/* Q72. Account age in months from registration_date. */
/* Q73. Business days a ticket stayed open. */
/* Q74. Safe day-add across a month boundary. */
/* Q75. AGE() vs subtraction (calendar-aware vs exact days). */

/* ============================================================
   SECTION D: FULL-TEXT SEARCH + MATCHING/HASHING TOOLKIT (25)
   ------------------------------------------------------------ */
/* Q76. Show stemming: 'running runs ran' -> 'run' (to_tsvector). */
/* Q77. Reviews matching phone AND repair (inline tsvector @@ tsquery). */
/* Q78. Rank full-text results with ts_rank. */
/* Q79. Highlight matches with ts_headline. */
/* Q80. Prefix full-text search ('phon:*'). */
/* Q81. Negation in a tsquery (phone & !repair). */
/* Q82. Phrase search with phraseto_tsquery. */
/* Q83. Google-style search with websearch_to_tsquery. */
/* Q84. plainto_tsquery vs to_tsquery. */
/* Q85. Weighted full-text over ticket subject (setweight). */
/* Q86. Full-text + scalar filter (rating >= 4). */
/* Q87. Stemming across english vs simple configs. */
/* Q88. Generate a UUID token (built-in gen_random_uuid). */
/* Q89. (accio_NN) Persist a tsvector column + GIN index for fast search. */
/* Q90. (accio_NN) Create a custom text-search configuration (DDL + unaccent). */
/* Q91. (accio_NN) Trigram similarity() and % operator (pg_trgm). */
/* Q92. (accio_NN) Trigram distance ordering <-> with a GiST index. */
/* Q93. (accio_NN) Edit distance with levenshtein (fuzzystrmatch). */
/* Q94. (accio_NN) Phonetic matching: soundex/metaphone/dmetaphone. */
/* Q95. (accio_NN) SHA-256 / HMAC with pgcrypto. */
/* Q96. (accio_NN) bcrypt password hashing with crypt + gen_salt. */
/* Q97. (accio_NN) Symmetric encryption with pgp_sym_encrypt. */
/* Q98. Describe a fuzzy near-duplicate detection pipeline (conceptual). */
/* Q99. Describe a search-bar FTS-then-trigram fallback pattern (conceptual). */
/* Q100. Build a privacy-safe customer export using only built-ins (md5 + base64). */

/* ============================================================
   END OF Scalar Functions (String & Date) - CRAZY LEVEL (100 QUESTIONS)
============================================================ */
