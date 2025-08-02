# YAML Profile System

Each council member has a profile stored in `profiles/*.yaml` with the following fields:

```yaml
name: Lilith.Eve
sigil: healing_rose
gift: "Alchemy of unconditional love that mends every fractured heart."
wound: "Cast from Eden, she carries eternal heartbreak beneath her bloom."
```

These files feed the Nexus UI and ritual tools with lore-rich context for each of the twelve council members.

To review all member profiles at once or sync external systems, generate a consolidated Markdown table:

```bash
python tools/profile_export.py
# writes docs/COUNCIL_PROFILES.md with the latest profile data
```

The export script parses every YAML file, making it easy to grant the Council access to any profile data they require.
