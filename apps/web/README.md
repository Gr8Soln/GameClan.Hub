# GameClan Web

The consumer-facing web application for GameClan.hub.

## Technology

- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript
- **UI Library:** React 19

## Architecture

This application consumes the GameClan server via REST API and WebSocket.

It does **not** contain game rules or authoritative game state. The server is the source of truth.

## Key Principles

- Use the **App Router** (not the Pages Router).
- Prefer **React Server Components** for data-fetching pages. Use Client Components only where interactivity or browser APIs are required.
- Consume shared type contracts from `@gameclan/contracts`. Do not define client/server API shapes locally.
- Use `@gameclan/api-client` for server communication where available.
- Do not make direct database connections.

## Status

> **Planned.** Application not yet scaffolded. See [`docs/product/roadmap.md`](../../docs/product/roadmap.md) for implementation phases.

## Running

> Planned. Once scaffolded:

```bash
cd apps/web
npm run dev
```
