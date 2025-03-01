#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'
DIM='\033[2m'

# Function for the matrix effect
matrix_effect() {
    local duration=${1:-3}  # Default duration is 3 seconds
    local end_time=$((SECONDS + duration))
    
    # Save cursor position and hide it
    tput civis
    
    while [ $SECONDS -lt $end_time ]; do
        # Generate a random character
        local char=$((RANDOM % 2))
        local color=$((RANDOM % 2))
        
        # Position cursor randomly
        local row=$((RANDOM % $(tput lines)))
        local col=$((RANDOM % $(tput cols)))
        
        tput cup $row $col
        
        if [ $color -eq 0 ]; then
            echo -ne "${GREEN}${DIM}"
        else
            echo -ne "${GREEN}"
        fi
        
        if [ $char -eq 0 ]; then
            echo -n "0"
        else
            echo -n "1"
        fi
    done
    
    # Show cursor and restore position
    tput cnorm
    clear
}

# Function for the spinner animation
show_spinner() {
    local message=$1
    local spinstr='⣾⣽⣻⢿⡿⣟⣯⣷'
    for ((i=0; i<20; i++)); do
        local temp=${spinstr#?}
        printf "\r    ${CYAN}%s${NC} [%c]" "$message" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep 0.1
    done
    echo
}

# Function for the loading bar
show_loading() {
    clear
    matrix_effect
    sleep 0.5
    clear
    
    echo -ne "\n${CYAN}${BOLD}    ⚡ Discord Bot Creator - Initializing...${NC}\n\n"
    
    local messages=(
        "Loading components"
        "Checking dependencies"
        "Initializing creator"
        "Preparing workspace"
    )
    
    for msg in "${messages[@]}"; do
        show_spinner "$msg"
    done
    
    echo -e "\n    ${GREEN}${BOLD}✓ System Ready!${NC}\n"
    sleep 1
}

# Function to display fancy header
show_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "    ╔════════════════════════════════════════════╗"
    echo "    ║             Discord Bot Creator            ║"
    echo "    ║                Version 2.0                 ║"
    echo "    ╚════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "    ${DIM}Created with ❤️  by Enyzelle${NC}"
    echo -e "    ${DIM}GitHub: https://github.com/enyzelle${NC}"
}

# Function to show welcome message
show_welcome() {
    clear
    cat << "EOF"
    
    ██████╗ ██╗███████╗ ██████╗ ██████╗ ██████╗ ██████╗     ██████╗  ██████╗ ████████╗
    ██╔══██╗██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔═══██╗╚══██╔══╝
    ██║  ██║██║███████╗██║     ██║   ██║██████╔╝██║  ██║    ██████╔╝██║   ██║   ██║   
    ██║  ██║██║╚════██║██║     ██║   ██║██╔══██╗██║  ██║    ██╔══██╗██║   ██║   ██║   
    ██████╔╝██║███████║╚██████╗╚██████╔╝██║  ██║██████╔╝    ██████╔╝╚██████╔╝   ██║   
    ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝     ╚═════╝  ╚═════╝    ╚═╝   
                                                                                        
EOF
    echo -e "\n    ${CYAN}${BOLD}Welcome to Discord Bot Creator!${NC}"
    echo -e "    ${DIM}This tool will help you create a Discord bot with best practices and modern setup.${NC}"
    echo -e "\n    ${YELLOW}Features:${NC}"
    echo -e "    ${WHITE}• Modern project structure${NC}"
    echo -e "    ${WHITE}• Command handler setup${NC}"
    echo -e "    ${WHITE}• Environment configuration${NC}"
    echo -e "    ${WHITE}• Example commands${NC}"
    echo -e "    ${WHITE}• Development best practices${NC}"
    echo
    read -n 1 -s -r -p "    Press any key to continue..."
}

# Function to create Node.js project files
create_nodejs_files() {
    # Create project structure
    mkdir -p src/{commands,events,utils}
    
    # Create package.json
    cat > package.json << EOF
{
  "name": "discord-bot",
  "version": "1.0.0",
  "description": "A Discord bot created with Discord.js",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js"
  },
  "dependencies": {
    "discord.js": "^14.11.0",
    "dotenv": "^16.0.3"
  },
  "devDependencies": {
    "nodemon": "^2.0.22"
  }
}
EOF

    # Create main bot file
    cat > src/index.js << EOF
require('dotenv').config();
const { Client, GatewayIntentBits, Collection } = require('discord.js');
const fs = require('fs');
const path = require('path');

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

client.commands = new Collection();

// Command Handler
const commandsPath = path.join(__dirname, 'commands');
const commandFiles = fs.readdirSync(commandsPath).filter(file => file.endsWith('.js'));

for (const file of commandFiles) {
    const filePath = path.join(commandsPath, file);
    const command = require(filePath);
    client.commands.set(command.data.name, command);
}

// Event Handler
const eventsPath = path.join(__dirname, 'events');
const eventFiles = fs.readdirSync(eventsPath).filter(file => file.endsWith('.js'));

for (const file of eventFiles) {
    const filePath = path.join(eventsPath, file);
    const event = require(filePath);
    if (event.once) {
        client.once(event.name, (...args) => event.execute(...args));
    } else {
        client.on(event.name, (...args) => event.execute(...args));
    }
}

client.login(process.env.TOKEN);
EOF

    # Create example command
    cat > src/commands/ping.js << EOF
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('ping')
        .setDescription('Replies with Pong!'),
    async execute(interaction) {
        await interaction.reply('Pong! 🏓');
    }
};
EOF

    # Create ready event
    cat > src/events/ready.js << EOF
module.exports = {
    name: 'ready',
    once: true,
    execute(client) {
        console.log(\`Ready! Logged in as \${client.user.tag}\`);
    }
};
EOF

    # Create .env file
    cat > .env << EOF
TOKEN=your-bot-token-here
CLIENT_ID=your-client-id-here
GUILD_ID=your-guild-id-here
EOF

    # Create README
    cat > README.md << EOF
# Discord Bot

A modern Discord bot created with Discord.js.

## Setup

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Configure environment variables:
   - Rename \`.env.example\` to \`.env\`
   - Add your bot token and other configuration

3. Start the bot:
   \`\`\`bash
   npm start
   \`\`\`

## Features

- Modern command handler
- Event system
- Environment configuration
- Example commands

## Commands

- \`/ping\` - Test the bot's response time

## Created with ❤️ by Enyzelle
EOF
}

# Function to create Python project files
create_python_files() {
    # Create project structure
    mkdir -p src/{cogs,utils}
    
    # Create requirements.txt
    cat > requirements.txt << EOF
discord.py==2.3.1
python-dotenv==1.0.0
EOF

    # Create main bot file
    cat > src/bot.py << EOF
import os
import discord
from discord.ext import commands
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Bot setup
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix='!', intents=intents)

# Load cogs
async def load_cogs():
    for filename in os.listdir('./src/cogs'):
        if filename.endswith('.py'):
            await bot.load_extension(f'cogs.{filename[:-3]}')

@bot.event
async def on_ready():
    await load_cogs()
    print(f'{bot.user} has connected to Discord!')

# Run the bot
bot.run(os.getenv('TOKEN'))
EOF

    # Create example cog
    cat > src/cogs/basic.py << EOF
import discord
from discord.ext import commands

class Basic(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @commands.command()
    async def ping(self, ctx):
        await ctx.send(f'Pong! 🏓 {round(self.bot.latency * 1000)}ms')

async def setup(bot):
    await bot.add_cog(Basic(bot))
EOF

    # Create .env file
    cat > .env << EOF
TOKEN=your-bot-token-here
EOF

    # Create README
    cat > README.md << EOF
# Discord Bot (Python)

A modern Discord bot created with discord.py.

## Setup

1. Create virtual environment:
   \`\`\`bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   venv\\Scripts\\activate    # Windows
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`

3. Configure environment variables:
   - Rename \`.env.example\` to \`.env\`
   - Add your bot token

4. Start the bot:
   \`\`\`bash
   python src/bot.py
   \`\`\`

## Features

- Cog-based command system
- Environment configuration
- Example commands

## Commands

- \`!ping\` - Test the bot's response time

## Created with ❤️ by Enyzelle
EOF
}

# Function to create TypeScript project files
create_typescript_files() {
    # Create project structure
    mkdir -p src/{commands,events,utils}
    
    # Create package.json
    cat > package.json << EOF
{
  "name": "discord-bot-typescript",
  "version": "1.0.0",
  "description": "A Discord bot created with TypeScript",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts",
    "watch": "tsc -w"
  },
  "dependencies": {
    "discord.js": "^14.11.0",
    "dotenv": "^16.0.3"
  },
  "devDependencies": {
    "@types/node": "^18.0.0",
    "ts-node": "^10.9.1",
    "typescript": "^5.0.0"
  }
}
EOF

    # Create tsconfig.json
    cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
EOF

    # Create main bot file
    cat > src/index.ts << EOF
import { Client, GatewayIntentBits, Collection } from 'discord.js';
import * as dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';

dotenv.config();

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

client.commands = new Collection();

// Command Handler
const commandsPath = path.join(__dirname, 'commands');
const commandFiles = fs.readdirSync(commandsPath).filter(file => file.endsWith('.ts'));

for (const file of commandFiles) {
    const filePath = path.join(commandsPath, file);
    const command = require(filePath);
    client.commands.set(command.data.name, command);
}

client.once('ready', () => {
    console.log('Bot is ready!');
});

client.login(process.env.TOKEN);
EOF

    # Create example command
    cat > src/commands/ping.ts << EOF
import { SlashCommandBuilder } from 'discord.js';

module.exports = {
    data: new SlashCommandBuilder()
        .setName('ping')
        .setDescription('Replies with Pong!'),
    async execute(interaction: any) {
        await interaction.reply('Pong! 🏓');
    }
};
EOF

    # Create .env file
    cat > .env << EOF
TOKEN=your-bot-token-here
CLIENT_ID=your-client-id-here
GUILD_ID=your-guild-id-here
EOF

    # Create README
    cat > README.md << EOF
# Discord Bot (TypeScript)

A modern Discord bot created with TypeScript and Discord.js.

## Setup

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Configure environment variables:
   - Rename \`.env.example\` to \`.env\`
   - Add your bot token and other configuration

3. Build and start the bot:
   \`\`\`bash
   npm run build
   npm start
   \`\`\`

## Development

- \`npm run dev\` - Run with ts-node
- \`npm run watch\` - Watch for changes

## Features

- TypeScript support
- Modern command handler
- Environment configuration
- Example commands

## Commands

- \`/ping\` - Test the bot's response time

## Created with ❤️ by Enyzelle
EOF
}

# Function for creating project structure
create_project() {
    local project_type=$1
    local dir_name=$2
    local steps=()
    local current_step=1
    
    mkdir -p "$dir_name"
    cd "$dir_name" || exit
    
    echo -e "\n    ${CYAN}${BOLD}🚀 Creating $project_type project...${NC}\n"
    
    case $project_type in
        "Node.js")
            steps=(
                "Initializing Node.js project structure"
                "Creating package.json"
                "Setting up Discord.js configuration"
                "Creating main bot file"
                "Setting up environment variables"
                "Creating README.md"
                "Setting up command handler"
                "Creating example commands"
            )
            create_nodejs_files
            ;;
        "Python")
            steps=(
                "Initializing Python project structure"
                "Creating virtual environment"
                "Setting up requirements.txt"
                "Creating main bot file"
                "Setting up environment variables"
                "Creating README.md"
                "Setting up cogs structure"
                "Creating example commands"
            )
            create_python_files
            ;;
        "TypeScript")
            steps=(
                "Initializing TypeScript project structure"
                "Creating package.json"
                "Setting up TypeScript configuration"
                "Creating source directory"
                "Setting up Discord.js with TypeScript"
                "Creating type definitions"
                "Setting up environment variables"
                "Creating example commands"
            )
            create_typescript_files
            ;;
    esac
    
    total_steps=${#steps[@]}
    
    for step in "${steps[@]}"; do
        echo -ne "\r    ${YELLOW}[${current_step}/${total_steps}]${NC} ${step}..."
        show_progress_bar $((current_step * 100 / total_steps))
        ((current_step++))
        sleep 0.5
    done
    
    echo -e "\n\n    ${GREEN}${BOLD}✓ Project created successfully!${NC}"
    echo -e "    ${CYAN}📁 Location: $(pwd)${NC}\n"
    
    # Show next steps
    echo -e "    ${YELLOW}${BOLD}Next steps:${NC}"
    echo -e "    ${WHITE}1. cd ${dir_name}${NC}"
    case $project_type in
        "Node.js")
            echo -e "    ${WHITE}2. npm install${NC}"
            echo -e "    ${WHITE}3. Add your bot token to .env${NC}"
            echo -e "    ${WHITE}4. npm start${NC}"
            ;;
        "Python")
            echo -e "    ${WHITE}2. python -m venv venv${NC}"
            echo -e "    ${WHITE}3. source venv/bin/activate${NC}"
            echo -e "    ${WHITE}4. pip install -r requirements.txt${NC}"
            echo -e "    ${WHITE}5. Add your bot token to .env${NC}"
            echo -e "    ${WHITE}6. python src/bot.py${NC}"
            ;;
        "TypeScript")
            echo -e "    ${WHITE}2. npm install${NC}"
            echo -e "    ${WHITE}3. Add your bot token to .env${NC}"
            echo -e "    ${WHITE}4. npm run build${NC}"
            echo -e "    ${WHITE}5. npm start${NC}"
            ;;
    esac
    echo
    read -n 1 -s -r -p "    Press any key to continue..."
    cd ..
}

# Function to show progress bar
show_progress_bar() {
    local percent=$1
    local bar_size=30
    local filled=$((percent * bar_size / 100))
    local empty=$((bar_size - filled))
    
    echo -ne "\n    ["
    for ((i=0; i<filled; i++)); do echo -ne "${GREEN}█${NC}"; done
    for ((i=0; i<empty; i++)); do echo -ne " "; done
    echo -ne "] ${percent}%"
}

# Main menu function
show_menu() {
    echo -e "\n    ${YELLOW}${BOLD}Select your preferred programming language:${NC}\n"
    echo -e "    ${BLUE}[1]${NC} Node.js     ${DIM}(Recommended for beginners)${NC}"
    echo -e "    ${GREEN}[2]${NC} Python      ${DIM}(Great for automation)${NC}"
    echo -e "    ${PURPLE}[3]${NC} TypeScript ${DIM}(Type-safe JavaScript)${NC}"
    echo -e "    ${RED}[4]${NC} Exit\n"
    echo -n "    Enter your choice (1-4): "
}

# Show welcome screen and initial loading
show_welcome
show_loading

# Main program loop
while true; do
    show_header
    show_menu
    read -n 1 choice
    echo ""

    case $choice in
        1)
            create_project "Node.js" "nodejs_discord_bot"
            ;;
        2)
            create_project "Python" "python_discord_bot"
            ;;
        3)
            create_project "TypeScript" "typescript_discord_bot"
            ;;
        4)
            clear
            echo -e "\n    ${YELLOW}${BOLD}Thanks for using Discord Bot Creator!${NC}"
            echo -e "    ${CYAN}Made with ❤️  by Enyzelle${NC}"
            echo -e "    ${DIM}https://github.com/enyzelle${NC}\n"
            matrix_effect 3
            exit 0
            ;;
        *)
            echo -e "\n    ${RED}Invalid option. Please try again.${NC}"
            sleep 1
            ;;
    esac
done 