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
