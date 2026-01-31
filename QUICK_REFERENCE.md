# 🚀 GEEKCON HERBS - QUICK REFERENCE

*Just the commands you need, nothing else.*

---

## 🌐 **Website**
**URL**: http://13.215.224.99

---

## 🐟 **Fish Shell Commands** (Type these from your Mac)

### **Connect to Server**
```fish
gk              # SSH into server (2 letters!)
```

### **Server Management**
```fish
gkst            # Check if website is running
gklog           # View website logs (Ctrl+C to exit)
gkrestart       # Restart website
```

### **Gastown Agent** (AI monitoring)
```fish
gka             # Check system status (CPU, RAM, etc)
gkm             # Monitor website health
gkw             # List AWS resources (DynamoDB, S3)
gki             # Interactive AI shell
```

### **Show Info**
```fish
geekcon-info    # Server details
gastown-info    # Agent details
```

---

## 🔧 **On Server Commands** (After typing `gk`)

### **Website**
```bash
sudo systemctl status geekcon-herbs     # Check status
sudo systemctl restart geekcon-herbs    # Restart
sudo journalctl -u geekcon-herbs -f     # View logs
cd /opt/geekcon/app                     # Go to app folder
```

### **Gastown Agent**
```bash
gastown --status                        # System info
gastown --monitor                       # Website health
gastown --aws                           # AWS resources
gastown -i                              # Interactive mode
gastown --ask "your question"           # Ask Claude (needs API key)
```

### **System Info**
```bash
free -h         # RAM usage (128GB total)
df -h           # Disk space
uptime          # How long server has been running
htop            # Interactive process monitor (q to quit)
```

---

## 🔑 **SSH Details**

**Full command** (if shortcuts don't work):
```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
```

**Location**: Singapore (ap-southeast-1)  
**RAM**: 128GB  
**Instance**: i-0049cfb72e9633897

---

## 🤖 **Enable Claude AI** (Optional)

1. Get API key: https://console.anthropic.com/
2. Add to server:
   ```bash
   gk
   echo 'export ANTHROPIC_API_KEY="sk-ant-YOUR-KEY"' >> ~/.bashrc
   source ~/.bashrc
   ```
3. Test: `gastown --ask "test"`

---

## ⚡ **Most Used Commands**

```fish
# Quick health check
gka && gkm

# SSH and check everything
gk
gastown --status
exit

# Restart if needed
gkrestart

# View logs
gklog
```

---

## 🆘 **Troubleshooting**

### **Website not loading?**
```fish
gkst                                    # Check status
gkrestart                               # Restart
```

### **Shortcuts not working?**
```fish
source ~/.config/fish/config.fish       # Reload fish
exec fish                               # Or restart shell
```

### **Can't SSH?**
```bash
# Use full command
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
```

---

## 📁 **Important Locations**

### **On Server**
- Website: `/opt/geekcon/app/`
- Agent: `/opt/gastown/`
- Logs: `/opt/gastown/logs/`
- Config: `/opt/gastown/config/`

### **On Your Mac**
- SSH key: `~/.ssh/geekcon-herbs-key.pem`
- Fish config: `~/.config/fish/config.fish`
- Docs: `~/stacks/geekcon-site-demo/`

---

## 📚 **Full Docs**

- `GASTOWN_COMPLETE.md` - Complete guide
- `FISH_SHELL_SETUP.md` - All fish shortcuts
- `GASTOWN_AGENT_SETUP.md` - Agent details
- `WEBSITE_LIVE.md` - Website info

---

**That's it! Just type `gk` to start.** 🚀
