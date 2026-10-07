# ADR-002 — Go Server

## Status

Accepted

## Context

A backend language and runtime was needed for the GameClan.hub server. The server must handle REST API requests, WebSocket connections for realtime gameplay and chat, and background platform operations such as matchmaking and notifications.

Key requirements:

- High concurrency for many simultaneous WebSocket connections
- Low overhead per connection
- Strong standard library
- Good ecosystem for building HTTP services
- Statically typed
- Fast build and deployment

## Decision

Use **Go** as the backend language.

The server is a single Go application (`server/`) serving all clients — web, mobile, and admin.

## Consequences

**Benefits:**

- Go's goroutine model handles high concurrency with low memory overhead, well-suited to WebSocket-heavy workloads.
- The standard library (`net/http`, `encoding/json`, `database/sql`) covers most server needs without heavy dependencies.
- Fast compilation and single binary deployment simplify CI/CD.
- Strong typing and interfaces enable Clean Architecture patterns naturally.
- Excellent tooling for testing, formatting, and static analysis (`go test`, `go vet`, `golangci-lint`).

**Tradeoffs:**

- Go's verbosity compared to scripting languages increases the lines of code required for some operations.
- Fewer ORM choices than ecosystems like Node.js or Python.

**Implications:**

- The server follows Clean Architecture (see ADR-006).
- The Go module lives at `server/go.mod` with module path `github.com/gameclan/server`.
- No other backend language is introduced without a new ADR.
