import os
import sys
import logging
import discord
from discord.ext import commands
from dotenv import load_dotenv

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger('ShadowFlowerBot')

# Load environment variables
load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')

if not TOKEN or TOKEN == 'your_discord_bot_token_here':
    logger.error("No valid token found in .env file")
    sys.exit(1)

# Initialize bot with intents
intents = discord.Intents.default()
intents.message_content = True
intents.members = True

bot = commands.Bot(
    command_prefix='!',
    intents=intents,
    case_insensitive=True
)

# Goddess database
goddesses = {
    "Lilith": {
        "description": "Wisdom of the night and desire.",
        "color": 0x9b59b6,
        "emoji": "🌙"
    },
    "Hathor": {
        "description": "Joy, love, and nurturing power.",
        "color": 0xe74c3c,
        "emoji": "💖"
    },
    "Kali": {
        "description": "Destruction of illusions and fierce love.",
        "color": 0x1abc9c,
        "emoji": "🔥"
    }
}

@bot.event
async def on_ready():
    """Event triggered when the bot is ready."""
    logger.info(f'Logged in as {bot.user} (ID: {bot.user.id})')
    logger.info('------')
    await bot.change_presence(
        activity=discord.Activity(
            type=discord.ActivityType.listening,
            name="!invoke [goddess]"
        )
    )

@bot.command(name="invoke", help="Invoke a goddess by name")
async def invoke(ctx, goddess_name: str = None):
    """Invoke a goddess to speak."""
    try:
        if not goddess_name:
            # List available goddesses
            embed = discord.Embed(
                title="🌺 ShadowFlower Council",
                description="Invoke a goddess by typing `!invoke [name]`\n\n**Available Goddesses:**",
                color=0x9b59b6
            )
            
            for name, data in goddesses.items():
                embed.add_field(
                    name=f"{data['emoji']} {name}",
                    value=data["description"],
                    inline=False
                )
            
            await ctx.send(embed=embed)
            return
        
        # Process the goddess name
        goddess_name = goddess_name.capitalize()
        
        if goddess_name in goddesses:
            goddess = goddesses[goddess_name]
            embed = discord.Embed(
                title=f"{goddess['emoji']} {goddess_name} Speaks",
                description=goddess["description"],
                color=goddess["color"]
            )
            embed.set_footer(text="ShadowFlower Council")
            await ctx.send(embed=embed)
            logger.info(f"Successfully invoked {goddess_name}")
        else:
            await ctx.send("That goddess is not yet awakened. Use `!invoke` to see available goddesses.")
            logger.warning(f"Unknown goddess invoked: {goddess_name}")
            
    except Exception as e:
        logger.error(f"Error in invoke command: {e}", exc_info=True)
        await ctx.send("An error occurred while processing your request.")

@bot.event
async def on_command_error(ctx, error):
    """Handle command errors."""
    if isinstance(error, commands.CommandNotFound):
        return  # Ignore unknown commands
    
    logger.error(f"Command error: {error}", exc_info=True)
    
    if isinstance(error, commands.MissingRequiredArgument):
        await ctx.send("Please provide all required arguments. Use `!help [command]` for more info.")
    else:
        await ctx.send(f"An error occurred: {str(error)}")

if __name__ == "__main__":
    try:
        logger.info("Starting ShadowFlower Council bot...")
        bot.run(TOKEN)
    except discord.LoginFailure:
        logger.error("Failed to log in. Please check your bot token in the .env file.")
    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
