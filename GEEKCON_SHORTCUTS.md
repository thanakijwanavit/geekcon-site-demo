# 🎩 Geekcon Shortcut

**Date**: February 1, 2026  
**Shell**: Fish

---

## The Command

### `geekcon` 🎩

Go directly to Mayor in tmux. One command, immediate access.

```bash
geekcon
# Talking to Mayor!
```

**What it does:**
1. SSHs to server as ec2-user
2. Switches to gastown user
3. Changes to `/home/gastown/gt` (working directory)
4. Creates or attaches to tmux session "mayor"
5. Runs `gt mayor attach`
6. **You're immediately talking to the Mayor! 🎩**

---

## Usage

### Start your day:
```bash
geekcon
# Tell Mayor what to build
"Mayor, I need to add user authentication to Geekcon Herbs"
```

### Detach and come back:
```bash
# In tmux, press: C-b d (detach, keeps running)

# Later, reconnect:
geekcon
# Automatically reattaches to existing Mayor session
```

### Check status quickly:
```bash
geekcon
# Check what's happening
gt status
gt convoy list
# Press C-b d to detach
```

---

## What It Expands To

```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 -t \
  "sudo -u gastown bash -c 'export PATH=/usr/local/bin:\$PATH && cd ~/gt && tmux new-session -A -s mayor gt mayor attach'"
```

**Breakdown:**
- `ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99` - SSH to server
- `-t` - Force pseudo-terminal allocation (needed for tmux)
- `sudo -u gastown` - Run as gastown user
- `cd ~/gt` - Go to `/home/gastown/gt` (working directory)
- `tmux new-session -A -s mayor` - Create or attach to session named "mayor"
- `gt mayor attach` - Attach to Mayor agent

---

## Other Shortcuts

```bash
gk          # SSH as ec2-user (for system admin)
gkst        # Check geekcon-herbs service status
gklog       # Follow geekcon-herbs logs
gkrestart   # Restart geekcon-herbs service
gtst        # Show convoy status (remotely)
```

---

## tmux Quick Reference

When in tmux (after `geekcon`):

```bash
C-b d       # Detach (keeps Mayor running)
C-b [       # Scroll mode (ESC to exit)
C-b s       # List all sessions
C-b ?       # Show all keybindings
```

To exit Mayor and close session:
```bash
# Just type "exit" or press C-d
# This closes the tmux session
```

To detach and keep Mayor running:
```bash
# Press: C-b d
# Mayor keeps working in background
```

---

## 🎯 Recommended Workflow

```bash
# Morning: Start Mayor
geekcon

# Tell Mayor your goals
"Mayor, today I want to:
1. Add user authentication
2. Fix the checkout bug
3. Deploy to production"

# Detach (C-b d)
# Mayor works in background

# Check progress throughout day
geekcon
gt convoy list
C-b d

# Evening: Review with Mayor
geekcon
"Mayor, what did we accomplish today?"
```

---

## Troubleshooting

### Command not found:
```bash
source ~/.config/fish/config.fish
# Or open new terminal
```

### Can't connect:
```bash
# Check SSH key permissions
ls -la ~/.ssh/geekcon-herbs-key.pem
# Should be: -r-------- (400)

# Fix if needed
chmod 400 ~/.ssh/geekcon-herbs-key.pem
```

### tmux session stuck:
```bash
# SSH as ec2-user first
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99

# Kill stuck session
sudo -u gastown tmux kill-session -t mayor

# Then try again
geekcon
```

### Wrong directory:
```bash
# Should be at: /home/gastown/gt
pwd

# If wrong, manually:
cd /home/gastown/gt
gt mayor attach
```

---

## Fish Config Location

Command defined in: `~/.config/fish/config.fish`

To edit:
```bash
nano ~/.config/fish/config.fish
# or
code ~/.config/fish/config.fish
```

---

## Full Command Reference

### Quick Access:
```bash
geekcon     # SSH + attach to Mayor 🎩
gk          # SSH as ec2-user
```

### Service Management (remote):
```bash
gkst        # Check service status
gklog       # Follow logs
gkrestart   # Restart service
gtst        # Show convoy status
```

### On Server (after geekcon):
```bash
gt status           # Check town status
gt rig list         # List rigs
gt convoy list      # List convoys
gt convoy show      # Show convoy details
bd list             # List beads
bd show <id>        # Show bead details
tmux ls             # List tmux sessions
```

### Info Commands:
```bash
geekcon-info        # Show server info
gastown-info        # Show Gastown info
```

---

## Working Directory

```
Location: /home/gastown/gt
User:     gastown
Purpose:  Gastown town root (HQ)

Structure:
├── mayor/          # Mayor workspace
├── deacon/         # Deacon workspace
├── geekcon_herbs/  # Your project rig
├── settings/       # Configuration
├── .beads/         # Beads database
└── CLAUDE.md       # Agent instructions
```

---

## Tips

1. **One command does it all**: Just type `geekcon`
2. **Detach, don't exit**: Use `C-b d` to keep Mayor running
3. **Reconnect anytime**: `geekcon` reattaches to existing session
4. **Mayor works 24/7**: Detach and let Mayor finish work overnight
5. **Check in regularly**: Quick `geekcon` → status check → `C-b d`

---

**Simple workflow:** `geekcon` → talk to Mayor → `C-b d` → come back later → repeat! 🚀
