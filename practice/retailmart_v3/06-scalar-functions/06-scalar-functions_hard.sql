/* ============================================================
   SQL PRACTICE SET - Scalar Functions (String & Date) (HARD LEVEL)
   Curriculum:   RetailMart V3
   Topic:        Scalar Functions - advanced (string + date + regex)
   Database:     RetailMart V3

   Scope (HARD):
     - Regex (~, ~*, regexp_match, regexp_replace, regexp_split_to_array)
     - Advanced date arithmetic (intervals, age, business days, time zones)
     - String parsing for real data (emails, phones, addresses)
     - JSON <-> TEXT conversions
     - Encoding (md5, sha256, base64, encode/decode)
     - Functional/expression indexes
     - GENERATED columns from functions

   Structure: 25 Conceptual + 25 Regex/String advanced + 25 Date/Time advanced + 25 Real-world data cleaning
   ============================================================ */

/* ============================================================
   SECTION A: SCALAR FUNCTIONS - CONCEPTUAL (25)
   ------------------------------------------------------------ */
/* Q1.  What's the difference between LIKE, ILIKE, ~, ~*, ~~, ~~* in Postgres? */
/* Q2.  Compare regexp_match vs regexp_matches - which returns multiple? */
/* Q3.  Explain regexp_split_to_array vs string_to_array. */
/* Q4.  Why does \d work in Postgres regex but \d+ inside SQL string needs '\\d+'? */
/* Q5.  What is the SUBSTRING(... FROM regex) form - and how is it useful? */
/* Q6.  Compare to_char(now(), 'YYYY-MM-DD') vs ::date - both for date display. */
/* Q7.  Explain AGE(end, start) - what does it return vs (end - start)? */
/* Q8.  Compare INTERVAL '1 month' vs INTERVAL '30 days' - when do they differ? */
/* Q9.  Why does CURRENT_TIMESTAMP return the txn-start time, not now()? */
/* Q10. Compare now() vs statement_timestamp() vs clock_timestamp(). */
/* Q11. Explain AT TIME ZONE - when does it convert vs assign? */
/* Q12. What is DATE_TRUNC('week', ts) - and which day starts the week in Postgres? */
/* Q13. How do you compute "business days between two dates" - give a SQL approach. */
/* Q14. What is EXTRACT(EPOCH FROM ts) - and when is it useful? */
/* Q15. Compare md5() vs sha256() (with pgcrypto) - when does each apply? */
/* Q16. What is encode(bytea, 'hex' | 'base64') - and decode() reverse. */
/* Q17. Explain url_encode (via plpgsql) - Postgres doesn't ship it; how do you build it? */
/* Q18. What is to_tsvector - and why is it needed for full-text search? */
/* Q19. Why are functional indexes (CREATE INDEX ON t(lower(email))) essential for sargable LOWER queries? */
/* Q20. Compare CAST(x AS TYPE) vs x::TYPE - when does each fail differently. */
/* Q21. What is FORMAT() - when is it preferred over string concatenation? */
/* Q22. Explain how STRING_AGG with ORDER BY produces ordered concatenated lists. */
/* Q23. Compare JSON_BUILD_OBJECT vs ROW_TO_JSON - when each. */
/* Q24. Explain GENERATED ALWAYS AS (lower(email)) STORED - when use it. */
/* Q25. What is the IMMUTABLE / STABLE / VOLATILE function classification - and why does it matter for indexes? */

/* ============================================================
   SECTION B: REGEX & STRING ADVANCED (25)
   ------------------------------------------------------------ */
/* Q26. Validate email with regex: SELECT email FROM customers WHERE email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'. */
/* Q27. Extract domain from email using regexp_match. */
/* Q28. Extract phone country code: regexp_match(phone, '^\+(\d{1,3})'). */
/* Q29. Split full_name into first/last/middle via regexp_split_to_array. */
/* Q30. Find customers whose email contains digits: WHERE email ~ '\d'. */
/* Q31. Strip non-digit characters from phone: regexp_replace(phone, '\D', '', 'g'). */
/* Q32. Mask middle of phone: regexp_replace(phone, '(.{3})(.+)(.{2})', '\1***\3'). */
/* Q33. Extract hashtags from a review_text: regexp_matches(review_text, '#(\w+)', 'g'). */
/* Q34. Find customers with consecutive duplicate letters: WHERE full_name ~ '([a-z])\1'. */
/* Q35. Validate Indian PIN code: WHERE pin_code ~ '^\d{6}$'. */
/* Q36. Find emails with uncommon TLDs: WHERE email !~ '\.(com|net|org|in)$'. */
/* Q37. Replace whitespace with underscore: regexp_replace(name, '\s+', '_', 'g'). */
/* Q38. Extract numbers from product codes: regexp_replace(code, '[^0-9]', '', 'g'). */
/* Q39. Find duplicate words in subject: WHERE subject ~ '\\m(\\w+)\\M.*\\1'. */
/* Q40. Use SIMILAR TO for SQL-standard pattern: WHERE name SIMILAR TO '[A-Z][a-z]+'. */
/* Q41. Build a "slug" from a title: lower(regexp_replace(title, '\W+', '-', 'g')). */
/* Q42. Extract third word: split_part(text, ' ', 3). */
/* Q43. Find palindrome strings: WHERE col = reverse(col). */
/* Q44. Count vowels in a string: char_length(col) - char_length(regexp_replace(col, '[aeiou]', '', 'gi')). */
/* Q45. Truncate string at first whitespace: split_part(col, ' ', 1). */
/* Q46. CASE-INSENSITIVE email match using LOWER + functional index. */
/* Q47. URL-encode a parameter (DIY using regexp_replace). */
/* Q48. Title-case a name: initcap(lower(full_name)). */
/* Q49. Strip diacritics: unaccent(col) - requires unaccent extension. */
/* Q50. Levenshtein distance for fuzzy match (requires fuzzystrmatch). */

/* ============================================================
   SECTION C: DATE/TIME ADVANCED (25)
   ------------------------------------------------------------ */
/* Q51. AGE between created_at and now: SELECT AGE(now(), created_at). */
/* Q52. EXTRACT(YEAR/MONTH/DAY/HOUR FROM ts) - all four in one row. */
/* Q53. Compute customer tenure in years: AGE(now(), created_at) -> EXTRACT(YEAR FROM ...). */
/* Q54. Truncate timestamp to start of month / quarter / year. */
/* Q55. Generate series of dates: SELECT generate_series('2025-01-01', '2025-12-31', '1 day')::date. */
/* Q56. Find last day of the month: DATE_TRUNC('month', d) + INTERVAL '1 month' - INTERVAL '1 day'. */
/* Q57. Compute end_of_week from any given date. */
/* Q58. Compute "business days" between two dates (exclude Sat/Sun). */
/* Q59. Subtract 90 days: now() - INTERVAL '90 days' vs now() - INTERVAL '3 months'. */
/* Q60. Bucket orders by hour of day: EXTRACT(HOUR FROM order_date). */
/* Q61. Convert UTC timestamp to IST: ts AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Kolkata'. */
/* Q62. Find first Monday of each month using DATE_TRUNC + day-of-week math. */
/* Q63. Compute "is_weekend": EXTRACT(DOW FROM d) IN (0, 6). */
/* Q64. Compute days_to_due: (due_date - CURRENT_DATE). */
/* Q65. ISO week number: EXTRACT(ISOWEEK FROM ts) or to_char(ts, 'IYYY-IW'). */
/* Q66. Compute "fiscal quarter" starting April: CASE-based on month. */
/* Q67. Snap timestamp to 15-minute bucket. */
/* Q68. Subtract intervals: AGE('2025-12-31', '2025-01-01') vs '2025-12-31' - '2025-01-01'. */
/* Q69. Compute time-of-day buckets: morning/afternoon/evening/night via CASE on EXTRACT(HOUR ...). */
/* Q70. Find orders placed in last 30 minutes. */
/* Q71. Find shipments older than 30 days. */
/* Q72. Convert epoch seconds to timestamp: to_timestamp(1700000000). */
/* Q73. Find overlap of two date ranges: GREATEST(start1,start2), LEAST(end1,end2). */
/* Q74. Compute "stay duration" in hours: EXTRACT(EPOCH FROM (end - start)) / 3600. */
/* Q75. Compute moving window dates: a date and date - INTERVAL '7 days'. */

/* ============================================================
   SECTION D: REAL-WORLD DATA CLEANING (25)
   ------------------------------------------------------------ */
/* Q76. Normalize emails: LOWER(TRIM(email)). */
/* Q77. Normalize phone: keep only digits, prepend +91 if missing. */
/* Q78. Clean full_name: TRIM + INITCAP + remove extra spaces. */
/* Q79. Find customers with leading/trailing whitespace in name (LENGTH(full_name) <> LENGTH(TRIM(full_name))). */
/* Q80. Find double-spaced names: WHERE full_name ~ '  '. */
/* Q81. Detect emails with no '@': WHERE email NOT LIKE '%@%'. */
/* Q82. Detect non-ASCII characters in names: WHERE full_name ~ '[^\x00-\x7F]'. */
/* Q83. Detect city names with unusual capitalization. */
/* Q84. Strip non-alphanumeric from product codes. */
/* Q85. Hash email for anonymization: md5(email). */
/* Q86. Hash phone with sha256 (requires pgcrypto): encode(digest(phone, 'sha256'), 'hex'). */
/* Q87. Base64-encode a JSON payload: encode(payload_text::bytea, 'base64'). */
/* Q88. Find inconsistent date formats: e.g., column stored as TEXT vs DATE - find unparseable. */
/* Q89. Detect orphan email domains: domains appearing < 3 times. */
/* Q90. Detect impossible dates: birth_date > now() or birth_date < '1900-01-01'. */
/* Q91. Compute customer age from date_of_birth (EXTRACT year from age()). */
/* Q92. Auto-derive birth_year using LEFT(SSN-equivalent, 4) - not real, just a parsing exercise. */
/* Q93. Auto-fix capitalization on city using INITCAP. */
/* Q94. Combine first/last/middle into full_name with NULL-safe concatenation. */
/* Q95. Build "display name" rule: prefer full_name, fall back to email prefix. */
/* Q96. Build a search-index column: lower(full_name) || ' ' || lower(email) || ' ' || phone. */
/* Q97. Build a GENERATED column for a normalized email. */
/* Q98. Find rows where a JSON field is malformed (JSONB validation). */
/* Q99. Identify columns where TRIM changes the value (whitespace bugs). */
/* Q100. Build a "data quality report" - single row showing counts: bad_emails, missing_phones, dupe_names. */

/* ============================================================
   END OF Scalar Functions (String & Date) - HARD LEVEL (100 QUESTIONS)
============================================================ */
