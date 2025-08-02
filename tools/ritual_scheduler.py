"""Schedule rituals using leyline data and IP geolocation."""
import json
import requests
from datetime import datetime
from pathlib import Path
import schedule
import time

LEYLINE_FILE = Path('leyline_data.json')


def fetch_location():
    """Get approximate latitude and longitude using ip-api."""
    resp = requests.get('http://ip-api.com/json/')
    data = resp.json()
    return float(data.get('lat', 0)), float(data.get('lon', 0))


def load_leylines():
    if not LEYLINE_FILE.exists():
        return []
    return json.loads(LEYLINE_FILE.read_text())


def find_nearest_leyline(lat, lon, leylines):
    closest = None
    best_dist = float('inf')
    for ll in leylines:
        d = (lat - ll['lat']) ** 2 + (lon - ll['lon']) ** 2
        if d < best_dist:
            best_dist = d
            closest = ll
    return closest


def ritual_task(leyline):
    print(f"\n[ {datetime.now()} ] Ritual at {leyline['name']} ({leyline['lat']}, {leyline['lon']})")


def main():
    lat, lon = fetch_location()
    leylines = load_leylines()
    nearest = find_nearest_leyline(lat, lon, leylines)
    if nearest:
        schedule.every().day.at('06:00').do(ritual_task, nearest)
        schedule.every().day.at('18:00').do(ritual_task, nearest)
        print(f"Scheduled rituals near {nearest['name']} at 06:00 and 18:00")
        while True:
            schedule.run_pending()
            time.sleep(1)
    else:
        print('No leyline data found.')


if __name__ == '__main__':
    main()
