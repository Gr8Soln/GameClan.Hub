# Workflow: Database Migration

This document describes the workflow for making database schema changes in the GameClan server.

---

## Principles

- Every schema change requires a migration file.
- Migration files are never modified after they have been applied to any environment.
- If a migration was wrong, create a new migration to correct it.
- Migrations should be forward-only (rollback migrations are optional but encouraged for development).
- Migrations must be tested before being applied to production.

---

## Migration Files

Migration files live in `server/migrations/`.

Naming convention:

```
{sequence}_{description}.sql

Examples:
0001_create_users.sql
0002_create_profiles.sql
0003_add_avatar_url_to_profiles.sql
```

Use a monotonically increasing sequence number (not a timestamp). This makes the migration order explicit and easy to read.

---

## Workflow

### 1. Plan the change

- Understand what schema change is needed.
- Consider the impact on existing data.
- Consider whether the change is backward-compatible with the current server code (important for zero-downtime deployments).

### 2. Write the migration

Create a new `.sql` file in `server/migrations/` with the next sequence number.

The migration must:

- Be idempotent where possible (`CREATE TABLE IF NOT EXISTS`, `ADD COLUMN IF NOT EXISTS`).
- Include a `-- Description:` comment at the top explaining the purpose.
- Handle existing data if necessary (e.g., backfill a new required column).

Example:

```sql
-- Description: Create initial users table

CREATE TABLE IF NOT EXISTS users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email       TEXT NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 3. Test the migration locally

- Apply the migration to your local development database.
- Verify the schema change is correct.
- Verify the server still starts and behaves correctly.

### 4. Update repository interfaces if needed

- If the migration adds or changes columns used by a repository, update the repository interface in `server/internal/domain/` and its implementation in `server/internal/infrastructure/`.

### 5. Apply to other environments

- Apply the migration to staging and production environments using the migration tool.

---

## Migration Tool

> **Planned.** The migration tooling (e.g., `golang-migrate`, `goose`, or a custom runner) will be selected and documented before the first migration is written. Migration files are plain SQL to remain tool-agnostic in the interim.

---

## Do Not

- Do not modify a migration file after it has been applied to any environment.
- Do not write schema changes directly in Go code.
- Do not skip the migration file for "quick" or "temporary" changes.
- Do not apply migrations manually in production without tracking them.
