# Realtime Architecture

WebSockets are a first-class part of the GameClan.hub platform.

**Status:** Architecture documented. WebSocket implementation is planned.

---

## REST vs WebSocket

The two protocols serve distinct purposes and should not be mixed.

### REST — Request / Response Operations

Use REST for operations that follow a clear request/response pattern:

- Authentication (login, register, token refresh)
- User profile retrieval and update
- Game discovery and metadata
- Match creation and history retrieval
- Leaderboard queries
- Friend management (send, accept, decline requests)
- Notification history
- Conversation and message history
- Settings

### WebSocket — Realtime Operations

Use WebSocket for operations that require low latency or server-push behaviour:

- Live multiplayer game state updates
- Game actions submitted during a match
- Game events (turn changed, game finished, etc.)
- Chat messages within a match or conversation
- Presence updates (online, offline, in-game)
- Match status changes
- Realtime notifications (new message, friend request, etc.)

---

## Commands and Events

The WebSocket protocol distinguishes between commands (client → server) and events (server → client).

### Commands

A command is an intentional client request to change state. The server validates and authorises the command before executing it.

```
create_match          — Create a new match
join_match            — Join an existing match
start_match           — Start a pending match
submit_game_action    — Submit a game-specific action during a match
send_message          — Send a chat message
accept_friend_request — Accept a pending friend request
```

Commands may result in one or more events being broadcast to relevant clients.

### Events

An event represents something that happened. The server broadcasts events to relevant connected clients.

```
match.created           — A match was created
match.joined            — A player joined a match
game.started            — A game started
game.action_processed   — A game action was processed
game.turn_changed       — The active turn changed
game.finished           — A game ended
message.sent            — A chat message was sent
friend_request.accepted — A friend request was accepted
presence.changed        — A user's presence status changed
```

---

## Command / Event Flow

```
Client                    Server
  │                          │
  │──── Command ────────────▶│  1. Receive command
  │                          │  2. Validate and authorise
  │                          │  3. Execute via use case
  │                          │  4. Persist state changes
  │◀─── Event ───────────────│  5. Broadcast events to relevant clients
  │                          │
```

---

## Connection Lifecycle

> **Planned.** The WebSocket connection lifecycle (authentication, reconnection, heartbeat, graceful disconnect) will be designed before implementation.

Considerations:

- WebSocket connections must be authenticated. Unauthenticated connections are not permitted.
- The server must handle client disconnection gracefully, including mid-game disconnects.
- Reconnection must allow a client to recover ongoing game state.
- Redis will coordinate WebSocket state across server instances (if the server ever scales horizontally).

---

## Protocol Design

> **Planned.** The exact envelope format for commands and events (JSON structure, message types, correlation IDs) will be designed before implementation.

Type contracts for WebSocket envelopes will be published in `@gameclan/contracts/realtime`.

---

## Security

- All commands are validated server-side. Clients are never trusted as authoritative.
- Game actions must be validated against current game state before processing.
- Rate limiting applies to WebSocket messages as well as REST requests.
