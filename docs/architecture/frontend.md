# Frontend Architecture

GameClan.hub has three client applications: the consumer web app, the mobile app, and the admin app.

All clients consume the same GameClan server via REST API and WebSocket.

**Status:** Architecture documented. Applications not yet implemented.

---

## Client Overview

```
┌────────────────────────────────────────────────────┐
│  apps/web         apps/mobile       apps/admin     │
│  Next.js 15       React Native      Next.js 15     │
│  App Router       Expo              App Router      │
│  TypeScript       TypeScript        TypeScript      │
└──────────────┬─────────────┬──────────────┬────────┘
               │             │              │
               └─────────────┴──────────────┘
                             │
                REST API + WebSocket
                             │
                    GameClan Server (Go)
```

---

## Consumer Web Application (`apps/web`)

| Property | Value |
|---|---|
| Framework | Next.js 15 |
| Router | App Router |
| Language | TypeScript |
| UI Library | React 19 |

### Key Conventions

- Default to **React Server Components**. Use `'use client'` only where browser interactivity or browser APIs are needed.
- Consume API types from `@gameclan/contracts`.
- Do not implement game rules or authoritative game state.

---

## Mobile Application (`apps/mobile`)

| Property | Value |
|---|---|
| Framework | React Native + Expo |
| Navigation | Expo Router |
| Language | TypeScript |

### Key Conventions

- Use Expo SDK for platform capabilities.
- Target both iOS and Android.
- Consume API types from `@gameclan/contracts`.
- The server is authoritative for game state.

---

## Admin Application (`apps/admin`)

| Property | Value |
|---|---|
| Framework | Next.js 15 |
| Router | App Router |
| Language | TypeScript |

The admin application is **completely separate** from the consumer web application. It shares the same server but has its own authentication, routing, and access control.

---

## Shared Packages

| Package | Purpose |
|---|---|
| `@gameclan/contracts` | TypeScript types for all API request/response shapes and WebSocket envelopes. Shared across all clients. |
| `@gameclan/api-client` | Shared API client with type-safe HTTP and WebSocket helpers. |
| `@gameclan/validation` | Shared validation schemas for common inputs. |

### Contract Ownership

`@gameclan/contracts` is the **explicit interface** between clients and the server. Changes to the API must be reflected in contracts before clients are updated.

---

## Realtime

All clients connect to the GameClan server over WebSocket for:

- Live game state
- Chat messages
- Presence updates
- Match status
- Realtime notifications

See [`realtime.md`](realtime.md) for the full realtime architecture.

---

## Current State

All three applications are **planned**. The repository structure and conventions are established. Scaffolding and implementation will begin in subsequent development phases.
