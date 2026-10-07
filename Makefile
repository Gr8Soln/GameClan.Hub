.PHONY: help setup dev dev-apps dev-server stop clean web admin mobile server worker ngrok install test lint format check

help: ## Show this help message
	@echo "GameClan.hub Local Development Commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Bootstrap the local environment (idempotent)
	@bash scripts/dev/setup.sh

dev: ## Start the complete development environment (tmux)
	@bash scripts/dev/dev.sh

dev-apps: ## Start only the client applications
	@bash scripts/dev/apps.sh

dev-server: ## Start only the backend server and its dependencies
	@bash scripts/dev/server.sh

stop: ## Stop all GameClan-specific processes and tmux sessions
	@tmux kill-session -t gameclan-dev 2>/dev/null || true
	@tmux kill-session -t gameclan-apps 2>/dev/null || true
	@tmux kill-session -t gameclan-server 2>/dev/null || true
	@echo "GameClan processes stopped."

clean: ## Remove build artifacts and caches
	@echo "Cleaning caches and node_modules..."
	@rm -rf node_modules apps/*/node_modules packages/*/node_modules
	@rm -rf .next apps/*/.next
	@rm -rf .expo apps/*/.expo
	@echo "Clean complete."

web: ## Run the web app only
	@npm run dev -w apps/web

admin: ## Run the admin app only
	@npm run dev -w apps/admin

mobile: ## Run the mobile app only
	@npm run start -w apps/mobile

server: ## Run the backend API only
	@cd server && go run ./cmd/gameclan/

worker: ## Run the background worker only
	@cd server && go run ./cmd/gameclan/ -worker

ngrok: ## Run ngrok for local tunneling
	@echo "ngrok not configured yet"

install: ## Install dependencies
	@npm install
	@cd server && go mod download

test: ## Run tests for all packages
	@npm run test
	@cd server && go test ./...

lint: ## Run linting for all packages
	@npm run lint
	@cd server && go vet ./...

format: ## Format all packages
	@npm run format 2>/dev/null || true
	@cd server && gofmt -w .

check: lint test ## Run all checks (lint + test)
