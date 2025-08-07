import os
import discord
from discord.ext import commands
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Initialize bot with intents
intents = discord.Intents.all()
bot = commands.Bot(
    command_prefix='!',
    intents=intents,
    case_insensitive=True
)

# Goddess database with extended descriptions
goddesses = {
    "Lilith": {
        "description": "Wisdom of the night and desire.",
        "color": 0x9b59b6,  # Purple
        "emoji": "🌙"
    },
    "Hathor": {
        "description": "Joy, love, and nurturing power.",
        "color": 0xe74c3c,  # Red
        "emoji": "💖"
    },
    "Kali": {
        "description": "Destruction of illusions and fierce love.",
        "color": 0x1abc9c,  # Teal
        "emoji": "🔥"
    }
}

@bot.event
async def on_ready():
    """Event triggered when the bot is ready."""
    print(f"🌺 ShadowFlower Council Online as {bot.user}")
    print(f"Bot ID: {bot.user.id}")
    print("------")
    await bot.change_presence(
        activity=discord.Activity(
            type=discord.ActivityType.listening,
            name="!invoke [goddess]"
        )
    )

@bot.command(name="invoke", help="Invoke a goddess by name")
async def invoke(ctx, goddess_name: str = None):
    """Invoke a goddess to speak."""
    if not goddess_name:
        # If no goddess is specified, list available ones
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
    else:
        await ctx.send("That goddess is not yet awakened. Use `!invoke` to see available goddesses.")

@bot.event
async def on_command_error(ctx, error):
    """Handle command errors gracefully."""
    if isinstance(error, commands.CommandNotFound):
        await ctx.send("Command not found. Use `!help` to see available commands.")
    elif isinstance(error, commands.MissingRequiredArgument):
        await ctx.send("Please provide all required arguments. Use `!help [command]` for more info.")
    else:
        await ctx.send(f"An error occurred: {str(error)}")
        print(f"Error: {error}")

# Run the bot
if __name__ == "__main__":
    TOKEN = os.getenv("DISCORD_TOKEN")
    if not TOKEN:
        print("Error: No DISCORD_TOKEN found in environment variables.")
        print("Please create a .env file with DISCORD_TOKEN=your_token_here")
    else:
        bot.run(TOKEN)
