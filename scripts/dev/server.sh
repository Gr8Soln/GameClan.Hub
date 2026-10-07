#!/usr/bin/env bash
set -e

SESSION_NAME="gameclan-server"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session $SESSION_NAME already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

echo "=> Starting GameClan.hub backend server..."

tmux new-session -d -s "$SESSION_NAME" -n "SERVER"
tmux send-keys -t "$SESSION_NAME:SERVER.0" "make server" C-m
tmux split-window -v -t "$SESSION_NAME:SERVER"
tmux send-keys -t "$SESSION_NAME:SERVER.1" "make worker" C-m

tmux attach-session -t "$SESSION_NAME"
