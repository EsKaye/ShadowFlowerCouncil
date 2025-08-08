# ShadowFlower Council Architecture

The council is orchestrated by five guardian branches (Athena, Persephone, Brigid, Hecate, Lilith) and Lilybear as the voice and operations hub. Each guardian focuses on its specialty while communicating through MCP and Serafina.

Serafina bridges Discord and the Unity world:
- Slash commands dispatch messages through `UNITY_BRIDGE_URL`.
- Unity's `DiscordMessageReceiver` injects payloads into `LilybearOpsBus` so guardians can react in-world.
- Nightly council reports summarise MCP health and commit digests.

## Communication Map
- **Guardian branches** evolve features in isolation.
- **Nightly sync** fast-forwards guardians from `main` and opens PRs back.
- **MCP & Serafina** dispatch merged updates to dependent services and VRChat worlds.
- **Unity bridge** relays Discord-triggered messages into the VRChat world via `LilybearOpsBus`.
