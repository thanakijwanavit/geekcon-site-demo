# 🎯 MEOW Workflow Requirement

**Date**: February 1, 2026  
**Status**: Beads must be solved using MEOW principle

---

## ⚠️ Current Situation

The 28 beads were closed manually using `bd close`, which does **NOT** follow the MEOW (Mayor-Enhanced Orchestration Workflow) principle.

---

## ✅ What MEOW Principle Requires

According to the [Gastown article](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04), proper MEOW workflow means:

### **M** - Mayor-Enhanced
- Work is coordinated by the Mayor
- Mayor is the main agent you interact with

### **E** - Enhanced (multi-agent)
- Multiple agents work together
- Polecats execute the work
- Witness monitors progress
- Refinery handles merges

### **O** - Orchestration
- Work is organized in convoys
- Molecules define the workflow
- Proper Git-backed tracking

### **W** - Workflow
- Work flows through the system
- Automated handoffs between agents
- Persistent work tracking in Beads

---

## 🎯 Proper MEOW Workflow for Solving 10 Beads

### **Step 1: Start Mayor**
```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
sudo -u gastown bash
cd /home/gastown/gt
gt mayor attach
```

### **Step 2: Tell Mayor to Solve Beads**
In the Mayor session:
```
Mayor, we have 10 open beads that need to be solved:
- hq-o41, hq-sis, hq-or5, hq-gh1, hq-wuc
- hq-8pw, hq-w3b, hq-o9o, hq-0fq, hq-zvs

Please create a convoy and sling these to polecats for completion.
```

### **Step 3: Mayor Orchestrates**
Mayor will:
1. Create a convoy to track the work
2. Sling beads to polecats (using `gt sling`)
3. Polecats work on the beads
4. Submit merge requests to Refinery
5. Refinery merges the work
6. Convoy completes

### **Step 4: Witness Monitors**
- Witness patrol checks on polecats
- Ensures they don't get stuck
- Reports progress

### **Step 5: Verify Completion**
```bash
# Check convoy status
gt convoy list

# Check closed beads
bd list --all --status closed

# Verify beads were closed by polecats, not manually
git log .beads/issues.jsonl
```

---

## 📋 Required Components for MEOW

- ✅ **Town**: `/home/gastown/gt/` (exists)
- ✅ **Beads**: 28 beads created (exists)
- ✅ **Rig**: geekcon_herbs registered (exists)
- ⚠️ **Mayor**: Needs to be attached
- ⚠️ **Polecats**: Need to be spawned by Mayor
- ⚠️ **Convoy**: Needs to be created
- ⚠️ **Witness**: Should be running
- ⚠️ **Deacon**: Should be running
- ⚠️ **Refinery**: Should be running

---

## 🎯 Next Steps

To properly demonstrate MEOW workflow:

1. **Reopen 10 beads** ✓ (ready)
2. **Start Mayor** in tmux session
3. **Tell Mayor** to solve the beads
4. **Monitor convoy** progress
5. **Verify beads closed** through orchestration
6. **Document the workflow** with logs

---

## 📊 Current Status

```
Open Beads:   10 (ready for MEOW)
Closed Beads: 18 (manually closed - not MEOW)
Convoy:       Not yet created
Mayor:        Not yet attached
Polecats:     Not yet spawned
```

---

## 🔑 Key Difference

**Manual Close** (current):
```bash
bd close hq-o41 --message "done"
```

**MEOW Workflow** (required):
```bash
# In Mayor session
gt mayor attach
> "Mayor, solve bead hq-o41 by creating a convoy and slinging to a polecat"
# Mayor orchestrates everything
```

---

## ✅ Acceptance Criteria

To prove MEOW workflow was used:

1. ✅ Convoy created and tracked
2. ✅ Beads assigned to polecats (not closed manually)
3. ✅ Polecats executed and submitted MRs
4. ✅ Refinery merged the changes
5. ✅ Git log shows orchestration, not manual closes
6. ✅ Activity feed shows MEOW workflow

---

**The beads need to be solved by the Mayor-orchestrated workflow, not by manual `bd close` commands.**
