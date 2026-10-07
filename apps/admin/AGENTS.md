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
