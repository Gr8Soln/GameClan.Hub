# Product Roadmap

This document describes the planned phases of GameClan.hub development.

**Status:** All phases beyond Phase 1 are planned, not committed timelines.

---

## Phase 1 — Bootstrap (Current)

**Goal:** Establish a clean, documented, extensible repository foundation.

- [x] Repository structure defined
- [x] Architecture documented
- [x] Engineering conventions defined (`AGENTS.md`)
- [x] ADRs written for all major decisions
- [x] Workflow documentation created
- [x] Game integration model documented
- [ ] Applications: not yet scaffolded
- [ ] Database schema: not yet defined
- [ ] Server: minimal entry point only

---

## Phase 2 — Platform Core

**Goal:** Implement the core platform backend and web application foundation.

- [ ] Go server infrastructure (HTTP server, configuration, graceful shutdown)
- [ ] Database connection and migration tooling
- [ ] Authentication (register, login, token management)
- [ ] User profiles
- [ ] Web application scaffolded
- [ ] REST API for auth and profiles
- [ ] WebSocket connection foundation

---

## Phase 3 — First Game

**Goal:** Integrate Find the Number as the first GameClan game.

- [ ] Game domain interface defined
- [ ] Find the Number game logic implemented in Go (server-authoritative)
- [ ] Matchmaking (basic)
- [ ] Game rooms
- [ ] Live game state via WebSocket
- [ ] Game results persisted
- [ ] Leaderboard for Find the Number

See [`../games/find-the-number.md`](../games/find-the-number.md) for game specification.

---

## Phase 4 — Social Features

**Goal:** Make GameClan.hub a social platform, not just a game host.

- [ ] Friends system
- [ ] Presence
- [ ] Persistent chat
- [ ] Notifications
- [ ] Player statistics
- [ ] Achievements
- [ ] XP and levels

---

## Phase 5 — Mobile and Growth

**Goal:** Launch mobile application and competitive features.

- [ ] Mobile application (React Native + Expo)
- [ ] Push notifications
- [ ] Challenges
- [ ] Seasonal leaderboards
- [ ] Moderation tools
- [ ] Admin application

---

## Future

- Additional games
- Tournament system
- Computer / AI opponents
- Spectator mode
- Replay viewer
