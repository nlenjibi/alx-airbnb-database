# AirBnB Clone Sample Data (Seed)

This folder contains a PostgreSQL seed script that inserts realistic sample data for the AirBnB Clone database.

- File: `seed.sql` — Inserts users (hosts/guests), properties, amenities, property images, bookings, payments, and a review.
- It is idempotent (uses `ON CONFLICT DO NOTHING` on primary keys), so you can run it multiple times safely.

## Prerequisites

- The schema from `../database-script-0x01/schema.sql` must already be applied to your database.
- PostgreSQL 13+ (14+ recommended), and `uuid-ossp` extension if you rely on DB-side UUID defaults.

## Apply seed

```powershell
# Assuming the database name is airbnb_clone and you have psql installed
psql -U postgres -h localhost -d airbnb_clone -f .\database-script-0x02\seed.sql
```

## What gets inserted

- 3 users (1 host, 2 guests)
- 2 properties for the host (San Francisco loft and Lake Tahoe cabin)
- 6 amenities and mapping to properties
- 3 images across both properties
- 2 bookings (one past, completed; one upcoming, confirmed)
- 2 payments (one per booking)
- 1 review for the completed stay

## Notes

- Password hashes are placeholders for demo purposes and should not be used in production.
- Dates are chosen to satisfy constraints and illustrate past vs upcoming bookings.
- You can extend the seed with more users, overlapping bookings tests, or failed payment records as needed.
