import 'dotenv/config';
import {
  Client,
  GatewayIntentBits,
  REST,
  Routes,
  SlashCommandBuilder,
  Interaction
} from 'discord.js';
import { scheduleNightlyCouncilReport, sendCouncilReport } from './nightlyReport.js';
import { relayToUnity } from './unityRelay.js';
import { performHandshakes } from './handshake.js';

const token = process.env.DISCORD_TOKEN!; // Discord bot token
const guildId = process.env.GUILD_ID; // optional: limit command registration to guild

// Instantiate client with minimal intents for slash commands
const client = new Client({ intents: [GatewayIntentBits.Guilds] });

client.once('ready', async () => {
  console.log('Serafina online. Registering slash commands.');

  // Define slash commands for council report and guardian relay
  const commands = [
    new SlashCommandBuilder()
      .setName('councilreport')
      .setDescription('Generate a council report immediately'),
    new SlashCommandBuilder()
      .setName('guardian')
      .setDescription('Relay a message to an in-world guardian')
      .addStringOption(o =>
        o.setName('to').setDescription('Guardian name').setRequired(true)
      )
      .addStringOption(o =>
        o.setName('message').setDescription('Message content').setRequired(true)
      )
  ].map(c => c.toJSON());

  const rest = new REST({ version: '10' }).setToken(token);
  if (guildId) {
    await rest.put(Routes.applicationGuildCommands(client.user!.id, guildId), { body: commands });
  } else {
    await rest.put(Routes.applicationCommands(client.user!.id), { body: commands });
  }

  // Establish handshake with sibling services for mesh awareness
  await performHandshakes();

  // Start nightly report scheduler
  scheduleNightlyCouncilReport(client);
});

client.on('interactionCreate', async (interaction: Interaction) => {
  if (!interaction.isChatInputCommand()) return;

  if (interaction.commandName === 'councilreport') {
    await sendCouncilReport(client);
    await interaction.reply({ content: 'Council report dispatched.', ephemeral: true });
  }

  if (interaction.commandName === 'guardian') {
    const to = interaction.options.getString('to', true);
    const message = interaction.options.getString('message', true);
    await relayToUnity(to, message);
    await interaction.reply({ content: `Relayed to ${to}`, ephemeral: true });
  }
});

// Login sequence
client.login(token).catch(err => {
  console.error('Discord login failed', err);
  process.exit(1);
});
