#!/usr/bin/env bash
set -euo pipefail

echo "=== Starting OpenClaw Agent ==="

# Source environment
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if [ -f "$PROJECT_DIR/.env" ]; then
    set -a
    source "$PROJECT_DIR/.env"
    set +a
fi

# Activate Python venv
if [ -d "$PROJECT_DIR/.venv" ]; then
    source "$PROJECT_DIR/.venv/bin/activate"
fi

# Kill existing gateway if running
lsof -ti:18789 2>/dev/null | xargs -r kill -9 2>/dev/null || true
sleep 1

# Start OpenClaw Gateway
echo "Starting OpenClaw Gateway on port 18789..."
openclaw gateway start &
GATEWAY_PID=$!
sleep 3

echo ""
echo "=== OpenClaw Agent is running! ==="
echo ""
echo "Web UI:  http://localhost:18789"
echo "Gateway: http://localhost:18789"
echo "Model:   deepseek-v3 via 9Router (http://127.0.0.1:20128/v1)"
echo ""
echo "Skills:"
echo "  - Browser (web search & navigation)"
echo "  - Code Interpreter (Python/Shell execution)"
echo "  - Filesystem (read/write/manage files)"
echo "  - Web Search (DuckDuckGo - no API key needed)"
echo ""
echo "MCP Servers:"
echo "  - filesystem: workspace at $PROJECT_DIR/workspace"
echo ""
echo "Press Ctrl+C to stop"

# Wait for gateway
wait $GATEWAY_PID
