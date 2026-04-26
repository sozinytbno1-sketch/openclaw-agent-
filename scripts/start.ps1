# OpenClaw Agent Start Script for Windows

$ErrorActionPreference = "Stop"

Write-Host "=== Starting OpenClaw Agent ===" -ForegroundColor Cyan

$ProjectDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Source .env if exists
$EnvFile = Join-Path $ProjectDir ".env"
if (Test-Path $EnvFile) {
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
            $key = $matches[1].Trim()
            $val = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($key, $val, "Process")
        }
    }
}

# Activate Python venv
$VenvActivate = Join-Path $ProjectDir ".venv\Scripts\Activate.ps1"
if (Test-Path $VenvActivate) {
    & $VenvActivate
}

# Kill existing gateway if running
Get-NetTCPConnection -LocalPort 18789 -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 1

# Start OpenClaw Gateway in foreground
Write-Host "Starting OpenClaw Gateway on port 18789..." -ForegroundColor Yellow
Write-Host ""
Write-Host "=== OpenClaw Agent is running! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Web UI:  http://localhost:18789" -ForegroundColor Cyan
Write-Host "Gateway: http://localhost:18789" -ForegroundColor Cyan
Write-Host "Model:   deepseek-v3 via 9Router (http://127.0.0.1:20128/v1)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Skills:" -ForegroundColor White
Write-Host "  - Browser (web search & navigation)" -ForegroundColor White
Write-Host "  - Code Interpreter (Python/Shell execution)" -ForegroundColor White
Write-Host "  - Filesystem (read/write/manage files)" -ForegroundColor White
Write-Host "  - Web Search (DuckDuckGo - no API key needed)" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

# Run gateway in foreground
openclaw gateway run --port 18789 --force
