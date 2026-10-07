# GameClan.hub

GameClan.hub is a social multiplayer gaming platform where users discover and play games, compete on leaderboards, build profiles, earn achievements, chat with friends, and participate in challenges.

This repository is the monorepo for all GameClan.hub software.

---

## Project Status

**Current phase: Repository bootstrap.**

The repository structure, architecture documentation, and engineering conventions have been established. Product features and individual games are not yet implemented.

---

## Technology Stack

| Area | Technology |
|---|---|
| Backend | Go |
| Database | PostgreSQL |
| Cache / Realtime state | Redis |
| API | REST + WebSocket |
| Web | Next.js, TypeScript, React (App Router) |
| Mobile | React Native, Expo, TypeScript |
| Admin | Next.js, TypeScript (separate app) |

---

## Architecture Overview

```
Web ────────┐
Mobile ─────┼──→ GameClan Server (Go) ──→ PostgreSQL
Admin ──────┘                        ──→ Redis
```

The Go server is the central backend for all clients. It is not a backend specifically for the web application.

The server follows **Clean Architecture** with clear separation between:

- **Domain** — business entities and rules
- **Application** — use cases and orchestration
- **Infrastructure** — databases, external services, messaging
- **Presentation** — HTTP handlers, WebSocket handlers

See [`docs/architecture/overview.md`](docs/architecture/overview.md) for the full architecture documentation.

---

## Repository Structure

```
gameclan/
├── apps/
│   ├── web/          # Consumer web application (Next.js)
│   ├── admin/        # Admin application (Next.js, separate)
│   └── mobile/       # Mobile application (React Native + Expo)
│
├── server/           # Go backend server
│   ├── cmd/
│   ├── internal/
│   ├── migrations/
│   ├── tests/
│   ├── configs/
│   └── go.mod
│
├── packages/
│   ├── contracts/    # Shared client/server type contracts
│   ├── api-client/   # Shared API client library
│   └── validation/   # Shared validation schemas
│
├── docs/
│   ├── architecture/ # Architecture documentation
│   ├── decisions/    # Architecture Decision Records (ADRs)
│   ├── product/      # Product vision and roadmap
│   ├── games/        # Game integration documentation
│   └── workflows/    # Engineering workflow guides
│
├── scripts/          # Development and automation scripts
│
├── AGENTS.md         # Engineering constitution for AI agents and developers
├── README.md
└── package.json
```

---

## Development Philosophy

- **Simplicity first.** Do not introduce abstractions merely because they are possible.
- **Clear boundaries.** Platform and game-specific logic are strictly separated.
- **Backend authority.** The server is the source of truth for game state.
- **Incremental architecture.** Build for current needs, not hypothetical scale.
- **No premature microservices.** The backend is a single Go server.
- **Explicit contracts.** Client/server contracts are versioned and changed deliberately.

See [`AGENTS.md`](AGENTS.md) for the full engineering constitution.

---

## Documentation Index

| Document | Description |
|---|---|
| [`docs/architecture/overview.md`](docs/architecture/overview.md) | Platform architecture overview |
| [`docs/architecture/server.md`](docs/architecture/server.md) | Go server architecture |
| [`docs/architecture/frontend.md`](docs/architecture/frontend.md) | Frontend architecture |
| [`docs/architecture/realtime.md`](docs/architecture/realtime.md) | WebSocket / realtime architecture |
| [`docs/architecture/data.md`](docs/architecture/data.md) | Data architecture (PostgreSQL + Redis) |
| [`docs/decisions/`](docs/decisions/) | Architecture Decision Records |
| [`docs/product/vision.md`](docs/product/vision.md) | Product vision |
| [`docs/product/platform.md`](docs/product/platform.md) | Platform capabilities |
| [`docs/product/roadmap.md`](docs/product/roadmap.md) | Product roadmap |
| [`docs/games/README.md`](docs/games/README.md) | Game integration model |
| [`docs/games/find-the-number.md`](docs/games/find-the-number.md) | Find the Number game spec |
| [`docs/workflows/`](docs/workflows/) | Engineering workflow guides |
| [`AGENTS.md`](AGENTS.md) | AI agent and developer guidelines |

---

## Development Prerequisites

> **Note:** Applications are not yet implemented. The following prerequisites will be required once implementation begins.

- **Go** 1.23+
- **Node.js** 20+
- **PostgreSQL** 16+
- **Redis** 7+
- A package manager: `npm`, `pnpm`, or `yarn`

---

## Running the Project

> **Planned.** Instructions for running the web, mobile, admin, and server applications will be added here as each application is implemented.

---

## Contributing

Before making changes, read [`AGENTS.md`](AGENTS.md). It is the canonical engineering constitution for this repository.
