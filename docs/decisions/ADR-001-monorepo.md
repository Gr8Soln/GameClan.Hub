# ADR-001 — Monorepo

## Status

Accepted

## Context

GameClan.hub consists of multiple applications and shared packages that must work together: a Go backend server, a consumer web application, a mobile application, an admin application, and shared client contracts. These components share domain types, API contracts, and development conventions.

A decision was needed about whether to use a monorepo (all components in one repository) or a polyrepo (separate repositories per component).

## Decision

Use a monorepo for all GameClan.hub software.

The monorepo contains:

- `apps/web` — consumer web application
- `apps/admin` — admin application
- `apps/mobile` — mobile application
- `server/` — Go backend server
- `packages/contracts` — shared client/server type contracts
- `packages/api-client` — shared API client
- `packages/validation` — shared validation schemas
- `docs/` — architecture and product documentation
- `scripts/` — development scripts

## Consequences

**Benefits:**

- Shared contracts between clients and the server can be updated atomically in a single changeset.
- Cross-cutting concerns (conventions, tooling, CI/CD) are managed in one place.
- Easier for developers and AI agents to understand the full system in context.
- Simpler dependency management between internal packages.
- A single source of truth for architecture decisions and documentation.

**Tradeoffs:**

- Repository size grows as more components are added.
- Monorepo tooling (workspace configuration, selective builds, CI caching) must be managed.
- All teams share a single repository, which requires coordination conventions.

**Implications:**

- A JavaScript package manager with workspace support (npm, pnpm, or yarn workspaces) manages the web, mobile, admin, and JavaScript packages.
- The Go server is managed independently under `server/` with its own `go.mod`.
- Build and CI pipelines should be scoped to detect changes per application and avoid rebuilding unaffected components.
