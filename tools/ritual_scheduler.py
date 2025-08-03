"""Schedule rituals using leyline data and IP geolocation.

Refactored for resiliency, security, and clarity.
"""
from __future__ import annotations

import json
import logging
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import List, Optional, Tuple

import requests
import schedule

# ---- Configuration -----------------------------------------------------------------------------
LEYLINE_FILE = Path("leyline_data.json")
IP_API_URL = "https://ip-api.com/json/"  # Prefer HTTPS when available for data integrity
REQUEST_TIMEOUT = 5  # seconds

logging.basicConfig(level=logging.INFO, format="[%(asctime)s] %(levelname)s: %(message)s")


@dataclass
class Leyline:
    """Simple container for leyline coordinates."""

    name: str
    lat: float
    lon: float


def fetch_location() -> Optional[Tuple[float, float]]:
    """Return (lat, lon) using the ip-api service or None on failure."""
    try:
        resp = requests.get(IP_API_URL, timeout=REQUEST_TIMEOUT)
        resp.raise_for_status()
        data = resp.json()
        return float(data.get("lat", 0)), float(data.get("lon", 0))
    except requests.RequestException as exc:
        logging.error("Failed to fetch location: %s", exc)
        return None


def load_leylines() -> List[Leyline]:
    """Load leyline coordinates from local file."""
    if not LEYLINE_FILE.exists():
        logging.warning("Leyline file %s missing", LEYLINE_FILE)
        return []
    entries = json.loads(LEYLINE_FILE.read_text())
    return [Leyline(**e) for e in entries]


def find_nearest_leyline(lat: float, lon: float, leylines: List[Leyline]) -> Optional[Leyline]:
    """Return the nearest leyline to given coordinates."""
    closest: Optional[Leyline] = None
    best_dist = float("inf")
    for ll in leylines:
        dist = (lat - ll.lat) ** 2 + (lon - ll.lon) ** 2
        if dist < best_dist:
            best_dist = dist
            closest = ll
    return closest


def ritual_task(leyline: Leyline) -> None:
    """Log execution of a ritual."""
    logging.info("Ritual at %s (%.4f, %.4f)", leyline.name, leyline.lat, leyline.lon)


def main() -> int:
    """Entry point for scheduling daily rituals."""
    location = fetch_location()
    if not location:
        return 1

    lat, lon = location
    leylines = load_leylines()
    nearest = find_nearest_leyline(lat, lon, leylines)

    if nearest:
        schedule.every().day.at("06:00").do(ritual_task, nearest)
        schedule.every().day.at("18:00").do(ritual_task, nearest)
        logging.info("Scheduled rituals near %s at 06:00 and 18:00", nearest.name)
        try:
            while True:
                schedule.run_pending()
                time.sleep(1)
        except KeyboardInterrupt:
            logging.info("Ritual scheduler terminated by user")
    else:
        logging.warning("No leyline data found.")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
