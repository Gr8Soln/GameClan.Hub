# @gameclan/contracts

Shared type contracts for the GameClan.hub platform.

This package is the **explicit interface between clients and the server**. It is consumed by the web application, mobile application, admin application, and informs the server implementation.

---

## Purpose

Contracts prevent clients and the server from drifting into incompatible shapes.

When the server's API changes, contracts must be updated first. Consumers then update to the new contract version.

---

## Planned Contract Areas

| Area | Description |
|---|---|
| `auth` | Authentication requests and responses (login, register, token refresh) |
| `users` | User profile shapes |
| `games` | Game metadata and discovery |
| `matches` | Match creation, state, history |
| `chat` | Conversation and message shapes |
| `notifications` | Notification payload shapes |
| `leaderboards` | Leaderboard entry shapes |
| `realtime` | WebSocket command and event envelope types |

---

## Usage

> **Planned.** This package is not yet populated. Contracts will be defined as the server API is implemented.

Once populated, consumers import from this package:

```typescript
import type { User, Match, GameMetadata } from '@gameclan/contracts';
```

---

## Ownership

- Contract definitions are owned jointly by the server and the consuming applications.
- Changes to contracts require coordinated updates across the server and all consumers.
- Treat breaking changes to contracts the same as breaking changes to a public API.
