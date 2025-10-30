# Index Performance Measurement

How to measure query performance before and after adding indexes.

1. Pick a representative query. Example: list bookings with user and property:

```sql
EXPLAIN ANALYZE
SELECT b.id, b.check_in, b.check_out, b.total_price, u.email, p.title
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
WHERE b.check_in >= DATE '2025-01-01' AND b.check_in < DATE '2026-01-01';
```

2. Save the output (execution time, planning time, rows, and any index scans/seq scans).

3. Apply the indexes from `database_index.sql` (run the file in psql or your client).

4. Re-run the same EXPLAIN ANALYZE and compare:

   - Look for changes from SEQ SCAN to INDEX SCAN.
   - Compare 'Total runtime' / 'actual time' (planning+execution) numbers.
   - If added indexes increased planning time or did not change scan type, consider different index strategy.

5. Example commands (psql):

```powershell
# Run original explain
psql -d yourdb -c "EXPLAIN ANALYZE SELECT ..."

# Apply indexes
psql -d yourdb -f database-adv-script/database_index.sql

# Run explain again
psql -d yourdb -c "EXPLAIN ANALYZE SELECT ..."
```

Notes and caveats:

- Indexes help when they cover the query predicates and/or ordering. They add overhead to INSERT/UPDATE/DELETE.
- For large tables, consider BRIN indexes (for naturally clustered data like dates) or partial indexes for common predicates.
- Use `EXPLAIN` first (no execution) to see planner choices, then `EXPLAIN ANALYZE` to measure real execution.
