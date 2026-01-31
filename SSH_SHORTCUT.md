# ✅ SSH SHORTCUT CREATED: "ggt"

## 🚀 Connect to Your Gastown Instance

### Simple Command
```bash
ssh ggt
```

That's it! Just type `ssh ggt` to connect to your EC2 instance.

---

## 📊 Instance Details

- **Shortcut**: ggt (Geekcon Gastown)
- **Public IP**: 13.214.204.225
- **User**: ec2-user
- **Instance Type**: r7g.4xlarge (128GB RAM)
- **SSH Key**: ~/.ssh/villa-gastown-key.pem
- **Region**: ap-southeast-1 (Singapore)

---

## 📝 SSH Config Location

Configuration added to: `~/.ssh/config`

```bash
Host ggt
    HostName 13.214.204.225
    User ec2-user
    IdentityFile ~/.ssh/villa-gastown-key.pem
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

---

## 🔧 Additional SSH Commands

### Copy files to server
```bash
scp file.txt ggt:/home/ec2-user/
scp -r folder/ ggt:/home/ec2-user/
```

### Copy files from server
```bash
scp ggt:/home/ec2-user/file.txt ./
scp -r ggt:/home/ec2-user/folder/ ./
```

### SSH with port forwarding
```bash
ssh -L 8080:localhost:8080 ggt
```

### SSH with X11 forwarding
```bash
ssh -X ggt
```

### SSH and run command
```bash
ssh ggt "ls -la"
ssh ggt "df -h"
ssh ggt "htop"
```

---

## 🔑 Key Management

### View key details
```bash
ls -la ~/.ssh/villa-gastown-key.pem
```

### Verify key permissions (should be 400)
```bash
stat -f "%A %N" ~/.ssh/villa-gastown-key.pem
```

### Fix permissions if needed
```bash
chmod 400 ~/.ssh/villa-gastown-key.pem
```

---

## 🎯 Quick Access Examples

```bash
# Connect
ssh ggt

# Check server status
ssh ggt "uptime"

# Check disk space
ssh ggt "df -h"

# Check memory
ssh ggt "free -h"

# View running processes
ssh ggt "ps aux | head -20"

# Tail logs
ssh ggt "tail -f /var/log/messages"
```

---

## ✅ Setup Complete!

Your SSH shortcut is ready to use. Just type:

```bash
ssh ggt
```

To connect to your Geekcon Gastown instance!
