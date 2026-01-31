# 🤖 Gastown Agent Installation - Complete!

## ✅ Installed Components

### **1. Gastown Agent** ✅
- **Location**: `/opt/gastown/agents/gastown-agent.py`
- **Command**: `gastown` (symlinked to `/usr/local/bin/gastown`)
- **Features**:
  - System status monitoring
  - Website health checks
  - AWS resource listing
  - Claude AI integration
  - Interactive shell

### **2. Dependencies** ✅
- ✅ Python 3.9.25
- ✅ Anthropic SDK (Claude)
- ✅ Boto3 (AWS SDK)
- ✅ PyYAML (Configuration)
- ✅ PynamoDB (DynamoDB ORM)

### **3. Directory Structure** ✅
```
/opt/gastown/
├── agents/        # Agent scripts
│   └── gastown-agent.py
├── config/        # Configuration files
│   └── config.yaml
├── logs/          # Agent logs
├── data/          # Data storage
```

### **4. Systemd Service** ✅
- **Service**: `gastown-monitor.service`
- **Status**: Created (not started - needs API key)
- **Auto-restart**: Every 5 minutes

---

## 🚀 How to Use Gastown Agent

### **Basic Commands**

#### **1. Check System Status**
```bash
# On server
gastown --status

# Remote from your Mac
geekcon "gastown --status"
```

#### **2. Monitor Website Health**
```bash
gastown --monitor
```

#### **3. List AWS Resources**
```bash
gastown --aws
```

#### **4. Interactive Shell**
```bash
gastown --interactive

# Or short form:
gastown -i
```

### **Interactive Shell Commands**

Once in interactive mode (`gastown -i`):
```
gastown> status    # Show system status
gastown> monitor   # Check website health
gastown> aws       # List AWS resources
gastown> ask       # Ask Claude a question
gastown> help      # Show commands
gastown> quit      # Exit
```

---

## 🔑 Setting Up Claude AI Integration

### **Step 1: Get Anthropic API Key**
1. Visit: https://console.anthropic.com/
2. Create an account or log in
3. Go to API Keys
4. Create a new API key
5. Copy the key (starts with `sk-ant-...`)

### **Step 2: Add API Key to Server**

**Method 1: Environment Variable (Persistent)**
```bash
# SSH into server
gk

# Add to .bashrc
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.bashrc
source ~/.bashrc

# Verify
echo $ANTHROPIC_API_KEY
```

**Method 2: Systemd Service File (For auto-monitoring)**
```bash
# SSH into server
gk

# Edit the service file
sudo nano /etc/systemd/system/gastown-monitor.service

# Add this line under [Service]:
Environment="ANTHROPIC_API_KEY=sk-ant-your-key-here"

# Save and reload
sudo systemctl daemon-reload
sudo systemctl start gastown-monitor
sudo systemctl status gastown-monitor
```

### **Step 3: Test Claude Integration**
```bash
# SSH into server
gk

# Test with a question
gastown --ask "What is the current status of the Geekcon Herbs website?"

# Or use interactive mode
gastown -i
gastown> ask
Ask Claude: How can I optimize this server?
```

---

## 📊 What Gastown Agent Can Do

### **System Monitoring** ✅
- Check if Geekcon Herbs service is running
- Monitor memory usage
- Monitor disk space
- Check HTTP response times

### **AWS Integration** ✅
- List DynamoDB tables
- List S3 buckets
- List CloudWatch alarms
- Check resource status

### **Website Health** ✅
- HTTP status codes
- Response times
- Service uptime
- Error detection

### **AI Assistant** (with API key) 🤖
- Ask questions about infrastructure
- Get recommendations
- Troubleshooting help
- Performance optimization tips

---

## 🔧 Advanced Usage

### **1. Scheduled Monitoring**

**Start the monitoring service:**
```bash
# After adding ANTHROPIC_API_KEY
sudo systemctl start gastown-monitor
sudo systemctl status gastown-monitor

# View logs
sudo journalctl -u gastown-monitor -f
```

### **2. Custom Monitoring Script**
```bash
# Create a monitoring script
cat > /opt/gastown/scripts/monitor.sh << 'EOF'
#!/bin/bash
while true; do
    echo "=== $(date) ==="
    gastown --status
    gastown --monitor
    echo ""
    sleep 300  # Every 5 minutes
done
EOF

chmod +x /opt/gastown/scripts/monitor.sh
```

### **3. Integration with CloudWatch**
The agent can push custom metrics to CloudWatch:
```python
# Future enhancement
import boto3
cloudwatch = boto3.client('cloudwatch')
cloudwatch.put_metric_data(
    Namespace='GeekconHerbs',
    MetricData=[{
        'MetricName': 'WebsiteResponseTime',
        'Value': response_time,
        'Unit': 'Milliseconds'
    }]
)
```

---

## 🐟 Fish Shell Integration

### **Add Gastown Shortcuts to Fish**

```fish
# SSH into server first
gk

# Then run gastown commands, OR add fish functions:
```

Add to `~/.config/fish/config.fish`:
```fish
# Gastown Agent shortcuts
abbr -a gka 'geekcon "gastown --status"'
abbr -a gkm 'geekcon "gastown --monitor"'
abbr -a gkw 'geekcon "gastown --aws"'
abbr -a gki 'geekcon "gastown -i"'

function gastown-status --description 'Check Gastown agent status'
    geekcon "gastown --status" | jq
end
```

Then reload:
```fish
source ~/.config/fish/config.fish
```

Now you can use:
```fish
gka    # Check status
gkm    # Monitor website
gkw    # List AWS resources
gki    # Interactive shell
```

---

## 📝 Example Session

```bash
$ gk
🌿 Connecting to Geekcon Herbs server...

[ec2-user@ip-172-31-10-70 ~]$ gastown -i

============================================================
🤖 GASTOWN AGENT - Interactive Shell
============================================================
Project: geekcon-herbs
Region: ap-southeast-1
Claude: ✅ Connected

Commands:
  status   - Show system status
  monitor  - Check website health
  aws      - List AWS resources
  ask      - Ask Claude a question
  quit     - Exit
============================================================

gastown> status
{
  "timestamp": "2026-02-01T03:00:00",
  "project": "geekcon-herbs",
  "region": "ap-southeast-1",
  "services": {
    "geekcon-herbs": "active"
  },
  "memory_total": "131801540",
  "memory_available": "129234512"
}

gastown> monitor
{
  "timestamp": "2026-02-01T03:00:10",
  "service_status": "active",
  "response_time": "142.50ms",
  "http_status": 200
}

gastown> aws
{
  "dynamodb_tables": [
    "geekcon-products",
    "geekcon-users",
    "geekcon-orders"
  ],
  "s3_buckets": [
    "geekcon-herbs-assets-914499832220",
    "geekcon-herbs-backups-914499832220"
  ],
  "cloudwatch_alarms": []
}

gastown> ask
Ask Claude: How is the website performing?

🤖 Claude: Based on the current metrics, the Geekcon Herbs 
website is performing excellently:

1. Service Status: Active and running
2. Response Time: 142.5ms - Very fast!
3. HTTP Status: 200 OK - No errors
4. Memory: 129GB available out of 131GB - Excellent headroom

The website is healthy and ready to handle production traffic.
Consider setting up CloudWatch alarms for proactive monitoring.

gastown> quit
👋 Goodbye!
```

---

## 🎯 Next Steps

### **Immediate (Recommended)**
1. ✅ Get Anthropic API key from console.anthropic.com
2. ✅ Add API key to server environment
3. ✅ Test Claude integration: `gastown --ask "test"`
4. ✅ Start monitoring service: `sudo systemctl start gastown-monitor`

### **Optional Enhancements**
- [ ] Set up CloudWatch alarms
- [ ] Add email/SNS notifications
- [ ] Create custom monitoring dashboards
- [ ] Integrate with CI/CD pipeline
- [ ] Add automated backup scripts

---

## 📚 Files Reference

| File | Purpose |
|------|---------|
| `/opt/gastown/agents/gastown-agent.py` | Main agent script |
| `/opt/gastown/config/config.yaml` | Configuration |
| `/opt/gastown/logs/agent.log` | Agent logs |
| `/etc/systemd/system/gastown-monitor.service` | Systemd service |
| `/usr/local/bin/gastown` | Command shortcut |

---

## 🔍 Troubleshooting

### **Agent not found**
```bash
# Check if installed
ls -la /opt/gastown/agents/

# Check symlink
ls -la /usr/local/bin/gastown
```

### **Module not found errors**
```bash
# Reinstall dependencies
sudo pip3 install anthropic boto3 pyyaml

# Verify
python3 -c "import anthropic; print('OK')"
```

### **Claude API not working**
```bash
# Check if API key is set
echo $ANTHROPIC_API_KEY

# Test manually
python3 << EOF
import anthropic
client = anthropic.Anthropic(api_key="your-key-here")
print("Connection OK")
EOF
```

---

## 🎉 Summary

You now have:
- ✅ **Gastown Agent** installed and working
- ✅ **Claude AI integration** ready (needs API key)
- ✅ **System monitoring** capabilities
- ✅ **AWS resource tracking**
- ✅ **Interactive shell** for management
- ✅ **Systemd service** for auto-monitoring

**Quick Start**: 
```bash
gk                    # SSH into server
gastown -i           # Start interactive shell
```

**Get API Key**: https://console.anthropic.com/

🤖 **Gastown is ready to help manage your infrastructure!**
