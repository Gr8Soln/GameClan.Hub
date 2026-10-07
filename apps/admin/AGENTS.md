<!-- BEGIN:nextjs-agent-rules -->

## This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->


# Admin App AGENTS.md

This file contains engineering rules specific to the admin application (`apps/admin`).

The root [`AGENTS.md`](../../AGENTS.md) is authoritative. This file supplements it.

---

## Admin-Specific Rules

### Separation from Consumer Web

- The admin app is **completely separate** from `apps/web`. Do not share route definitions, auth flows, or UI components between them.
- Do not import from `apps/web` and do not allow `apps/web` to import from `apps/admin`.
- Shared UI primitives (if any) belong in a dedicated shared package, not in either app directly.

### Authentication and Access

- Admin authentication is strictly separate from consumer authentication.
- All admin API routes on the server must verify admin-level authorisation.
- Do not expose consumer-only data without authorisation checks appropriate for admin context.

### Next.js App Router

- Use the **App Router** exclusively.
- Follow the same RSC-first approach as the consumer web app.

### Do Not

- Do not expose admin functionality to regular users.
- Do not share authentication sessions with the consumer web application.
- Do not implement game-playing features in the admin application.
