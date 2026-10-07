# ADR-005 — REST and WebSocket

## Status

Accepted

## Context

The GameClan.hub server must support both standard request/response operations (user profiles, match history, leaderboards) and low-latency realtime operations (live game state, chat, presence, notifications).

A decision was needed about the API protocols.

## Decision

Use **REST** for request/response operations and **WebSocket** for realtime operations.

GraphQL is not adopted as the primary API.

### REST covers:
- Authentication
- User profiles
- Game discovery
- Match creation and history retrieval
- Leaderboards
- Friend management
- Notification history
- Conversation history
- Settings

### WebSocket covers:
- Live multiplayer game state
- Game actions during a match
- Chat messages
- Presence
- Match status changes
- Realtime notifications

## Consequences

**Benefits:**

- REST is well-understood, easy to test, and well-supported by all clients.
- WebSocket provides low-latency bidirectional communication needed for multiplayer gaming.
- The two protocols have clearly distinct responsibilities, reducing protocol ambiguity.
- REST endpoints are individually cacheable, documentable, and versionable.

**Tradeoffs:**

- Managing both REST and WebSocket adds complexity compared to a single protocol.
- The team must maintain clear conventions for which operations use which protocol.

**Implications:**

- All API contracts are shared in `@gameclan/contracts` (see ADR-001).
- WebSocket uses a commands-and-events model: clients send commands, the server broadcasts events.
- The protocol distinction is documented in `docs/architecture/realtime.md`.
- GraphQL is not introduced without a new ADR.
