# 🎩 Gastown Proper Setup - Mayor User

**Date**: February 1, 2026  
**Server**: 13.215.224.99 (ap-southeast-1)  
**Corrected Setup**: Following official Gastown conventions

---

## ✅ Proper Gastown Setup

### **User: mayor (Not gastown!)**
According to official Gastown documentation, the primary user should be `mayor`.

### **Workspace: $HOME/gt**
The town workspace should be at `/home/mayor/gt` (not `/home/gastown/gt`).

---

## 📋 What Was Fixed

### **Before (Incorrect)**
- ❌ User: `gastown`
- ❌ Workspace: `/home/gastown/gt`
- ❌ Convention: Custom/non-standard

### **After (Correct)**
- ✅ User: `mayor`
- ✅ Workspace: `/home/mayor/gt`
- ✅ Convention: Official Gastown standard

---

## 🏗️ Installation Summary

### **1. Created Mayor User**
```bash
useradd -m -s /bin/bash mayor
```

### **2. Installed Gastown Town**
```bash
sudo -u mayor bash
cd ~
gt install ~/gt --git
```

### **3. Added Project Rig**
```bash
cd ~/gt
gt rig add geekcon_herbs /path/to/project --adopt --prefix GH
```

### **4. Created tmux Configuration**
```bash
~/.tmux.conf with Gastown settings
```

### **5. Initialized Beads**
```bash
Created 10 sample beads for testing MEOW workflow
```

---

## 📂 Directory Structure

```
/home/mayor/                 (Mayor user home)
└── gt/                      (Town - The HQ) ✅
    ├── .git/                (Git tracking)
    ├── .beads/              (Beads database)
    ├── mayor/               (Mayor agent workspace)
    ├── deacon/              (Deacon agent)
    ├── geekcon_herbs/       (Project rig)
    ├── settings/            (Configuration)
    └── CLAUDE.md            (Agent instructions)
```

---

## 🚀 Starting Gastown

### **Method 1: Via sudo (Recommended)**
```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
sudo -u mayor bash
cd ~/gt
tmux new-session -s mayor
gt mayor attach
```

### **Method 2: Direct Login (if SSH key added)**
```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem mayor@13.215.224.99
cd ~/gt
tmux new-session -s mayor
gt mayor attach
```

---

## 🎯 MEOW Workflow

Once Mayor is attached in tmux:

```
Mayor, I have 10 production tasks that need to be completed:

Please review the 10 beads in the queue and:
1. Create a convoy to track this work
2. Sling the beads to polecats for execution
3. Monitor progress through the Witness
4. Ensure all work goes through the Refinery
5. Report back when the convoy completes

Follow proper MEOW orchestration principles.
```

---

## 📊 Current Status

```
✅ User:           mayor (correct!)
✅ Workspace:      /home/mayor/gt (correct!)
✅ gt binary:      /usr/local/bin/gt
✅ bd binary:      /usr/local/bin/bd
✅ tmux:           Installed (3.2a)
✅ tmux.conf:      Created
✅ Git:            Initialized
✅ Rig:            geekcon_herbs added
✅ Beads:          10 created
⚠️  Mayor:         Ready to attach
⚠️  tmux session:  Not started yet
```

---

## 🔑 Access Commands

### **Switch to Mayor User**
```bash
# From ec2-user
sudo -u mayor bash

# Verify
whoami  # Should show: mayor
pwd     # Should show: /home/mayor
```

### **Navigate to Town**
```bash
cd ~/gt
# or
cd $HOME/gt
```

### **Check Status**
```bash
gt status
gt rig list
bd list
```

---

## 📖 Following Official Documentation

This setup now matches the [official Gastown README](https://github.com/steveyegge/gastown):

```bash
gt install ~/gt --git &&
cd ~/gt &&
gt config agent list &&
gt mayor attach
```

**Key Points from Docs:**
- ✅ Workspace at `~/gt` ✅
- ✅ Git-backed town ✅
- ✅ Mayor as primary interface ✅
- ✅ tmux for UI ✅

---

## 🎨 tmux Shortcuts (for Gastown)

```bash
# Start mayor session
tmux new-session -s mayor

# Detach from session
Ctrl+b, d

# Reattach to session
tmux attach -t mayor

# List sessions
tmux ls

# Switch windows
Ctrl+b, n  (next)
Ctrl+b, p  (previous)
Ctrl+b, 0  (window 0: mayor)
Ctrl+b, 1  (window 1: deacon)
Ctrl+b, 2  (window 2: witness)

# Scroll mode
Ctrl+b, [
ESC (exit scroll mode)
```

---

## ⚠️ Migration Notes

The old `gastown` user still exists at `/home/gastown/gt` but is now deprecated. The correct setup is:

- **User**: `mayor` ✅
- **Location**: `/home/mayor/gt` ✅

This follows the official Gastown conventions and recommendations.

---

## ✅ Verification Checklist

- ✅ User `mayor` exists
- ✅ Workspace at `/home/mayor/gt`
- ✅ `gt` and `bd` binaries accessible
- ✅ tmux installed and configured
- ✅ Git initialized in town
- ✅ Rig added with proper prefix
- ✅ Beads created for testing
- ✅ Ready for `gt mayor attach`

---

**Gastown is now properly set up following official conventions!** 🏘️🎩

To start, simply:
```bash
sudo -u mayor bash
cd ~/gt
tmux new-session -s mayor
gt mayor attach
```
