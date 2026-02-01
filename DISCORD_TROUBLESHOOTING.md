# 🔧 Discord Bot Troubleshooting

**Date**: February 1, 2026  
**Issue**: Not receiving Discord messages

---

## 🔍 Diagnosis

The Discord bot (clawdbot) and poller services are installed but likely not running because:

1. **Services not started** - Need to start with `systemctl start`
2. **ANTHROPIC_API_KEY missing** - Required for Claude integration
3. **Services not enabled** - Won't auto-start on reboot

---

## ✅ Solution Steps

### **1. Add Anthropic API Key**

```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
sudo -u gastown bash
cd /home/gastown/gt/discord_bot/crew/notify
nano .env
```

Add your Anthropic API key:
```bash
DISCORD_BOT_TOKEN=[already configured]
ANTHROPIC_API_KEY=sk-ant-api03-YOUR-KEY-HERE
```

### **2. Start Services**

```bash
# Start Discord bot
sudo systemctl start clawdbot

# Start Discord message poller
sudo systemctl start discord-poller

# Enable auto-start on reboot
sudo systemctl enable clawdbot
sudo systemctl enable discord-poller
```

### **3. Verify Services Running**

```bash
# Check status
sudo systemctl status clawdbot
sudo systemctl status discord-poller

# Check logs
sudo journalctl -u clawdbot -f
sudo journalctl -u discord-poller -f
```

---

## 📊 Service Status Check

```bash
# Quick status check
systemctl is-active clawdbot
systemctl is-active discord-poller

# If not active, restart
sudo systemctl restart clawdbot
sudo systemctl restart discord-poller
```

---

## 🔑 What Each Service Does

### **clawdbot.service**
- Discord bot that connects to Discord servers
- Responds to commands like `!ping` and `!claude`
- Sends messages FROM agents TO Discord

### **discord-poller.service**
- Polls Discord channels for new messages
- Forwards human messages to agents
- Writes to `/home/gastown/gt/daemon/discord-inbox.jsonl`

---

## 📋 Discord Commands

Once running, test with:
```
!ping                    - Check if bot is alive
!claude Hello!           - Ask Claude a question
```

---

## 🐛 Common Issues

### Issue: Bot not responding
**Solution**: Check if clawdbot service is running
```bash
sudo systemctl status clawdbot
sudo journalctl -u clawdbot -n 50
```

### Issue: Not receiving messages
**Solution**: Check if discord-poller is running
```bash
sudo systemctl status discord-poller
sudo journalctl -u discord-poller -n 50
```

### Issue: Authentication errors
**Solution**: Verify Discord token in .env
```bash
cd /home/gastown/gt/discord_bot/crew/notify
cat .env | grep DISCORD_BOT_TOKEN
```

---

## 📍 File Locations

```
Bot:        /home/gastown/gt/discord_bot/crew/notify/bot.py
Poller:     /home/gastown/gt/scripts/discord-callback.py
Config:     /home/gastown/gt/discord_bot/crew/notify/.env
Inbox:      /home/gastown/gt/daemon/discord-inbox.jsonl
Services:   /etc/systemd/system/clawdbot.service
            /etc/systemd/system/discord-poller.service
```

---

## ✅ Quick Fix Commands

```bash
# Complete restart
sudo systemctl restart clawdbot discord-poller

# Check if running
systemctl is-active clawdbot discord-poller

# View live logs
sudo journalctl -u clawdbot -u discord-poller -f

# Check incoming messages
tail -f /home/gastown/gt/daemon/discord-inbox.jsonl
```

---

**After adding API key and restarting services, Discord messages should flow!** 🤖💬
