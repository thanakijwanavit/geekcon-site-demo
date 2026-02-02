# 🛠️ Gastown Server - Installed Tools

**Date**: February 2, 2026  
**Server**: 13.215.224.99 (ap-southeast-1)  
**User**: gastown (with sudo)

---

## ✅ Installed Tools

### 🤖 AI Agents
- **Claude CLI** v2.1.29 - `/home/gastown/.local/bin/claude`
- **cursor-agent** - Command for Gastown (uses Claude backend)

### ☁️ AWS Tools
- **AWS CLI** v2 - Latest version
- **Region**: ap-southeast-1 (configured)
- **Auth**: Instance IAM role (geekcon-herbs-ec2-role)

### 🏘️ Gastown Stack
- **gt** (Gastown) - `/usr/local/bin/gt`
- **bd** (Beads) - `/usr/local/bin/bd`
- **tmux** 3.2a - Terminal multiplexer

### 📝 Editors
- **vim** - Full version with syntax highlighting
- **nano** - Simple terminal editor

### 🔧 Core Development Tools
- **git** - Version control
- **curl** - HTTP client
- **wget** - File downloader
- **jq** - JSON processor
- **tree** - Directory tree viewer
- **htop** - Interactive process viewer
- **ncdu** - Disk usage analyzer

### 🐍 Python Environment
- **Python 3** - Latest Amazon Linux 2023 version
- **pip3** - Package manager
- **boto3** - AWS SDK for Python
- **pynamodb** - DynamoDB ORM
- **requests** - HTTP library
- **pyyaml** - YAML parser
- **rich** - Terminal formatting
- **httpie** - User-friendly HTTP client

### 🌐 Network Tools
- **net-tools** - netstat, ifconfig
- **bind-utils** - dig, nslookup
- **telnet** - Network testing
- **rsync** - File synchronization

### 📦 Compression Tools
- **zip/unzip** - ZIP archive tools
- **tar** - TAR archive tool
- **bzip2** - BZIP2 compression
- **gzip** - GZIP compression

### 🔐 Security & System
- **openssl** - Cryptography toolkit
- **sudo** - Superuser access (configured for gastown)
- **systemctl** - Service management

---

## 🚀 Quick Commands

### AI Agents
```bash
claude --version                    # Claude CLI
cursor-agent --version              # cursor-agent CLI
gt mayor attach                     # Start Mayor with Claude
gt mayor attach --agent cursor      # Start Mayor with cursor-agent
```

### AWS CLI
```bash
aws --version                       # Check version
aws sts get-caller-identity         # Check credentials
aws s3 ls                           # List S3 buckets
aws ec2 describe-instances          # List EC2 instances
aws configure get region            # Show region (ap-southeast-1)
```

### Gastown
```bash
gt status                           # Town status
gt convoy list                      # List convoys
gt rig list                         # List rigs
bd list                             # List beads
```

### System Tools
```bash
htop                                # Process monitor
ncdu                                # Disk usage
tree                                # Directory tree
jq '.' file.json                    # Pretty print JSON
```

### Aliases (Configured)
```bash
ll                                  # ls -alF
gtst                               # gt status
gtcl                               # gt convoy list
bdl                                # bd list
gst                                # git status
ec2                                # aws ec2 describe-instances
s3                                 # aws s3 ls
```

---

## 📂 Configuration Files

### AWS Config
```
~/.aws/config
[default]
region = ap-southeast-1
output = json
```

### Bash Config
```
~/.bashrc
- PATH includes: /usr/local/bin, ~/.local/bin
- GT_TOWN_ROOT set to ~/gt
- Useful aliases configured
- Git prompt configured
```

### Gastown Config
```
~/gt/settings/
- discord-channels.json
- escalation.json
```

---

## 💡 Usage Examples

### Start Working with Mayor
```bash
geekcon
gt mayor attach
"Mayor, I need to add user authentication to Geekcon Herbs"
```

### Use AWS CLI
```bash
geekcon
aws s3 ls                           # List S3 buckets
aws dynamodb list-tables            # List DynamoDB tables
aws ec2 describe-instances          # Describe EC2 instances
```

### Edit Files
```bash
vim ~/gt/CLAUDE.md                  # Use vim
nano ~/gt/settings/config.json      # Use nano
```

### Monitor System
```bash
htop                                # Interactive process viewer
ncdu /                              # Disk usage analyzer
df -h                               # Disk space
free -h                             # Memory usage
```

### Work with JSON
```bash
aws ec2 describe-instances | jq '.' # Pretty print
bd show hq-123 --json | jq '.title' # Extract field
```

### Python Development
```bash
python3 --version                   # Check Python
pip3 list                           # List packages
python3 -m boto3                    # Test boto3
```

---

## 🔧 Common Tasks

### Install New Package
```bash
sudo yum install <package>
# or
pip3 install --user <package>
```

### Create Systemd Service
```bash
sudo vim /etc/systemd/system/myservice.service
sudo systemctl daemon-reload
sudo systemctl start myservice
sudo systemctl enable myservice
```

### Check Logs
```bash
sudo journalctl -u geekcon-herbs -f  # Follow logs
sudo journalctl -u myservice --since today
tail -f /var/log/messages
```

### Network Debugging
```bash
netstat -tulanp                     # Show ports
dig example.com                     # DNS lookup
telnet example.com 80               # Test connection
curl -I https://example.com         # HTTP headers
```

---

## 🎯 Gastown Workflow

### 1. Connect
```bash
geekcon
```

### 2. Start Mayor
```bash
gt mayor attach
```

### 3. Create Work
```bash
# In Mayor session:
"Mayor, create a convoy for adding payment integration"
```

### 4. Monitor Progress
```bash
gtcl                                # gt convoy list (alias)
gtst                                # gt status (alias)
bdl                                 # bd list (alias)
```

### 5. Deploy Changes
```bash
# Use AWS CLI to deploy
aws s3 sync ./build s3://my-bucket
aws ecs update-service --service my-service --force-new-deployment
```

---

## 📊 System Information

```bash
# OS
cat /etc/os-release                 # Amazon Linux 2023

# CPU
lscpu

# Memory
free -h

# Disk
df -h

# Network
ip addr show

# Processes
ps aux | head

# Uptime
uptime
```

---

## 🔐 Security Notes

- **gastown user**: Has full sudo access (NOPASSWD)
- **AWS credentials**: Uses EC2 instance IAM role
- **SSH access**: Via ec2-user, then sudo to gastown
- **No passwords stored**: All auth via SSH keys and IAM

---

## 📦 Package Management

### Install Packages
```bash
sudo yum search <package>           # Search
sudo yum install <package>          # Install
sudo yum update                     # Update all
sudo yum remove <package>           # Remove
```

### Python Packages
```bash
pip3 install --user <package>       # Install for user
pip3 list                           # List installed
pip3 show <package>                 # Show details
pip3 uninstall <package>            # Uninstall
```

---

## 🎨 tmux Quick Reference

```bash
tmux ls                             # List sessions
tmux new -s name                    # New session
tmux attach -t name                 # Attach
tmux kill-session -t name           # Kill

# Inside tmux:
C-b d                               # Detach
C-b [                               # Scroll mode
C-b c                               # New window
C-b n/p                             # Next/previous window
```

---

## ✅ Verification

All tools installed and working:
- ✅ AWS CLI configured for ap-southeast-1
- ✅ Claude CLI accessible to gastown
- ✅ Cursor wrapper created
- ✅ Python packages installed
- ✅ Development tools ready
- ✅ Gastown fully operational
- ✅ Useful aliases configured

---

**Everything is ready to use!** 🚀

Connect with: `geekcon`  
Start working: `gt mayor attach`
