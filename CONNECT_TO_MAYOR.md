# 🎯 CONNECT TO MAYOR AGENT

## Mayor Agent Details

**Process ID**: 1452944
**Session**: hq-mayor (tmux)
**Terminal**: pts/4
**User**: gastown
**Status**: Running (1 day 20+ hours)
**Memory**: 1.5 GB
**CPU**: 238+ minutes

---

## 🔗 How to Connect

### Method 1: Attach to Mayor's Tmux Session (Recommended)
```bash
# SSH as gastown user and attach to mayor session
ssh ggt
sudo su - gastown
tmux attach-session -t hq-mayor
```

### Method 2: Direct Tmux Attach (One Command)
```bash
ssh -t ggt "sudo -u gastown tmux attach-session -t hq-mayor"
```

### Method 3: View Mayor's Activity
```bash
# Watch mayor's process
ssh ggt "sudo -u gastown watch -n 2 'ps aux | grep mayor | grep -v grep'"

# View mayor's logs (if available)
ssh ggt "sudo -u gastown tail -f /home/gastown/gt/.logs/mayor.log"
```

---

## 🎮 Tmux Commands (Once Connected)

```
Ctrl+B then D     - Detach from session (leave it running)
Ctrl+B then [     - Enter scroll mode (use arrows to scroll)
Ctrl+C            - Send interrupt to mayor (careful!)
Ctrl+B then ?     - Show all tmux commands
```

---

## 📊 Mayor Agent Info

The mayor is the main Gastown orchestrator that:
- Checks hooks for work assignments
- Reads mail/messages
- Coordinates other agents
- Executes hooked tasks

**Current Command**:
```
claude --dangerously-skip-permissions --model sonnet 
[GAS TOWN] mayor <- human • 2026-01-29T19:21 • cold-start
Check your hook and mail, then act on the hook if present
```

---

## 🔧 Troubleshooting

### "No session found"
Mayor might be running without tmux. Check:
```bash
ssh ggt "ps aux | grep mayor | grep claude"
```

### "Permission denied"
You need gastown user access:
```bash
ssh ggt "sudo su - gastown"
```

### Can't detach from session
Press: `Ctrl+B` then `D`

---

## ⚠️ Important Notes

- **Don't Ctrl+C** unless you want to stop mayor
- **Use Ctrl+B D** to safely detach
- Mayor is critical - be careful when interacting
- Other agents depend on mayor's coordination

---

## 🚀 Quick Connect

```bash
ssh -t ggt "sudo -u gastown tmux attach-session -t hq-mayor"
```

This will connect you directly to the mayor agent's interactive session.
