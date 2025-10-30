-- Example partitioning strategy for the bookings table (PostgreSQL declarative partitioning)

-- 1) Create a new partitioned table with the same structure (use caution in production)
-- Note: adjust types, constraints and defaults to match your current `bookings` table.

CREATE TABLE IF NOT EXISTS bookings_partitioned (
  id UUID PRIMARY KEY,
  property_id UUID NOT NULL,
  guest_id UUID NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  total_price NUMERIC(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (check_in);

-- 2) Create partitions (examples for 2024 and 2025 and a default partition).
CREATE TABLE IF NOT EXISTS bookings_p2024 PARTITION OF bookings_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE IF NOT EXISTS bookings_p2025 PARTITION OF bookings_partitioned
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE IF NOT EXISTS bookings_p_default PARTITION OF bookings_partitioned DEFAULT;

-- 3) Move existing data into the partitioned table (example, test first):
-- INSERT INTO bookings_partitioned SELECT * FROM bookings;

-- 4) After verifying data integrity and testing queries, you can drop or rename the old table
-- and rename bookings_partitioned to bookings; in production this requires downtime or careful migration.

-- 5) Query examples to test partition pruning:
-- EXPLAIN ANALYZE SELECT * FROM bookings_partitioned WHERE check_in >= '2025-01-01' AND check_in < '2026-01-01';

-- Notes:
-- - Partitioning helps queries that filter by the partition key (check_in) via partition pruning.
-- - For very large tables, partition maintenance (creating new partitions periodically) should be automated.
-- - Consider indexes on each partition if needed.
