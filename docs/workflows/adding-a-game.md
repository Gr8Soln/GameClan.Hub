# Workflow: Adding a Game

This document describes the workflow for integrating a new game into GameClan.hub.

Read the [game integration model](../games/README.md) and the [general feature workflow](adding-a-feature.md) first.

---

## Prerequisites

Before adding a game:

- The game's rules must be fully specified in `docs/games/<game-name>.md`.
- The game contract (the Go interface between platform and game) must be finalised.
- The game must have a unique identifier (`game_id`) registered with the platform.

---

## Workflow

### 1. Document the game

Create `docs/games/<game-name>.md` documenting:

- Game overview and rules
- Player requirements (min/max players)
- State model
- Commands
- Events
- Result structure
- Statistics

### 2. Implement game logic in the domain layer

- Create a new package under `server/internal/domain/games/<game-name>/`.
- Implement the game contract interface.
- Game logic must be **pure** — no database calls, no HTTP, no Redis.
- Write comprehensive unit tests for the game rules.

### 3. Register the game with the platform

- Add the game to the game registry (the registry design will be documented when the first game is integrated).
- Provide game metadata: name, description, player requirements, capabilities.

### 4. Add use cases

- Add any game-specific use cases in the application layer if the platform's generic match use cases are insufficient.
- Prefer extending the platform's generic use cases over adding game-specific application logic.

### 5. Update contracts

- If the game introduces new command or event types, add them to `@gameclan/contracts`.
- Game-specific commands and events should be namespaced clearly (e.g., `find_the_number.select_number`).

### 6. Add game discovery metadata

- Add a database entry (or seed) for the new game's metadata (name, description, icon, etc.).
- Write the migration if the game requires game-specific configuration stored in the database.

### 7. Update clients

- Implement the game UI in `apps/web` and `apps/mobile`.
- The client receives game state via WebSocket events and renders it.
- The client submits commands via WebSocket.
- The client must not contain authoritative game rules.

### 8. Test end-to-end

- Test game creation, joining, playing, and completion.
- Test edge cases: player disconnect, clock expiry, invalid commands.
- Verify leaderboard updates correctly after a game.

---

## Game Logic Rules

- Game rules live in the **domain layer** (`server/internal/domain/`).
- Game logic must be testable without a database, Redis, HTTP, or UI.
- Game state must be serialisable.
- The platform must not need to understand game-specific rules to manage a match.

---

## Currently Planned Games

| Game | Documentation | Status |
|---|---|---|
| Find the Number | [find-the-number.md](../games/find-the-number.md) | Planned (Phase 3) |
