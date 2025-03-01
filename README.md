# Discord Bot Creator ADVANCED 🤖

A powerful and modern Discord bot creator that helps you scaffold Discord bots in multiple programming languages with best practices and modern setup.

![Discord Bot Creator](https://img.shields.io/badge/Discord-Bot_Creator-7289DA?style=for-the-badge&logo=discord&logoColor=white)
![Version](https://img.shields.io/badge/Version-2.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## 🌟 Features

- 🚀 Support for multiple programming languages:
  - Node.js (Discord.js)
  - Python (discord.py)
  - TypeScript (Discord.js with TypeScript)
- 📁 Modern project structure
- ⚙️ Command handler system
- 🔒 Environment configuration
- 📝 Example commands
- 🛠️ Development tools
- 📚 Comprehensive documentation

## 🔧 Prerequisites

- Bash-compatible shell
- For Node.js/TypeScript projects:
  - Node.js (v16.x or higher)
  - npm (v7.x or higher)
- For Python projects:
  - Python (v3.8 or higher)
  - pip
  - virtualenv or venv

## 🚀 Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/enyzelle/discord-bot-creator.git
   ```

2. Make the script executable:
   ```bash
   chmod +x create_discord_bot.sh
   ```

3. Run the script:
   ```bash
   ./create_discord_bot.sh
   ```

4. Follow the interactive prompts to create your bot!

## 📦 Project Structure

### Node.js/TypeScript Structure
```
project/
├── src/
│   ├── commands/     # Bot commands
│   ├── events/       # Event handlers
│   └── utils/        # Utility functions
├── package.json      # Dependencies and scripts
├── .env             # Environment variables
└── README.md        # Project documentation
```

### Python Structure
```
project/
├── src/
│   ├── cogs/        # Bot cogs/commands
│   └── utils/       # Utility functions
├── requirements.txt # Python dependencies
├── .env            # Environment variables
└── README.md       # Project documentation
```

## 💻 Available Commands

### Node.js/TypeScript
```bash
npm install        # Install dependencies
npm start         # Start the bot
npm run dev       # Run in development mode
npm run build     # Build TypeScript code
npm run watch     # Watch for changes (TypeScript)
```

### Python
```bash
python -m venv venv                # Create virtual environment
source venv/bin/activate           # Activate virtual environment (Linux/Mac)
venv\Scripts\activate             # Activate virtual environment (Windows)
pip install -r requirements.txt    # Install dependencies
python src/bot.py                 # Start the bot
```

## 🔑 Environment Variables

Each project comes with a `.env` file where you need to configure:
- `TOKEN` - Your Discord bot token
- `CLIENT_ID` - Your bot's client ID
- `GUILD_ID` - Your development server ID (optional)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Enyzelle**
- GitHub: [@enyzelle](https://github.com/enyzelle)

## ⭐ Support

If you find this project helpful, please give it a star on GitHub! It helps others discover the project.

## 📚 Documentation

For more detailed information about Discord bot development:
- [Discord.js Guide](https://discordjs.guide/)
- [discord.py Documentation](https://discordpy.readthedocs.io/)
- [Discord Developer Portal](https://discord.com/developers/docs)

---
Made with ❤️ by Enyzelle 
