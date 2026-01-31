# ✅ SSH SHORTCUT FIXED!

## **Now Connects to Gastown User**

### Before:
```
ssh ggt → connected as ec2-user ❌
- No claude
- No full gastown access
- Had to sudo su - gastown
```

### After:
```
ssh ggt → connects as gastown ✅
- Full claude access
- Full gastown environment
- All agents visible
- Direct access to everything
```

---

## 🚀 Quick Access

### Connect to Gastown
```bash
ssh ggt
```

You're now directly in the gastown environment!

### Quick Commands
```bash
# Connect and check status
ssh ggt "whoami"
# Result: gastown ✅

# Run claude
ssh ggt "claude --help"

# Run gt commands
ssh ggt "gt status"

# List tmux sessions
ssh ggt "tmux list-sessions"

# Attach to mayor
ssh ggt "tmux attach-session -t hq-mayor"
```

---

## 📊 What You Now Have Access To

```bash
ssh ggt
```

Gives you immediate access to:
- ✅ Claude command (15 agents running)
- ✅ GT command (dashboard on port 8080)
- ✅ All tmux sessions
- ✅ Gastown projects
- ✅ Full environment

---

## 🎯 Common Operations

### Check running agents
```bash
ssh ggt "ps aux | grep claude | wc -l"
```

### List all tmux sessions
```bash
ssh ggt "tmux list-sessions"
```

### Connect to mayor
```bash
ssh -t ggt "tmux attach-session -t hq-mayor"
```

### Check GT dashboard
```bash
curl http://13.214.204.225:8080
```

---

## ✅ FIXED!

**SSH shortcut `ggt` now connects directly to the gastown user with full access to everything!**
