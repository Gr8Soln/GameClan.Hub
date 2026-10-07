# Contracts AGENTS.md

This file contains engineering rules specific to the `@gameclan/contracts` package.

The root [`AGENTS.md`](../../AGENTS.md) is authoritative. This file supplements it.

---

## Contracts-Specific Rules

### What Belongs Here

- TypeScript types and interfaces that represent the shape of API requests and responses.
- TypeScript types for WebSocket command and event envelopes.
- Shared enumeration types used by both clients and the server.

### What Does Not Belong Here

- Business logic or validation implementations.
- UI components.
- Server-side only types (internal domain types not exposed to clients).
- Fetch utilities or API client code (those belong in `@gameclan/api-client`).

### Change Discipline

- **Contracts are an explicit public interface.** Change them deliberately.
- Before changing a contract: identify all consumers (web, admin, mobile) and plan the coordinated update.
- Breaking changes must be communicated clearly. When possible, prefer additive changes.
- When a contract changes, update the server implementation and all consuming clients in the same changeset, or explicitly document a migration plan.

### Do Not

- Do not add implementation code to this package.
- Do not define types that are only used internally by one application.
- Do not silently break consumers.
