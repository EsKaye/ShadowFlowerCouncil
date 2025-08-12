import os
import discord
import random
import asyncio
import json
from datetime import datetime, timedelta, timezone
from typing import Dict, List, Optional, Tuple
from discord.ext import commands, tasks
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Initialize bot with intents
intents = discord.Intents.default()
intents.message_content = True
intents.members = True
intents.presences = True

class ShadowFlowerBot(commands.Bot):
    """Custom bot class for the ShadowFlower Council."""
    
    def __init__(self):
        super().__init__(
            command_prefix=commands.when_mentioned_or('!'),
            intents=intents,
            case_insensitive=True,
            help_command=None,
            activity=discord.Game(name="!help | Divine Wisdom")
        )
        self.start_time = datetime.now(timezone.utc)
        self.daily_blessings: Dict[str, dict] = {}
        self.user_devotion: Dict[int, dict] = {}
        self.load_data()
    
    def load_data(self):
        """Load persistent data from files."""
        try:
            if os.path.exists('data/user_devotion.json'):
                with open('data/user_devotion.json', 'r') as f:
                    self.user_devotion = json.load(f)
        except Exception as e:
            print(f"Error loading data: {e}")
    
    def save_data(self):
        """Save persistent data to files."""
        try:
            os.makedirs('data', exist_ok=True)
            with open('data/user_devotion.json', 'w') as f:
                json.dump(self.user_devotion, f, indent=2)
        except Exception as e:
            print(f"Error saving data: {e}")

bot = ShadowFlowerBot()

# Goddess database with extended descriptions and blessings
GODDESSES = {
    "Lilith": {
        "description": "First of the divine feminine, she teaches the power of independence and self-knowledge.",
        "color": 0x9b59b6,  # Purple
        "emoji": "🌙",
        "invocation": "By the silver light of the moon, I call upon Lilith, first among equals...",
        "domains": ["Wisdom", "Independence", "Desire", "Knowledge"],
        "alignment": "Neutral",
        "blessings": [
            "May your independence be your strength and your wisdom guide your path.",
            "The night reveals truths the day cannot see. Trust your inner knowing.",
            "In the silence of the moon, find the answers you seek within.",
            "Your desires are the compass of your soul. Follow them fearlessly.",
            "The first breath of creation flows through you. Breathe deeply and know your power."
        ]
    },
    "Athena": {
        "description": "Goddess of wisdom, strategy, and just warfare. She represents the power of intellect and strategic thinking.",
        "color": 0x3498db,  # Blue
        "emoji": "🦉",
        "invocation": "By the light of wisdom and sound judgment, I call upon Athena, strategist of the gods...",
        "domains": ["Wisdom", "Strategy", "Warfare", "Craft"],
        "alignment": "Lawful Good",
        "blessings": [
            "May your mind be sharp and your strategies unerring.",
            "In battle and in life, let wisdom be your shield and courage your sword.",
            "The owl of wisdom watches over you. Trust in your intellect.",
            "A wise warrior knows when to fight and when to seek peace.",
            "Your thoughts are your greatest weapon. Sharpen them daily."
        ]
    },
    "Persephone": {
        "description": "Queen of the Underworld and goddess of spring's renewal. She embodies the cycle of life, death, and rebirth.",
        "color": 0x9b59b6,  # Purple
        "emoji": "🌷",
        "invocation": "Through the veil of seasons, I call upon Persephone, queen of transformation...",
        "domains": ["Seasons", "Transformation", "Underworld", "Renewal"],
        "alignment": "Neutral",
        "blessings": [
            "May your transitions be gentle and your power bloom in darkness.",
            "The seeds you've buried will rise again in radiant form.",
            "In the depths of your challenges, remember: spring always follows winter.",
            "Your ability to transform is your greatest strength.",
            "Like the pomegranate seeds, your choices shape your destiny."
        ]
    },
    "Brigid": {
        "description": "Celtic goddess of poetry, healing, and smithcraft. Keeper of the sacred flame of inspiration.",
        "color": 0xe74c3c,  # Red
        "emoji": "🔥",
        "invocation": "By the sacred flame of inspiration, I call upon Brigid, keeper of the eternal fire...",
        "domains": ["Poetry", "Healing", "Smithcraft", "Inspiration"],
        "alignment": "Good",
        "blessings": [
            "May the sacred flame of inspiration burn brightly within you.",
            "Your words have power to heal and transform. Use them wisely.",
            "The forge of your soul tempers you into something stronger.",
            "Let your creativity flow like the eternal flame.",
            "In healing others, you heal yourself."
        ]
    },
    "Hecate": {
        "description": "Goddess of magic, crossroads, and the moon. She guides lost souls and bestows wisdom.",
        "color": 0x2ecc71,  # Green
        "emoji": "🌕",
        "invocation": "At the crossroads of destiny, I call upon Hecate, keeper of the keys...",
        "domains": ["Magic", "Crossroads", "Moon", "Necromancy"],
        "alignment": "Neutral",
        "blessings": [
            "At life's crossroads, trust your intuition to guide you.",
            "The full moon illuminates hidden truths. Look beyond the surface.",
            "Your magic is your birthright. Wield it with wisdom.",
            "The keys to all doors are within your reach.",
            "In the darkness, find the light of your own power."
        ]
    },
    "Kali": {
        "description": "The fierce mother who destroys illusions. She represents transformation through destruction.",
        "color": 0x1abc9c,  # Teal
        "emoji": "🔥",
        "invocation": "In the dance of destruction and creation, I call upon Kali the transformer...",
        "domains": ["Destruction", "Transformation", "Power", "Liberation"],
        "alignment": "Chaotic",
        "blessings": [
            "What no longer serves you must be destroyed to make way for the new.",
            "Your fierceness is a gift. Wield it with purpose.",
            "In the ashes of what was, find the seeds of what will be.",
            "Dance fearlessly through the fires of transformation.",
            "Your power to destroy is also your power to create."
        ]
    },
    "Aphrodite": {
        "description": "Goddess of love, beauty, and desire. She represents the power of love in all its forms.",
        "color": 0xe91e63,  # Pink
        "emoji": "💝",
        "invocation": "By the gentle waves of the sea, I call upon Aphrodite, goddess of love...",
        "domains": ["Love", "Beauty", "Desire", "Passion"],
        "alignment": "Chaotic Good",
        "blessings": [
            "May your heart remain open to love in all its forms.",
            "Your beauty shines from within. Let it radiate outward.",
            "Love is your birthright. Give it freely and receive it graciously.",
            "The most powerful magic is the magic of the heart.",
            "Your capacity for love is infinite. Share it without fear."
        ]
    },
    "Isis": {
        "description": "Egyptian goddess of magic, healing, and motherhood. She holds the secrets of transformation.",
        "color": 0x9b59b6,  # Purple
        "emoji": "🔮",
        "invocation": "By the power of the sacred ankh, I call upon Isis, weaver of magic...",
        "domains": ["Magic", "Healing", "Motherhood", "Mysteries"],
        "alignment": "Good",
        "blessings": [
            "The wings of Isis protect you. Feel their embrace.",
            "In healing others, you heal the world.",
            "The mysteries reveal themselves to those who seek with an open heart.",
            "Your intuition is your greatest guide. Trust its whispers.",
            "The magic of creation flows through you. Use it wisely."
        ]
    },
    "Freya": {
        "description": "Norse goddess of love, beauty, and war. She rides a chariot pulled by cats.",
        "color": 0xe67e22,  # Orange
        "emoji": "🐈",
        "invocation": "By the golden light of the northern sky, I call upon Freya, lady of the slain...",
        "domains": ["Love", "War", "Magic", "Fertility"],
        "alignment": "Neutral Good",
        "blessings": [
            "May your battles be just and your victories sweet.",
            "Love and war require equal measures of passion and strategy.",
            "Your independence is your strength. Own it fiercely.",
            "The magic of the seer flows through your veins.",
            "Like the cats that pull my chariot, walk with confidence and grace."
        ]
    },
    "Artemis": {
        "description": "Goddess of the hunt, wilderness, and the moon. Protector of young women and wild things.",
        "color": 0x3498db,  # Blue
        "emoji": "🌙",
        "invocation": "By the silver light of the crescent moon, I call upon Artemis, the untamed...",
        "domains": ["Hunt", "Wilderness", "Moon", "Independence"],
        "alignment": "Neutral Good",
        "blessings": [
            "May your aim be true and your spirit remain wild and free.",
            "The wilderness calls to your soul. Answer its song.",
            "Your independence is your strength. Never apologize for it.",
            "The moon's phases mirror your own cycles of growth and release.",
            "Protect what is wild within you and around you."
        ]
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

# Helper function to get a random goddess
def get_random_goddess() -> tuple[str, dict]:
    """Return a random goddess name and data."""
    name = random.choice(list(GODDESSES.keys()))
    return name, GODDESSES[name]

# Helper function to create a goddess embed
def create_goddess_embed(goddess_name: str, goddess_data: dict) -> discord.Embed:
    """Create a beautiful embed for a goddess."""
    embed = discord.Embed(
        title=f"{goddess_data['emoji']} {goddess_name}",
        description=goddess_data['description'],
        color=goddess_data['color']
    )
    
    # Add fields
    embed.add_field(name="Domains", value=", ".join(goddess_data['domains']), inline=True)
    embed.add_field(name="Alignment", value=goddess_data['alignment'], inline=True)
    
    # Add a random blessing
    if 'blessings' in goddess_data and goddess_data['blessings']:
        blessing = random.choice(goddess_data['blessings'])
        embed.add_field(name="Divine Blessing", value=f"*{blessing}*", inline=False)
    
    # Set footer with current time
    embed.set_footer(text="ShadowFlower Council | Divine Wisdom")
    
    return embed

@bot.event
async def on_ready():
    """Called when the bot is ready and connected to Discord."""
    print(f'🌙 We have logged in as {bot.user} (ID: {bot.user.id})')
    print('------')
    
    # Start background tasks
    change_status.start()
    reset_daily_blessings.start()
    
    # Create data directory if it doesn't exist
    os.makedirs('data', exist_ok=True)
    
    # Save data on shutdown
    bot.save_data()

@tasks.loop(minutes=30)
async def change_status():
    """Change the bot's status message periodically."""
    statuses = [
        f"!help | {len(bot.guilds)} servers",
        "!help | Divine Wisdom",
        f"!help | {sum(g.member_count for g in bot.guilds)} blessed souls",
        "!help | ShadowFlower Council"
    ]
    await bot.change_presence(activity=discord.Game(random.choice(statuses)))

@tasks.loop(hours=24)
async def reset_daily_blessings():
    """Reset daily blessings for all users."""
    bot.daily_blessings.clear()
    print("Daily blessings have been reset.")

# Start the background task when the bot starts
@bot.event
async def on_ready():
    """Called when the bot is ready and connected to Discord."""
    print(f'Logged in as {bot.user.name} (ID: {bot.user.id})')
    print('------')
    
    # Start background tasks
    change_status.start()
    reset_daily_blessings.start()
    
    # Set initial status
    await bot.change_presence(
        activity=discord.Game(name="!help | Divine Wisdom"),
        status=discord.Status.online
    )
    
    print('Bot is ready and running!')

@bot.command(name="divine", help="Ask the goddesses a yes/no question")
async def divine(ctx, *, question: str = None):
    """Provide divine guidance to a yes/no question."""
    if not question:
        await ctx.send("🔮 Ask a yes/no question: `!divine Will I succeed?`")
        return
    
    # List of possible divine responses
    responses = [
        ("✨ It is certain.", 0x2ecc71),  # Green
        ("🌙 Without a doubt.", 0x9b59b6),  # Purple
        ("🔮 Signs point to yes.", 0x3498db),  # Blue
        ("🌿 As I see it, yes.", 0x2ecc71),  # Green
        ("🔥 The flames say yes.", 0xe74c3c),  # Red
        ("💀 The spirits whisper no.", 0x1abc9c),  # Teal
        ("🌑 The future is unclear.", 0x2c3e50),  # Dark blue
        ("🌪️ The winds of fate are uncertain.", 0x3498db),  # Blue
        ("❌ Do not count on it.", 0xe74c3c),  # Red
        ("⚖️ The scales are balanced. Meditate and ask again.", 0x95a5a6)  # Gray
    ]
    
    # Select a random response
    response, color = random.choice(responses)
    
    # Create and send the divination embed
    embed = discord.Embed(
        title="🔮 Divine Guidance",
        description=f"**Your Question:** {question}\n\n**The Goddesses Respond:**\n*{response}*",
        color=color
    )
    
    # Add a random goddess's blessing
    goddess_name, goddess = random.choice(list(GODDESSES.items()))
    embed.set_footer(text=f"{goddess['emoji']} {goddess_name} offers this wisdom")
    
    await ctx.send(embed=embed)

@bot.command(name="goddesses", help="List all available goddesses and their domains")
async def list_goddesses(ctx):
    """List all available goddesses and their domains."""
    # Create an embed with all goddesses
    embed = discord.Embed(
        title="👑 The ShadowFlower Council",
        description="A gathering of divine feminine wisdom across cultures and ages.\n"
                  "Use `!invoke [name]` to call upon a goddess directly.",
        color=0x9b59b6
    )
    
    # Group goddesses by alignment for better organization
    alignments = {}
    for name, data in GODDESSES.items():
        if data['alignment'] not in alignments:
            alignments[data['alignment']] = []
        alignments[data['alignment']].append((name, data))
    
    # Add a field for each alignment group
    for alignment, goddess_list in alignments.items():
        goddess_text = []
        for name, data in sorted(goddess_list, key=lambda x: x[0]):
            goddess_text.append(f"**{name}** {data['emoji']} - {', '.join(data['domains'])}")
        
        embed.add_field(
            name=f"{alignment} Aligned",
            value="\n".join(goddess_text),
            inline=False
        )
    
    embed.set_footer(text=f"Total Goddesses: {len(GODDESSES)}")
    await ctx.send(embed=embed)

@bot.command(name="about", help="Learn about the ShadowFlower Council bot")
async def about(ctx):
    """Display information about the bot."""
    # Calculate uptime
    uptime = datetime.utcnow() - bot.start_time
    days, seconds = uptime.days, uptime.seconds
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    
    # Create the about embed
    embed = discord.Embed(
        title="🌺 About ShadowFlower Council",
        description="A divine Discord bot channeling the wisdom, grace, and strength "
                   "of goddesses across cultures and ages.",
        color=0x9b59b6
    )
    
    # Add bot statistics
    embed.add_field(
        name="Bot Stats",
        value=f"• **Uptime:** {days}d {hours}h {minutes}m\n"
              f"• **Goddesses:** {len(GODDESSES)}\n"
              f"• **Servers:** {len(bot.guilds)}\n"
              f"• **Version:** 1.0.0",
        inline=True
    )
    
    # Add creator information
    embed.add_field(
        name="Creator",
        value="Created with 💜 by Sunny\n"
              "and her devoted AI assistant\n"
              "using discord.py",
        inline=True
    )
    
    # Add command examples
    embed.add_field(
        name="Quick Start",
        value="• `!blessing` - Get a daily blessing\n"
              "• `!divine [question]` - Ask a yes/no question\n"
              "• `!invoke [name]` - Call upon a goddess\n"
              "• `!goddesses` - List all available goddesses\n"
              "• `!help` - See all commands",
        inline=False
    )
    
    embed.set_footer(text="May the goddesses guide your path ✨")
    await ctx.send(embed=embed)

@bot.command(name="help", help="Show help information")
async def help_command(ctx, command: str = None):
    """Display help information for commands."""
    if command:
        # Show help for a specific command
        cmd = bot.get_command(command.lower())
        if not cmd:
            await ctx.send(f"No command named '{command}' found. Use `!help` to see all commands.")
            return
        
        # Create an embed for the specific command
        embed = discord.Embed(
            title=f"Help: !{cmd.name}",
            description=cmd.help or "No description available.",
            color=0x9b59b6
        )
        
        # Add usage information if available
        params = [f"!{cmd.name}"]
        for param in cmd.clean_params.values():
            if param.default == param.empty:
                params.append(f"<{param.name}>")
            else:
                params.append(f"[{param.name}]")
        
        embed.add_field(
            name="Usage",
            value=f'`{" ".join(params)}`',
            inline=False
        )
        
        # Add aliases if any
        if hasattr(cmd, 'aliases') and cmd.aliases:
            embed.add_field(
                name="Aliases",
                value=", ".join([f'`{a}`' for a in cmd.aliases]),
                inline=False
            )
        
        await ctx.send(embed=embed)
        return
    
    # Show general help
    embed = discord.Embed(
        title="🌺 ShadowFlower Council Help",
        description="Call upon the divine feminine for wisdom, blessings, and guidance.\n"
                   "Use `!help [command]` for more information on a specific command.",
        color=0x9b59b6
    )
    
    # Add command categories
    categories = {
        "Invocation": ["invoke", "blessing", "divine"],
        "Information": ["goddesses", "about", "help"]
    }
    
    for category, commands_list in categories.items():
        cmd_text = []
        for cmd_name in commands_list:
            cmd = bot.get_command(cmd_name)
            if cmd:
                cmd_text.append(f"• `!{cmd_name}` - {cmd.help or 'No description'}")
        
        embed.add_field(
            name=f"{category} Commands",
            value="\n".join(cmd_text),
            inline=False
        )
    
    embed.set_footer(text="May the goddesses guide your path ✨")
    await ctx.send(embed=embed)

# Error handling
@bot.event
async def on_command_error(ctx, error):
    """Handle command errors gracefully."""
    if isinstance(error, commands.CommandNotFound):
        return  # Ignore unknown commands
    
    error_messages = {
        commands.MissingRequiredArgument: "You're missing a required argument. Use `!help [command]` for guidance.",
        commands.BotMissingPermissions: "I don't have permission to perform that action.",
        commands.MissingPermissions: "You don't have permission to use that command.",
        commands.CommandOnCooldown: "This command is on cooldown. Please try again in {:.1f} seconds.",
        commands.BadArgument: "Invalid argument provided. Please check your input and try again.",
        commands.CheckFailure: "You don't have permission to use this command.",
    }
    
    # Find the appropriate error message
    error_type = type(error)
    if error_type in error_messages:
        message = error_messages[error_type]
        if error_type == commands.CommandOnCooldown:
            message = message.format(error.retry_after)
        await ctx.send(f"⚠️ {message}")
    else:
        # Log unexpected errors
        print(f"Error in {ctx.command}: {error}")
        await ctx.send("An unexpected error occurred. The goddesses have been notified.")

# Run the bot with the token from .env
if __name__ == "__main__":
    # Ensure data directory exists
    os.makedirs('data', exist_ok=True)
    
    # Load environment variables
    TOKEN = os.getenv('DISCORD_TOKEN')
    if not TOKEN:
        print("Error: No Discord token found in .env file")
        exit(1)
    
    # Run the bot
    print("Starting ShadowFlower Council bot...")
    try:
        bot.run(TOKEN)
    except discord.LoginFailure:
        print("Error: Invalid Discord token. Please check your .env file.")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # Ensure data is saved on shutdown
        bot.save_data()
    if not TOKEN:
        print("Error: No DISCORD_TOKEN found in environment variables.")
        print("Please create a .env file with DISCORD_TOKEN=your_token_here")
    else:
        bot.run(TOKEN)
