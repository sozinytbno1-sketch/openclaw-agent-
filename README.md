# OpenClaw Agent (Windows)

An agentic AI assistant with **Hermes-like capabilities** powered by OpenClaw, connected to your 9Router endpoint.

## Architecture

```
┌─────────────────────────────────────────────────┐
│                  Web UI (Control UI)              │
│              http://localhost:18789                │
└──────────────────────┬──────────────────────────┘
                       │
┌──────────────────────┴──────────────────────────┐
│              OpenClaw Gateway                     │
│         (Agent Runtime + Tool Router)             │
├─────────────────────────────────────────────────┤
│  Model: deepseek-v3 via 9Router                  │
│  Endpoint: http://127.0.0.1:20128/v1             │
└──────────┬──────────┬──────────┬────────────────┘
           │          │          │
    ┌──────┴───┐ ┌────┴────┐ ┌──┴──────────┐
    │ Browser  │ │  Exec   │ │ Filesystem  │
    │ (Chrome) │ │ (Shell) │ │ (MCP+Built) │
    └──────────┘ └─────────┘ └─────────────┘
           │          │          │
    ┌──────┴───┐ ┌────┴────┐ ┌──┴──────────┐
    │Web Search│ │ Python  │ │  MCP Server │
    │(DuckDuck)│ │  venv   │ │ (filesystem)│
    └──────────┘ └─────────┘ └─────────────┘
```

## Skills (Hermes-like Capabilities)

| Skill | Tool | Description |
|-------|------|-------------|
| **Browse & Search** | `browser`, `web_search` | Navigate websites, extract data, search the web |
| **Execute Code** | `exec` | Run Python/Shell commands, solve math, process data |
| **File Management** | `read`, `write`, `edit` + MCP filesystem | Read, write, edit files in workspace |
| **Web Fetch** | `web_fetch` | Fetch and parse web page content |

## Prerequisites

- **Windows 10/11**
- **Node.js >= 22.14** (24 recommended) — [Download](https://nodejs.org/en/download)
- **Python 3.10+** — [Download](https://www.python.org/downloads/)
- **Git** — [Download](https://git-scm.com/download/win)
- **9Router** running on `http://127.0.0.1:20128/v1`

## Quick Start (PowerShell)

```powershell
# 1. Clone the repo
git clone https://github.com/sozinytbno1-sketch/openclaw-agent-.git
cd openclaw-agent-

# 2. Run setup (installs OpenClaw, Python venv, Playwright, MCP server)
.\scripts\setup.ps1

# 3. Start the agent
.\scripts\start.ps1

# 4. Open Web UI
# Navigate to http://localhost:18789
# Use: openclaw dashboard --no-open   to get URL with auth token
```

> **Note:** If PowerShell blocks script execution, run this first:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

## Configuration

### 9Router Connection
- **Endpoint**: `http://127.0.0.1:20128/v1`
- **Model**: `deepseek-v3`
- **API**: OpenAI-compatible completions

### Config File
The setup script copies `openclaw.json.template` to `%USERPROFILE%\.openclaw\openclaw.json`.

**Important:** After copying, edit the `workspace` path and `mcp.servers.filesystem.args` path in the config to match where you cloned the repo. The setup script does this automatically.

### MCP Servers
- **filesystem**: Provides file read/write/search in `.\workspace\`

## Project Structure

```
openclaw-agent-/
├── .env                         # Environment variables
├── .gitignore
├── README.md                    # This file
├── openclaw.json.template       # OpenClaw config template
├── workspace/                   # Agent workspace (file operations target here)
├── skills/                      # Skill definitions
│   ├── browser-skill.md
│   ├── code-skill.md
│   └── filesystem-skill.md
└── scripts/
    ├── setup.ps1                # Windows setup (PowerShell)
    ├── start.ps1                # Launch the agent (PowerShell)
    ├── stop.ps1                 # Stop all services (PowerShell)
    ├── setup.sh                 # Linux/macOS setup (bash)
    ├── start.sh                 # Linux/macOS launch (bash)
    └── stop.sh                  # Linux/macOS stop (bash)
```

## Testing

### Browser Skill
Ask the agent: *"Search for the latest technology news today"*

### Code Skill
Ask the agent: *"Solve the integral of x^3 * e^x dx using Python"*

### Filesystem Skill
Ask the agent: *"Create a file called hello.txt with 'Hello World' in the workspace"*

## Troubleshooting

### PowerShell Execution Policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Gateway won't start
- Ensure 9Router is running: `curl http://127.0.0.1:20128/v1/models`
- Check config: `openclaw config validate`
- Check logs: `openclaw gateway status`

### Token auth
After first run, the gateway generates an auth token. Get the tokenized URL:
```powershell
openclaw dashboard --no-open
```
