# Game Integration Model

GameClan.hub is designed to host multiple games on a shared platform.

This document describes the intended model for how games integrate with the platform.

**Status:** Conceptual. The concrete Go interfaces will be designed before the first game is integrated.

---

## Principle

The platform and each game have strictly separated responsibilities.

**The platform does not contain game-specific rules.** A `Match` in the platform knows which game it belongs to, but the platform delegates all game logic to the game module.

## Conceptual Game Contract

Each game must eventually expose the following concepts to the platform:

### Metadata

Static information about the game:

- Name and description
- Minimum and maximum player count
- Human-readable rules summary
- Whether the game supports solo play, computer opponents, or multiplayer

### Rules

The logic that governs the game:

- What actions are valid in a given state
- How state transitions occur in response to actions
- Win conditions and draw conditions
- Turn structure (whose turn it is, how turns progress)

### State

The current state of an in-progress game:

- All information needed to render the game for each player
- State must be serialisable so it can be stored, transmitted, and reconstructed

### Commands

Actions that a player can submit during a game:

- Each command is specific to the game (e.g. "select a number", "place a piece")
- Commands are received and validated by the server
- Invalid commands are rejected

### Events

State changes that result from processing a command:

- Events are broadcast to all relevant players
- Events allow clients to update their view of the game

### Result

The final outcome of a completed game:

- Winner(s) and loser(s)
- Final scores
- Any game-specific result metadata

### Statistics

Per-player game-specific statistics:

- Recorded per match
- Aggregated over time for player profiles and leaderboards

---

## Platform / Game Interaction

```
Platform creates Match
        │
        ▼
Platform delegates game start → Game module initialises State
        │
        ▼
Player submits Command (via WebSocket)
        │
        ▼
Game module validates Command against State
        │
        ▼
Game module applies Command → new State + Events
        │
        ▼
Platform broadcasts Events to players
        │
        ▼
If game finished: Platform receives Result
                    │
                    ▼
                   Persists Result + Statistics
                   Updates leaderboards
```

---

## Games

| Game | Status | Documentation |
|---|---|---|
| Find the Number | Planned (first game) | [find-the-number.md](find-the-number.md) |

---

## Adding a New Game

See [`../workflows/adding-a-game.md`](../workflows/adding-a-game.md) for the workflow.
