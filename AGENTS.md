# AGENTS.md — GameClan.hub Engineering Constitution

This document is the canonical engineering constitution for the GameClan.hub repository.

All contributors — human developers and AI coding agents alike — must read and follow this document before making changes to the repository.

> **Do not redesign an established architecture merely because another architecture appears preferable. Existing architectural decisions are intentional unless explicitly changed through an architecture decision.**

---

## Project Purpose

GameClan.hub is a social multiplayer gaming platform where users:

- Discover and play multiple games
- Play against other people or the computer
- Chat with friends
- Build persistent profiles
- Compete on leaderboards
- Earn achievements and XP
- Participate in challenges
- Play in private rooms or public matchmaking

The platform is designed to support many games. Each game is an independent domain implementation hosted on the shared platform.

---

## Technology Decisions

The following technology decisions are **final** for this project phase. Do not replace or introduce alternatives without an explicit Architecture Decision Record (ADR).

| Area | Technology | Notes |
|---|---|---|
| Backend language | Go | Central server for all clients |
| Primary database | PostgreSQL | Durable relational state |
| Cache / ephemeral state | Redis | Sessions, presence, queues, rate limiting |
| API protocol | REST + WebSocket | REST for request/response, WS for realtime |
| Backend architecture | Clean Architecture | Domain / Application / Infrastructure / Presentation |
| Web application | Next.js + TypeScript + React | App Router |
| Mobile application | React Native + Expo + TypeScript | |
| Admin application | Next.js + TypeScript | Separate app from consumer web |
| Repository structure | Monorepo | apps/, server/, packages/, docs/, scripts/ |

### Do NOT introduce

- Rust as a backend language
- Python as the backend
- Flutter for mobile
- GraphQL as the primary API
- A different backend framework (e.g. Node.js, Django, Rails)
- Microservices (the backend is a single Go server)

---

## Repository Structure

```
gameclan/
├── apps/
│   ├── web/          # Consumer web application (Next.js)
│   ├── admin/        # Admin application (Next.js, separate)
│   └── mobile/       # Mobile application (React Native + Expo)
│
├── server/           # Go backend — central server for all clients
│   ├── cmd/gameclan/ # Application entry point
│   ├── internal/
│   │   ├── domain/           # Entities, value objects, domain logic
│   │   ├── application/      # Use cases, orchestration
│   │   ├── infrastructure/   # DB, Redis, external services
│   │   └── presentation/     # HTTP handlers, WebSocket handlers
│   ├── migrations/   # PostgreSQL migration files
│   ├── tests/        # Integration and end-to-end tests
│   └── configs/      # Configuration files and schemas
│
├── packages/
│   ├── contracts/    # Shared type contracts (client ↔ server)
│   ├── api-client/   # Shared API client library
│   └── validation/   # Shared validation schemas
│
├── docs/
│   ├── architecture/ # Architecture documentation
│   ├── decisions/    # Architecture Decision Records
│   ├── product/      # Product documentation
│   ├── games/        # Game integration documentation
│   └── workflows/    # Engineering workflow guides
│
└── scripts/          # Development and automation scripts
```

### Critical structural rules

- `server/` is at the **repository root** — not `backend/server/`, `apps/server/`, or `backend/`.
- Do not create directories to appear sophisticated. Create them only when implementation requires it.
- The structure can and should evolve when implementation requires it.

---

## Architecture

### Platform Architecture

```
Web ────────┐
Mobile ─────┼──→ GameClan Server (Go) ──→ PostgreSQL
Admin ──────┘                        ──→ Redis
```

All clients consume the same backend. The server is not a backend specifically for the web application.

### Clean Architecture Layers

```
Domain           — Business entities, value objects, domain rules, interfaces
Application      — Use cases, command/query handlers, orchestration
Infrastructure   — PostgreSQL, Redis, external services, messaging
Presentation     — HTTP handlers, WebSocket handlers, middleware
```

**Dependency rule:** Dependencies point inward only. Infrastructure depends on Application. Application depends on Domain. Domain has no outward dependencies.

### Platform Core vs Game System

The platform and individual games have **strictly separated responsibilities**.

**Platform Core** handles functionality shared across all games:
- Authentication, users, profiles
- Friends, presence, chat
- Game discovery, matchmaking, rooms
- Leaderboards, XP, levels, achievements, challenges
- Player statistics, moderation, notifications

**Game System** — each game is an independent domain implementation that exposes:
- Metadata (name, description, player counts, rules summary)
- Rules (game-specific logic, win conditions)
- State (current state of a game in progress)
- Commands (actions a player can take)
- Events (state changes that occurred)
- Result (final outcome of a completed game)
- Statistics (per-player game-specific stats)

**The platform must not contain game-specific rules.** A match identifies which game it belongs to, but the platform does not understand the internal rules of that game.

---

## API Principles

### REST

REST handles normal request/response operations:
- Authentication
- User profiles
- Game discovery
- Match creation and history
- Leaderboards
- Friend management
- Notifications
- Conversations
- Settings

### WebSocket

WebSocket handles realtime operations:
- Live multiplayer game state
- Game events and actions
- Chat messages
- Presence updates
- Match status changes
- Realtime notifications

### Commands vs Events

**Commands** are intentional requests to change state:
```
create_match, join_match, start_match, submit_game_action,
send_message, accept_friend_request
```

**Events** represent things that happened:
```
match.created, match.joined, game.started, game.action_processed,
game.turn_changed, game.finished, message.sent, friend_request.accepted
```

### Contract Stability

Client-facing contracts are explicit interfaces. Change them deliberately:
1. Update the contract in `packages/contracts/`
2. Update the server implementation
3. Update all consuming clients
4. Document breaking changes

---

## Data Principles

### PostgreSQL — Durable State

All business data that must survive a server restart lives in PostgreSQL:
- Users, profiles, friendships
- Match history, game results
- Messages, conversations
- Achievements, leaderboard entries
- Challenges, statistics

### Redis — Ephemeral State

High-speed or short-lived state lives in Redis:
- Active sessions
- Presence (online/offline/in-game)
- WebSocket coordination
- Matchmaking queues
- Rate limiting
- Response caching
- Live match state (where low-latency is critical)

**Do not use Redis as the permanent source of truth for durable business data.**

---

## Engineering Principles

### Simplicity
Do not introduce abstractions merely because they are possible. Complexity must justify itself.

### Backend Authority
For multiplayer games, clients must not be trusted as authoritative sources of game state. All game state transitions must be validated and authorised by the server.

### Deterministic Game Logic
Game rules must be testable independently from HTTP handlers, WebSockets, databases, and UI. Game logic is pure domain code.

### Explicit State Transitions
State transitions are deliberate, observable, and testable. Avoid implicit side effects.

### Observability
Production systems must provide structured logs, metrics, traces (OpenTelemetry-compatible), and meaningful product telemetry.

### Incremental Architecture
Do not build infrastructure for hypothetical scale before the product requires it. Solve real problems, not imagined ones.

### No Premature Microservices
The backend is a single Go server. Do not split into microservices unless a future ADR explicitly requires it.

---

## Testing Expectations

- **Domain logic** must be unit-tested independently of infrastructure.
- **Use cases** should be tested with mocked infrastructure dependencies.
- **Integration tests** cover database interactions and real infrastructure where appropriate.
- **Game rules** must have their own test suites — they are too critical for informal testing.
- Tests live close to the code they test, with integration tests in `server/tests/`.
- Do not skip tests for "convenience" during bootstrap or iteration.

---

## Documentation Expectations

- Architecture documents live in `docs/architecture/`.
- Technology decisions live in `docs/decisions/` as ADRs.
- Engineering workflow guides live in `docs/workflows/`.
- Game documentation lives in `docs/games/`.
- Scoped guidance for each area lives in the area's own `AGENTS.md`.
- **Update documentation when architecture or behavior changes.**
- Clearly distinguish between what is **current**, **planned**, and **future**.
- Do not describe planned functionality as if it already exists.

---

## Change Management Rules

All contributors must follow these rules:

1. **Inspect existing code before modifying it.** Understand what already exists.
2. **Read relevant documentation before implementing features.** Architecture docs and ADRs are authoritative.
3. **Preserve established architecture.** Do not silently redesign existing patterns.
4. **Make the smallest correct change.** Avoid scope creep.
5. **Avoid unrelated refactoring.** Refactoring in the same PR as a feature change obscures intent.
6. **Avoid unnecessary dependencies.** Every dependency is a liability.
7. **Do not replace technology decisions without explicit approval.** Technology choices are documented in ADRs and are not casual.
8. **Update contracts when API behavior changes.** Contracts in `packages/contracts/` must stay in sync with the server.
9. **Update tests when behavior changes.** Tests must reflect current expected behavior.
10. **Update documentation when architecture or behavior changes.** Stale documentation is actively harmful.

---

## Scoped Instructions

Each major area of the repository has its own `AGENTS.md` with area-specific rules:

- [`apps/web/AGENTS.md`](apps/web/AGENTS.md) — Consumer web application
- [`apps/admin/AGENTS.md`](apps/admin/AGENTS.md) — Admin application
- [`apps/mobile/AGENTS.md`](apps/mobile/AGENTS.md) — Mobile application
- [`server/AGENTS.md`](server/AGENTS.md) — Go backend server
- [`packages/contracts/AGENTS.md`](packages/contracts/AGENTS.md) — Shared contracts

Scoped instructions supplement this document. They do not override it. In case of conflict, this document is authoritative.

---

## Architecture Decision Records

All significant technology decisions are documented as ADRs in [`docs/decisions/`](docs/decisions/).

Before proposing a technology change, read the relevant ADR. Understand the context and consequences that were already considered.

To change an architecture decision: create a new ADR, document the new context, the new decision, and the migration path. Get explicit approval before making changes.

---

## Local Development

For all local development workflows, use the root-level Makefile.

The canonical commands are:
- `make setup` — Idempotent environment bootstrap (creates `.env` files, installs dependencies).
- `make dev` — Starts the complete application stack locally via tmux.

For a complete guide, see [`docs/workflows/local-development.md`](docs/workflows/local-development.md).
