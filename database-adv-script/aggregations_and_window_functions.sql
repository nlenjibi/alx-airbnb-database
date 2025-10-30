-- Aggregation and Window Function examples

-- 1) Total number of bookings made by each user (COUNT + GROUP BY)
-- Use LEFT JOIN to include users with zero bookings.

SELECT
  u.id AS user_id,
  u.full_name,
  COALESCE(COUNT(b.id), 0) AS bookings_count
FROM users u
LEFT JOIN bookings b
  ON b.guest_id = u.id
GROUP BY u.id, u.full_name
ORDER BY bookings_count DESC;

-- 2) Rank properties based on total number of bookings they have received.
-- We compute bookings_count per property, then apply RANK() to order properties by popularity.

WITH property_bookings AS (
  SELECT property_id, COUNT(*) AS bookings_count
  FROM bookings
  GROUP BY property_id
)
SELECT
  p.id AS property_id,
  p.title,
  COALESCE(pb.bookings_count, 0) AS bookings_count,
  RANK() OVER (ORDER BY COALESCE(pb.bookings_count, 0) DESC) AS bookings_rank
FROM properties p
LEFT JOIN property_bookings pb
  ON p.id = pb.property_id
ORDER BY bookings_rank, bookings_count DESC;

-- Alternative: use ROW_NUMBER() if you need a strict ordering without ties.
