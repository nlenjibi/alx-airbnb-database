# Database Normalization for AirBnB Clone

This document explains ER diagrams, normalization steps to reach Third Normal Form (3NF), and provides a normalized SQL schema for the AirBnB Clone project.

## 1. ER Overview

Entities:

- Users
- Properties
- Bookings
- Payments
- Reviews
- PropertyImages
- Amenities
- PropertyAmenities (join table)

ASCII ER Diagram (simplified)

```
Users (user_id PK) 1---< Properties (property_id PK) >---* PropertyImages
      |                            |
      |                            >---< PropertyAmenities >--- Amenities
      |
      >---< Bookings (booking_id PK) >--- Payments
                 |
                 >---< Reviews
```

Notes:

- One User can have many Properties (when a user is a host).
- One Property has many Bookings.
- One Booking has one Payment (simplified assumption; could be many for partial payments).
- Reviews are tied to Properties and authored by Users.
- Amenities are many-to-many with Properties.

## 2. Normalization steps

Goal: Achieve 3NF (Third Normal Form). We'll walk through key tables and how they comply with 1NF, 2NF, and 3NF.

1NF (atomic values and unique rows)

- Ensure each table's columns contain atomic values (e.g., avoid storing comma-separated city/state in a single column).
- Use unique primary keys (UUIDs recommended for distributed systems).

2NF (remove partial dependencies)

- For composite keys, ensure non-key attributes depend on the whole key. In our design we generally use single-column UUID primary keys, so partial dependency issues are minimal.

3NF (remove transitive dependencies)

- Remove attributes that depend on other non-key attributes. Example: avoid storing `host_full_name` inside `Properties` — that belongs in `Users`.

### Example: Bookings table normalization

Initial naive Booking row might contain: booking_id, property_id, property_title, host_id, guest_id, guest_email, check_in, check_out, total_price

- `property_title` duplicates data from Properties -> move to Properties table
- `host_id` can be found through Properties.host_id -> do not store host_id directly in bookings unless denormalized for performance with careful constraints
- `guest_email` duplicates Users.email -> remove and join to Users when needed

After normalization, Bookings stores: booking_id (PK), property_id (FK), guest_id (FK), check_in, check_out, total_price, status

## 3. Normalized SQL Schema (PostgreSQL)

Below are CREATE TABLE statements following 3NF. Types chosen for clarity; adjust sizes/precision as needed.

```sql
-- Extensions (if using UUIDs)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) NOT NULL UNIQUE,
  full_name VARCHAR(255) NOT NULL,
  hashed_password VARCHAR(255) NOT NULL,
  is_host BOOLEAN NOT NULL DEFAULT FALSE,
  phone VARCHAR(30),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Properties
CREATE TABLE properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  host_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  address_line VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  latitude NUMERIC(9,6),
  longitude NUMERIC(9,6),
  price_per_night NUMERIC(10,2) NOT NULL,
  capacity INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Property Images
CREATE TABLE property_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  caption TEXT,
  is_cover BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Amenities
CREATE TABLE amenities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT
);

-- PropertyAmenities (many-to-many)
CREATE TABLE property_amenities (
  property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  amenity_id UUID NOT NULL REFERENCES amenities(id) ON DELETE CASCADE,
  PRIMARY KEY (property_id, amenity_id)
);

-- Bookings
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  guest_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  total_price NUMERIC(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  CONSTRAINT check_dates CHECK (check_out > check_in)
);

-- Payments
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  amount NUMERIC(10,2) NOT NULL,
  currency VARCHAR(10) NOT NULL DEFAULT 'USD',
  payment_provider VARCHAR(50),
  status VARCHAR(30) NOT NULL,
  transaction_id VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Reviews
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_properties_host ON properties(host_id);
CREATE INDEX idx_bookings_property ON bookings(property_id);
CREATE INDEX idx_bookings_guest ON bookings(guest_id);
CREATE INDEX idx_bookings_dates ON bookings(check_in, check_out);
```

## 4. Notes on Denormalization & Performance

- Denormalization (copying fields into child tables) can improve read performance for read-heavy endpoints (e.g., storing `property_title` in bookings). Use sparingly and maintain sync via triggers or application logic.
- Use partial indexes for common query patterns (e.g., active bookings where status='confirmed').
- Consider materialized views for aggregations (average ratings per property).
- Use Redis for caching frequent reads (property lists, property details) and Celery for background tasks (index updates, batch calculations).

## 5. How to proceed (practical)

1. Create migrations from Django models based on the schema above.
2. Add model tests for constraints (date checks, rating bounds).
3. Add CI steps that run tests with a PostgreSQL test instance (use GitHub Actions + services or Testcontainers).

---

This `normalization.md` should be added to the repository as requested, and the SQL schema adapted to match your final Django models and project conventions.
