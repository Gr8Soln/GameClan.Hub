#!/usr/bin/env bash
set -e

SESSION_NAME="gameclan-apps"

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session $SESSION_NAME already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

echo "=> Starting GameClan.hub client applications..."

tmux new-session -d -s "$SESSION_NAME" -n "APPS"
tmux send-keys -t "$SESSION_NAME:APPS.0" "make mobile" C-m
tmux split-window -h -t "$SESSION_NAME:APPS"
tmux send-keys -t "$SESSION_NAME:APPS.1" "make web" C-m
tmux split-window -v -t "$SESSION_NAME:APPS.1"
tmux send-keys -t "$SESSION_NAME:APPS.2" "make admin" C-m

tmux attach-session -t "$SESSION_NAME"
