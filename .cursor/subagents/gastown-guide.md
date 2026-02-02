# Gastown Guide - Context & Best Practices

**Role**: Provide Gastown-specific knowledge and guide agents through workflows.

## Quick Reference

### Server Details
- **IP**: 13.215.224.99
- **Region**: ap-southeast-1 (Singapore)
- **User**: `gastown` (has sudo)
- **Workspace**: `/home/gastown/gt`
- **Access**: `geekcon` (fish shell command)

### Current Setup
- **Gastown**: Official Go-based from `steveyegge/gastown`
- **Beads**: Git-backed issue tracking
- **Rig**: `geekcon_herbs` (Next.js e-commerce site)
- **Agents**: Claude v2.1.29, cursor-agent
- **Tools**: AWS CLI, git, vim, htop, python3, pip

## Gastown Commands Quick Reference

### Work Management
```bash
# Beads (Issues)
bd new --type [feature|bug|task|epic|convoy] --title "..." --assign [self|agent]
bd list [--status pending|in_progress|closed]
bd show [ID]
bd close [ID] --comment "..."

# Hook (Your Current Work)
gt hook                        # Show what's on your hook
gt hook attach [bead-id]       # Attach work to hook
gt sling [bead-id] [agent]     # Assign work to agent

# Convoys (Multi-Rig Work Batches)
gt convoy new --title "..." --rigs rig1,rig2
gt convoy list
gt convoy status [ID]
gt convoy close [ID]
```

### Agent Management
```bash
# Mayor (Primary Interface)
gt mayor attach                # Start Mayor with Claude
gt mayor attach --agent cursor # Start Mayor with cursor-agent

# Polecats (Ephemeral Workers)
gt polecat spawn --bead [ID]   # Spawn polecat for bead
gt polecat list                # List active polecats
gt polecat status [name]       # Check polecat status

# Deacon (Town Daemon)
gt deacon attach               # Monitor Deacon
gt deacon status               # Check Deacon health

# Witness (Polecat Monitor)
gt witness attach              # Monitor polecats in rig
```

### Git & Identity
```bash
gt whoami                      # Show agent identity
gt commit -m "message"         # Commit with agent identity
git log --format="%an <%ae>"   # Verify agent commits
```

### Diagnostics
```bash
gt status                      # Town overview
gt doctor                      # Health checks
gt trail                       # Recent activity
gt ready                       # Work ready to process
gt orphans                     # Lost polecat work
gt costs                       # Claude costs
```

## Typical Workflows

### 1. Single Task Workflow
```bash
# Create bead
bd new --type task --title "Add user authentication" --assign self

# Work on it (Mayor)
gt mayor attach
# ... do work ...
# Mayor handles commits with agent identity

# Close bead
bd close [ID] --comment "Authentication implemented"
```

### 2. Polecat Workflow (Parallel Tasks)
```bash
# Create multiple beads
bd new --type feature --title "Feature A" --assign polecat
bd new --type feature --title "Feature B" --assign polecat

# Spawn polecats (one per bead)
gt polecat spawn --bead [BEAD_A_ID]
gt polecat spawn --bead [BEAD_B_ID]

# Monitor progress
gt polecat list
gt trail

# Polecats auto-submit MRs and self-destruct
```

### 3. Convoy Workflow (Cross-Rig)
```bash
# Create convoy
gt convoy new --title "Multi-service deployment" --rigs api,frontend,infra

# Create beads for convoy
bd new --type convoy --title "Deploy API" --convoy [CONVOY_ID]
bd new --type convoy --title "Deploy Frontend" --convoy [CONVOY_ID]

# Assign work
gt sling [BEAD_API] polecat-api
gt sling [BEAD_FRONTEND] polecat-frontend

# Track convoy
gt convoy status [CONVOY_ID]

# Close convoy when all done
gt convoy close [CONVOY_ID]
```

### 4. Handoff Workflow (Context Refresh)
```bash
# When Mayor session gets stale
gt handoff --message "Completed auth, starting payment integration"

# Resume in new session
gt mayor attach
gt resume  # Picks up handoff message
```

## Common Patterns

### Bead Types
- **feature**: New functionality
- **bug**: Fix broken behavior
- **task**: General work item
- **epic**: Parent bead with children
- **convoy**: Cross-rig coordinated work
- **system**: Infrastructure/maintenance

### Agent Assignment
- **self**: Work it yourself (Mayor/Crew)
- **polecat**: Spawn ephemeral worker
- **[specific-name]**: Assign to specific agent
- **deacon**: Town-level maintenance
- **witness**: Polecat monitoring

### Rig Management
```bash
gt rig list                    # List all rigs
gt rig add [path] [name]       # Add new rig
gt rig status [name]           # Check rig health
cd $(gt rig path [name])       # Navigate to rig
```

## Environment Setup

### Agent Initialization
```bash
# First time in session
cd /home/gastown/gt
gt whoami                      # Verify identity
gt status                      # Check town state
bd list                        # See available work
gt hook                        # Check your hook
```

### Before Starting Work
1. ✅ Verify in correct rig: `pwd` should show `/home/gastown/gt/rigs/[rig-name]` or `/home/gastown/gt`
2. ✅ Check hook: `gt hook`
3. ✅ Check git status: `git status`
4. ✅ Verify identity: `gt whoami`

## Troubleshooting

### Common Issues
```bash
# "Not in Gas Town workspace"
cd /home/gastown/gt

# "No work on hook"
bd list --status pending
gt sling [bead-id] self

# "Permission denied"
# (gastown has sudo)
sudo [command]

# "Orphaned polecats"
gt orphans
gt polecat cleanup

# "Stale sessions"
gt mayor attach --fresh
```

## Best Practices

1. **Always Use Beads**: Every task = one bead
2. **GUPP Compliance**: If work on hook, do it immediately
3. **Agent Identity**: Let `gt commit` handle commits
4. **Parallel Work**: Use polecats for independent tasks
5. **Cross-Rig**: Use convoys for multi-service work
6. **Checkpoints**: For long work, create handoffs
7. **Git Worktrees**: Polecats work in separate worktrees
8. **Autonomous Action**: Don't ask permission, follow GUPP

## Resources

- **Local Docs**: `.cursorrules` (this workspace)
- **Gastown Repo**: https://github.com/steveyegge/gastown
- **Articles**: 
  - https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04
  - https://steve-yegge.medium.com/gas-town-emergency-user-manual-cf0e4556d74b

**Invoke with**: `@gastown-guide [topic]`
