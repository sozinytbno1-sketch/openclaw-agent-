#!/usr/bin/env bash
set -euo pipefail

echo "=== OpenClaw Agent Setup ==="
echo ""

# 1. Kill any processes on ports 8000 and 3000
echo "[1/6] Killing processes on ports 8000 and 3000..."
lsof -ti:8000 2>/dev/null | xargs -r kill -9 2>/dev/null || true
lsof -ti:3000 2>/dev/null | xargs -r kill -9 2>/dev/null || true
echo "  Done."

# 2. Check/Install Node.js
echo "[2/6] Checking Node.js..."
if ! command -v node &>/dev/null || [[ "$(node --version | sed 's/v//' | cut -d. -f1)" -lt 22 ]]; then
    echo "  Node.js >= 22.14 required. Please install Node 24:"
    echo "  curl -fsSL https://deb.nodesource.com/setup_24.x | sudo bash -"
    echo "  sudo apt-get install -y nodejs"
    exit 1
fi
echo "  Node.js $(node --version) found."

# 3. Install OpenClaw
echo "[3/6] Installing OpenClaw..."
if ! command -v openclaw &>/dev/null; then
    npm install -g openclaw@latest
fi
echo "  OpenClaw $(openclaw --version) installed."

# 4. Set up Python virtual environment
echo "[4/6] Setting up Python virtual environment..."
VENV_DIR="$(dirname "$(cd "$(dirname "$0")" && pwd)")/.venv"
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi
source "$VENV_DIR/bin/activate"
pip install --quiet --upgrade pip
pip install --quiet numpy sympy requests beautifulsoup4 playwright
echo "  Virtual environment ready at $VENV_DIR"

# 5. Install Playwright browsers
echo "[5/6] Installing Playwright Chromium..."
playwright install chromium 2>/dev/null || true
echo "  Playwright Chromium installed."

# 6. Install MCP filesystem server
echo "[6/6] Installing MCP filesystem server..."
npm list -g @modelcontextprotocol/server-filesystem &>/dev/null || npm install -g @modelcontextprotocol/server-filesystem
echo "  MCP filesystem server installed."

echo ""
echo "=== Setup Complete ==="
echo "Run: ./scripts/start.sh to launch the agent"
