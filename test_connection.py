import os
from dotenv import load_dotenv
import pytest

load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')


def test_discord_token_configured():
    if not TOKEN or TOKEN == 'your_discord_bot_token_here':
        pytest.skip('DISCORD_TOKEN not configured')
    assert isinstance(TOKEN, str)
