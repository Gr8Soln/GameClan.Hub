# ADR-008 — React Native and Expo

## Status

Accepted

## Context

A mobile framework was needed to deliver GameClan.hub on iOS and Android. Requirements included:

- Shared codebase across iOS and Android
- TypeScript support
- Good developer experience (fast iteration, hot reload)
- Access to native device capabilities (notifications, etc.)
- Ability to share code conventions and contracts with the web applications

## Decision

Use **React Native** with **Expo** for the mobile application (`apps/mobile`).

The application is written in TypeScript.

Flutter is not adopted.

## Consequences

**Benefits:**

- Shared React component model and TypeScript across web and mobile reduces cognitive overhead when switching contexts.
- Expo provides a managed workflow with access to native APIs without requiring native build toolchains for most development tasks.
- Expo Router provides file-based routing consistent with Next.js conventions.
- Large community and ecosystem.
- `@gameclan/contracts` can be shared directly with the mobile application, eliminating contract duplication.

**Tradeoffs:**

- React Native performance for graphics-intensive games may require native bridges or WebView-based rendering for certain game types.
- Expo managed workflow has some restrictions on native modules; ejecting may be required for advanced use cases.

**Implications:**

- Expo Router is used for navigation. No alternative navigation library is introduced without a new ADR.
- Both iOS and Android are first-class targets.
- The mobile app consumes the same GameClan server as the web and admin apps.
