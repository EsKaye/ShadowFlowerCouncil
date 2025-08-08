import os
import discord
import random
import asyncio
from datetime import datetime
from discord.ext import commands, tasks
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Initialize bot with intents
intents = discord.Intents.all()
class ShadowFlowerBot(commands.Bot):
    def __init__(self):
        super().__init__(
            command_prefix='!',
            intents=intents,
            case_insensitive=True,
            help_command=None  # We'll create a custom help command
        )
        self.start_time = datetime.utcnow()
        self.daily_blessing = {}

bot = ShadowFlowerBot()

# Goddess database with extended descriptions
goddesses = {
    # Original Goddesses
    "Lilith": {
        "description": "Wisdom of the night and desire. First of the divine feminine, she teaches the power of independence and self-knowledge.",
        "color": 0x9b59b6,  # Purple
        "emoji": "🌙",
        "invocation": "By the silver light of the moon, I call upon Lilith, first among equals...",
        "domains": ["wisdom", "independence", "desire", "knowledge"],
        "alignment": "Neutral"
    },
    "Hathor": {
        "description": "Goddess of joy, love, and nurturing power. She embodies the divine feminine's capacity for love and celebration.",
        "color": 0xe74c3c,  # Red
        "emoji": "💖",
        "invocation": "With joyful heart and open arms, I call upon Hathor, mother of delight...",
        "domains": ["love", "joy", "celebration", "nurturing"],
        "alignment": "Good"
    },
    "Kali": {
        "description": "The fierce mother who destroys illusions. She represents transformation through destruction of the false self.",
        "color": 0x1abc9c,  # Teal
        "emoji": "🔥",
        "invocation": "In the dance of destruction and creation, I call upon Kali the transformer...",
        "domains": ["destruction", "transformation", "power", "liberation"],
        "alignment": "Chaotic"
    },
    
    # New Goddesses
    "Athena": {
        "description": "Goddess of wisdom, strategy, and just warfare. She represents the power of intellect and strategic thinking.",
        "color": 0x3498db,  # Blue
        "emoji": "🦉",
        "invocation": "By the light of wisdom and sound judgment, I call upon Athena, strategist of the gods...",
        "domains": ["wisdom", "strategy", "warfare", "craft"],
        "alignment": "Lawful Good"
    },
    "Persephone": {
        "description": "Queen of the Underworld and goddess of spring's renewal. She embodies the cycle of life, death, and rebirth.",
        "color": 0x9b59b6,  # Purple
        "emoji": "🌷",
        "invocation": "Through the veil of seasons, I call upon Persephone, queen of transformation...",
        "domains": ["seasons", "underworld", "renewal", "mysteries"],
        "alignment": "Neutral"
    },
    "Brigid": {
        "description": "Celtic goddess of poetry, healing, and smithcraft. She is the keeper of the sacred flame of inspiration.",
        "color": 0xe74c3c,  # Red
        "emoji": "🔥",
        "invocation": "By the sacred flame of inspiration, I call upon Brigid, keeper of the eternal fire...",
        "domains": ["poetry", "healing", "smithcraft", "inspiration"],
        "alignment": "Good"
    },
    "Hecate": {
        "description": "Goddess of magic, crossroads, and the moon. She guides lost souls and bestows wisdom to those who seek it.",
        "color": 0x2ecc71,  # Green
        "emoji": "🌕",
        "invocation": "At the crossroads of destiny, I call upon Hecate, keeper of the keys...",
        "domains": ["magic", "moon", "crossroads", "necromancy"],
        "alignment": "Neutral"
    }
}

@bot.event
async def on_ready():
    """Event triggered when the bot is ready."""
    print(f"🌺 ShadowFlower Council Online as {bot.user}")
    print(f"Bot ID: {bot.user.id}")
    print("------")
    
    # Set a rotating status
    statuses = [
        discord.Activity(type=discord.ActivityType.listening, name="!help"),
        discord.Activity(type=discord.ActivityType.watching, name=f"over {len(bot.guilds)} servers"),
        discord.Game(name="with divine energy"),
        discord.Streaming(name="Divine Wisdom", url="https://twitch.tv/example")
    ]
    
    async def change_status():
        while True:
            for status in statuses:
                await bot.change_presence(activity=status)
                await asyncio.sleep(30)  # Change status every 30 seconds
    
    # Start the status rotation
    bot.loop.create_task(change_status())
    
    # Start background tasks
    if not update_daily_blessing.is_running():
        update_daily_blessing.start()

@bot.command(name="invoke", help="Invoke a goddess by name")
async def invoke(ctx, goddess_name: str = None):
    """Invoke a goddess to speak and share her wisdom."""
    try:
        if not goddess_name:
            # List available goddesses with pagination
            embed = discord.Embed(
                title="🌺 ShadowFlower Council",
                description=(
                    "The divine feminine speaks through many voices. "
                    "Call upon a goddess with `!invoke [name]`\n\n"
                    "**Available Goddesses:**"
                ),
                color=0x9b59b6
            )
            
            for name, data in goddesses.items():
                embed.add_field(
                    name=f"{data['emoji']} {name}",
                    value=f"{data['description'][:100]}... [invoke to learn more]",
                    inline=False
                )
            
            embed.set_footer(text=f"Use !invoke [name] to call upon a goddess • {len(goddesses)} goddesses available")
            await ctx.send(embed=embed)
            return
        
        # Process the goddess name (case-insensitive match)
        goddess_name = next((name for name in goddesses if name.lower() == goddess_name.lower()), None)
        
        if goddess_name:
            goddess = goddesses[goddess_name]
            
            # Create a rich embed response
            embed = discord.Embed(
                title=f"{goddess['emoji']} {goddess_name} Answers Your Call",
                description=(
                    f"*{goddess['invocation']}*\n\n"
                    f"**{goddess_name} says:** {goddess['description']}\n\n"
                    f"*The presence of {goddess_name} lingers in the air...*"
                ),
                color=goddess["color"]
            )
            
            # Add a random piece of wisdom or action
            actions = [
                f"{goddess_name} gazes deeply into your soul...",
                f"A gentle breeze carries {goddess_name}'s whisper...",
                f"{goddess['emoji']} The energy shifts as {goddess_name} makes her presence known...",
                f"In the distance, you hear {goddess_name}'s laughter..."
            ]
            
            import random
            embed.add_field(
                name="Divine Presence",
                value=random.choice(actions),
                inline=False
            )
            
            # Add a footer with a random blessing
            blessings = [
                "May her wisdom guide you.",
                "The goddess has spoken.",
                "Her message lingers in your heart.",
                "The divine feminine smiles upon you."
            ]
            
            embed.set_footer(
                text=f"ShadowFlower Council • {random.choice(blessings)}"
            )
            
            # Send the message with a small delay for dramatic effect
            message = await ctx.send("🌺 *The air shimmers with divine energy...*")
            import asyncio
            await asyncio.sleep(1.5)
            await message.edit(content="", embed=embed)
            
            logger.info(f"Successfully invoked {goddess_name}")
            
        else:
            await ctx.send(
                f"That goddess is not yet awakened. Use `!invoke` to see the current members of the ShadowFlower Council."
            )
            logger.warning(f"Unknown goddess invoked: {goddess_name}")
    except Exception as e:
        await ctx.send(f"An error occurred: {str(e)}")
        logger.error(f"Error invoking goddess: {e}")

@bot.command(name="help")
async def custom_help(ctx, command: str = None):
    """Show help information about commands."""
    if command:
        # Show help for a specific command
        cmd = bot.get_command(command.lower())
        if cmd:
            embed = discord.Embed(
                title=f"Command: {cmd.name}",
                description=cmd.help or "No description available.",
                color=0x9b59b6
            )
            if cmd.aliases:
                embed.add_field(name="Aliases", value=", ".join(cmd.aliases), inline=False)
            if cmd.signature:
                embed.add_field(name="Usage", value=f"!{cmd.name} {cmd.signature}", inline=False)
            await ctx.send(embed=embed)
        else:
            await ctx.send(f"Command '{command}' not found. Use `!help` to see all commands.")
    else:
        # Show general help
        embed = discord.Embed(
            title="🌺 ShadowFlower Council - Help",
            description="Call upon the divine feminine for guidance and wisdom.\n\n**Available Commands:**",
            color=0x9b59b6
        )
        
        command_list = [
            ("!invoke [goddess]", "Call upon a specific goddess for wisdom"),
            ("!blessing", "Receive a daily blessing from a random goddess"),
            ("!divine [question]", "Seek divine guidance with a yes/no question"),
            ("!goddesses", "List all available goddesses and their domains"),
            ("!about", "Learn about the ShadowFlower Council"),
            ("!help [command]", "Get help with a specific command")
        ]
        
        for cmd, desc in command_list:
            embed.add_field(name=cmd, value=desc, inline=False)
            
        embed.set_footer(text="Type !help [command] for more info on a command")
        await ctx.send(embed=embed)

@bot.command(name="blessing")
async def daily_blessing(ctx):
    """Receive a blessing from a random goddess."""
    guild_id = str(ctx.guild.id) if ctx.guild else "global"
    
    # Check if there's a cached blessing for today
    today = datetime.utcnow().strftime("%Y-%m-%d")
    if guild_id in bot.daily_blessing and bot.daily_blessing[guild_id].get("date") == today:
        blessing = bot.daily_blessing[guild_id]
    else:
        # Create a new blessing
        goddess_name, goddess = random.choice(list(goddesses.items()))
        blessings = [
            f"{goddess['emoji']} {goddess_name} bestows upon you the gift of {random.choice(goddess['domains'])}.",
            f"{goddess['emoji']} {goddess_name} whispers words of {random.choice(goddess['domains'])} to your heart.",
            f"{goddess['emoji']} {goddess_name} blesses you with {random.choice(['clarity', 'strength', 'wisdom', 'courage'])}.",
            f"{goddess['emoji']} {goddess_name} surrounds you with {random.choice(['love', 'light', 'protection', 'peace'])}.",
            f"{goddess['emoji']} {goddess_name} reveals a path of {random.choice(['healing', 'discovery', 'transformation', 'growth'])}."
        ]
        
        blessing = {
            "goddess": goddess_name,
            "message": random.choice(blessings),
            "date": today
        }
        bot.daily_blessing[guild_id] = blessing
    
    embed = discord.Embed(
        title=f"🌺 Daily Blessing from {blessing['goddess']}",
        description=blessing['message'],
        color=random.choice([0x9b59b6, 0xe74c3c, 0x1abc9c, 0x3498db, 0x2ecc71])
    )
    embed.set_footer(text="Blessings refresh daily")
    await ctx.send(embed=embed)

@bot.command(name="divine")
async def divine_guidance(ctx, *, question: str = None):
    """Seek divine guidance with a yes/no question."""
    if not question:
        await ctx.send("Please ask a question for the divine guidance.")
        return
    
    responses = [
        "The signs point to yes.",
        "Without a doubt.",
        "You may rely on it.",
        "Ask again later.",
        "Better not tell you now.",
        "Cannot predict now.",
        "Concentrate and ask again.",
        "Don't count on it.",
        "My reply is no.",
        "Very doubtful.",
        "The goddesses are undecided.",
        "The answer lies within your heart.",
        "The stars say yes, but be cautious.",
        "The path is unclear at this time.",
        "All signs indicate a positive outcome."
    ]
    
    # Add a dramatic pause
    message = await ctx.send("🔮 The divine energies swirl around your question...")
    await asyncio.sleep(2)
    
    # Choose a random goddess for the response
    goddess_name, goddess = random.choice(list(goddesses.items()))
    
    embed = discord.Embed(
        title=f"{goddess['emoji']} {goddess_name}'s Guidance",
        description=f"**Your Question:** {question}\n\n**Divine Answer:** {random.choice(responses)}",
        color=goddess['color']
    )
    embed.set_footer(text="The divine feminine speaks in mysterious ways")
    
    await message.edit(content=None, embed=embed)

@bot.command(name="goddesses")
async def list_goddesses(ctx):
    """List all available goddesses and their domains."""
    embed = discord.Embed(
        title="🌺 The Divine Pantheon",
        description="The sacred circle of the ShadowFlower Council",
        color=0x9b59b6
    )
    
    for name, data in goddesses.items():
        domains = ", ".join([f"`{d}`" for d in data['domains']])
        embed.add_field(
            name=f"{data['emoji']} {name} - {data['alignment']}",
            value=f"{data['description']}\n**Domains:** {domains}",
            inline=False
        )
    
    embed.set_footer(text=f"{len(goddesses)} divine beings in the council")
    await ctx.send(embed=embed)

@bot.command(name="about")
async def about(ctx):
    """Learn about the ShadowFlower Council."""
    uptime = datetime.utcnow() - bot.start_time
    days = uptime.days
    hours, remainder = divmod(int(uptime.total_seconds() - (days * 24 * 60 * 60)), 3600)
    minutes, _ = divmod(remainder, 60)
    
    embed = discord.Embed(
        title="🌺 About ShadowFlower Council",
        description=(
            "A sacred gathering of divine feminine energies, "
            "the ShadowFlower Council offers wisdom, guidance, and blessings "
            "to those who seek their counsel."
        ),
        color=0x9b59b6
    )
    
    embed.add_field(name="Uptime", value=f"{days}d {hours}h {minutes}m", inline=True)
    embed.add_field(name="Goddesses", value=str(len(goddesses)), inline=True)
    embed.add_field(name="Version", value="1.0.0", inline=True)
    
    creator = await bot.fetch_user(1234567890)  # Replace with your user ID
    if creator:
        embed.add_field(name="Created By", value=str(creator), inline=False)
    
    embed.set_footer(text="May the divine feminine guide your path")
    await ctx.send(embed=embed)

@tasks.loop(hours=24)
async def update_daily_blessing():
    """Update the daily blessing for all servers."""
    bot.daily_blessing.clear()
    print("Daily blessings have been reset!")

@bot.event
async def on_command_error(ctx, error):
    """Handle command errors gracefully."""
    if isinstance(error, commands.CommandNotFound):
        return  # Ignore unknown commands to prevent spam
    elif isinstance(error, commands.MissingRequiredArgument):
        await ctx.send(f"Missing required argument: {error.param.name}")
    elif isinstance(error, commands.BotMissingPermissions):
        await ctx.send("I need more permissions to perform this action.")
    elif isinstance(error, commands.CommandOnCooldown):
        await ctx.send(f"This command is on cooldown. Try again in {error.retry_after:.1f} seconds.")
    else:
        print(f"Error in {ctx.command}: {error}")
        await ctx.send("An unexpected error occurred. The goddesses have been notified.")

# Run the bot
if __name__ == "__main__":
    TOKEN = os.getenv("DISCORD_TOKEN")
    if not TOKEN:
        print("Error: No DISCORD_TOKEN found in environment variables.")
        print("Please create a .env file with DISCORD_TOKEN=your_token_here")
    else:
        bot.run(TOKEN)
