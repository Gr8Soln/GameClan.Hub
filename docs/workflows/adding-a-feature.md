# Workflow: Adding a Feature

This document describes the general engineering workflow for adding a new feature to GameClan.hub.

This applies to any feature: a new platform capability, a new API endpoint, a new UI screen, or a new game.

---

## Workflow

```
Understand the requirement
          │
          ▼
 Inspect existing architecture
          │
          ▼
 Identify affected domains and contracts
          │
          ▼
 Design the change
          │
          ▼
 Implement
          │
          ▼
 Test
          │
          ▼
 Update documentation and contracts
          │
          ▼
 Validate
```

---

## Step 1: Understand the Requirement

Before touching any code:

- Understand what the feature must do and why.
- Identify whether this is a platform feature or a game-specific feature.
- Identify the expected user-facing behaviour.

---

## Step 2: Inspect Existing Architecture

**Do not modify code before understanding what already exists.**

- Read relevant architecture documentation in `docs/architecture/`.
- Read relevant ADRs in `docs/decisions/`.
- Inspect the existing code in the affected area.
- Identify which layers will be affected (domain, application, infrastructure, presentation).
- Identify whether the change is additive or modifies existing behaviour.

---

## Step 3: Identify Affected Domains and Contracts

- Which domain entities are affected?
- Does the API contract change? If yes, `@gameclan/contracts` must be updated.
- Which clients consume the affected API?
- Does the database schema change? A migration will be needed.
- Does the WebSocket protocol change? See the [WebSocket event workflow](adding-a-websocket-event.md).

---

## Step 4: Design the Change

For non-trivial features, design before implementing:

- Sketch the domain model changes (new entities, changed relationships).
- Define the use case(s) in the application layer.
- Plan the API surface (REST endpoints or WebSocket commands/events).
- Plan the database migration if required.
- Consider failure modes and error handling.

---

## Step 5: Implement

Implement from the inside out, following Clean Architecture:

1. **Domain** — add or update entities, value objects, and repository interfaces.
2. **Application** — implement use cases.
3. **Infrastructure** — implement repository adapters, any external service integrations.
4. **Presentation** — add or update HTTP handlers or WebSocket handlers.
5. **Contracts** — update `@gameclan/contracts` if the API surface changed.
6. **Client** — update the affected client application(s).

Make the **smallest correct change**. Avoid scope creep and unrelated refactoring.

---

## Step 6: Test

- Write or update unit tests for domain logic.
- Write or update use case tests with mocked infrastructure.
- Write integration tests if the change touches the database or Redis.
- Verify the client(s) behave correctly with the new API.

---

## Step 7: Update Documentation and Contracts

- Update `@gameclan/contracts` if the API changed.
- Update architecture documentation if the design changed.
- Update workflow documentation if a process changed.
- Add or update an ADR if a technology or architecture decision changed.

---

## Step 8: Validate

- All tests pass.
- The feature works end-to-end.
- Documentation reflects the current state.
- No unrelated code was modified.
