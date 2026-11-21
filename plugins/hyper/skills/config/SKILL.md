---
name: config
description: Interactively configure hyper — max plan workers, max /hyper:do workers, testing rigor, worker model, dev mode (solo/pro/prod), Claude Code Code Mode record — via question UI; applies live to running orchestration. Trigger: /hyper:config [key=value ...].
---

# /hyper:config [key=value ...]

State: `.hyper/config` (lines `key=value`). Keys: `max_workers` (1-20, default 3), `max_do` (0-10, default 2), `rigor` (fast|medium|slow, default fast), `model` (auto|opus|sonnet|haiku, default auto = route by task), `dev_mode` (solo|pro|prod, default solo; see Dev mode in WORKER.md), `code_mode` (on|off, default off). `code_mode` is a Claude Code setting, not a hyper worker behavior: it records whether Claude Code's experimental Code Mode (env `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE`, docs: https://code.claude.com/docs/en/code-mode.md) is enabled. Changing it edits `~/.claude/settings.json` `env` (not project settings), always after confirmation, even in auto mode: `on` → merge `"CLAUDE_CODE_EXPERIMENTAL_CODE_MODE": "1"` (check `claude --version` >= 2.1.323 first; preserve other keys); `off` → set it to `"0"` (or remove it). Then tell the user to restart claude. If the shell exports the var, mention it overrides/needs unsetting.

- Args given (e.g. `rigor=slow max_workers=6`) → write them, skip questions.
- No args → read current values, then ask in two AskUserQuestion calls (max 4 questions each; mark current value "(current)"). Call 1:
  1. Max workers: 2 / 3 / 6 / 8
  2. Max do workers: 1 / 2 / 4 / 0 (disabled)
  3. Testing rigor: fast (narrowest check) / medium (affected tests per thread) / slow (tests every change + review)
  4. Worker model: auto (route by task) / opus / sonnet / haiku

  Call 2: 5. Dev mode: solo (Recommended: shared tree, small commits, push to origin, no PRs) / pro (branch + PR per thread, lead merges) / prod (pro + slow rigor, review, CI green, approval before merge). 6. Claude Code Code Mode (experimental, restart needed): off (default) / on.
- Write file, log `[config] <changes>` to `.hyper/log.md`, print all 6 values in one line.

Live effect: orchestrator re-reads config each dispatch; running workers see `[config] rigor=` in the log and switch at their next step (`code_mode` takes effect only after a claude restart). Lowering limits never kills workers — just stops new launches.
