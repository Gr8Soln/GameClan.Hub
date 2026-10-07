# Data Architecture

GameClan.hub uses two data stores with clearly separated responsibilities.

**Status:** Architecture documented. Schema and infrastructure not yet implemented.

---

## PostgreSQL — Durable State

PostgreSQL is the primary database. All business data that must survive a server restart lives in PostgreSQL.

### Responsibility

- All relational business entities
- Historical data (match history, game results, messages)
- User-owned data (profiles, achievements, statistics)
- Referential integrity between entities

### Conceptual Entities

The following entities are planned. This list is conceptual and does not represent the final schema.

```
users                  — Registered accounts
profiles               — Public player profiles
games                  — Available games
matches                — Game sessions (past and present)
match_players          — Players in a match
game_results           — Outcomes of completed matches
friendships            — Friend relationships
conversations          — Chat conversation threads
conversation_members   — Members of a conversation
messages               — Chat messages
notifications          — In-app notifications
achievements           — Defined achievements
user_achievements      — Achievements earned by users
leaderboards           — Defined leaderboards
leaderboard_entries    — Player positions on leaderboards
challenges             — Defined challenges
user_statistics        — Aggregate per-player statistics
```

> **Planned.** No database schema exists yet. Schema will be introduced incrementally via migrations as features are implemented.

### Migrations

All schema changes use migration files in `server/migrations/`.

See [`../workflows/database-migration.md`](../workflows/database-migration.md) for the workflow.

---

## Redis — Ephemeral and High-Speed State

Redis handles state that is short-lived, high-frequency, or does not need durable persistence.

### Responsibility

| Use Case | Description |
|---|---|
| Active sessions | Authenticated session tokens |
| Presence | Online / offline / in-game status per user |
| WebSocket coordination | Routing messages to the correct connection |
| Matchmaking queues | Players waiting for opponents |
| Rate limiting | Request and action rate limits |
| Response caching | Cached expensive query results |
| Live match state | In-progress game state where low latency matters |

### Boundaries

**Redis is not the source of truth for durable business data.**

- When a Redis key expires or Redis is restarted, the data may be lost. This is acceptable for ephemeral data.
- Anything that must be preserved (match results, earned achievements, message history) must be written to PostgreSQL.
- Live match state in Redis should be considered a performance cache — the authoritative record of a completed match lives in PostgreSQL.

---

## Choosing the Right Store

| Data Type | Store | Reason |
|---|---|---|
| User accounts | PostgreSQL | Durable, relational |
| Match history | PostgreSQL | Durable, queryable |
| Chat messages | PostgreSQL | Durable, historical |
| Achievements earned | PostgreSQL | Durable, owned by user |
| Active session tokens | Redis | Short-lived, high-speed |
| Player presence | Redis | Ephemeral, frequently updated |
| Matchmaking queue | Redis | Transient, order-sensitive |
| Live game state | Redis (+ eventual PostgreSQL) | Low-latency, then persisted on completion |
| Leaderboard cache | Redis | Cached for performance, sourced from PostgreSQL |
