
## Codex notes

Hyperdo was written for Claude Code; `install.sh` adds this section when it installs for Codex. Same workflow, same `PLAN.md` and `.hyper/` files. Read the rest of this file with these substitutions:

- `/hyper:<name>` is the `hyper-<name>` skill here (`$hyper-<name>`).
- "Launch a background Agent" = spawn a Codex sub-agent with the same one-line prompt. No sub-agents available → run the ready threads yourself, one at a time in priority order, still claiming, locking and logging as each `T<k>`.
- `m:` tags and `--model` aliases name Claude models. Keep them in `PLAN.md`, but run on the session's model unless the user maps them.
- AskUserQuestion = ask in chat. Plan mode / ExitPlanMode = show the plan and wait for approval before writing.
- `code_mode` and `~/.claude/settings.json` are Claude Code only: skip those steps and leave `code_mode=off`.
