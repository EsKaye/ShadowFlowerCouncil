# Serafina Service

Serafina is the council's Discord router and bridge into Unity/VRChat. It registers slash commands for manual council reports and guardian relays, schedules nightly status posts, and forwards messages into the in-world event bus.

## Development

```bash
cd serafina
npm install
npm run dev
```

Set environment variables in `.env` or the host platform:

- `DISCORD_TOKEN`
- `GUILD_ID` *(optional, limit command registration to a guild)*
- `CHN_COUNCIL` *(channel for council reports)*
- `MCP_URL` *(MCP endpoint for health summaries)*
- `UNITY_BRIDGE_URL` *(HTTP endpoint that forwards payloads to Unity)*
- `NAV_REPOS` *(comma-separated repo slugs for commit digests)*

## Slash Commands
- `/councilreport` – generate an immediate status summary
- `/guardian to:<name> message:<text>` – relay a message to an in-world guardian

## Further Improvements
- WebSocket bridge for lower latency Unity comms
- Message signing between mesh nodes
