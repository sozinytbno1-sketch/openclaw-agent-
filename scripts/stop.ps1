# OpenClaw Agent Stop Script for Windows

Write-Host "=== Stopping OpenClaw Agent ===" -ForegroundColor Cyan

# Stop gateway
try { openclaw gateway stop 2>$null } catch {}

# Kill any remaining processes on relevant ports
@(18789, 8000, 3000) | ForEach-Object {
    Get-NetTCPConnection -LocalPort $_ -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "All processes stopped." -ForegroundColor Green
