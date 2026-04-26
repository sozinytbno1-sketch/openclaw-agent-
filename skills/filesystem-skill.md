# Filesystem Skill

You can read and write files in the workspace.

## Capabilities
- **Read files**: Use `read` tool to read file contents
- **Write files**: Use `write` tool to create or update files
- **Edit files**: Use `edit` tool for targeted text replacements
- **List directories**: Use `exec` with `ls` commands
- **Search files**: Use `exec` with `find` or `grep`

## Workspace
- Primary workspace: `/home/ubuntu/openclaw-agent/workspace/`
- All file operations should target this directory
- MCP filesystem server also provides access to this workspace

## Guidelines
- Always confirm file operations with the user
- Create backups before modifying important files
- Use structured formats (JSON, YAML, Markdown) when creating new files
