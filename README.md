# 🌸 ShadowFlower Council

Public nexus for the MK World Wide constellation. This repository hosts shared documentation, rituals, and prompts while coordinating autonomous guardian branches that evolve the ecosystem.

## Guardians
- **Athena** – strategy & intelligence
- **Persephone** – transformation & migrations
- **Brigid** – creativity & UX/content
- **Hecate** – security & hidden ops
- **Lilith** – experimental features

Lilybear serves as the voice and operations hub, relaying messages between guardians, MCP, and Serafina.

## How It Autonomously Evolves
- Nightly GitHub Action fast-forwards each guardian branch from `main` and opens PRs tagged `[council-auto]`.
- Merged updates trigger `on-merge-dispatch.yml` to notify MCP and dispatch events to dependent repos.
- Rituals in `rituals/` and prompts in `prompts/` keep context flowing across the network.

## MCP & Serafina Integration
- `mcp.manifest.json` describes channels and directories consumed by the MCP server.
- Secrets `MCP_URL` and `DISCORD_WEBHOOK_COUNCIL` allow automated notifications.
- Downstream repos such as Serafina and GameDinVR listen for `repository_dispatch` events.

### VRChat Bridge Workflow
Serafina exposes slash commands (`/councilreport`, `/guardian`) and forwards messages to a Unity bridge via `UNITY_BRIDGE_URL`.
The Unity side uses `DiscordMessageReceiver` and `LilybearOpsBus` to deliver those payloads to in-world guardians.

**Local development for Serafina:**

```bash
cd serafina
npm install
npm run dev
```

Define environment variables in `.env` or the hosting platform (see [serafina/README.md](serafina/README.md)).

## Contributing
1. Fork and branch from the guardian that matches your feature.
2. Open a pull request to `main` using the template.
3. Keep docs updated; `docs/` holds architecture and intent references.

## Security
Review [SECURITY.md](SECURITY.md) for vulnerability reporting instructions.

---
Licensed under the [MIT License](LICENSE).
