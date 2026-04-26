# OpenClaw Agent

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
    │ (Chrome) │ │ (Shell) │ │ (MCP+Built)│
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

## Quick Start

```bash
# 1. Run setup (installs everything)
./scripts/setup.sh

# 2. Start the agent
./scripts/start.sh

# 3. Open Web UI
# Navigate to http://localhost:18789
```

## Configuration

### 9Router Connection
- **Endpoint**: `http://127.0.0.1:20128/v1`
- **Model**: `deepseek-v3`
- **API**: OpenAI-compatible completions

### Config File
Main config: `~/.openclaw/openclaw.json`

### Environment
Environment vars: `.env`

### MCP Servers
- **filesystem**: Provides file read/write/search in `./workspace/`

## Project Structure

```
openclaw-agent/
├── .env                    # Environment variables
├── .venv/                  # Python virtual environment
├── README.md               # This file
├── workspace/              # Agent workspace (file operations target here)
├── skills/                 # Skill definitions
│   ├── browser-skill.md
│   ├── code-skill.md
│   └── filesystem-skill.md
└── scripts/
    ├── setup.sh            # Full setup script
    ├── start.sh            # Launch the agent
    └── stop.sh             # Stop all services
```

## Testing

### Browser Skill
Ask the agent: *"Search for the latest technology news today"*

### Code Skill
Ask the agent: *"Solve the integral of x^3 * e^x dx using Python"*

### Filesystem Skill
Ask the agent: *"Create a file called hello.txt with 'Hello World' in the workspace"*

## Requirements

- Node.js >= 22.14 (24 recommended)
- Python 3.10+
- 9Router running on `http://127.0.0.1:20128/v1`
