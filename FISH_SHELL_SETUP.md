# 🐟 Fish Shell Setup for Geekcon Herbs Server

## ✅ Installation Complete!

Your fish shell now has quick shortcuts to access the Geekcon Herbs server.

---

## 🚀 **Quick Commands**

### **Connect to Server**
```fish
gk
# or
geekcon
```

### **Run Remote Command**
```fish
geekcon "ls -la /opt/geekcon/app"
geekcon "free -h"
```

### **Check Service Status**
```fish
gkst
# Runs: sudo systemctl status geekcon-herbs
```

### **View Live Logs**
```fish
gklog
# Runs: sudo journalctl -u geekcon-herbs -f
# Press Ctrl+C to exit
```

### **Restart Application**
```fish
gkrestart
# Runs: sudo systemctl restart geekcon-herbs
```

### **Show Server Info**
```fish
geekcon-info
```

---

## 📋 **All Available Shortcuts**

| Shortcut | Command | Description |
|----------|---------|-------------|
| `gk` | `geekcon` | SSH into server |
| `gkst` | Status check | Check if website is running |
| `gklog` | View logs | Tail application logs (live) |
| `gkrestart` | Restart app | Restart the Next.js application |
| `geekcon-info` | Show info | Display server details |

---

## 🔧 **How to Activate**

**Option 1: Reload fish config**
```fish
source ~/.config/fish/config.fish
```

**Option 2: Restart your terminal**
```fish
exit
# Then open a new terminal
```

**Option 3: Start a new fish session**
```fish
exec fish
```

---

## 📝 **Common Tasks**

### **1. Check if website is running**
```fish
gkst
```

### **2. View what's happening on the server**
```fish
gklog
```
Press `Ctrl+C` to stop viewing logs

### **3. Restart the website**
```fish
gkrestart
sleep 3
gkst  # Verify it restarted
```

### **4. Check server resources**
```fish
geekcon "free -h && df -h && uptime"
```

### **5. Update the website**
```fish
gk
# Now you're on the server
cd /opt/geekcon/app
sudo systemctl stop geekcon-herbs
# ... make your changes ...
npm run build
sudo systemctl start geekcon-herbs
exit
```

---

## 🎯 **Examples**

### **Quick health check**
```fish
# Connect and check everything
gk
free -h           # Check RAM usage
df -h             # Check disk space
sudo systemctl status geekcon-herbs  # Check app status
exit
```

### **Debugging**
```fish
# View logs without connecting
gklog

# Or connect for deeper investigation
gk
sudo journalctl -u geekcon-herbs --since "10 minutes ago"
tail -f /var/log/nginx/error.log
exit
```

### **Deploy new code**
```fish
# Upload files then restart
scp -i ~/.ssh/geekcon-herbs-key.pem -r ./new-feature/ ec2-user@13.215.224.99:/opt/geekcon/app/
gkrestart
```

---

## 📁 **Files Created**

1. **`~/.config/fish/functions/geekcon.fish`**
   - Main SSH function
   - Handles both interactive and command mode
   - Includes server information

2. **`~/.config/fish/config.fish` (appended)**
   - Abbreviations for quick typing
   - `geekcon-info` function
   - Auto-loaded on fish startup

---

## 🔑 **SSH Details**

**Full SSH Command:**
```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
```

**Server Details:**
- **IP**: 13.215.224.99
- **User**: ec2-user
- **Key**: ~/.ssh/geekcon-herbs-key.pem
- **Location**: Singapore (ap-southeast-1)
- **Instance ID**: i-0049cfb72e9633897
- **Type**: r6i.4xlarge (128GB RAM, 16 vCPUs)

---

## 🌐 **Website Access**

**Public URL**: http://13.215.224.99

Test from your browser or terminal:
```fish
curl http://13.215.224.99
```

---

## 🛠️ **Useful Server Commands**

Once connected (`gk`), here are useful commands:

### **Service Management**
```bash
sudo systemctl status geekcon-herbs    # Check status
sudo systemctl restart geekcon-herbs   # Restart
sudo systemctl stop geekcon-herbs      # Stop
sudo systemctl start geekcon-herbs     # Start
sudo journalctl -u geekcon-herbs -f    # Follow logs
```

### **Application**
```bash
cd /opt/geekcon/app                    # Go to app directory
npm run build                          # Rebuild application
ls -la                                 # List files
```

### **System Info**
```bash
free -h                                # RAM usage
df -h                                  # Disk usage
uptime                                 # System uptime
htop                                   # Interactive process viewer (q to quit)
```

### **Logs**
```bash
sudo journalctl -u geekcon-herbs --since "1 hour ago"
sudo tail -f /var/log/nginx/error.log
```

---

## 🔄 **Update Fish Functions**

If you need to modify the shortcuts later:

```fish
# Edit the function
nano ~/.config/fish/functions/geekcon.fish

# Or edit config
nano ~/.config/fish/config.fish

# Then reload
source ~/.config/fish/config.fish
```

---

## 💡 **Pro Tips**

1. **Tab completion works!**
   ```fish
   gk<TAB>     # Shows: gk, gkst, gklog, gkrestart
   ```

2. **Pipe commands:**
   ```fish
   geekcon "ps aux" | grep node
   ```

3. **Chain commands:**
   ```fish
   gkrestart && sleep 5 && gkst
   ```

4. **Background processes:**
   ```fish
   # Don't do this - logs will clutter your terminal
   # Instead use: gklog (Ctrl+C to stop)
   ```

---

## ✅ **Test Your Setup**

Try these commands now:

```fish
# 1. Show server info
geekcon-info

# 2. Quick SSH test (will connect and disconnect)
gk "echo 'Connection successful!'"

# 3. Check service status
gkst
```

---

## 🎉 **You're All Set!**

Type `gk` to connect to your Geekcon Herbs server!

Type `geekcon-info` anytime to see the server details.

Happy herbal e-commerce! 🌿
