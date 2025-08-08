import asyncio
import discord
from discord.ext import commands

# Test the bot's basic functionality
async def test_bot():
    # Initialize bot with test token
    intents = discord.Intents.all()
    bot = commands.Bot(command_prefix='!', intents=intents, case_insensitive=True)
    
    @bot.event
    async def on_ready():
        print("\n✅ Bot is online and responsive!")
        print(f"Bot Name: {bot.user.name}")
        print(f"Bot ID: {bot.user.id}")
        print("\nTest Commands Available:")
        print("1. !ping - Check bot's response time")
        print("2. !echo [message] - Echo back your message")
        print("3. !test - Run a basic functionality test")
        print("\nType 'exit' to close the test")
    
    @bot.command()
    async def ping(ctx):
        """Check bot's response time."""
        latency = round(bot.latency * 1000)  # in ms
        await ctx.send(f"🏓 Pong! Latency: {latency}ms")
    
    @bot.command()
    async def echo(ctx, *, message: str):
        """Echo back the provided message."""
        await ctx.send(f"🔊 You said: {message}")
    
    @bot.command()
    async def test(ctx):
        """Run a basic functionality test."""
        embed = discord.Embed(
            title="🛠️ Bot Test",
            description="Basic functionality test successful!",
            color=0x00ff00
        )
        embed.add_field(name="Status", value="✅ Online", inline=True)
        embed.add_field(name="Ping", value=f"{round(bot.latency * 1000)}ms", inline=True)
        await ctx.send(embed=embed)
    
    # Run the bot with test token (will be replaced by actual token)
    try:
        token = input("\nPlease enter your Discord bot token: ").strip()
        if token.lower() == 'exit':
            return
            
        print("\n🚀 Starting bot test...")
        print("Press Ctrl+C to stop the bot")
        
        await bot.start(token)
    except KeyboardInterrupt:
        print("\n🛑 Bot test stopped by user")
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
    finally:
        if not bot.is_closed():
            await bot.close()

if __name__ == "__main__":
    print("=== ShadowFlower Council Bot Tester ===")
    print("This will test basic bot functionality.")
    print("Make sure to have your bot token ready.")
    
    asyncio.run(test_bot())
