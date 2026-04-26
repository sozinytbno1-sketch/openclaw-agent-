# Browser Skill

You have full browser automation capabilities. Use the `browser` tool to:

## Capabilities
- **Navigate** to any URL: `browser({ action: "navigate", url: "https://..." })`
- **Search the web** using `web_search({ query: "..." })` for real-time information
- **Take screenshots** of web pages for visual analysis
- **Click elements** using accessibility tree refs like `@e1`, `@e2`
- **Type text** into input fields
- **Extract data** from web pages using accessibility tree snapshots

## Guidelines
- Always use `web_search` for quick factual queries and latest news
- Use `browser` for interactive pages that require JavaScript rendering
- When asked to "find the latest news", use `web_search` first, then optionally browse specific results
- Extract key information and present it in a structured format
