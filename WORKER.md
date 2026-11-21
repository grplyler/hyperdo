# Hyper worker protocol

1. Read PLAN.md (Contracts + your thread) and tail `.hyper/log.md`.
2. Claim: set your thread `status: doing:T<k>` in PLAN.md. For every file you will edit outside your `owns:`, take a lock: `mkdir .hyper/locks/<path-with-slashes-as-__>` — fails = someone has it; post in log and work on something else or wait. Ignore `## Phase` headings/gates; never start a thread the lead hasn't dispatched to you.
3. Build. Edit only owned/locked files. Code to the Contracts; if a contract must change, post `NEED T<k>→all: <change>` in log and stop that part — the lead decides.
4. Collaborate via `.hyper/log.md` (append one line: `[T<k> HH:MM] msg`). Re-tail it between steps; answer `NEED`/`ASK` lines addressed to you.
5. Tick `- [x]` as steps finish. Test per rigor (prompt, or latest `[config] rigor=` in log): fast = your `check:` only; medium = + tests for core logic; slow = tests every change + self-review diff. Run every check per **Checks** below. When a `[lead] URGENT` thread needs a file you hold, release it at your next step.
6. Done: `rmdir` your locks, set `status: done` (or `blocked:<why>`), log `[T<k>] DONE: <files touched>`. Reply to lead in ≤3 lines.

## Checks
Silent on success, details on demand. Run each check with full output in a log: `mkdir -p .hyper/logs; <cmd> >.hyper/logs/T<k>-<check>.log 2>&1` (e.g. `npm test >.hyper/logs/T5-test.log 2>&1`).
- Exit 0: print and log nothing about it beyond your `DONE` line. Never echo or paste passing output.
- Non-zero: show only `exit <code>`, the log path, and the first ≤10 relevant lines (`grep -m10 -iE 'error|fail' <log>`, else `tail -10 <log>`). Log `[T<k> HH:MM] FAIL <check> exit <code> <log path>` and fix, or set `blocked:<why>`.
- More detail: rerun with the tool's `-v`/`--verbose`, or `grep`/read the log file. `/hyper:status` lists failing threads with log paths.

## Code mode
Claude Code's experimental Code Mode (`CLAUDE_CODE_EXPERIMENTAL_CODE_MODE=1`, set per session, not by hyper) lets you write JS that runs several tool calls in one step. If your session has it, batch independent reads/edits/checks into one code step. Checks that may exceed 10 min run in the background. Locks and ownership rules are unchanged. Not available = ignore this section.

## Dev mode
Prompt says `Dev mode: <mode>` (else latest `dev_mode=` in `.hyper/config`, default solo). No git repo: skip all git steps silently.
- **solo**: work in the shared tree, no worktrees unless two workers must edit the same file. Commit small on main (or current branch) as each step passes, `git pull --rebase` then `git push` to origin often. No PRs. Choosing solo is the user's standing approval for these pushes.
- **pro**: branch (or worktree when parallel workers overlap) per thread, conventional commits, run affected tests (rigor >= medium), push the branch and open a PR via `gh`; the lead merges after checks pass. Never push to main directly.
- **prod**: everything in pro, plus rigor=slow, a worktree per thread, fresh-context review before merge, CI green, no force-push, a release notes/CHANGELOG entry, and explicit user approval before merge/deploy.

## Modes
- **Auto mode** (prompt says "Auto mode: on", or auto mode is active): don't ask questions; pick the default, log `[T<k> HH:MM] DEFAULT <choice>`. Use Bash freely for reads/edits within owned/locked files. Still never do destructive or outward-facing actions (force-push, deploy, deleting data, external posts) without asking; if needed, `blocked:<why>`.
- **Plan mode**: workers are launched only after the lead's plan is approved, so build normally. If you are in plan mode anyway, research read-only, post the intended changes to the log, and stop with `status: blocked:plan-mode` rather than editing.
