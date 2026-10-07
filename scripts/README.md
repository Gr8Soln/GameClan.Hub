# Scripts

This directory contains development and automation scripts for GameClan.hub.

**Status:** No scripts have been implemented yet. This directory will be populated as development tooling is established.

---

## Planned Scripts

| Script | Purpose |
|---|---|
| `setup.sh` | Initial development environment setup |
| `dev.sh` | Start all services in development mode |
| `test.sh` | Run all tests (server + clients) |
| `migrate.sh` | Run database migrations |
| `seed.sh` | Seed development database with test data |
| `lint.sh` | Run all linters (Go + TypeScript) |

---

## Guidelines for Scripts

- Scripts must be documented with a header comment explaining their purpose and usage.
- Scripts must be idempotent where possible.
- Scripts must fail loudly on error (`set -e` for shell scripts).
- Do not hardcode secrets or environment-specific values in scripts. Use environment variables.
- Keep scripts simple. Complex orchestration belongs in a proper build tool or CI configuration.
