# ADR-006 — Clean Architecture

## Status

Accepted

## Context

The GameClan.hub server handles a complex domain: multiple games, platform services, realtime communication, and many interacting components. A structural approach was needed to ensure that the codebase remains testable, maintainable, and extensible as it grows.

Key requirements:

- Domain logic must be testable without databases, HTTP, or Redis.
- Game rules in particular must be independently testable.
- Infrastructure choices (database, cache, external services) must be swappable without modifying business logic.
- The codebase must be navigable by developers and AI agents unfamiliar with the full system.

## Decision

Use **Clean Architecture** for the Go server with four layers:

- **Domain** — Entities, value objects, domain rules, repository interfaces
- **Application** — Use cases, command/query handlers, orchestration
- **Infrastructure** — PostgreSQL adapters, Redis clients, external services
- **Presentation** — HTTP handlers, WebSocket handlers, middleware

**Dependency rule:** Dependencies point inward only. Domain has no external dependencies. Infrastructure and Presentation depend on Application. Application depends only on Domain.

## Consequences

**Benefits:**

- Domain logic is pure Go — no database drivers, no `net/http`. Fully unit-testable.
- Infrastructure can be swapped (e.g., different database driver) without modifying business logic.
- Use cases are explicit and named, making the system's capabilities discoverable.
- Interfaces at the domain boundary enable test doubles (mocks, stubs) without third-party mocking libraries.

**Tradeoffs:**

- More boilerplate than a simple layered or MVC architecture.
- Requires discipline to maintain layer boundaries as the codebase grows.
- New contributors must understand the pattern.

**Implications:**

- `server/internal/` contains the four layers as top-level directories.
- No direct database calls from handlers. No HTTP types in use cases.
- Game logic is a domain concern — it must not depend on infrastructure.
- The architecture is documented in `docs/architecture/server.md`.
