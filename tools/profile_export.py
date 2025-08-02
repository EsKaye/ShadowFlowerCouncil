#!/usr/bin/env python3
"""Generate a consolidated Markdown view of all council profiles.

This script scans the `profiles` directory for YAML files and exports
an easy-to-read Markdown table summarizing name, sigil, gift, and wound
for each council member. The table helps readers browse lore quickly
without digging through individual files.
"""

from pathlib import Path
import argparse
import yaml  # type: ignore


def load_profiles(profile_dir: Path):
    """Return list of profile dictionaries from YAML files."""
    profiles = []
    for path in sorted(profile_dir.glob("*.yaml")):
        # Reading each YAML profile ensures the Nexus UI can stay in sync
        with path.open("r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
            data["_path"] = path  # keep reference for potential cross-linking
            profiles.append(data)
    return profiles


def render_markdown(profiles: list[dict]) -> str:
    """Render profiles into a Markdown table."""
    lines = [
        "# ShadowFlower Council Profiles",
        "",
        "| Name | Sigil | Gift | Wound |",
        "|------|-------|------|-------|",
    ]
    for profile in profiles:
        lines.append(
            f"| {profile['name']} | {profile['sigil']} | {profile['gift']} | {profile['wound']} |"
        )
    lines.append("")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Export council profiles to Markdown")
    parser.add_argument(
        "--profile-dir",
        type=Path,
        default=Path("profiles"),
        help="Directory containing YAML profiles",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("docs/COUNCIL_PROFILES.md"),
        help="Markdown file to write",
    )
    args = parser.parse_args()

    profiles = load_profiles(args.profile_dir)
    markdown = render_markdown(profiles)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(markdown, encoding="utf-8")
    print(f"Wrote {len(profiles)} profiles to {args.output}")


if __name__ == "__main__":
    main()
