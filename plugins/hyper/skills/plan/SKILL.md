---
name: plan
description: Plan a build as parallel threads in PLAN.md for sub-agent workers, then orchestrate them. Trigger: /hyper:plan <max_subagents> "<what to build>".
---

# /hyper:plan <N> "<goal>"

Fast orchestrator planning. You are the **lead**: plan, dispatch, merge. Workers build. Minimal testing, no ceremony.

## 1. Parse
`N` = max workers (default: `.hyper/config` max_workers, else 3); write it to config. Rest = goal. No args + PLAN.md exists → resume (go to step 4).
PLAN.md exists + new goal → append as new threads, never overwrite.

## 2. Recon (≤2 min)
Skim tree, manifest, entrypoints. No deep reads. No questions unless truly blocked — pick defaults, note them.

## 3. Write PLAN.md + state
Split the goal into **threads**: independent lanes with **disjoint file ownership**. Shared interfaces go in a T0 `contracts` thread done first by you (types, stubs, file layout) so others never block on each other.

```markdown
# PLAN: <goal>
state: .hyper/ (limits + rigor live in .hyper/config)

## Contracts
<interfaces/shared types/paths every thread codes against>

## Threads
### T1 <name> · p:5 · m:sonnet · owns: src/a/** · deps: — · status: todo
- [ ] step
- [ ] step
- [ ] check: <one cheap command>
```
**Phases** (automatic, lead-only; never ask the user): if >4 threads and >1 dependency level, group threads under `## Phase N <name>` headings (by dep depth / milestone) inside `## Threads`, each followed by one `gate: <integration check command or observable condition>`. Ids stay global; deps/p/owns unchanged. Smaller plans stay flat. `· hold` on a heading = skip its todo threads until removed.

status ∈ todo | doing:<worker> | done | blocked:<why>. `p:` priority 1-10 (10 highest, default 5). `m:` model opus|sonnet|haiku, set per thread by the routing rule below.

Create `.hyper/`: `config` (`max_workers=N`, `max_do=2`, `rigor=fast`, `model=auto`, `dev_mode=solo`, `code_mode=off` = record of Claude Code Code Mode, see /hyper:config), `log.md` (shared chat, append-only), `locks/` (empty), `logs/` (empty, check output). Add `.hyper/` to .gitignore if git.
Append to CLAUDE.md once: `Hyper: PLAN.md is truth. Workers follow ~/.claude/hyperdo/WORKER.md.`

## 4. Orchestrate
Loop until all threads done. **Re-read `.hyper/config` every dispatch** (user may change it live via /hyper:config).
- Ready = todo with deps done, sorted by `p:` desc. Launch up to max_workers minus running in **one message** (Agent tool, background), each prompt: `You are hyper worker T<k>. Rigor: <rigor>. Dev mode: <dev_mode>. Read and follow ~/.claude/hyperdo/WORKER.md. Thread: T<k> in <abs path>/PLAN.md.`
- Model: pass Agent `model` = thread's `m:` tag, else config `model` if not `auto`, else route: **opus** = architecture/contracts, tricky algorithms, cross-cutting refactors, debugging unknown failures, p≥9; **sonnet** = normal feature/thread work (default); **haiku** = mechanical edits, renames, boilerplate, docs, config, running checks.
- Dev mode (config `dev_mode`, default solo; rules in WORKER.md "Dev mode"): lead merges/pushes per mode (solo: workers push themselves, nothing to merge; pro/prod: merge each thread's PR once checks pass, prod also needs user approval). Not a git repo → skip git steps silently.
- Phases: a thread waits on phase N's gate only if it has a dep in phase N; otherwise deps + p as usual (never serialize). When a phase's last thread is done, run its gate once per **Checks** (`.hyper/logs/lead-phaseN.log`): ok → log `[lead] PHASE N DONE`; fail → `[lead] PHASE N FAIL <log>` and add a fix thread to that phase. dev_mode=prod: ask user approval before gated threads start; solo/pro never ask.
- On each completion: read its log lines, flip status, launch next ready thread immediately. Don't wait for batches.
- Lead is the bottleneck: keep your turns tiny, never do worker work while workers run.
- End (per rigor — fast: one cheapest check; medium: + affected tests; slow: + full suite & self-review): run the cheapest whole-project check once (build/typecheck). Run it per the **Checks** rule in WORKER.md (output to `.hyper/logs/lead-<check>.log`, silent on exit 0, on failure only exit code + ≤10 error lines + log path). Fix or spawn a fix thread. Report done/total in 3 lines.

## Modes
- **Plan mode** (Claude Code plan mode active): steps 1-2 only, read-only. Draft PLAN.md contents (goal, Contracts, threads with p/m/owns/deps/steps/check) and present them via ExitPlanMode. Do NOT write PLAN.md, `.hyper/`, CLAUDE.md, or launch workers until approved. After approval: do step 3, then step 4.
- **Auto mode** (auto mode active): no confirmation questions; ask only genuinely-blocking ones. Pick defaults, log each as `[lead] DEFAULT <choice>`. Use Bash freely for reads/edits and launch workers without asking. Still ask before destructive or outward-facing actions (force-push, deploy, deleting data, external posts). Workers inherit this: include "Auto mode: on" in their prompt.
