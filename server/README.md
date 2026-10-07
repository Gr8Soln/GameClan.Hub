# GameClan Server

The Go backend server for GameClan.hub.

This is the **central backend for all clients** — web, mobile, and admin. It is not a backend specifically for the web application.

---

## Technology

- **Language:** Go 1.23+
- **Database:** PostgreSQL
- **Cache / Ephemeral state:** Redis
- **API:** REST + WebSocket
- **Architecture:** Clean Architecture

---

## Architecture

The server follows Clean Architecture with clear separation between layers:

```
internal/
├── domain/          # Business entities, value objects, domain rules, repository interfaces
├── application/     # Use cases, command/query handlers, application services
├── infrastructure/  # PostgreSQL, Redis, external service adapters
└── presentation/    # HTTP handlers, WebSocket handlers, middleware, routing
```

### Dependency Rule

Dependencies point inward only:

```
Presentation → Application → Domain
Infrastructure → Application → Domain
```

The Domain layer has no dependencies on any other layer.

### Platform Core vs Game System

The server implements two conceptual layers:

**Platform Core** — functionality shared across all games:
- Authentication, users, profiles
- Friends, presence, notifications
- Chat, conversations
- Game discovery, matchmaking, rooms
- Leaderboards, XP, levels, achievements, challenges
- Moderation, reporting, statistics

**Game System** — each game is an independent domain module.

The platform does not contain game-specific rules. A match knows which game it belongs to, but the platform does not understand the internal rules of that game.

---

## Entry Point

```
cmd/gameclan/main.go
```

> **Planned.** The server entry point is a placeholder. Infrastructure (HTTP server, database connections, configuration loading, graceful shutdown) will be implemented when development begins.

---

## Migrations

Database migrations live in `migrations/`.

See [`docs/workflows/database-migration.md`](../docs/workflows/database-migration.md) for the migration workflow.

> **Planned.** No migrations exist yet.

---

## Configuration

Configuration files and schemas live in `configs/`.

> **Planned.** Configuration loading will be implemented when development begins.

---

## Testing

- Unit tests live alongside the code they test.
- Integration tests live in `tests/`.
- Game rule logic must be unit-tested independently of infrastructure.

---

## Building

> **Planned.** Once the server is implemented:

```bash
cd server
go build ./cmd/gameclan/
```

## Running

> **Planned.** Once infrastructure is implemented:

```bash
cd server
go run ./cmd/gameclan/
```
