# Workflow: Adding an API Endpoint

This document describes the workflow for adding a new REST API endpoint to the GameClan server.

Read the [general feature workflow](adding-a-feature.md) first. This document focuses on the server-side and contract steps.

---

## Checklist

- [ ] Understand what the endpoint does and which client(s) will consume it
- [ ] Inspect existing handlers and use cases in the affected area
- [ ] Define the request and response shapes
- [ ] Update `@gameclan/contracts` with the new types
- [ ] Implement the domain changes (if any)
- [ ] Implement the use case in the application layer
- [ ] Implement the repository changes (if any) in infrastructure
- [ ] Add the HTTP handler in the presentation layer
- [ ] Register the route
- [ ] Write tests (unit + integration)
- [ ] Update consuming clients
- [ ] Update documentation

---

## Layer Responsibilities

### Domain

If the endpoint requires new or modified business entities:

- Add or update domain entities in `server/internal/domain/`.
- Add or update repository interfaces.
- Do not reference `net/http` in domain code.

### Application

- Add a use case (command handler or query handler) in `server/internal/application/`.
- The use case accepts a plain request struct and returns a plain response struct.
- The use case calls repository interfaces, not SQL directly.
- Do not import `net/http` or database packages.

### Infrastructure

- If the use case requires a new repository method, implement it in `server/internal/infrastructure/`.
- Infrastructure implements the interfaces defined in domain.

### Presentation

- Add an HTTP handler in `server/internal/presentation/`.
- The handler:
  1. Parses and validates the HTTP request.
  2. Calls the appropriate application use case.
  3. Translates the use case response to an HTTP response.
- The handler does not contain business logic.

### Route Registration

- Register the new route in the router.
- Follow the existing URL naming convention (`/api/v1/...`).

---

## Contracts

Before implementing the handler:

1. Define the request and response TypeScript types in `packages/contracts/`.
2. The server implementation must match the contract.
3. Clients must import from `@gameclan/contracts`, not define types locally.

---

## Testing

- Unit test the use case with mocked repositories.
- Integration test the handler with a real (test) database.
- Verify the contract types match the actual response shape.

---

## Database Migration

If the endpoint requires a schema change, follow the [database migration workflow](database-migration.md).
