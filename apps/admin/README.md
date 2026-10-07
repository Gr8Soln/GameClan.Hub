# GameClan Admin

The admin application for GameClan.hub.

This is a **separate application** from the consumer web application (`apps/web`). It shares the same Go backend but operates as a distinct Next.js project with its own authentication, routing, and access controls.

## Technology

- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript
- **UI Library:** React 19

## Scope

The admin application provides internal tooling for platform operators:

- User management and moderation
- Content management
- Reporting and analytics (planned)
- Game management
- Platform configuration

## Key Principles

- This application is strictly for internal/operator use. It must never be accessible to regular users.
- Admin authentication is separate from consumer authentication.
- The same GameClan server handles both consumer and admin API requests, with separate authorisation rules.

## Status

> **Planned.** Application not yet scaffolded.

## Running

> Planned. Once scaffolded:

```bash
cd apps/admin
npm run dev
```
