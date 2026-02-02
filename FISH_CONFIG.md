# 🐟 Geekcon Fish Shell Configuration

**Created**: February 2, 2026  
**Purpose**: Direct access to Gastown Mayor from local machine

---

## 🎯 Command: `geekcon`

### Direct-to-Mayor Access
```fish
geekcon
```

**What it does**:
1. SSH to `ec2-user@13.215.224.99` (ap-southeast-1)
2. Switch to `gastown` user with sudo
3. Navigate to `/home/gastown/gt` (Gastown workspace)
4. Create or attach to tmux session named `mayor`
5. Launch `gt mayor attach` (starts Mayor agent with Claude)

**Result**: You land directly in the Mayor's session, ready to work.

---

## 📦 Installation

### For Fish Shell Users

1. **Add to your fish config**:
   ```bash
   vim ~/.config/fish/config.fish
   ```

2. **Paste this function**:
   ```fish
   # Geekcon - SSH directly to Mayor in Gastown
   function geekcon --description 'SSH to Gastown Mayor (primary agent interface)'
       ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 -t "sudo -u gastown bash -c 'cd /home/gastown/gt && exec tmux new-session -A -s mayor /usr/local/bin/gt mayor attach'"
   end
   ```

3. **Reload config**:
   ```bash
   source ~/.config/fish/config.fish
   ```

4. **Test**:
   ```bash
   geekcon
   ```

---

## 🔑 Prerequisites

1. **SSH Key**: `~/.ssh/geekcon-herbs-key.pem`
   - Ensure it exists and has correct permissions: `chmod 400`

2. **Server Access**: `ec2-user@13.215.224.99`
   - EC2 instance in `ap-southeast-1`
   - Security group allows SSH from your IP

3. **Gastown User**: `gastown` with sudo privileges
   - Workspace at `/home/gastown/gt`
   - Claude CLI installed at `/home/gastown/.local/bin/claude`

---

## 🚀 Usage

### Basic Connection
```bash
geekcon
```

Lands you in Mayor session immediately. No manual `gt mayor attach` needed.

### tmux Session Controls

**Within Mayor session**:
- `Ctrl+B D` - Detach from tmux (Mayor keeps running)
- `Ctrl+D` or `exit` - Exit Mayor and disconnect

**Reconnect to existing Mayor**:
```bash
geekcon  # Reattaches to running Mayor session
```

### Alternative Agents

**To use cursor-agent instead of Claude**:
```bash
# After geekcon lands you in gastown workspace
gt mayor attach --agent cursor
```

---

## 🛠️ Troubleshooting

### "Permission denied (publickey)"
```bash
# Check SSH key exists
ls -la ~/.ssh/geekcon-herbs-key.pem

# Fix permissions
chmod 400 ~/.ssh/geekcon-herbs-key.pem
```

### "open terminal failed: not a terminal"
This is expected during tmux session creation. The session still starts correctly.

### "Command not found: geekcon"
```bash
# Reload fish config
source ~/.config/fish/config.fish

# Or add function manually
funced geekcon
# Paste function, save with Ctrl+D
funcsave geekcon
```

### Mayor won't start
```bash
# Connect to server first
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99

# Switch to gastown
sudo -u gastown -i

# Check Gastown status
cd /home/gastown/gt
gt status
gt doctor

# Manually start Mayor
gt mayor attach
```

### tmux session conflicts
```bash
# List existing tmux sessions
tmux ls

# Kill Mayor session if stuck
tmux kill-session -t mayor

# Then reconnect
geekcon
```

---

## 📋 What Happens Under the Hood

### Full Command Breakdown
```fish
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 -t \
  "sudo -u gastown bash -c 'cd /home/gastown/gt && \
   exec tmux new-session -A -s mayor /usr/local/bin/gt mayor attach'"
```

**Step by step**:
1. `ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99`
   - Connect to EC2 instance with SSH key

2. `-t`
   - Allocate pseudo-terminal (required for tmux)

3. `sudo -u gastown bash -c '...'`
   - Execute command as `gastown` user

4. `cd /home/gastown/gt`
   - Navigate to Gastown workspace

5. `exec tmux new-session -A -s mayor`
   - Create or attach to tmux session named `mayor`
   - `-A`: Attach if exists, create if not

6. `/usr/local/bin/gt mayor attach`
   - Start Mayor agent (Gastown's primary agent)
   - Uses Claude CLI by default

---

## 🎯 Workflow Examples

### Quick Task
```bash
# Connect
geekcon

# In Mayor session
bd list                              # See available work
bd new --type task --title "Fix bug" --assign self
# Mayor handles it automatically (GUPP principle)

# Exit when done
exit
```

### Spawn Polecats
```bash
geekcon

# Create multiple beads
bd new --type feature --title "Feature A" --assign polecat
bd new --type feature --title "Feature B" --assign polecat

# Mayor spawns polecats (parallel workers)
gt polecat spawn --bead [ID_A]
gt polecat spawn --bead [ID_B]

# Monitor
gt polecat list
gt trail
```

### Convoy (Multi-Rig)
```bash
geekcon

# Create convoy
gt convoy new --title "Deploy all services" --rigs api,frontend,infra

# Create convoy beads
bd new --type convoy --title "Deploy API" --convoy [CONVOY_ID]
bd new --type convoy --title "Deploy Frontend" --convoy [CONVOY_ID]

# Assign work
gt sling [BEAD_API] polecat-api
gt sling [BEAD_FRONTEND] polecat-frontend

# Track progress
gt convoy status [CONVOY_ID]
```

---

## 🔄 Comparison: Old vs New

### Old Workflow (2 steps)
```bash
geekcon          # SSH to gastown, lands in shell
gt mayor attach  # Manually start Mayor
```

### New Workflow (1 step)
```bash
geekcon          # SSH + auto-start Mayor ✅
```

**Time saved**: ~5-10 seconds per connection  
**Cognitive load**: Reduced (no need to remember `gt mayor attach`)

---

## 📚 Related Documentation

- **Gastown Setup**: `GASTOWN_READY.md`
- **Subagents**: `GASTOWN_SUBAGENTS.md`
- **SSH Access**: `SSH_SHORTCUT.md`
- **Commands**: `.cursor/subagents/gastown-guide.md`
- **MEOW Principles**: `.cursorrules`

---

## 🎓 Best Practices

1. **Use `geekcon` for all Gastown access**
   - Consistent entry point
   - Auto-configured environment

2. **Detach, don't exit**
   - `Ctrl+B D` to detach (Mayor keeps running)
   - `geekcon` to reattach later

3. **Check status first**
   ```bash
   geekcon
   gt status    # Town health
   bd list      # Available work
   gt hook      # Your current work
   ```

4. **Follow MEOW principles**
   - Use `@gastown-auditor` to validate compliance
   - Use `@gastown-guide` for command reference

5. **Handoff for long work**
   ```bash
   gt handoff --message "Context for next session"
   # Mayor creates checkpoint
   # Resume later with: gt resume
   ```

---

## ✅ Verification

After setup, test the command:

```bash
geekcon
```

**Expected result**:
```
✓ Mayor restarted with context
Gas Town Mayor - Chief of Staff

Mayor is ready. What's on the agenda?

gastown@ip-xxx-xxx-xxx-xxx ~/gt (master) $
```

If you see this, **you're ready!** 🚀

---

**Status**: ✅ ACTIVE  
**Last Updated**: February 2, 2026  
**File Location**: `.config/fish/config.fish`
