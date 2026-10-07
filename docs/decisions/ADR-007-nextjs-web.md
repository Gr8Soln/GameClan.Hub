# ADR-007 — Next.js for Web and Admin

## Status

Accepted

## Context

A framework was needed for the consumer web application and the admin application. Requirements included:

- TypeScript support
- React-based component model
- Server-side rendering for SEO and performance
- Good developer experience
- Broad ecosystem and community
- Strong support for both static and dynamic content

## Decision

Use **Next.js 15** with the **App Router** for both the consumer web application (`apps/web`) and the admin application (`apps/admin`).

Both applications are written in TypeScript.

The two applications are **separate** Next.js projects. They are not combined into a single application.

## Consequences

**Benefits:**

- React Server Components (App Router) allow server-rendered pages with selective client-side interactivity.
- TypeScript support is first-class.
- Large ecosystem and community with extensive documentation.
- Flexible deployment (Vercel, self-hosted, Docker).
- Built-in routing, image optimisation, and API routes where needed.

**Tradeoffs:**

- The App Router model (RSC, Server Actions) requires understanding of the server/client component boundary.
- Two separate Next.js projects increases the surface area that must be maintained.

**Implications:**

- The Pages Router is not used. All routing uses the App Router.
- React Server Components are the default. `'use client'` is used only where required.
- Shared types come from `@gameclan/contracts`, not from locally duplicated types.
- The admin application is strictly separated from the consumer web application (separate auth, separate routes, separate deployment).
