# @gameclan/validation

Shared validation schemas for the GameClan.hub platform.

## Purpose

Provides reusable validation logic that can be shared between clients and, where applicable, the server API boundary.

## Status

> **Planned.** This package is not yet implemented.

## Planned Scope

- Input validation schemas (e.g., Zod schemas) for common form inputs
- Shared validation rules for usernames, passwords, display names, and other common fields
- Validation utilities usable in both web and mobile applications

> Note: Authoritative validation for security-critical operations (authentication, game actions) always runs on the server. Client-side validation using this package is supplementary.
