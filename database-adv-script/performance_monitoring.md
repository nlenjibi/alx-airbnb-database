# Performance Monitoring and Refinement

This document describes commands and steps to monitor query performance and refine schema/indexes.

1. Use EXPLAIN and EXPLAIN ANALYZE frequently

- `EXPLAIN` shows the planner's chosen plan (no execution).
- `EXPLAIN ANALYZE` runs the query and returns execution timing and actual row counts.

Example:

```sql
EXPLAIN ANALYZE
SELECT b.id, u.email, p.title
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
WHERE b.check_in >= DATE '2025-01-01';
```

2. Use pg_stat_statements (recommended)

- Enable extension: `CREATE EXTENSION IF NOT EXISTS pg_stat_statements;`
- Query the view to find the most expensive statements:

  SELECT
  query,
  calls,
  total_time,
  mean_time,
  rows
  FROM pg_stat_statements
  ORDER BY total_time DESC
  LIMIT 20;

3. Common actions after identifying slow queries

- Add or modify indexes that match WHERE, JOIN, ORDER BY predicates.
- Reduce row width returned by queries (select only needed columns).
- Avoid unnecessary joins or de-duplicate joined rows if joins cause row multiplication.
- Consider materialized views for expensive aggregated reports.

4. Validate changes

- After making a change (index, query rewrite), run `EXPLAIN ANALYZE` again to verify improvements.

5. When changes are not sufficient

- Consider schema adjustments (denormalization), batching writes, or moving heavy analytical queries to a reporting replica.
