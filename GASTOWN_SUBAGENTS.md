# 🤖 Gastown Subagents - MEOW Principle Enforcers

**Created**: February 2, 2026  
**Purpose**: Guide Claude Code agents with Gastown-specific knowledge and ensure MEOW compliance

---

## 📋 Installed Subagents

### 1. 🔍 Gastown Auditor
**File**: `.cursor/subagents/gastown-auditor.md`  
**Role**: MEOW Principle Enforcer

**Responsibilities**:
- ✅ Enforce GUPP (Gastown Universal Propulsion Principle)
- ✅ Validate MEOW workflows (beads, convoys, molecules)
- ✅ Check NDI (Nondeterministic Idempotence) compliance
- ✅ Ensure "Physics Over Politeness" behavior
- ✅ Monitor Vibe Coding (throughput over perfection)

**Key Functions**:
```
- Verify bead tracking for all work
- Flag permission-seeking behavior (anti-GUPP)
- Ensure git commits use agent identity
- Monitor convoy progress
- Check for orphaned work
- Validate autonomous agent action
```

**Red Flags** 🚨:
- Working without beads
- Asking "should I?" when work is on hook
- Manual work instead of spawning polecats
- Missing agent identity in commits
- Excessive documentation vs. actual work

**Invoke**: `@gastown-auditor audit current work`

---

### 2. 📚 Gastown Guide
**File**: `.cursor/subagents/gastown-guide.md`  
**Role**: Context Provider & Best Practices

**Provides**:
- Quick reference for all Gastown commands
- Server connection details (IP, user, workspace)
- Common workflow patterns (single task, polecat, convoy)
- Troubleshooting guides
- Environment setup instructions

**Key Sections**:
```
- Server Details (geekcon, IP, workspace)
- Command Quick Reference (bd, gt, agents)
- Typical Workflows (task, polecat, convoy, handoff)
- Common Patterns (bead types, assignments)
- Troubleshooting (orphans, permissions, stale sessions)
```

**Use Cases**:
- New agent onboarding
- Command syntax lookup
- Workflow pattern selection
- Debugging common issues

**Invoke**: `@gastown-guide [topic]`

---

## 🎯 How Subagents Work

### In Cursor IDE
Subagents are referenced using `@` mentions:

```
@gastown-auditor audit the current bead workflow
@gastown-guide show me convoy workflow
```

### With Mayor/Agents
When working in Gastown Mayor session:

1. **Before Work**: Auditor checks compliance
2. **During Work**: Guide provides commands
3. **After Work**: Auditor validates completion

### Integration Flow
```
Human → geekcon → Mayor → @gastown-guide (context)
                        ↓
                   Work on Beads
                        ↓
                   @gastown-auditor (validate)
                        ↓
                   MEOW Compliant ✅
```

---

## 🚀 Updated Geekcon Command

### New Direct-to-Mayor Access
```fish
# Connect directly to Mayor (no manual attach needed)
geekcon
```

**What it does**:
1. SSH to `ec2-user@13.215.224.99`
2. Switch to `gastown` user
3. Navigate to `/home/gastown/gt`
4. Create/attach tmux session `mayor`
5. Launch `gt mayor attach` (Mayor agent)

**Previous**: Required manual `gt mayor attach` after `geekcon`  
**Now**: Direct to Mayor immediately ✅

---

## 📖 Usage Examples

### Example 1: Start New Feature with Audit
```bash
# Connect to Mayor
geekcon

# In Mayor session:
@gastown-guide show feature workflow
# → Guide shows: bd new --type feature --title "..." --assign self

# Create bead (Mayor will do this)
bd new --type feature --title "Add payment integration" --assign self

# Auditor auto-checks:
@gastown-auditor audit current work
# ✅ Bead created
# ✅ Assigned to self (on hook)
# ✅ GUPP compliance: work must proceed immediately
```

### Example 2: Spawn Polecats with Validation
```bash
# Create multiple beads
bd new --type task --title "Task A" --assign polecat
bd new --type task --title "Task B" --assign polecat

# Auditor checks:
@gastown-auditor verify polecat spawning
# ✅ Beads properly typed
# ✅ Assigned to polecat (not manual work)

# Spawn polecats
gt polecat spawn --bead [ID_A]
gt polecat spawn --bead [ID_B]

# Guide monitors:
@gastown-guide track polecats
# Shows: gt polecat list, gt trail, gt orphans
```

### Example 3: Convoy with Full Audit
```bash
# Plan convoy
@gastown-guide convoy workflow

# Create convoy
gt convoy new --title "Multi-service deploy" --rigs api,frontend

# Auditor validates:
@gastown-auditor audit convoy planning
# ✅ Convoy created with proper rigs
# ✅ Beads tagged with convoy ID
# ✅ Work distribution planned

# Execute
gt sling [bead-api] polecat-api
gt sling [bead-frontend] polecat-frontend

# Track progress
gt convoy status [ID]
```

---

## 🔧 Subagent Audit Checklist

When auditor is invoked, it checks:

### ✅ Bead Compliance
- [ ] All work tracked as beads
- [ ] Proper bead types (feature, bug, task, convoy)
- [ ] Assignments match agent capabilities
- [ ] Status transitions tracked (pending → in_progress → closed)

### ✅ GUPP Compliance
- [ ] Work on hook being executed immediately
- [ ] No "should I?" permission-seeking
- [ ] Autonomous agent action
- [ ] No manual work for polecat-appropriate tasks

### ✅ Git Identity
- [ ] Commits use `gt commit` (agent identity)
- [ ] Git log shows agent names
- [ ] No human identity in agent commits

### ✅ NDI Compliance
- [ ] Work persists through restarts (beads)
- [ ] Handoffs documented for long work
- [ ] Checkpoints created when needed

### ✅ Workflow Selection
- [ ] Single-task → Mayor/Crew
- [ ] Parallel-task → Polecats
- [ ] Cross-rig → Convoy
- [ ] Correct agent for job

---

## 🎓 Training for Agents

### New Agent Onboarding
1. **Connect**: `geekcon` (lands in Mayor)
2. **Context**: `@gastown-guide quick start`
3. **Verify**: `gt status`, `bd list`, `gt hook`
4. **Audit**: `@gastown-auditor check readiness`

### Before Each Work Session
```bash
@gastown-guide environment setup
# → Shows: cd /home/gastown/gt, gt whoami, gt status, gt hook

@gastown-auditor pre-work check
# → Validates: correct rig, identity, no orphans, hook clear/ready
```

### During Work
- **Stuck?** → `@gastown-guide [topic]`
- **Validation?** → `@gastown-auditor audit [aspect]`
- **Command?** → `@gastown-guide command [cmd]`

### After Work
```bash
@gastown-auditor validate completion
# ✅ Beads closed
# ✅ Git commits proper
# ✅ No orphaned work
# ✅ Convoy updated (if applicable)
```

---

## 📦 File Structure

```
geekcon-site-demo/
├── .cursor/
│   └── subagents/
│       ├── gastown-auditor.md    # MEOW enforcer
│       └── gastown-guide.md      # Context & commands
├── .cursorrules                   # Main Gastown rules
└── GASTOWN_SUBAGENTS.md          # This file
```

---

## 🔄 Continuous Improvement

### Subagent Updates
- Add new patterns as they emerge
- Update commands based on Gastown releases
- Refine audit criteria based on violations
- Expand troubleshooting guides

### Feedback Loop
```
Agent Work → Auditor Violations → Guide Updates → Better Compliance
```

---

## 📊 Success Metrics

### MEOW Compliance Rate
- **Target**: 95%+ bead tracking
- **Target**: Zero GUPP violations
- **Target**: 100% agent identity in commits
- **Target**: <5% orphaned polecats

### Agent Efficiency
- **Measure**: Time from bead creation to closure
- **Measure**: Number of "should I?" questions (minimize)
- **Measure**: Successful polecat spawns vs. failures
- **Measure**: Convoy completion rate

---

## 🚀 Next Steps

1. **Test Geekcon**: `geekcon` → Should land directly in Mayor
2. **Invoke Auditor**: `@gastown-auditor audit current work`
3. **Use Guide**: `@gastown-guide show commands`
4. **Create Beads**: Follow MEOW workflow
5. **Verify Compliance**: Continuous audit checks

---

## 📞 Invocation Syntax

### In Cursor IDE
```
@gastown-auditor [command]
@gastown-guide [topic]
```

### In Mayor Session (via Cursor integration)
```
# Auditor checks happen automatically
# Guide provides context on demand
```

### Manual Check
```bash
# From Gastown workspace
gt status                 # Overall health
gt doctor                 # Detailed diagnostics
gt audit [agent]          # Agent work history
```

---

**Status**: ✅ ACTIVE  
**Last Updated**: February 2, 2026  
**Maintainer**: Gastown Overseer (Human)
