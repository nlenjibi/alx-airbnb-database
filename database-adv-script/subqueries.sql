-- Subqueries (non-correlated and correlated) for alx-airbnb-database

-- 1) NON-CORRELATED SUBQUERY: Find all properties where the average rating is greater than 4.0
-- This uses a grouped subquery that returns property_ids meeting the condition, then selects properties.

SELECT p.*
FROM properties p
WHERE p.id IN (
  SELECT property_id
  FROM reviews
  GROUP BY property_id
  HAVING AVG(rating) > 4.0
)
ORDER BY p.title;

-- 2) CORRELATED SUBQUERY: Find users who have made more than 3 bookings.
-- This subquery references the outer query (users) and counts bookings per user.

SELECT u.*
FROM users u
WHERE (
  SELECT COUNT(*)
  FROM bookings b
  WHERE b.guest_id = u.id
) > 3
ORDER BY u.full_name;

-- Note: In the sample seed data there are only a few bookings; adjust the threshold when testing locally.
