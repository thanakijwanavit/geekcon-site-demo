# 🤖 Gastown Agent Configuration

**Created**: February 2, 2026  
**Purpose**: Configure different agents for Mayor (Opus) and workers (cursor-agent)

---

## 🎯 Agent Configuration Strategy

### Role-Based Agent Selection

1. **Mayor (Coordinator)**: Claude Opus
   - More powerful model for planning and coordination
   - Better at complex decision-making
   - Orchestrates worker agents

2. **Workers (Polecats, etc.)**: cursor-agent (auto)
   - Uses cursor-agent for actual implementation work
   - More cost-effective for execution tasks
   - Follows Mayor's instructions

---

## ⚙️ Configuration Commands

### 1. Create claude-opus Agent
```bash
cd /home/gastown/gt
gt config agent set claude-opus 'claude --model opus'
```

**What this does**:
- Creates custom agent alias `claude-opus`
- Uses Claude CLI with `--model opus` flag
- Available for Mayor to use

### 2. Set Default Agent for Workers
```bash
gt config default-agent cursor
```

**What this does**:
- Sets `cursor` (cursor-agent) as default
- All polecats and workers use cursor-agent by default
- Unless explicitly overridden with `--agent` flag

### 3. Verify Configuration
```bash
gt config agent list
gt config default-agent
```

---

## 🚀 Usage

### Starting Mayor with Opus
```bash
# From local machine
geekcon  # Now automatically uses claude-opus

# Or manually
gt mayor attach --agent claude-opus
```

### Spawning Workers (Auto cursor-agent)
```bash
# Spawn polecat - uses default (cursor-agent)
gt polecat spawn --bead [BEAD_ID]

# Sling work - uses default (cursor-agent)
gt sling [BEAD_ID] polecat

# Override to use different agent
gt polecat spawn --bead [BEAD_ID] --agent claude-opus
```

---

## 📋 Available Agents

After configuration:

```
Available Agents:

  amp [built-in] amp --dangerously-allow-all --no-ide
  auggie [built-in] auggie --allow-indexing
  claude [built-in] claude --dangerously-skip-permissions
  claude-opus [custom] claude --model opus           ← NEW (for Mayor)
  codex [built-in] codex --yolo
  cursor [built-in] cursor-agent -f                  ← DEFAULT (for workers)
  gemini [built-in] gemini --approval-mode yolo
  opencode [built-in] opencode

Default: cursor   ← Workers use this by default
```

---

## 🔄 Workflow with Agent Roles

### 1. Mayor Coordination (Opus)
```bash
geekcon  # Connects to Mayor with Opus

# Mayor session (using Claude Opus)
bd new --type feature --title "Add payment system"
bd new --type feature --title "Add analytics"
bd new --type feature --title "Add notifications"

# Mayor analyzes and plans
# Then spawns workers...
```

### 2. Worker Execution (cursor-agent)
```bash
# Mayor spawns polecats (auto-use cursor-agent)
gt polecat spawn --bead [PAYMENT_ID]   # Uses cursor-agent
gt polecat spawn --bead [ANALYTICS_ID] # Uses cursor-agent
gt polecat spawn --bead [NOTIF_ID]     # Uses cursor-agent

# Workers execute tasks with cursor-agent
# More cost-effective, follows Mayor's plan
```

### 3. Result
- Mayor (Opus): High-level coordination, planning, decision-making
- Workers (cursor-agent): Efficient task execution
- Cost optimization: Opus only where needed, cursor-agent for bulk work

---

## 💰 Cost Optimization

### Before (All using Sonnet/Opus)
```
Mayor:    Claude Sonnet/Opus  (expensive)
Worker 1: Claude Sonnet/Opus  (expensive)
Worker 2: Claude Sonnet/Opus  (expensive)
Worker 3: Claude Sonnet/Opus  (expensive)
...
```

### After (Role-based)
```
Mayor:    Claude Opus          (expensive, but strategic)
Worker 1: cursor-agent         (cost-effective)
Worker 2: cursor-agent         (cost-effective)
Worker 3: cursor-agent         (cost-effective)
...
```

**Savings**: Significant reduction for multi-agent workloads while maintaining Mayor's intelligence.

---

## 🔧 Advanced Configuration

### Create More Custom Agents
```bash
# Claude with specific model
gt config agent set claude-sonnet 'claude --model sonnet'

# Codex with low thinking
gt config agent set codex-low 'codex --thinking low'

# Gemini with custom mode
gt config agent set gemini-custom 'gemini --approval-mode yolo'
```

### Get Agent Configuration
```bash
gt config agent get claude-opus
gt config agent get cursor
```

### Remove Custom Agent
```bash
gt config agent remove claude-opus
```

### Change Default Agent
```bash
# Switch default to claude
gt config default-agent claude

# Switch back to cursor
gt config default-agent cursor
```

---

## 📚 geekcon Command Updated

The `geekcon` fish function now automatically uses claude-opus:

```fish
function geekcon --description 'SSH to Gastown Mayor with Claude Opus'
    ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 -t \
      "sudo -u gastown bash -c 'cd /home/gastown/gt && \
       exec tmux new-session -A -s mayor /usr/local/bin/gt mayor attach --agent claude-opus'"
end
```

**What changed**:
- Before: `gt mayor attach` (uses default)
- After: `gt mayor attach --agent claude-opus` (explicitly uses Opus)

---

## 🎯 Best Practices

### When to Use Each Agent

**Claude Opus (Mayor)**:
- ✅ Complex planning and coordination
- ✅ Multi-rig convoy orchestration
- ✅ Strategic decision-making
- ✅ Debugging complex issues
- ✅ Architecture decisions

**cursor-agent (Workers)**:
- ✅ Implementing features
- ✅ Writing tests
- ✅ Fixing bugs
- ✅ Code refactoring
- ✅ Documentation updates

**Claude Sonnet (Optional)**:
- Middle ground for moderately complex tasks
- Balance of cost and capability

---

## 🧪 Testing Configuration

### Verify Mayor Uses Opus
```bash
geekcon

# In Mayor session, check:
# The prompt should indicate claude-opus
# Or run: echo $CLAUDE_MODEL (if set)
```

### Verify Workers Use cursor-agent
```bash
# Spawn a test polecat
bd new --type task --title "Test polecat agent" --assign polecat
gt polecat spawn --bead [TEST_ID]

# Check polecat status
gt polecat status [polecat-name]
# Should show agent: cursor
```

---

## 📊 Monitoring

### Check Active Agents
```bash
gt agents           # List all active agent sessions
gt trail            # Recent agent activity
gt costs            # Claude usage costs
```

### Verify Agent in Use
```bash
# For Mayor
gt mayor status

# For polecats
gt polecat list
gt polecat status [name]
```

---

## 🔄 Rollback

If you need to revert to default configuration:

```bash
# Remove custom claude-opus
gt config agent remove claude-opus

# Set default back to claude
gt config default-agent claude

# Update geekcon function (remove --agent claude-opus)
```

---

## ✅ Verification Checklist

After configuration:

- [ ] claude-opus agent created: `gt config agent get claude-opus`
- [ ] cursor set as default: `gt config default-agent` shows "cursor"
- [ ] Mayor uses Opus: `geekcon` connects with Opus
- [ ] Workers use cursor-agent: spawned polecats use cursor
- [ ] geekcon function updated in fish config
- [ ] Documentation updated

---

**Status**: ✅ CONFIGURED  
**Last Updated**: February 2, 2026  
**Configuration Location**: `/home/gastown/gt/.gt/` (Gastown workspace)
