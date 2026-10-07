# Mobile App AGENTS.md

This file contains engineering rules specific to the mobile application (`apps/mobile`).

The root [`AGENTS.md`](../../AGENTS.md) is authoritative. This file supplements it.

---

## Mobile-Specific Rules

### Expo and React Native

- Use **Expo Router** for navigation. Do not introduce an alternative navigation library.
- Use the **Expo SDK** for platform capabilities (camera, notifications, sensors). Avoid bare React Native modules where Expo provides an equivalent.
- Target both iOS and Android. Do not implement features that only work on one platform without an explicit plan for the other.

### TypeScript

- Strict TypeScript. No `any` types without justification.
- All API response types must come from `@gameclan/contracts`.

### Platform-Specific Code

- Use `.ios.tsx` / `.android.tsx` file suffixes only when platform-specific behaviour is genuinely necessary.
- Prefer cross-platform implementations.

### State and Realtime

- Consume shared contracts from `@gameclan/contracts`.
- WebSocket connections to the GameClan server handle realtime game state, chat, and presence.
- The server is authoritative. Do not implement game rules in the mobile client.

### Do Not

- Do not implement game rules or authoritative game state in the client.
- Do not make direct database connections.
- Do not use web-only APIs (localStorage, DOM APIs).
