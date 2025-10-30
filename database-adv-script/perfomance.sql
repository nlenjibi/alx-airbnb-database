-- Initial (unoptimized) complex query that retrieves bookings with user, property and payment details

-- This query returns a wide result set and is a good starting point for EXPLAIN/ANALYZE.

SELECT
  b.id AS booking_id,
  b.check_in,
  b.check_out,
  b.total_price,
  b.status AS booking_status,
  u.id AS guest_id,
  u.full_name AS guest_name,
  u.email AS guest_email,
  p.id AS property_id,
  p.title AS property_title,
  p.city AS property_city,
  pay.id AS payment_id,
  pay.amount AS payment_amount,
  pay.status AS payment_status
FROM bookings b
JOIN users u
  ON b.guest_id = u.id
JOIN properties p
  ON b.property_id = p.id
LEFT JOIN payments pay
  ON pay.booking_id = b.id
ORDER BY b.check_in DESC;

-- ---------------------------------------------------------------------------
-- Filtered variant (includes WHERE and AND) - realistic initial query for performance testing
-- Example: filter by a date range and booking status. This is useful for measuring index impact.

-- EXPLAIN ANALYZE
-- SELECT
--   b.id AS booking_id,
--   b.check_in,
--   b.check_out,
--   b.total_price,
--   b.status AS booking_status,
--   u.id AS guest_id,
--   u.full_name AS guest_name,
--   u.email AS guest_email,
--   p.id AS property_id,
--   p.title AS property_title,
--   p.city AS property_city,
--   pay.id AS payment_id,
--   pay.amount AS payment_amount,
--   pay.status AS payment_status
-- FROM bookings b
-- JOIN users u ON b.guest_id = u.id
-- JOIN properties p ON b.property_id = p.id
-- LEFT JOIN payments pay ON pay.booking_id = b.id
-- WHERE b.check_in >= DATE '2025-01-01'
--   AND b.check_in < DATE '2026-01-01'
--   AND b.status = 'confirmed'
-- ORDER BY b.check_in DESC;

-- Tips:
-- - Run the EXPLAIN ANALYZE before and after creating indexes (see database_index.sql).
-- - Adjust the date range and status to match your workload for representative results.
