# 🏘️ Gastown Ready to Use

**Date**: February 1, 2026  
**Status**: Claude installed, Mayor ready  
**Server**: 13.215.224.99

---

## ✅ Setup Complete

### What's Installed:
- ✅ Gastown (`gt`) at `/usr/local/bin/gt`
- ✅ Beads (`bd`) at `/usr/local/bin/bd`
- ✅ Claude CLI (v2.1.29) at `/home/gastown/.local/bin/claude`
- ✅ tmux (3.2a)
- ✅ User: `gastown` (with sudo privileges)
- ✅ Working directory: `/home/gastown/gt`
- ✅ Rig: `geekcon_herbs`
- ✅ Beads: 28 created
- ✅ Mayor: Running (hq-mayor tmux session)

---

## 🚀 How to Use

### Step 1: Connect
```bash
geekcon
```

### Step 2: Start Mayor
```bash
gt mayor attach
```

That's it! You're talking to the Mayor.

---

## 📋 Full Example

```bash
# From your Mac
$ geekcon

# You're now: gastown@server:/home/gastown/gt
[gastown@server gt]$ gt mayor attach

# Mayor starts in tmux
# Talk to Mayor:
"Mayor, I need to add user authentication to Geekcon Herbs"

# Detach from tmux (keeps Mayor running)
C-b d

# Exit
exit
```

---

## 🎯 Mayor Commands

```bash
gt mayor attach      # Start/attach to Mayor
gt mayor detach      # Detach from Mayor
gt mayor start       # Start Mayor daemon
gt mayor stop        # Stop Mayor

# In tmux session:
C-b d               # Detach (keeps running)
C-b [               # Scroll mode (ESC to exit)
```

---

## 📊 Status Commands

```bash
gt status           # Town status
gt convoy list      # List convoys
gt rig list         # List rigs
gt agents           # List active agents
bd list             # List beads
bd list --all       # All beads
tmux ls             # List tmux sessions
```

---

## 🏗️ Working with Rigs

```bash
# Your project rig
cd geekcon_herbs

# Create crew workspace
gt crew add yourname --rig geekcon_herbs

# Work in crew
cd crew/yourname
gt crew attach yourname
```

---

## 📿 Beads (Issues)

```bash
# Create bead
bd new --type task --title "Add feature X" --body "Description"

# Valid types: bug, feature, task, epic, chore

# View beads
bd show <id>
bd list
bd list --status closed

# Work with beads
bd close <id>
bd reopen <id>
```

---

## 🚚 Convoys (Work Orders)

```bash
# Create convoy
gt convoy create "Feature X" <bead-id-1> <bead-id-2>

# List convoys
gt convoy list

# Show convoy details
gt convoy show <convoy-id>

# Sling work to agent
gt sling <bead-id> <rig-name>
```

---

## 🐺 Agents & Workers

### Mayor (Your main interface)
```bash
gt mayor attach
```

### Crew (Your personal agents)
```bash
gt crew add <name> --rig <rig-name>
gt crew attach <name>
```

### Polecats (Ephemeral workers)
Automatically spawned by Mayor when work is slung.

### Deacon (Daemon)
Runs automatically in background.

---

## 🔧 Configuration

### Check default agent
```bash
gt config default-agent
```

### List available agents
```bash
gt config agent list
```

Available built-in agents:
- `claude` (default)
- `cursor`
- `codex`
- `gemini`
- `amp`
- `auggie`
- `opencode`

### Set different agent
```bash
gt config default-agent cursor
```

### Use specific agent for Mayor
```bash
gt mayor attach --agent cursor
```

---

## 📂 Directory Structure

```
/home/gastown/gt/              (Town root)
├── .beads/                    (Beads database)
├── .git/                      (Git tracking)
├── mayor/                     (Mayor workspace)
├── deacon/                    (Deacon workspace)
├── geekcon_herbs/             (Your project rig)
│   ├── crew/                  (Crew workspaces)
│   └── polecats/              (Polecat workspaces)
├── settings/                  (Configuration)
│   ├── discord-channels.json
│   └── escalation.json
└── CLAUDE.md                  (Agent instructions)
```

---

## 🎨 tmux Quick Reference

```bash
# Sessions
tmux new-session -s name    # Create session
tmux attach -t name         # Attach to session
tmux ls                     # List sessions
tmux kill-session -t name   # Kill session

# Inside tmux
C-b d        # Detach
C-b [        # Scroll mode (ESC to exit)
C-b s        # List sessions
C-b c        # New window
C-b n/p      # Next/previous window
C-b 0-9      # Switch to window N
C-b ?        # Help (all keybindings)
```

---

## 💡 Tips

1. **Start with Mayor**: It's your main interface
2. **Use tmux detach**: `C-b d` keeps Mayor running
3. **Check status often**: `gt status` and `gt convoy list`
4. **Create convoys**: Bundle related work for tracking
5. **Let Mayor orchestrate**: Tell it what you want, it figures out how
6. **Beads for everything**: All work should be in beads

---

## 🐛 Troubleshooting

### Mayor won't start
```bash
# Check Claude
which claude
claude --version

# Check PATH
echo $PATH
# Should include: /usr/local/bin

# Manually export
export PATH=/usr/local/bin:$HOME/.local/bin:$PATH
```

### gt command not found
```bash
# Check installation
which gt
ls -la /usr/local/bin/gt

# Should exist and be executable
```

### Permission denied
```bash
# Make sure you're gastown user
whoami
# Should show: gastown

# If not:
sudo -u gastown -i bash
cd ~/gt
```

### tmux session stuck
```bash
# List sessions
tmux ls

# Kill stuck session
tmux kill-session -t mayor

# Start fresh
gt mayor attach
```

---

## 🔄 Reload Setup

If you need to reload environment:

```bash
# Reload bashrc
source ~/.bashrc

# Or start fresh login shell
sudo -u gastown -i bash
cd ~/gt
```

---

## 📚 Resources

- Gastown repo: https://github.com/steveyegge/gastown
- Beads repo: https://github.com/steveyegge/beads
- Emergency Manual: https://steve-yegge.medium.com/gas-town-emergency-user-manual-cf0e4556d74b
- Welcome Guide: https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04

---

## ✅ Verification Checklist

- ✅ Claude installed and accessible
- ✅ `gt` binary at `/usr/local/bin/gt`
- ✅ `bd` binary at `/usr/local/bin/bd`
- ✅ Town initialized at `/home/gastown/gt`
- ✅ Git initialized
- ✅ Rig `geekcon_herbs` added
- ✅ 28 beads created
- ✅ Mayor ready to attach
- ✅ tmux installed (3.2a)

---

**Ready to use! Just run:** `geekcon` → `gt mayor attach` 🎩
