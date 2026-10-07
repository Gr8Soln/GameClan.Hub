# Server Architecture

The GameClan server is a Go application that serves as the central backend for all GameClan.hub clients.

**Status:** Architecture documented. Implementation in progress (bootstrap phase — entry point only).

---

## Clean Architecture

The server follows Clean Architecture with strict separation between layers.

```
server/internal/
├── domain/          # Entities, value objects, domain rules, repository interfaces
├── application/     # Use cases, command/query handlers, application services
├── infrastructure/  # PostgreSQL adapters, Redis, external service clients
└── presentation/    # HTTP handlers, WebSocket handlers, middleware, routing
```

### Dependency Rule

Dependencies point **inward only**:

```
Presentation  ──→  Application  ──→  Domain
Infrastructure ──→  Application  ──→  Domain
```

- **Domain** has no imports from any other layer.
- **Application** imports from Domain only. No `net/http`, no `database/sql`, no Redis.
- **Infrastructure** implements interfaces defined in Domain. Contains all persistence code.
- **Presentation** calls Application use cases. Translates HTTP/WebSocket requests into application commands.

---

## Platform Core

Functionality shared across all games lives in the Platform Core:

| Capability | Notes |
|---|---|
| Authentication | JWT or session-based (design TBD) |
| Users | Registration, login, account management |
| Profiles | Display names, avatars, bios |
| Friends | Friend requests, friendship management |
| Presence | Online / offline / in-game status |
| Notifications | In-app and push notifications |
| Chat | Conversations, messages |
| Game discovery | Browsing available games |
| Matchmaking | Finding opponents |
| Rooms | Private game rooms |
| Leaderboards | Global and per-game rankings |
| XP and Levels | Player progression |
| Achievements | Unlockable accomplishments |
| Challenges | Time-limited or competitive challenges |
| Player statistics | Aggregate play history |
| Moderation | Reporting, blocking |

> **Planned.** None of these are implemented in the bootstrap phase.

---

## Game System

Each game is an independent domain implementation. The platform does not contain game-specific rules.

### Conceptual Game Contract

A game module will eventually expose:

```
Metadata     — name, description, min/max players, rules summary
Rules        — win conditions, valid actions, turn structure
State        — current state of an in-progress game
Commands     — actions a player can submit
Events       — state changes that result from commands
Result       — final outcome of a completed game
Statistics   — per-player game-specific stats
```

The concrete Go interfaces for the game contract will be designed before the first game is integrated.

### Platform / Game Relationship

```
Platform
    └── Match
            └── identifies → Game
                                └── owns → Rules, State, Events
```

A `Match` in the platform knows which game it belongs to. But the platform does not execute or understand the game's internal rules. Game logic is delegated entirely to the game module.

See [`../../docs/games/README.md`](../games/README.md) for the game integration model.

---

## API Design

See [`realtime.md`](realtime.md) for the REST vs WebSocket distinction and the commands/events model.

---

## Observability

The server will implement:

- **Structured logging** — key-value format, not printf-style
- **Metrics** — request rates, latencies, error rates
- **Traces** — OpenTelemetry-compatible distributed tracing
- **Product telemetry** — business events for product analytics

> **Planned.** Observability infrastructure is not yet implemented.

---

## Entry Point

```
server/cmd/gameclan/main.go
```

Currently a minimal placeholder. Infrastructure wiring (HTTP server, database connections, configuration, graceful shutdown) will be implemented as development begins.

---

## Configuration

> **Planned.** Configuration will be loaded from environment variables and/or configuration files in `server/configs/`. Secrets will not be committed to the repository.

---

## Database Migrations

All schema changes are managed via migration files in `server/migrations/`.

See [`../../docs/workflows/database-migration.md`](../workflows/database-migration.md) for the workflow.

> **Planned.** No migrations exist in the bootstrap phase.
