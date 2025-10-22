# AirBnB Clone Database Schema (DDL)

This folder contains the PostgreSQL DDL for the AirBnB Clone backend.

- File: `schema.sql` — Creates tables, constraints, and indexes for users, properties, bookings, payments, reviews, amenities, and images.
- Based on the normalized design described in `../normalization.md`.

## Prerequisites

- PostgreSQL 13+ (14+ recommended)
- A user with privileges to create extensions and tables

## Create database (optional)

```powershell
# Create a database named airbnb_clone (adjust user/host/port as needed)
psql -U postgres -h localhost -c "CREATE DATABASE airbnb_clone;"
```

## Apply schema

```powershell
# Run the schema against your database
psql -U postgres -h localhost -d airbnb_clone -f .\database-script-0x01\schema.sql
```

If `uuid-ossp` extension is not allowed by your DBA/policy, replace UUID generation with application-side UUIDs and remove the `CREATE EXTENSION` line.

## Tables overview

- `users`: accounts for guests and hosts (email unique, password hash, is_host)
- `properties`: listings with host FK, pricing, capacity, and location
- `property_images`: images per property, optional cover flag
- `amenities`: amenity catalog
- `property_amenities`: many-to-many link between properties and amenities
- `bookings`: reservations with date range and status
- `payments`: payment records per booking
- `reviews`: user-authored property reviews with rating constraints

## Indexes

- `users.email`
- `properties.host_id`
- `bookings.property_id`, `bookings.guest_id`, `(check_in, check_out)`

These support common lookups and date range queries.

## Next steps

- Implement models/migrations in Django to match this schema (or generate DDL from models).
- Add exclusion constraints for overlapping bookings per property if you plan to enforce it at the DB level (requires ranges + GiST index).
- Add additional partial indexes based on real query patterns (e.g., `status = 'confirmed'`).
