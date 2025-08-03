#!/usr/bin/env python3
"""Generate a consolidated Markdown view of all council profiles.

Refactored for clarity and logging to aid future integrations.
"""
from __future__ import annotations

import argparse
import logging
from pathlib import Path
from typing import List, Dict

import yaml  # type: ignore

logging.basicConfig(level=logging.INFO, format="[%(asctime)s] %(levelname)s: %(message)s")


def load_profiles(profile_dir: Path) -> List[Dict]:
    """Return list of profile dictionaries from YAML files."""
    profiles: List[Dict] = []
    for path in sorted(profile_dir.glob("*.yaml")):
        with path.open("r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
            data["_path"] = path  # keep reference for potential cross-linking
            profiles.append(data)
    logging.debug("Loaded %d profiles", len(profiles))
    return profiles


def render_markdown(profiles: List[Dict]) -> str:
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


def main(argv: List[str] | None = None) -> int:
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
    args = parser.parse_args(argv)

    profiles = load_profiles(args.profile_dir)
    markdown = render_markdown(profiles)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(markdown, encoding="utf-8")
    logging.info("Wrote %d profiles to %s", len(profiles), args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
