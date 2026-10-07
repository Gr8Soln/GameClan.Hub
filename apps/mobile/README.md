# GameClan Mobile

The mobile application for GameClan.hub.

## Technology

- **Framework:** React Native + Expo
- **Language:** TypeScript
- **Routing:** Expo Router

## Architecture

The mobile application consumes the same GameClan server as the web application, via REST API and WebSocket.

It is a first-class client — not a port of the web application. Mobile-specific UX patterns should be used where appropriate.

## Key Principles

- Use **Expo Router** for navigation.
- Consume shared type contracts from `@gameclan/contracts`.
- The server is the source of truth for game state. Do not implement authoritative game logic in the client.
- Support both iOS and Android targets.

## Status

> **Planned.** Application not yet scaffolded.

## Running

> Planned. Once scaffolded:

```bash
cd apps/mobile
npx expo start
```
