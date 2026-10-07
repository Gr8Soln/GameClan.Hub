# Find the Number

Find the Number is the first planned game for GameClan.hub.

An existing working browser-based version of the game exists. This document describes the game's mechanics as they should eventually be modelled within the GameClan platform.

**Status:** Planned. The game will not be migrated or rebuilt during the repository bootstrap. It will be integrated in Phase 3.

---

## Overview

Find the Number is a turn-based multiplayer number game. Two players compete on a shared number board. One player (**the selector**) secretly selects a target number. The other player (**the finder**) attempts to identify it by clicking numbers on the board. Players alternate between the selector and finder roles across multiple rounds.

---

## Players

- **2 players** required.
- Each player alternates between the **selector** role and the **finder** role.

---

## Game Board

- The board displays a grid of numbers.
- Each number on the board can be in one of several states:
  - Available (not yet used)
  - Selected (the current target, visible to the selector only)
  - Found (correctly identified by the finder)
  - Wrong (an incorrect guess)
  - Used (no longer available)
- Once a number has been used, it cannot be selected or guessed again.

---

## Roles

### Selector

- Chooses a number from the available numbers on the board.
- The chosen number is hidden from the finder.
- Waits while the finder attempts to identify the number.

### Finder

- Sees the board without knowing which number is selected.
- Clicks numbers to guess the target.
- Correct guess: the round ends. Points are awarded.
- Wrong guess: a time penalty is applied to the finder's clock.

---

## Turns and Clocks

- Each player has an **individual clock** tracking their time.
- The clock runs only for the active player.
- If a player's clock runs out, they lose the game.
- Incorrect guesses by the finder subtract time from the finder's clock (time penalty).

---

## Scoring

- Points are awarded when the finder correctly identifies the selected number.
- The scoring formula is based on the remaining time or the speed of identification (exact formula TBD during implementation).
- The player with more points at the end of the game wins.

---

## Game Completion

- The game ends when:
  - All numbers have been used, or
  - A player's clock runs out.
- The player with the higher score wins.
- If scores are equal, the game is a draw.

---

## GameClan Integration Plan

When integrated into GameClan.hub, Find the Number will be implemented as a game module on the server:

| Concept | Find the Number Implementation |
|---|---|
| **Metadata** | Name, description, 2 players required, multiplayer only |
| **Rules** | Selector/finder mechanic, turn structure, clock rules, penalty rules |
| **State** | Board state (numbers + their states), scores, clocks, current roles, current turn |
| **Commands** | `select_number` (selector), `guess_number` (finder) |
| **Events** | `number_selected`, `guess_correct`, `guess_wrong`, `round_complete`, `game_over` |
| **Result** | Winner, final scores, final clock times |
| **Statistics** | Games played, games won, numbers found, average time per find |

### Implementation Notes

- Game rules must be implemented on the **server** (Go), not in the client.
- The existing browser game contains rules in React UI code. The authoritative implementation must move to the server before the game is integrated into GameClan.
- Clients receive state updates via WebSocket events and render accordingly.
- The finder's correct/wrong guess decisions are validated by the server, not the client.

---

## Current State

The existing Find the Number game is a standalone browser application and is **not part of this repository**. It will be referenced and eventually integrated in Phase 3 of the roadmap.

See [`../product/roadmap.md`](../product/roadmap.md) for the integration timeline.
