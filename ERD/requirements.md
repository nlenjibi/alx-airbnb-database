# ER Diagram Requirements

This document defines the entities, attributes, and relationships for the AirBnB Clone database and provides a visual ER model using Mermaid. Use it as the blueprint when building or reviewing the ER diagram (in Draw.io, Mermaid, or your preferred tool).

## Scope and goal

- Capture core marketplace flows: hosting properties, booking stays, payments, and reviews.
- Ensure the model is normalized (3NF) and maps cleanly to a relational schema.

## Entities and attributes

1. Users

- id (UUID, PK)
- email (varchar, unique, required)
- full_name (varchar, required)
- hashed_password (varchar, required)
- is_host (boolean, default false)
- phone (varchar, optional)
- created_at (timestamptz)
- updated_at (timestamptz)

2. Properties

- id (UUID, PK)
- host_id (UUID, FK -> Users.id, required)
- title (varchar, required)
- description (text, optional)
- address_line (varchar, optional)
- city (varchar, optional)
- state (varchar, optional)
- country (varchar, optional)
- latitude (numeric, optional)
- longitude (numeric, optional)
- price_per_night (numeric, required)
- capacity (int, default 1)
- created_at (timestamptz)
- updated_at (timestamptz)

3. PropertyImages

- id (UUID, PK)
- property_id (UUID, FK -> Properties.id, required)
- url (text, required)
- caption (text, optional)
- is_cover (boolean, default false)
- created_at (timestamptz)

4. Amenities

- id (UUID, PK)
- name (varchar, unique, required)
- description (text, optional)

5. PropertyAmenities (join)

- property_id (UUID, FK -> Properties.id, required)
- amenity_id (UUID, FK -> Amenities.id, required)
- PK: (property_id, amenity_id)

6. Bookings

- id (UUID, PK)
- property_id (UUID, FK -> Properties.id, required)
- guest_id (UUID, FK -> Users.id, required)
- check_in (date, required)
- check_out (date, required)
- total_price (numeric, required)
- status (varchar, required; e.g., pending, confirmed, cancelled, completed)
- created_at (timestamptz)
- updated_at (timestamptz)

7. Payments

- id (UUID, PK)
- booking_id (UUID, FK -> Bookings.id, required)
- amount (numeric, required)
- currency (varchar, default 'USD')
- payment_provider (varchar, optional; e.g., stripe, paypal)
- status (varchar, required)
- transaction_id (varchar, optional)
- created_at (timestamptz)

8. Reviews

- id (UUID, PK)
- property_id (UUID, FK -> Properties.id, required)
- author_id (UUID, FK -> Users.id, required)
- rating (int, required, 1..5)
- comment (text, optional)
- created_at (timestamptz)

## Relationships and cardinality

- User (host) 1 — N Property (Users.id -> Properties.host_id)
- User (guest) 1 — N Booking (Users.id -> Bookings.guest_id)
- Property 1 — N Booking (Properties.id -> Bookings.property_id)
- Booking 1 — N Payment (Bookings.id -> Payments.booking_id)
- User 1 — N Review (Users.id -> Reviews.author_id)
- Property 1 — N Review (Properties.id -> Reviews.property_id)
- Property 1 — N PropertyImage (Properties.id -> PropertyImages.property_id)
- Property M — N Amenity via PropertyAmenities (PK: property_id + amenity_id)

Participation notes

- Every Booking must reference an existing Property and User (guest)।
- Every Payment must reference an existing Booking; a Booking can have zero or more Payments (supports retries/refunds if needed).
- A Review is optional and requires an existing Property and User.
- A Property can exist without images or amenities, but typically has one or more of each.

## Visual ER diagram (Mermaid)

```mermaid
erDiagram
  USERS ||--o{ PROPERTIES : hosts
  USERS ||--o{ BOOKINGS : makes
  PROPERTIES ||--o{ BOOKINGS : has
  BOOKINGS ||--o{ PAYMENTS : has
  USERS ||--o{ REVIEWS : writes
  PROPERTIES ||--o{ REVIEWS : receives
  PROPERTIES ||--o{ PROPERTY_IMAGES : has
  PROPERTIES ||--o{ PROPERTY_AMENITIES : features
  AMENITIES ||--o{ PROPERTY_AMENITIES : used_in

  USERS {
    uuid id PK
    varchar email UNIQUE
    varchar full_name
    varchar hashed_password
    boolean is_host
    varchar phone
    timestamptz created_at
    timestamptz updated_at
  }

  PROPERTIES {
    uuid id PK
    uuid host_id FK
    varchar title
    text description
    varchar address_line
    varchar city
    varchar state
    varchar country
    numeric latitude
    numeric longitude
    numeric price_per_night
    int capacity
    timestamptz created_at
    timestamptz updated_at
  }

  PROPERTY_IMAGES {
    uuid id PK
    uuid property_id FK
    text url
    text caption
    boolean is_cover
    timestamptz created_at
  }

  AMENITIES {
    uuid id PK
    varchar name UNIQUE
    text description
  }

  PROPERTY_AMENITIES {
    uuid property_id FK
    uuid amenity_id FK
    -- PK(property_id, amenity_id)
  }

  BOOKINGS {
    uuid id PK
    uuid property_id FK
    uuid guest_id FK
    date check_in
    date check_out
    numeric total_price
    varchar status
    timestamptz created_at
    timestamptz updated_at
  }

  PAYMENTS {
    uuid id PK
    uuid booking_id FK
    numeric amount
    varchar currency
    varchar payment_provider
    varchar status
    varchar transaction_id
    timestamptz created_at
  }

  REVIEWS {
    uuid id PK
    uuid property_id FK
    uuid author_id FK
    int rating
    text comment
    timestamptz created_at
  }
```

## Draw.io guidance (optional)

If you must deliver a Draw.io diagram:

1. Open https://app.diagrams.net/ and create a new diagram.
2. Use Entity Relation shape set (More Shapes > Software > Entity Relation).
3. Create entities with the attributes above; mark PK, FK, and unique fields.
4. Connect relationships with crow's foot notation:
   - Users —< Properties (hosts)
   - Users —< Bookings (makes)
   - Properties —< Bookings (has)
   - Bookings —< Payments (has)
   - Users —< Reviews (writes)
   - Properties —< Reviews (receives)
   - Properties —< PropertyImages (has)
   - Properties >—< Amenities via PropertyAmenities
5. Export to .drawio (source) and .png/.svg (rendered) if required by your submission.

## References

- See `database-script-0x01/schema.sql` for DDL
- See `database-script-0x02/seed.sql` for sample data
- See `normalization.md` for normalization notes and rationale
