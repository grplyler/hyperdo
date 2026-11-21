---
name: add
description: Add a prioritized thread (p 1-10, 10 highest) to the running hyper plan and spin up a worker now; it collaborates via .hyper/log.md. Trigger: /hyper:add [-p N] [--model <alias>] [--split [--force]] "<task>".
---

# /hyper:add [-p N] [--model <alias>] [--split [--force]] "<task>"

Priority `N` 1-10, 10 = highest, default 5 (also accept `p8`, `priority 8`).

`--model <alias>` overrides the model for this thread. Aliases: `s55`/`sonnet` → sonnet (Sonnet 5.5), `o55`/`opus` → opus (Opus 5.5), `f52`/`fable` → fable (Fable 5.2), `h55`/`haiku` → haiku (Haiku 5.5). Unknown alias → say so and ask. The override wins over routing, config `model`, and any `m:` tag; record the resolved model as the thread's `m:` tag.

`--split` lets the lead decide whether the task is really 2+ independent parts. Judge using the hyper:plan thread rules (disjoint file ownership): if it splits, add one thread per part (`T<k>`, `T<k+1>`, ...), each with its own `owns:`, steps and `check:`, same `p:`/`m:`, and `deps:` between parts where order matters (shared interfaces first). If it doesn't, log `[lead] NOSPLIT <why>` and add a single thread as usual. `--split --force` always splits into >=2 parts along the best seam; where files overlap, use `shares:`/`deps:` so parts don't collide. `--force` alone implies `--split --force`.

1. Read PLAN.md, `.hyper/config`, `ls .hyper/locks`. No PLAN.md → create a minimal one and `.hyper/{config,log.md,locks/}` (defaults `max_workers=3 max_do=2 rigor=fast`).
2. Append (one per part when splitting) `### T<next> <name> · p:N · m:<model> · owns: <files not owned by others> · deps: <ids or —> · status: todo` with 2-5 steps + `check:`. Files owned by others → `shares:`; the worker locks or asks via log.
3. Log `[lead] ADD T<k> p:N: <task>` (one line per thread; when split, add `(part i/n of <task>)`).
4. For each thread: start now if deps done AND (running < max_workers OR N ≥ 9); the rest queue (max_workers is never exceeded by a split, except p ≥ 9). Launch one background Agent (model per rule below): `You are hyper worker T<k>. Rigor: <rigor>. Read and follow ~/.claude/hyperdo/WORKER.md. Thread: T<k> in <abs>/PLAN.md.` Else queue; the orchestrator dispatches by priority.
   p:10 also logs `[lead] URGENT T<k>` — workers holding files it needs release them at next step.

Model (precedence): `--model` override (already stored as the `m:` tag) > thread's `m:` tag > config `model` > routing. Pass Agent `model` = thread's `m:` tag, else config `model` if not `auto`, else route: **opus** = architecture/contracts, tricky algorithms, cross-cutting refactors, debugging unknown failures, p≥9; **sonnet** = normal feature/thread work (default); **haiku** = mechanical edits, renames, boilerplate, docs, config, running checks.

5. Reply one line: every id, priority, model, started/queued (e.g. `T11 p5 sonnet started, T12 p5 sonnet queued (deps T11)`).

## Modes
- **Plan mode**: don't write PLAN.md/`.hyper/` or launch a worker. Describe the thread (name, p, m, owns, steps) and ExitPlanMode first; then do steps 1-5.
- **Auto mode**: no confirmation questions (unknown `--model` alias → log `[lead] DEFAULT` and fall back to routing); add "Auto mode: on" to the worker prompt. Still ask before destructive or outward-facing actions.
