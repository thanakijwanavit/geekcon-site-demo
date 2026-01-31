# 🤖 Clawdbot Installation Complete

**Date**: February 1, 2026  
**Location**: `/home/gastown/gt/discord_bot/crew/notify/`

---

## ✅ Installation Summary

Clawdbot Discord bot has been installed and configured on the Gastown server.

---

## 📦 Components Installed

### **1. Discord Bot Script**
```
Location: /home/gastown/gt/discord_bot/crew/notify/discord_bot.py
Features:
  - Discord bot with Claude integration
  - Commands: !claude, !ping
  - Claude 3.5 Sonnet model
  - Message chunking for long responses
```

### **2. Systemd Service**
```
Service:  clawdbot.service
Location: /etc/systemd/system/clawdbot.service
User:     gastown
Status:   Installed (not started)
```

### **3. Environment Configuration**
```
File: /home/gastown/gt/discord_bot/crew/notify/.env
Keys:
  - DISCORD_BOT_TOKEN=***SAVED***
  - ANTHROPIC_API_KEY=***NEEDS_SETUP***
```

---

## 🚀 Starting Clawdbot

### **1. Add Anthropic API Key**
```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
sudo -u gastown bash
cd /home/gastown/gt/discord_bot/crew/notify
nano .env  # Add: ANTHROPIC_API_KEY=sk-ant-...
```

### **2. Start the Service**
```bash
sudo systemctl start clawdbot
sudo systemctl enable clawdbot
sudo systemctl status clawdbot
```

### **3. View Logs**
```bash
sudo journalctl -u clawdbot -f
```

---

## 💬 Discord Commands

Once running, use these commands in Discord:

```
!claude <question>     - Ask Claude a question
!ping                  - Check bot status
```

### Example:
```
!claude What is Gastown?
!claude Write a Python hello world
!ping
```

---

## 📁 File Structure

```
/home/gastown/gt/discord_bot/
└── crew/
    └── notify/
        ├── discord_bot.py    (Bot script)
        └── .env              (Environment vars)
```

---

## 🔧 Management Commands

```bash
# Start bot
sudo systemctl start clawdbot

# Stop bot
sudo systemctl stop clawdbot

# Restart bot
sudo systemctl restart clawdbot

# Check status
sudo systemctl status clawdbot

# View logs
sudo journalctl -u clawdbot -f

# Enable on boot
sudo systemctl enable clawdbot

# Disable on boot
sudo systemctl disable clawdbot
```

---

## 🔑 Required Configuration

Before starting, ensure `.env` has both keys:

```bash
DISCORD_BOT_TOKEN=***REDACTED***
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

---

## 🏘️ Integration with Gastown

Clawdbot is installed within the Gastown town structure:

```
Town:     /home/gastown/gt/
Rigs:     geekcon_herbs
Workers:  Mayor, Deacon, Polecats, Crew
Discord:  Clawdbot (notify crew member)
```

---

## ✅ Next Steps

1. Add your Anthropic API key to `.env`
2. Start the service: `sudo systemctl start clawdbot`
3. Invite the bot to your Discord server
4. Test with `!ping` and `!claude` commands

---

**Clawdbot is ready to connect your Discord server to Claude AI!** 🤖✨
