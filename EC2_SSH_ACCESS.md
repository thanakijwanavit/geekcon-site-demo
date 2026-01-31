# 🔐 EC2 SSH ACCESS - GASTOWN INSTANCE

## ✅ EC2 Instance Details

**Instance ID**: i-0887b32332fa32ed9
**Instance Type**: r7g.4xlarge (ARM-based, 128GB RAM)
**Status**: ✅ RUNNING
**Public IP**: 13.214.204.225
**SSH Key**: villa-gastown-key
**Region**: ap-southeast-1 (Singapore)

---

## 🔑 SSH CONNECTION COMMANDS

### Standard SSH Access
```bash
ssh -i ~/.ssh/villa-gastown-key.pem ec2-user@13.214.204.225
```

### SSH with Ubuntu (if Amazon Linux 2023)
```bash
ssh -i ~/.ssh/villa-gastown-key.pem ec2-user@13.214.204.225
```

### SSH with Verbose (for debugging)
```bash
ssh -v -i ~/.ssh/villa-gastown-key.pem ec2-user@13.214.204.225
```

### SSH via Session Manager (no key needed)
```bash
aws ssm start-session \
  --target i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1
```

---

## 🔧 KEY SETUP (If key not found)

### 1. Check if key exists
```bash
ls -la ~/.ssh/villa-gastown-key.pem
```

### 2. If key doesn't exist, you need to locate it
The key was created when the EC2 instance was launched. Check:
```bash
# Common locations
ls -la ~/Downloads/villa-gastown-key.pem
ls -la ~/.ssh/
ls -la ~/keys/
```

### 3. Move key to .ssh directory
```bash
mv /path/to/villa-gastown-key.pem ~/.ssh/
chmod 400 ~/.ssh/villa-gastown-key.pem
```

### 4. Set correct permissions (REQUIRED)
```bash
chmod 400 ~/.ssh/villa-gastown-key.pem
```

---

## 🚀 QUICK SSH ACCESS

### One-Line Command (adjust key path if needed)
```bash
ssh -i ~/.ssh/villa-gastown-key.pem ec2-user@13.214.204.225
```

### Alternative usernames to try:
```bash
# Amazon Linux 2023
ssh -i ~/.ssh/villa-gastown-key.pem ec2-user@13.214.204.225

# Ubuntu
ssh -i ~/.ssh/villa-gastown-key.pem ubuntu@13.214.204.225

# Root (usually disabled)
ssh -i ~/.ssh/villa-gastown-key.pem root@13.214.204.225
```

---

## 📊 INSTANCE MANAGEMENT COMMANDS

### Check instance status
```bash
aws ec2 describe-instances \
  --instance-ids i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1 \
  --query 'Reservations[0].Instances[0].[State.Name,PublicIpAddress]' \
  --output table
```

### Stop instance
```bash
aws ec2 stop-instances \
  --instance-ids i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1
```

### Start instance
```bash
aws ec2 start-instances \
  --instance-ids i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1
```

### Reboot instance
```bash
aws ec2 reboot-instances \
  --instance-ids i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1
```

### Get instance console output
```bash
aws ec2 get-console-output \
  --instance-id i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1
```

---

## 🔒 SECURITY GROUP CHECK

### View security group rules
```bash
aws ec2 describe-instances \
  --instance-ids i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1 \
  --query 'Reservations[0].Instances[0].SecurityGroups[*].[GroupId,GroupName]' \
  --output table
```

### Check if SSH port 22 is open
```bash
# Get security group ID first
SG_ID=$(aws ec2 describe-instances \
  --instance-ids i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1 \
  --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' \
  --output text)

# Check rules
aws ec2 describe-security-groups \
  --group-ids $SG_ID \
  --profile villaai \
  --region ap-southeast-1 \
  --query 'SecurityGroups[0].IpPermissions[?FromPort==`22`]'
```

### Add SSH access rule (if needed)
```bash
# Get your current IP
MY_IP=$(curl -s ifconfig.me)

# Add SSH rule
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 22 \
  --cidr $MY_IP/32 \
  --profile villaai \
  --region ap-southeast-1
```

---

## 🐛 TROUBLESHOOTING

### Issue: Permission denied (publickey)
**Fix**: Check key permissions
```bash
chmod 400 ~/.ssh/villa-gastown-key.pem
```

### Issue: Connection timeout
**Fix 1**: Check security group allows SSH from your IP
```bash
curl ifconfig.me  # Get your IP
# Add your IP to security group (see above)
```

**Fix 2**: Check if instance is running
```bash
aws ec2 describe-instances --instance-ids i-0887b32332fa32ed9 \
  --profile villaai --region ap-southeast-1 \
  --query 'Reservations[0].Instances[0].State.Name'
```

### Issue: Key not found
**Fix**: Locate the key file
```bash
find ~ -name "villa-gastown-key.pem" 2>/dev/null
find ~/Downloads -name "*.pem" 2>/dev/null
```

### Issue: Wrong username
**Fix**: Try different usernames
```bash
# Try ec2-user (Amazon Linux)
ssh -i ~/.ssh/villa-gastown-key.pem ec2-user@13.214.204.225

# Try ubuntu (Ubuntu AMI)
ssh -i ~/.ssh/villa-gastown-key.pem ubuntu@13.214.204.225
```

---

## 📝 SSH CONFIG (Optional - For Easy Access)

Add to `~/.ssh/config`:
```bash
Host geekcon-gastown
    HostName 13.214.204.225
    User ec2-user
    IdentityFile ~/.ssh/villa-gastown-key.pem
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

Then connect simply with:
```bash
ssh geekcon-gastown
```

---

## 🔐 SESSION MANAGER (Alternative - No SSH Key Needed)

### Install Session Manager plugin
```bash
# macOS
brew install --cask session-manager-plugin

# Verify installation
session-manager-plugin
```

### Connect via Session Manager
```bash
aws ssm start-session \
  --target i-0887b32332fa32ed9 \
  --profile villaai \
  --region ap-southeast-1
```

**Note**: Requires SSM agent running on EC2 and IAM role with SSM permissions

---

## ✅ QUICK START

**If you have the key file:**
```bash
chmod 400 ~/.ssh/villa-gastown-key.pem
ssh -i ~/.ssh/villa-gastown-key.pem ec2-user@13.214.204.225
```

**If you don't have the key file:**
Let me know and I can help you:
1. Locate the key file
2. Set up Session Manager access
3. Create a new key pair and update the instance

---

## 📊 INSTANCE INFO

- **Instance ID**: i-0887b32332fa32ed9
- **Public IP**: 13.214.204.225
- **Instance Type**: r7g.4xlarge (128GB RAM)
- **Key Name**: villa-gastown-key
- **Region**: ap-southeast-1
- **Status**: RUNNING ✅
