---
name: init
description: Initialize hyper in a project — like /init (analyze codebase, write/refresh CLAUDE.md) plus create .hyper/ state, configure limits, then offer to run /hyper:plan. Trigger: /hyper:init [--defaults].
---

# /hyper:init [--defaults]

Set up a project for hyper. Fast; no ceremony.

## 1. Analyze + CLAUDE.md
Skim tree, manifest, entrypoints, build/test commands (≤2 min, no deep reads). Write CLAUDE.md at the project root, or refresh it if it exists (edit in place, keep user content, never duplicate sections): what the project is, key commands (build/test/lint), architecture in a few lines, conventions.
Ensure this line is present exactly once: `Hyper: PLAN.md is truth. Workers follow ~/.claude/hyperdo/WORKER.md.`

## 2. State
Create what is missing, never overwrite existing files:
- `.hyper/config` — `max_workers=3 max_do=2 rigor=fast model=auto dev_mode=solo code_mode=off` (one line, `key=value` pairs)
- `.hyper/log.md` — empty, append-only shared chat
- `.hyper/locks/` — empty dir
- `.hyper/logs/` — empty dir; workers write full check/test output here (see Checks in WORKER.md)
Git repo → add `.hyper/` to .gitignore if absent.

## 3. Configure
- `--defaults` given, or `.hyper/config` already existed → keep values, skip questions.
- Otherwise ask in two AskUserQuestion calls (the tool takes at most 4 questions). Call 1, 4 questions (mark defaults "(default)"):
  1. Max workers: 2 / 3 (default) / 6 / 8
  2. Max do workers: 1 / 2 (default) / 4 / 0 (disabled)
  3. Testing rigor: fast (default) / medium / slow
  4. Worker model: auto (default) / opus / sonnet / haiku

  Call 2: 5. Dev mode: solo (default, Recommended: shared tree, small commits, push to origin, no PRs) / pro (branch + PR per thread) / prod (pro + slow rigor, review, CI, approval before merge) → `dev_mode=solo|pro|prod`. 6. "Do you plan to use Claude Code's Code Mode (experimental)?" (Claude writes JS that batches several tool calls into one step; terminal-only, needs a restart): No (default) / Yes → `code_mode=off|on`.
- If Yes (see https://code.claude.com/docs/en/code-mode.md): run `claude --version`; need >= 2.1.323 (native build) — if older or missing, say so, keep `code_mode=off`. Else show the exact change and, on confirmation, merge `"CLAUDE_CODE_EXPERIMENTAL_CODE_MODE": "1"` into `env` of `~/.claude/settings.json` (create file/`env` if absent, preserve all other keys; project settings are ignored for this var). This is a user-global change: always confirm, even in auto mode. Also offer the shell alternative `export CLAUDE_CODE_EXPERIMENTAL_CODE_MODE=1`. Tell the user to restart claude (keep it set for --continue/--resume; first session asks to confirm). Caveats: interactive terminal only (not -p/VS Code/Desktop/cloud), no Bedrock/Vertex/gateways, incompatible with apiKeyHelper, OpenTelemetry, DISABLE_TELEMETRY. Declined → `code_mode=off`.
- Write answers to `.hyper/config` (same format as /hyper:config), log `[config] init: <values>` to `.hyper/log.md`.

## 4. Offer to plan
AskUserQuestion: "Run /hyper:plan now?" — Yes / Not now.
- Yes → ask a follow-up AskUserQuestion for the goal (free text via Other) and max_subagents (2 / 3 / 6 / 8, default = config `max_workers`), then run the hyper:plan skill with `<max_subagents> "<goal>"`.
- Not now → print the files created and `Run /hyper:plan <N> "<goal>" when ready.` Stop.

Reply in ≤3 lines: files written/updated, config values, planned or not.

## Modes
- **Plan mode**: read-only recon only. Describe the CLAUDE.md changes, `.hyper/` files, and config you would write, then ExitPlanMode before writing anything; after approval run steps 2-4.
- **Auto mode**: treat as `--defaults` (skip step 3 questions, `dev_mode=solo`, `code_mode=off`; never edit `~/.claude/settings.json`, log `[lead] DEFAULT config`); skip the step 4 question and do not start /hyper:plan (no goal is known) — just print the `Run /hyper:plan` hint. Still ask before destructive actions.
