# Architecture Overview

GameClan.hub is a social multiplayer gaming platform. This document describes the overall system architecture.

**Status:** Bootstrap phase. Architecture is documented and partially established. Applications are not yet implemented.

---

## System Diagram

```
┌─────────────────────────────────────────────────────┐
│                    Clients                          │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │   Web    │  │  Mobile  │  │      Admin       │  │
│  │ Next.js  │  │  Expo /  │  │    Next.js       │  │
│  │ (App     │  │  React   │  │    (separate     │  │
│  │ Router)  │  │  Native  │  │     app)         │  │
│  └────┬─────┘  └────┬─────┘  └────────┬─────────┘  │
└───────┼──────────────┼────────────────┼─────────────┘
        │              │                │
        └──────────────┴────────────────┘
                       │
                REST API + WebSocket
                       │
        ┌──────────────▼──────────────┐
        │      GameClan Server        │
        │           (Go)              │
        │                             │
        │  ┌──────────────────────┐   │
        │  │   Presentation       │   │
        │  │ (HTTP + WebSocket)   │   │
        │  └──────────┬───────────┘   │
        │  ┌──────────▼───────────┐   │
        │  │   Application        │   │
        │  │   (Use Cases)        │   │
        │  └──────────┬───────────┘   │
        │  ┌──────────▼───────────┐   │
        │  │   Domain             │   │
        │  │ (Entities + Rules)   │   │
        │  └──────────────────────┘   │
        │  ┌──────────────────────┐   │
        │  │   Infrastructure     │   │
        │  │ (DB, Redis, ext.)    │   │
        │  └──────────────────────┘   │
        └──────────┬──────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
┌───────▼───────┐    ┌────────▼────────┐
│  PostgreSQL   │    │     Redis       │
│  (Durable     │    │  (Ephemeral /   │
│   state)      │    │   Live state)   │
└───────────────┘    └─────────────────┘
```

---

## Technology Summary

| Component | Technology | Notes |
|---|---|---|
| Backend | Go | Single server for all clients |
| Database | PostgreSQL | Durable relational state |
| Cache / Ephemeral | Redis | Sessions, presence, queues |
| API | REST + WebSocket | Separate concerns (see realtime.md) |
| Web | Next.js + TypeScript | App Router |
| Mobile | React Native + Expo + TypeScript | |
| Admin | Next.js + TypeScript | Separate app |

---

## Key Principles

### Single Backend

The Go server is the central backend for **all** clients. It is not a backend specifically for the web application. Web, mobile, and admin all consume the same server.

### Backend Authority

The server is the authoritative source of truth for game state. Clients display state — they do not determine it.

### Clean Architecture

The server is organised into four layers with strict inward-pointing dependencies:

- **Domain** — entities, value objects, domain rules, repository interfaces
- **Application** — use cases, orchestration
- **Infrastructure** — database adapters, Redis, external services
- **Presentation** — HTTP handlers, WebSocket handlers

See [`server.md`](server.md) for detail.

### Platform + Game Separation

The platform provides shared infrastructure. Games are independent domain implementations. See [`server.md`](server.md) for detail.

### Shared Contracts

Client/server API shapes are defined in `packages/contracts/` and shared across all clients. Contracts are treated as explicit, versioned interfaces.

---

## Current State

- Repository structure established
- Architecture documented
- Engineering conventions defined
- Applications: **not yet implemented**
- Database schema: **not yet defined**
- API endpoints: **not yet implemented**

## Further Reading

- [`server.md`](server.md) — Go server architecture
- [`frontend.md`](frontend.md) — Frontend architecture
- [`realtime.md`](realtime.md) — WebSocket / realtime architecture
- [`data.md`](data.md) — Data architecture
- [`../decisions/`](../decisions/) — Architecture Decision Records
