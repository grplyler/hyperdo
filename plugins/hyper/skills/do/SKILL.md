---
name: do
description: Fire-and-forget a task right now with a hyper worker, outside the PLAN.md thread workflow; or with no args, drive all ready threads in PLAN.md. Trigger: /hyper:do [--model <alias>] [--split [--force]] ["<task>"].
---

# /hyper:do [--model <alias>] [--split [--force]] ["<task>"]

`--model <alias>` overrides the worker model. Aliases: `s55`/`sonnet` → sonnet (Sonnet 5.5), `o55`/`opus` → opus (Opus 5.5), `f52`/`fable` → fable (Fable 5.2), `h55`/`haiku` → haiku (Haiku 5.5). Unknown alias → say so and ask. It wins over config `model`, routing, and the `--opus|--sonnet|--haiku` shorthands.

`--split` (with a task) lets the lead decide whether the task is 2+ independent parts with disjoint files (hyper:plan thread rules). If so, launch one worker per part, each prompted with only its part and file scope; parts needing an order run sequentially (launch the later part when the earlier finishes). Each worker counts against `max_do`; excess parts queue as `[do QUEUED] <part>`. If not, log `[lead] NOSPLIT <why>` and run one worker. `--split --force` always splits into >=2 parts along the best seam; if files overlap, make the parts sequential or have them lock files. `--force` alone implies `--split --force`. Ignored with no task.

Read `.hyper/config` (defaults `max_do=2 rigor=fast dev_mode=solo`).

**With a task** — direct strike, no planning. If `do` workers running ≥ max_do, say so and queue it as a line in `.hyper/log.md` (`[do QUEUED] <task>`); launch it when one finishes.
- Launch one background Agent (model: `--model` override if given, else config `model` if not `auto`, else haiku for small/mechanical, sonnet for normal, opus for hard/debugging; legacy `--opus|--sonnet|--haiku` also accepted): `Do: <task>. Dev mode: <dev_mode> (per WORKER.md "Dev mode"; no git repo = skip git). Rigor: <rigor> (fast=narrowest check, medium=affected tests, slow=tests+self-review). Run checks per the Checks rule in ~/.claude/hyperdo/WORKER.md (full output to .hyper/logs/do-<check>.log; silent on exit 0; on failure only exit code, <=10 error lines, log path). Respect other workers: before editing a file run mkdir .hyper/locks/<path with / as __> (skip file if it fails), rmdir when done. Post one line to .hyper/log.md when done: [do HH:MM] <summary>.`
- Don't edit PLAN.md; do-tasks stay outside phases. Reply one line listing every worker launched or queued.

**No args** — run the plan: follow step 4 (Orchestrate) of the hyper:plan skill.

## Modes
- **Plan mode**: don't launch or edit anything. Describe the task, worker model, and files likely touched, then ExitPlanMode; launch only after approval (with no args: no dispatch before approval).
- **Auto mode**: no confirmation questions; pick defaults and log `[lead] DEFAULT <choice>`. Add "Auto mode: on" to the worker prompt. Use Bash freely for reads/edits; still ask before destructive or outward-facing actions.
