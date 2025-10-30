# Query Optimization Report

Files:

- `perfomance.sql` — initial complex query (wide SELECT across bookings, users, properties, payments).

Summary of findings (how to analyze and optimize):

1. Baseline

- Run `EXPLAIN` then `EXPLAIN ANALYZE` on the query in `perfomance.sql`.
- Note whether the planner uses SEQ SCAN on `bookings`, `users`, or `properties`.

2. Common inefficiencies

- Selecting all columns across joins causes more data to be materialized and transferred.
- LEFT JOIN to `payments` may produce row duplication when multiple payments exist per booking.
- Missing indexes on join/filter columns cause sequential scans.

3. Refactor suggestions

- Project only required columns instead of `SELECT *`-style wide selects.
- If you only need the most recent payment per booking, use LATERAL to fetch one row per booking:

  SELECT b.id, b.check_in, b.check_out, u.full_name, p.title, pay.amount
  FROM bookings b
  JOIN users u ON b.guest_id = u.id
  JOIN properties p ON b.property_id = p.id
  LEFT JOIN LATERAL (
  SELECT amount, status
  FROM payments
  WHERE booking_id = b.id
  ORDER BY created_at DESC
  LIMIT 1
  ) pay ON TRUE;

- Add appropriate indexes (see `database_index.sql`) to help the planner choose index scans.

4. Example targeted index

- If queries filter bookings by date range often, a composite index on (check_in, property_id) may help:

  CREATE INDEX IF NOT EXISTS idx_bookings_checkin_property ON bookings(check_in, property_id);

5. Re-run EXPLAIN ANALYZE and compare execution times, rows, and whether scans changed.

6. Additional tips

- Consider denormalizing or materialized views for heavy reporting queries.
- Keep an eye on write-heavy workloads: indexes speed reads but add overhead on writes.
