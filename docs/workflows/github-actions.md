# GitHub Actions

This document describes the GameClan.hub GitHub Actions CI system — what each workflow does, when it runs, what it validates, and how to reproduce checks locally.

**Status:** Current as of repository bootstrap phase. Workflows will expand as the codebase grows.

---

## Workflow Overview

| Workflow | File | Triggers | Purpose |
|---|---|---|---|
| CI | `ci.yml` | PR, push to `main` | Fast feedback: Go format, vet, build, test |
| Server Integration | `server-integration.yml` | PR, push to `main` | Go tests with real PostgreSQL + Redis |
| Database | `database.yml` | PR, push to `main` | Migration validation against a clean database |
| Security | `security.yml` | PR, push to `main`, weekly | Vulnerability scan + lint |

---

## CI (`ci.yml`)

**Purpose:** Primary fast-feedback loop. Should pass on every pull request.

**What it validates:**
- Go source files are correctly formatted (`gofmt`)
- No issues detected by `go vet`
- The server module compiles (`go build ./...`)
- All Go tests pass (`go test ./...`)

**What it deliberately does not do:**
- No frontend checks — the web, admin, and mobile apps contain no source code yet. Frontend CI steps will be added when those apps are scaffolded.
- No deployment or release steps.

**Reproduce locally:**
```bash
cd server

# Formatting check (mirrors CI — lists unformatted files without modifying them)
gofmt -l .

# Vet
go vet ./...

# Build
go build ./...

# Test
go test ./...
```

---

## Server Integration (`server-integration.yml`)

**Purpose:** Runs Go tests with real PostgreSQL and Redis infrastructure available.

**Infrastructure provisioned by CI:**
- PostgreSQL 16 on `localhost:5432` (database: `gameclan_test`, user: `gameclan`)
- Redis 7 on `localhost:6379`

Both services have health checks. Tests start only after both services report healthy.

**Environment variables set:**

| Variable | Value in CI |
|---|---|
| `GAMECLAN_DB_HOST` | `localhost` |
| `GAMECLAN_DB_PORT` | `5432` |
| `GAMECLAN_DB_NAME` | `gameclan_test` |
| `GAMECLAN_DB_USER` | `gameclan` |
| `GAMECLAN_DB_PASSWORD` | `gameclan_test` |
| `GAMECLAN_REDIS_ADDR` | `localhost:6379` |

**Current state:** No integration tests exist yet. `go test ./...` exits 0 with `[no test files]`. The workflow establishes the correct infrastructure and environment for when integration tests are written.

**Convention for integration tests:** Use a Go build tag to separate integration tests from unit tests:
```go
//go:build integration

package infrastructure_test
```

Run integration tests locally with:
```bash
cd server
# Requires local PostgreSQL and Redis running
GAMECLAN_DB_HOST=localhost \
GAMECLAN_DB_PORT=5432 \
GAMECLAN_DB_NAME=gameclan_test \
GAMECLAN_DB_USER=gameclan \
GAMECLAN_DB_PASSWORD=gameclan_test \
GAMECLAN_REDIS_ADDR=localhost:6379 \
go test -tags integration ./...
```

---

## Database (`database.yml`)

**Purpose:** Verifies that the committed migration history can build a database from scratch.

**Principle:** A fresh database must be reproducibly constructible from the migration files in `server/migrations/`.

**What it does:**
1. Starts a clean PostgreSQL 16 instance.
2. Verifies the database is reachable.
3. Discovers SQL files in `server/migrations/`.
4. If migrations exist: applies them in sorted order (consistent with the `0001_`, `0002_` naming convention).
5. If no migrations exist: prints an informational note and exits 0.

**Current state:** No migrations exist. The "no migrations" note is printed.

**When this becomes valuable:** As soon as the first `.sql` file is added to `server/migrations/`, this workflow will automatically validate it. No workflow changes required.

**Migration tool:** When the team selects a migration tool (`golang-migrate`, `goose`, etc.), the "Apply migrations" step in `database.yml` will be updated to use the tool's command. See [`database-migration.md`](database-migration.md) for the migration workflow.

**What it deliberately does not do:**
- Never connects to a production database.
- Never modifies or squashes existing migrations.

---

## Security (`security.yml`)

**Purpose:** Baseline security automation. Runs on every PR/push and weekly on `main`.

**Jobs:**

### `go-vulnerabilities` — `govulncheck`
- Uses the official Go vulnerability database to scan for known CVEs in dependencies.
- Currently produces a clean result (no external dependencies).
- Will flag any newly discovered vulnerabilities in dependencies as they are added.

### `go-lint` — `golangci-lint`
- Runs the official `golangci-lint` action with default linters.
- Default linters include: `gofmt`, `govet`, `ineffassign`, `staticcheck`.
- Configured for a 5-minute timeout.

**Weekly schedule:** Catches newly published CVEs against existing dependencies even without code changes.

**What it deliberately does not do:**
- No CodeQL — heavy static analysis. Will be considered when there is substantial Go and TypeScript source.
- No npm audit — no installed npm dependencies yet (no `package-lock.json`).
- No SARIF upload — kept simple for bootstrap. Can be added later.

---

## Dependabot

Configured in `.github/dependabot.yml`.

| Ecosystem | Directory | Schedule |
|---|---|---|
| Go modules | `/server` | Weekly (Monday) |
| GitHub Actions | `/` | Weekly (Monday) |

**npm is not configured.** Dependabot for npm requires a lockfile (`package-lock.json`). The JS apps have no installed dependencies yet. npm Dependabot will be added when the apps are scaffolded.

---

## Branch Protection (Manual Configuration Required)

GitHub branch protection cannot be configured automatically by a workflow. A repository administrator must configure the following in **GitHub → Repository Settings → Branches → Branch rulesets** for the `main` branch:

### Required status checks (must pass before merge)
- `Go — Format / Vet / Build / Test` (from `ci.yml`)
- `Go — Integration Tests` (from `server-integration.yml`)
- `Migration Validation` (from `database.yml`)

### Additional rules
- ✅ Require branches to be up to date before merging
- ✅ Require a pull request before merging
- ✅ Require at least 1 approving review (recommended)
- ✅ Block force pushes to `main`
- ✅ Restrict direct pushes to `main`
- ✅ Require linear history (optional, but recommended for clean history)

### AI-generated code policy

AI coding agents (Claude, Codex, Gemini, etc.) must meet exactly the same CI requirements as human-authored code. There is no special CI path for AI-generated changes.

CI acts as a safety net: an agent that introduces a formatting error, compilation failure, or broken test will have the error surfaced before merge.

---

## Adding New CI Checks

As the repository grows, follow these principles:

1. **Keep `ci.yml` fast.** It runs on every PR. If a check is slow, consider moving it to a separate workflow.
2. **Add frontend CI steps in `ci.yml` when apps have real source code and real scripts.** The web and admin apps will need lint, type-check, and build steps once they are scaffolded.
3. **Add npm Dependabot when a lockfile exists.**
4. **Update `database.yml` when a migration tool is adopted** — replace the `psql` loop with the tool's command.
5. **Add CodeQL when there is substantial source to analyze.**
