#!/usr/bin/env bash
echo "=== Stopping OpenClaw Agent ==="

# Stop gateway
openclaw gateway stop 2>/dev/null || true

# Kill any remaining processes
lsof -ti:18789 2>/dev/null | xargs -r kill -9 2>/dev/null || true
lsof -ti:8000 2>/dev/null | xargs -r kill -9 2>/dev/null || true
lsof -ti:3000 2>/dev/null | xargs -r kill -9 2>/dev/null || true

echo "All processes stopped."
