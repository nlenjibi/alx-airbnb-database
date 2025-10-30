-- Suggested CREATE INDEX statements for high-usage columns
-- Some indexes may already exist in schema.sql; use IF NOT EXISTS to be safe.

-- Users: email is frequently searched/used for login
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Properties: host_id used when listing host's properties
CREATE INDEX IF NOT EXISTS idx_properties_host ON properties(host_id);
CREATE INDEX IF NOT EXISTS idx_properties_city ON properties(city);
CREATE INDEX IF NOT EXISTS idx_properties_price ON properties(price_per_night);

-- Bookings: common join/filter columns
CREATE INDEX IF NOT EXISTS idx_bookings_property ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_guest ON bookings(guest_id);
CREATE INDEX IF NOT EXISTS idx_bookings_checkin ON bookings(check_in);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- Payments: join on booking_id
CREATE INDEX IF NOT EXISTS idx_payments_booking ON payments(booking_id);

-- Reviews: lookup by property
CREATE INDEX IF NOT EXISTS idx_reviews_property ON reviews(property_id);
CREATE INDEX IF NOT EXISTS idx_reviews_author ON reviews(author_id);

-- Property images/amenities lookups
CREATE INDEX IF NOT EXISTS idx_property_images_property ON property_images(property_id);

-- Example: partial index for active/confirmed bookings (if queries frequently filter by status):
-- CREATE INDEX IF NOT EXISTS idx_bookings_confirmed ON bookings (check_in) WHERE status = 'confirmed';

-- Notes:
-- - Create indexes selectively and test with EXPLAIN/ANALYZE; indexes speed up reads but add write overhead.
-- - Consider composite indexes when queries filter on multiple columns in combination (e.g. property_id + check_in).

-- ---------------------------------------------------------------------------
-- Measurement guidance: run these steps to measure before/after index impact.
-- 1) Baseline (before applying indexes): run EXPLAIN or EXPLAIN ANALYZE on a representative query.
--    Replace the SELECT below with a query that matches your workload.
--
-- Example baseline query (run BEFORE applying indexes):
-- EXPLAIN ANALYZE
-- SELECT b.id, b.check_in, b.check_out, b.total_price, u.email, p.title
-- FROM bookings b
-- JOIN users u ON b.guest_id = u.id
-- JOIN properties p ON b.property_id = p.id
-- WHERE b.check_in >= DATE '2025-01-01' AND b.check_in < DATE '2026-01-01';
--
-- 2) Apply the indexes in this file (run this file or the CREATE INDEX statements above).
--    Example (psql): psql -d yourdb -f database-adv-script/database_index.sql
--
-- 3) Re-run the same EXPLAIN ANALYZE (AFTER applying indexes) and compare results.
--    Look for changes from SEQ SCAN to INDEX SCAN, lower 'actual time' and fewer rows scanned.
--
-- Quick psql workflow (PowerShell example):
-- ```powershell
-- # Baseline
-- psql -d yourdb -c "EXPLAIN ANALYZE SELECT b.id, b.check_in, b.check_out, b.total_price, u.email, p.title FROM bookings b JOIN users u ON b.guest_id = u.id JOIN properties p ON b.property_id = p.id WHERE b.check_in >= DATE '2025-01-01' AND b.check_in < DATE '2026-01-01';"
-- 
-- # Apply indexes
-- psql -d yourdb -f database-adv-script/database_index.sql
-- 
-- # After
-- psql -d yourdb -c "EXPLAIN ANALYZE SELECT b.id, b.check_in, b.check_out, b.total_price, u.email, p.title FROM bookings b JOIN users u ON b.guest_id = u.id JOIN properties p ON b.property_id = p.id WHERE b.check_in >= DATE '2025-01-01' AND b.check_in < DATE '2026-01-01';"
-- ```
--
-- Additional tips:
-- - Use EXPLAIN (no ANALYZE) first to inspect the plan without running the query.
-- - For repeatable measurements, run `SET client_min_messages = WARNING;` to suppress extra output and run the query multiple times to average.
-- - Consider running on a warm cache (run the query once then measure) and on a cold cache to see worst-case performance.
