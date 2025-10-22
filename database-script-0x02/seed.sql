-- AirBnB Clone Sample Data Seed (PostgreSQL)
-- Ensure schema from database-script-0x01/schema.sql is already applied
-- This seed uses explicit UUIDs and is idempotent via ON CONFLICT DO NOTHING on PKs

BEGIN;

-- Users
INSERT INTO users (id, email, full_name, hashed_password, is_host, phone, created_at, updated_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'alice.host@example.com', 'Alice Host', '$2b$12$OQJf9fFv1r1hFf7l0uSj/.9Qy8i5t4Hn7g3s8y6y0F4Vq3Q1y7yRe', TRUE, '+1-415-555-0101', now(), now()),
  ('22222222-2222-2222-2222-222222222222', 'bob.guest@example.com', 'Bob Guest', '$2b$12$OQJf9fFv1r1hFf7l0uSj/.9Qy8i5t4Hn7g3s8y6y0F4Vq3Q1y7yRe', FALSE, '+1-415-555-0102', now(), now()),
  ('33333333-3333-3333-3333-333333333333', 'carol.guest@example.com', 'Carol Guest', '$2b$12$OQJf9fFv1r1hFf7l0uSj/.9Qy8i5t4Hn7g3s8y6y0F4Vq3Q1y7yRe', FALSE, '+1-415-555-0103', now(), now())
ON CONFLICT (id) DO NOTHING;

-- Properties (owned by Alice)
INSERT INTO properties (
  id, host_id, title, description, address_line, city, state, country, latitude, longitude, price_per_night, capacity, created_at, updated_at
) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111',
   'Sunny Loft in Mission', 'Bright loft near cafes and public transit.',
   '123 Valencia St', 'San Francisco', 'CA', 'USA', 37.7599, -122.4148, 180.00, 3, now(), now()),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111',
   'Cozy Cabin by the Lake', 'Relaxing cabin with fireplace and deck.',
   '45 Pine Cone Rd', 'Lake Tahoe', 'CA', 'USA', 39.0968, -120.0324, 240.00, 5, now(), now())
ON CONFLICT (id) DO NOTHING;

-- Amenities
INSERT INTO amenities (id, name, description) VALUES
  ('a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a1', 'Wi-Fi', 'High-speed wireless internet'),
  ('b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b2', 'Kitchen', 'Full kitchen with cookware'),
  ('c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c3', 'Air Conditioning', 'Central air conditioning'),
  ('d4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d4', 'Washer', 'In-unit washer'),
  ('e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e5', 'Free Parking', 'Free street/lot parking'),
  ('f6f6f6f6-f6f6-4f6f-f6f6-f6f6f6f6f6f6', 'Pet Friendly', 'Pets allowed')
ON CONFLICT (id) DO NOTHING;

-- Property Amenities
INSERT INTO property_amenities (property_id, amenity_id) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a1a1a1a1-a1a1-4a1a-a1a1-a1a1a1a1a1a1'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b2'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'c3c3c3c3-c3c3-4c3c-c3c3-c3c3c3c3c3c3'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'b2b2b2b2-b2b2-4b2b-b2b2-b2b2b2b2b2b2'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'd4d4d4d4-d4d4-4d4d-d4d4-d4d4d4d4d4d4'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'e5e5e5e5-e5e5-4e5e-e5e5-e5e5e5e5e5e5')
ON CONFLICT DO NOTHING;

-- Property Images
INSERT INTO property_images (id, property_id, url, caption, is_cover, created_at) VALUES
  ('1111aaaa-2222-bbbb-3333-ccccdddd0001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'https://pics.example.com/mission-loft-1.jpg', 'Living area', TRUE, now()),
  ('1111aaaa-2222-bbbb-3333-ccccdddd0002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'https://pics.example.com/mission-loft-2.jpg', 'Bedroom', FALSE, now()),
  ('1111aaaa-2222-bbbb-3333-ccccdddd0003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'https://pics.example.com/lake-cabin-1.jpg', 'Exterior deck', TRUE, now())
ON CONFLICT (id) DO NOTHING;

-- Bookings (one past completed, one upcoming confirmed)
INSERT INTO bookings (
  id, property_id, guest_id, check_in, check_out, total_price, status, created_at, updated_at
) VALUES
  ('44444444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222',
   DATE '2025-05-10', DATE '2025-05-13', 540.00, 'completed', now(), now()), -- 3 nights x 180
  ('55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '33333333-3333-3333-3333-333333333333',
   DATE '2025-11-01', DATE '2025-11-04', 720.00, 'confirmed', now(), now()) -- 3 nights x 240
ON CONFLICT (id) DO NOTHING;

-- Payments (one for each booking)
INSERT INTO payments (id, booking_id, amount, currency, payment_provider, status, transaction_id, created_at) VALUES
  ('66666666-6666-6666-6666-666666666666', '44444444-4444-4444-4444-444444444444', 540.00, 'USD', 'stripe', 'succeeded', 'pi_540_demo_1', now()),
  ('77777777-7777-7777-7777-777777777777', '55555555-5555-5555-5555-555555555555', 720.00, 'USD', 'stripe', 'succeeded', 'pi_720_demo_2', now())
ON CONFLICT (id) DO NOTHING;

-- Reviews (for the completed past booking)
INSERT INTO reviews (id, property_id, author_id, rating, comment, created_at) VALUES
  ('88888888-8888-8888-8888-888888888888', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 5,
   'Fantastic stay! Super clean and close to everything.', now())
ON CONFLICT (id) DO NOTHING;

COMMIT;
