# ADR-004 — Redis

## Status

Accepted

## Context

Certain platform operations require data access patterns that are not a good fit for a relational database:

- Presence tracking (many users changing online status frequently)
- Active session management (fast token lookups)
- Matchmaking queues (ordered, transient data)
- Rate limiting (per-request counters with TTLs)
- WebSocket coordination (routing messages to the correct server connection)
- Caching expensive query results

These use cases are characterised by: high read/write frequency, short data lifetime, tolerance for potential data loss on restart, and need for simple data structures (strings, sets, sorted sets, hashes).

## Decision

Use **Redis** for ephemeral and high-speed state.

Redis complements PostgreSQL. It is not a replacement.

## Consequences

**Benefits:**

- Sub-millisecond read/write latency for presence, sessions, and rate limiting.
- Built-in TTL (time-to-live) support for ephemeral data.
- Sorted sets are well-suited to leaderboard caching and matchmaking queues.
- Pub/Sub and Streams can support WebSocket event coordination.
- Widely supported and well-understood operationally.

**Tradeoffs:**

- Data is not durably guaranteed unless AOF/RDB persistence is configured carefully.
- Redis is not suitable as the source of truth for business data.

**Implications:**

- PostgreSQL remains the authoritative source of truth for all durable business data.
- Redis data that expires or is lost does not cause data corruption; at worst, users must re-authenticate or presence must be re-established.
- Live match state may be held in Redis during a game for performance, but the final result must be persisted to PostgreSQL.
- Redis access is confined to the Infrastructure layer.
