# Local Development Workflow

This guide explains how to set up and run the GameClan.hub development environment locally.

## Prerequisites

Ensure you have the following tools installed:
- Git
- Go 1.23+
- Node.js 20+
- npm (or pnpm/yarn)
- tmux (used for orchestrating the local dev environment)
- PostgreSQL (psql)
- Redis (redis-cli)

## First-Time Setup

To bootstrap your local environment, run:

```bash
make setup
```

This command is idempotent. It will:
- Check for required tools.
- Create `.env` files from `.env.sample` templates (it will never overwrite existing `.env` files).
- Install Node.js dependencies.
- Download Go modules.

## Running the Environment

Start all applications and services by running:

```bash
make dev
```

This command uses `tmux` to launch all services in a single terminal window, split into panes.

### Navigating tmux

The `make dev` session is divided into two windows:
1. **APPS**: Contains `mobile` (left), `web` (top-right), and `admin` (bottom-right).
2. **SERVER**: Contains the main `server` (top) and background `worker` (bottom).

Useful `tmux` shortcuts:
- `Ctrl+B`, then `n` or `p`: Switch between APPS and SERVER windows.
- `Ctrl+B`, then arrow keys: Move between panes in the current window.
- `Ctrl+B`, then `d`: Detach from the session (leaves it running in the background).
- `Ctrl+B`, then `z`: Zoom the current pane to full screen (and again to un-zoom).

To reattach to the session after detaching, run `make dev` again.

## Stopping the Environment

To stop all services and kill the `tmux` sessions, run:

```bash
make stop
```

## Running Individual Services

If you only want to run specific parts of the stack, you can use the following targets:
- `make dev-apps` - Starts only the web, admin, and mobile apps.
- `make dev-server` - Starts only the Go backend server.
- `make web` - Runs only the web application.
- `make admin` - Runs only the admin application.
- `make mobile` - Runs only the mobile application.
- `make server` - Runs only the Go server.
