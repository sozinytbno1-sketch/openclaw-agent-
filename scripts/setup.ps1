# OpenClaw Agent Setup Script for Windows
# Run in PowerShell as Administrator (if needed for npm global installs)

$ErrorActionPreference = "Stop"

Write-Host "=== OpenClaw Agent Setup (Windows) ===" -ForegroundColor Cyan
Write-Host ""

# 1. Kill any processes on ports 8000 and 3000
Write-Host "[1/6] Killing processes on ports 8000 and 3000..." -ForegroundColor Yellow
Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
}
Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
}
Write-Host "  Done." -ForegroundColor Green

# 2. Check Node.js
Write-Host "[2/6] Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    $major = [int]($nodeVersion -replace 'v','').Split('.')[0]
    if ($major -lt 22) {
        Write-Host "  Node.js >= 22.14 required. Current: $nodeVersion" -ForegroundColor Red
        Write-Host "  Download Node 24 from: https://nodejs.org/en/download" -ForegroundColor Red
        exit 1
    }
    Write-Host "  Node.js $nodeVersion found." -ForegroundColor Green
} catch {
    Write-Host "  Node.js not found! Download from: https://nodejs.org/en/download" -ForegroundColor Red
    exit 1
}

# 3. Install OpenClaw
Write-Host "[3/6] Installing OpenClaw..." -ForegroundColor Yellow
$openclawCmd = Get-Command openclaw -ErrorAction SilentlyContinue
if (-not $openclawCmd) {
    npm install -g openclaw@latest
}
$openclawVersion = openclaw --version
Write-Host "  OpenClaw $openclawVersion installed." -ForegroundColor Green

# 4. Set up Python virtual environment
Write-Host "[4/6] Setting up Python virtual environment..." -ForegroundColor Yellow
$ProjectDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$VenvDir = Join-Path $ProjectDir ".venv"
if (-not (Test-Path $VenvDir)) {
    python -m venv $VenvDir
}
& "$VenvDir\Scripts\Activate.ps1"
pip install --quiet --upgrade pip
pip install --quiet numpy sympy requests beautifulsoup4 playwright
Write-Host "  Virtual environment ready at $VenvDir" -ForegroundColor Green

# 5. Install Playwright browsers
Write-Host "[5/6] Installing Playwright Chromium..." -ForegroundColor Yellow
playwright install chromium 2>$null
Write-Host "  Playwright Chromium installed." -ForegroundColor Green

# 6. Install MCP filesystem server
Write-Host "[6/6] Installing MCP filesystem server..." -ForegroundColor Yellow
npm install -g @modelcontextprotocol/server-filesystem 2>$null
Write-Host "  MCP filesystem server installed." -ForegroundColor Green

# 7. Copy config template if needed
$OpenClawDir = Join-Path $env:USERPROFILE ".openclaw"
$ConfigFile = Join-Path $OpenClawDir "openclaw.json"
if (-not (Test-Path $OpenClawDir)) {
    New-Item -ItemType Directory -Path $OpenClawDir -Force | Out-Null
}
if (-not (Test-Path $ConfigFile)) {
    $TemplatePath = Join-Path $ProjectDir "openclaw.json.template"
    if (Test-Path $TemplatePath) {
        # Read template and replace workspace path
        $WorkspacePath = (Join-Path $ProjectDir "workspace") -replace '\\', '/'
        $config = Get-Content $TemplatePath -Raw
        $config = $config -replace '/home/ubuntu/openclaw-agent/workspace', $WorkspacePath
        Set-Content -Path $ConfigFile -Value $config
        Write-Host "  Config copied to $ConfigFile (workspace: $WorkspacePath)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Cyan
Write-Host "Run: .\scripts\start.ps1 to launch the agent" -ForegroundColor White
