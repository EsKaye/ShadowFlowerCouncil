import os
import discord
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')

# Set up basic logging
print("=== Testing Discord Bot Connection ===")
print(f"Token found: {'Yes' if TOKEN and TOKEN != 'your_discord_bot_token_here' else 'No'}")

if not TOKEN or TOKEN == 'your_discord_bot_token_here':
    print("❌ Error: Please set your Discord bot token in the .env file")
    exit(1)

# Initialize client with minimal intents
intents = discord.Intents.default()
intents.message_content = True
client = discord.Client(intents=intents)

@client.event
async def on_ready():
    print(f"✅ Successfully logged in as {client.user}")
    print(f"Bot ID: {client.user.id}")
    print("Type 'exit' to close the connection")

@client.event
async def on_message(message):
    if message.author == client.user:
        return
    
    if message.content.lower() == 'ping':
        await message.channel.send('Pong! 🏓')

# Run the test
print("\nAttempting to connect to Discord...")
try:
    client.run(TOKEN)
except discord.LoginFailure:
    print("❌ Failed to connect: Invalid token. Please check your token in the .env file")
except discord.PrivilegedIntentsRequired:
    print("❌ Error: Missing required intents. Please enable 'Message Content Intent' in the Discord Developer Portal")
except Exception as e:
    print(f"❌ An error occurred: {str(e)}")
