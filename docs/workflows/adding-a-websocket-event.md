# Workflow: Adding a WebSocket Command or Event

This document describes the workflow for adding a new WebSocket command or event to the GameClan server.

Read the [general feature workflow](adding-a-feature.md) and [realtime architecture](../architecture/realtime.md) first.

---

## Understand the Direction

**Command** — client → server. A client sends a command to request a state change.

**Event** — server → client. The server broadcasts an event after processing a command.

Most WebSocket additions involve both: a new command triggers a new event.

---

## Checklist

- [ ] Determine whether this is a command, an event, or both
- [ ] Define the command envelope type in `@gameclan/contracts/realtime`
- [ ] Define the event envelope type in `@gameclan/contracts/realtime`
- [ ] Implement the command handler on the server (presentation layer)
- [ ] Implement the use case in the application layer
- [ ] Implement the event broadcast logic
- [ ] Write tests for the command handling and event dispatch
- [ ] Update the realtime architecture documentation if the design changed
- [ ] Update consuming clients

---

## Server-Side Implementation

### Command Handler (Presentation Layer)

- Receives the raw WebSocket message.
- Deserialises the command envelope.
- Validates the command (sender is authenticated, sender is in the relevant match/conversation, etc.).
- Calls the appropriate application use case.
- Does not contain business logic.

### Use Case (Application Layer)

- Executes the business logic in response to the command.
- Calls repository interfaces if state must be persisted.
- Returns events to be broadcast.
- Does not reference WebSocket types directly.

### Event Broadcast

- Events are broadcast to the relevant set of connected clients (e.g., all players in a match, all members of a conversation).
- The broadcasting mechanism is an infrastructure concern (implemented using Redis Pub/Sub or similar).
- The use case should not need to know which specific WebSocket connections exist.

---

## Contracts

All WebSocket message envelope types are defined in `@gameclan/contracts`.

A command envelope typically includes:
- `type` — the command name (e.g. `submit_game_action`)
- `payload` — command-specific data
- `correlationId` — optional, for request/response correlation (design TBD)

An event envelope typically includes:
- `type` — the event name (e.g. `game.turn_changed`)
- `payload` — event-specific data
- `timestamp` — when the event occurred

---

## Security

- All commands must be validated and authorised server-side.
- A client must not be able to send a command on behalf of another player.
- Game action commands must be validated against current game state.
- Invalid commands are rejected with an error response, not silently ignored.
