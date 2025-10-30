Database Advanced Script

This folder contains advanced SQL exercises and artifacts for the ALX AirBnB database project.

Files included:

- `joins_queries.sql` — INNER, LEFT and FULL OUTER join examples.
- `subqueries.sql` — correlated and non-correlated subqueries.
- `aggregations_and_window_functions.sql` — aggregation and window function examples.
- `database_index.sql` — CREATE INDEX statements for commonly-used columns.
- `index_performance.md` — notes and commands to measure index impact using EXPLAIN/ANALYZE.
- `perfomance.sql` — initial complex query showing bookings with related details.
- `optimization_report.md` — analysis of the initial query and refactored alternatives.
- `partitioning.sql` — example of partitioning the `bookings` table by `check_in` (range partitioning).
- `partition_performance.md` — testing notes and expected improvements from partitioning.
- `performance_monitoring.md` — guidance for ongoing monitoring and suggested schema changes.

Run the SQL files using your PostgreSQL client. Some files include `EXPLAIN ANALYZE` examples — run them in a development database only.
