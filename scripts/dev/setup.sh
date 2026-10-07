#!/usr/bin/env bash
set -e

echo "=> Bootstrapping GameClan.hub local environment..."

echo "=> Checking required tools..."
for tool in git go node npm tmux psql redis-cli; do
    if ! command -v $tool &> /dev/null; then
        echo "Error: $tool is required but not installed."
        exit 1
    fi
done
echo "All required tools are installed."

echo "=> Setting up environment variables (won't overwrite existing)..."
for dest in apps/web apps/admin apps/mobile server; do
    if [ ! -f "$dest/.env" ]; then
        if [ -f "$dest/.env.sample" ]; then
            cp "$dest/.env.sample" "$dest/.env"
            echo "Created $dest/.env"
        fi
    else
        echo "Skipped $dest/.env (already exists)"
    fi
done

echo "=> Installing Node.js dependencies..."
npm install || echo "Warning: npm install encountered issues (likely workspace dependency conflicts). Continuing..."

echo "=> Downloading Go modules..."
cd server && go mod download && cd ..

echo "=> Setup complete! Run 'make dev' to start."
