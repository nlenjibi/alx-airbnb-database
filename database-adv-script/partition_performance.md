# Partition Performance Notes

How to test partitioning improvements after moving `bookings` into a partitioned table.

1. Establish baseline (pre-partition):

```sql
-- Measure an example query that filters by a date range
EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE check_in >= DATE '2025-01-01' AND check_in < DATE '2026-01-01';
```

Record planning time, execution time, and whether sequential scans are used.

2. Create partitioned table and move the data (see `partitioning.sql`).

3. Re-run the same query against the partitioned table:

```sql
EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned
WHERE check_in >= DATE '2025-01-01' AND check_in < DATE '2026-01-01';
```

4. What to look for:

- Partition pruning: planner should avoid scanning partitions outside the requested range.
- Reduced planning/execution time and fewer rows scanned.

5. Caveats:

- Small datasets may not show meaningful gains; partitioning shines with very large tables.
- Keep per-partition indexes if you need index-backed predicates.
