<!-- BEGIN:nextjs-agent-rules -->

## This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->


# Web App AGENTS.md

This file contains engineering rules specific to the consumer web application (`apps/web`).

The root [`AGENTS.md`](../../AGENTS.md) is authoritative. This file supplements it.

---

## Web-Specific Rules

### Next.js App Router

- Use the **App Router** exclusively. Do not use the Pages Router.
- Default to **React Server Components** (RSC). Use `'use client'` only when required for interactivity, browser APIs, or hooks that depend on browser state.
- Co-locate page-specific components with the page file in the `app/` directory.
- Shared components belong in a `components/` directory.

### Data Fetching

- Fetch data in Server Components where possible.
- Do not duplicate API type definitions locally — use `@gameclan/contracts`.
- Do not call the database directly from the web application.

### TypeScript

- Strict TypeScript. No `any` types unless absolutely unavoidable and explicitly annotated with a justification comment.
- All API response types must come from `@gameclan/contracts`.

### State Management

- Prefer React server state and URL state for most use cases.
- Add client-side state management only when the complexity clearly justifies it.

### Realtime

- WebSocket connections to the GameClan server handle realtime game state, chat, and presence.
- Do not implement alternative realtime mechanisms (polling, SSE) without a clear justification.

### Do Not

- Do not define authoritative game rules in the UI.
- Do not connect directly to the database.
- Do not duplicate type contracts that belong in `@gameclan/contracts`.
- Do not use the Pages Router.
