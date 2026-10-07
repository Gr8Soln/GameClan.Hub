# ADR-003 — PostgreSQL

## Status

Accepted

## Context

A primary database was needed to store durable business data for the GameClan.hub platform. Data includes user accounts, match history, chat messages, achievements, leaderboard entries, and other relational business entities.

Requirements:

- ACID compliance for transactional integrity
- Relational data model suitable for the platform's entities
- Strong support for complex queries (leaderboards, statistics, history)
- Mature ecosystem and operational tooling
- Good Go driver ecosystem

## Decision

Use **PostgreSQL** as the primary relational database.

All durable business data lives in PostgreSQL. Schema changes are managed via migration files in `server/migrations/`.

## Consequences

**Benefits:**

- ACID transactions ensure data integrity for critical operations (match results, earned achievements).
- Powerful query language supports complex reporting, leaderboard queries, and historical analysis.
- Mature ecosystem with excellent Go drivers (`pgx`, `database/sql`).
- Well-understood operational characteristics and monitoring tooling.
- JSON column support for flexible semi-structured data where needed.

**Tradeoffs:**

- Requires schema management and migration discipline.
- Not designed for high-frequency writes of very small state updates (this is Redis's role).

**Implications:**

- Redis is used for ephemeral, high-speed state (see ADR-004).
- Database access is confined to the Infrastructure layer in Clean Architecture.
- Repository interfaces are defined in the Domain layer; SQL implementations live in Infrastructure.
- The schema evolves incrementally via migration files. No migration is modified after it has been applied.
