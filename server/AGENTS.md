# Server AGENTS.md

This file contains engineering rules specific to the Go backend server.

The root [`AGENTS.md`](../AGENTS.md) is authoritative. This file supplements it with server-specific guidance.

---

## Server-Specific Rules

### Architecture

- Follow Clean Architecture strictly. Dependencies always point inward.
- **Domain** layer: entities, value objects, domain rules, repository interfaces. No imports from application, infrastructure, or presentation.
- **Application** layer: use cases and orchestration. Depends only on domain. No direct database calls. No HTTP-specific types.
- **Infrastructure** layer: implements repository interfaces defined in the domain. Contains all database, Redis, and external service code.
- **Presentation** layer: HTTP handlers and WebSocket handlers. Calls into application use cases. Never directly calls infrastructure.
- Do not import `net/http` or database drivers from the domain or application layers.

### Adding New Functionality

1. Define domain entities and interfaces in `internal/domain/`.
2. Define use cases in `internal/application/`.
3. Implement repository adapters in `internal/infrastructure/`.
4. Expose endpoints in `internal/presentation/`.
5. Add a database migration in `migrations/` if a schema change is required.
6. Update `packages/contracts/` if client-facing API changes.

### Domain Boundaries

- Platform logic (auth, users, matchmaking) is strictly separated from game logic.
- Game-specific rules must not leak into platform code.
- The platform identifies which game a match belongs to but does not execute game rules.

### Database

- All schema changes require a migration file in `migrations/`.
- Follow the migration workflow in [`docs/workflows/database-migration.md`](../docs/workflows/database-migration.md).
- Never modify already-applied migrations. Add a new migration instead.
- Repository interfaces are defined in the domain layer. SQL implementations live in infrastructure.

### Observability

- Use structured logging (key-value pairs, not printf-style).
- Errors must be wrapped with context using `fmt.Errorf("context: %w", err)`.
- Sensitive fields (passwords, tokens) must never appear in logs.
- Plan for OpenTelemetry-compatible tracing from the beginning — do not instrument after the fact.

### WebSocket

- All commands received over WebSocket must be validated and authorised server-side.
- Clients are never trusted as authoritative sources of game state.
- WebSocket event dispatch must be designed to handle connection drops gracefully.

### Testing

- Domain logic must be testable without a database, Redis, or HTTP.
- Use interfaces and dependency injection to keep tests isolated.
- Integration tests that require a real database live in `tests/`.
- Game rules require dedicated test suites.

### Dependencies

- Add dependencies deliberately. Each dependency must justify its inclusion.
- Do not add a library to avoid writing ten lines of Go.
- Prefer the standard library where it is sufficient.
