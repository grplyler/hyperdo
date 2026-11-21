---
name: clean
description: Remove all hyper state from a project (.hyper/, PLAN.md, stray tracer files) after listing and confirming; refuses while workers are running. Trigger: /hyper:clean [--keep-plan].
---

# /hyper:clean [--keep-plan]

Wipe hyper state. Destructive: always list and confirm first.

## 1. Safety check
`ls .hyper/locks`. Any lock present, or a PLAN.md thread with `status: doing:*`, means workers may be running. Show them and ask (AskUserQuestion): Abort (default) / Workers are dead, clean anyway. Abort → stop. Never delete locks of live workers.

## 2. Collect
Targets (only those that exist):
- `.hyper/` (config, log.md, locks/, logs/ check output, anything else inside)
- `PLAN.md` — skipped if `--keep-plan`
- other hyper tracer files found at the project root (e.g. `.hyper*`, `*.hyper.md`); list them, never glob outside the project
Never touch CLAUDE.md, source files, or `~/.claude/hyperdo/`. Nothing found → say "no hyper state" and stop.

## 3. Confirm
Print the exact list. One AskUserQuestion:
- Without `--keep-plan` and PLAN.md exists, ask: Delete everything (default) / Keep PLAN.md / Cancel.
- With `--keep-plan`: Delete listed files / Cancel.
Proceed only on an explicit delete answer.

## 4. Delete
`rm -rf` only the confirmed paths (use `rmdir` for locks first, then `rm -rf .hyper`, which includes `.hyper/logs/`). Do not log to `.hyper/log.md` (it is deleted). Optionally remove a `.hyper/` line from .gitignore only if the user asked.

Reply in ≤3 lines: what was deleted, what was kept.

## Modes
- **Plan mode**: read-only. Describe what would be deleted (run steps 1-2 only), then ExitPlanMode; delete only after approval and the step 3 confirmation.
- **Auto mode**: still run steps 1 and 3 — deletion is destructive, so never skip the confirmation. Without `--keep-plan`, default the PLAN.md question to Keep PLAN.md unless the user explicitly said to delete it.
