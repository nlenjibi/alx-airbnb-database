-- JOINs examples for alx-airbnb-database

-- 1) INNER JOIN: Retrieve all bookings and the respective users who made those bookings.
-- Returns only bookings that have a matching user (guest).

SELECT
  b.id AS booking_id,
  b.property_id,
  b.guest_id,
  b.check_in,
  b.check_out,
  b.total_price,
  b.status,
  u.email AS guest_email,
  u.full_name AS guest_name
FROM bookings b
INNER JOIN users u
  ON b.guest_id = u.id
ORDER BY b.check_in DESC;

-- 2) LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews.
-- For properties with multiple reviews this will return one row per review; to aggregate use GROUP BY/HAVING.

SELECT
  p.id AS property_id,
  p.title,
  p.city,
  r.id AS review_id,
  r.author_id AS reviewer_id,
  r.rating,
  r.comment
FROM properties p
LEFT JOIN reviews r
  ON p.id = r.property_id
ORDER BY p.title;

-- 2b) LEFT JOIN with aggregated reviews (one row per property, review stats):

SELECT
  p.id AS property_id,
  p.title,
  COALESCE(avg_stats.avg_rating, 0)::numeric(3,2) AS avg_rating,
  COALESCE(avg_stats.review_count, 0) AS review_count
FROM properties p
LEFT JOIN (
  SELECT property_id, AVG(rating) AS avg_rating, COUNT(*) AS review_count
  FROM reviews
  GROUP BY property_id
) AS avg_stats
  ON p.id = avg_stats.property_id
ORDER BY avg_rating DESC NULLS LAST;

-- 3) FULL OUTER JOIN: Retrieve all users and all bookings,
-- even if a user has no booking or a booking is not linked to a user.
-- NOTE: In this schema bookings.guest_id is NOT NULL and references users(id), so true unmatched bookings are unlikely
-- unless data is inconsistent; this query demonstrates the pattern.

SELECT
  u.id AS user_id,
  u.email,
  u.full_name,
  b.id AS booking_id,
  b.property_id,
  b.check_in,
  b.check_out,
  b.status
FROM users u
FULL OUTER JOIN bookings b
  ON u.id = b.guest_id
ORDER BY u.full_name NULLS LAST, b.check_in NULLS LAST;