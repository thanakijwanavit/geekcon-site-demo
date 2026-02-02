# 🎩 Geekcon Command - Correct Version

**Date**: February 1, 2026  
**Shell**: Fish  
**Working Directory**: `/home/gastown/gt`

---

## The Command

```bash
geekcon
```

**What it does:**
- SSHs to server as `ec2-user`
- Switches to `gastown` user with login shell
- Changes to `/home/gastown/gt` (working directory)
- Drops you into interactive bash shell
- **Then YOU run the commands you need**

---

## Usage

### 1. Connect to server:
```bash
geekcon
```

### 2. Start Mayor (choose your agent):

**With Claude (default):**
```bash
gt mayor attach
```

**With Cursor:**
```bash
gt mayor attach --agent cursor
```

**With other agents:**
```bash
gt config agent list          # See available agents
gt mayor attach --agent <name>  # Use specific agent
```

---

## Full Workflow

```bash
# Step 1: Connect
geekcon

# Step 2: You're now at: gastown@server:/home/gastown/gt

# Step 3: Start Mayor
gt mayor attach

# Step 4: Talk to Mayor
"Mayor, I need to add user authentication"

# Step 5: Detach from tmux (if using tmux)
# Press: C-b d

# Step 6: Exit when done
exit
```

---

## Available Agents

According to the server, you have:
- **Claude** - at `/home/ec2-user/.local/bin/claude`
- **Cursor** - needs to be installed if you want to use it

To check what agents Gastown knows about:
```bash
geekcon
gt config agent list
```

---

## What the Command Actually Does

```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 -t \
  "sudo -u gastown -i bash -c 'cd /home/gastown/gt && exec bash'"
```

**Breakdown:**
- `ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99` - SSH to server
- `-t` - Force pseudo-terminal (for interactive shell)
- `sudo -u gastown` - Run as gastown user
- `-i` - Login shell (loads full environment)
- `cd /home/gastown/gt` - Go to working directory
- `exec bash` - Start interactive bash shell

---

## Common Commands Once Connected

### Mayor Operations:
```bash
gt mayor attach              # Start Mayor (uses default agent)
gt mayor attach --agent cursor  # Start with Cursor
gt mayor detach              # Detach from Mayor
gt mayor start               # Start Mayor daemon
```

### Town Management:
```bash
gt status                    # Show town status
gt rig list                  # List project rigs
gt convoy list               # List active convoys
gt agents                    # List active agents
```

### Beads (Issues):
```bash
bd list                      # List open beads
bd list --all                # List all beads
bd show <id>                 # Show bead details
bd new --type task --title "Fix bug"  # Create bead
```

### tmux (if using):
```bash
tmux ls                      # List sessions
tmux new-session -s mayor    # New session
tmux attach -t mayor         # Attach to session
# C-b d                      # Detach (in tmux)
```

---

## Installing Cursor Agent

If you want to use Cursor instead of Claude:

```bash
# On your local machine, check Cursor CLI
which cursor

# On the server (after geekcon)
# You'd need to install cursor CLI there
# Or configure gt to use a different agent command
```

---

## Other Shortcuts

From your local machine:

```bash
gk          # SSH as ec2-user (for admin tasks)
gkst        # Check geekcon-herbs service status
gklog       # Follow geekcon-herbs logs
gkrestart   # Restart geekcon-herbs service
```

---

## Troubleshooting

### Command not found:
```bash
source ~/.config/fish/config.fish
```

### Wrong directory:
```bash
# After geekcon, check:
pwd
# Should show: /home/gastown/gt

# If not, manually:
cd /home/gastown/gt
```

### gt command not found:
```bash
# Check PATH
which gt
# Should show: /usr/local/bin/gt

# If not found:
export PATH=/usr/local/bin:$PATH
```

### Mayor won't start:
```bash
# Check if agent exists
which claude
# Should show: /home/ec2-user/.local/bin/claude

# Try manually:
gt mayor attach --help
```

---

## Why This Design?

**Simple and flexible:**
1. `geekcon` gets you to the right place
2. YOU decide what to run (mayor, crew, status checks, etc.)
3. No assumptions about which agent you want
4. Works with any Gastown workflow

**Two-step approach:**
```bash
geekcon              # Step 1: Connect
gt mayor attach      # Step 2: Start what you need
```

This is cleaner than trying to do everything in one SSH command!

---

## Quick Reference

```bash
# Connect
geekcon

# Start Mayor with Claude
gt mayor attach

# Start Mayor with Cursor
gt mayor attach --agent cursor

# Check status
gt status
gt convoy list
bd list

# Exit
exit
```

---

**Reload Fish config:** `source ~/.config/fish/config.fish`

**Working Directory:** `/home/gastown/gt`

**Simple workflow:** `geekcon` → `gt mayor attach` → talk to Mayor! 🚀
