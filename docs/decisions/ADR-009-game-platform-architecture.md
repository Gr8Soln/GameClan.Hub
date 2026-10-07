# ADR-009 — Game / Platform Architecture

## Status

Accepted

## Context

GameClan.hub is designed to host multiple games over time. Each game has its own rules, state, and behaviour. The platform provides shared infrastructure (matchmaking, rooms, leaderboards, profiles, chat) used by all games.

A decision was needed about how game-specific logic relates to platform logic, and how to prevent game rules from leaking into platform code as the number of games grows.

## Decision

Separate the **Platform Core** from the **Game System** with a clear boundary.

### Platform Core

The platform handles all functionality shared across games:
- Authentication, users, profiles, friends, presence
- Notifications, chat, conversations
- Game discovery, matchmaking, rooms
- Leaderboards, XP, levels, achievements, challenges
- Player statistics, moderation, reporting

The platform owns a `Match` entity that identifies which game is being played and tracks players, status, and results.

### Game System

Each game is an independent domain implementation. A game exposes:

```
Metadata     — name, description, player requirements, rules summary
Rules        — win conditions, valid actions, turn structure
State        — current state of an in-progress game
Commands     — player actions
Events       — state changes resulting from commands
Result       — final outcome
Statistics   — per-player game-specific stats
```

**The platform must not contain game-specific rules.** A `Match` knows its `GameID` but does not understand the internal rules of that game.

Game logic is delegated to the game module via a well-defined interface (to be designed before the first game integration).

## Consequences

**Benefits:**

- New games can be added without modifying platform code.
- Game logic is independently testable without the platform running.
- Platform features (leaderboards, matchmaking) work uniformly across all games.
- Each game can evolve its rules, state model, and scoring independently.

**Tradeoffs:**

- The game contract (the interface between platform and game) must be designed carefully. Getting it wrong early will require refactoring across multiple games.
- Discipline is required to keep platform code free of game-specific logic.

**Implications:**

- The concrete Go game interface will be designed before the first game (Find the Number) is integrated.
- Game documentation lives in `docs/games/`.
- The first game is **Find the Number** (see `docs/games/find-the-number.md`).
