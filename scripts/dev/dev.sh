#!/usr/bin/env bash
set -e

SESSION_NAME="gameclan-dev"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session $SESSION_NAME already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

echo "=> Starting GameClan.hub development environment..."

# Create session with the first window for APPS
tmux new-session -d -s "$SESSION_NAME" -n "APPS"

# Setup APPS window
# Pane 0: Mobile (left 50%)
tmux send-keys -t "$SESSION_NAME:APPS.0" "make mobile" C-m
# Split right side into Web (top 25%) and Admin (bottom 25%)
tmux split-window -h -t "$SESSION_NAME:APPS"
tmux send-keys -t "$SESSION_NAME:APPS.1" "make web" C-m
tmux split-window -v -t "$SESSION_NAME:APPS.1"
tmux send-keys -t "$SESSION_NAME:APPS.2" "make admin" C-m

# Setup SERVER window
tmux new-window -t "$SESSION_NAME" -n "SERVER"
# Pane 0: API + ngrok (top half)
tmux send-keys -t "$SESSION_NAME:SERVER.0" "make server" C-m
# Split bottom half for Worker
tmux split-window -v -t "$SESSION_NAME:SERVER"
tmux send-keys -t "$SESSION_NAME:SERVER.1" "make worker" C-m

# Focus the first window
tmux select-window -t "$SESSION_NAME:APPS"

echo "Environment started in tmux. Attaching..."
tmux attach-session -t "$SESSION_NAME"
