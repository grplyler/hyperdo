# PLAN

## Threads

### T1 hyper-init command · p:5 · m:sonnet · owns: plugins/hyper/skills/init/SKILL.md · deps: — · status: done
1. Read existing skills in plugins/hyper/skills/ (add, plan, config) for format/frontmatter conventions.
2. Write plugins/hyper/skills/init/SKILL.md: like /init (analyze codebase, write/refresh CLAUDE.md) but hyper-aware — create `.hyper/{config,log.md,locks/}` with defaults, ask config via question UI (or accept defaults), note hyper workflow in CLAUDE.md.
3. At end, prompt the user (AskUserQuestion) whether to run /hyper:plan now; if yes, ask for goal + max_subagents and invoke it.
4. Register in plugin manifest/README if skills are listed there.
check: SKILL.md has valid frontmatter matching sibling skills; any listing of commands includes hyper:init.

### T2 model-override flag · p:5 · m:sonnet · owns: plugins/hyper/skills/add/SKILL.md, plugins/hyper/skills/do/SKILL.md · deps: — · status: done
1. Read add and do SKILL.md.
2. Add `--model <alias>` to both: aliases s55/sonnet → sonnet (Sonnet 5.5), o55/opus → opus (Opus 5.5), f52/fable → fable (Fable 5.2), h55/haiku → haiku (Haiku 5.5).
3. Override wins over m: tag/config/routing; add records it as thread's `m:` tag; do passes it as Agent `model`.
4. Update usage lines/frontmatter descriptions/argument hints accordingly.
check: both files document --model with all four aliases and precedence.

### T3 auto+plan mode support · p:5 · m:sonnet · owns: plugins/hyper/skills/plan/SKILL.md, plugins/hyper/skills/do/SKILL.md, WORKER.md · shares: plugins/hyper/skills/add/SKILL.md, plugins/hyper/skills/init/SKILL.md · deps: — · status: done
1. Read all hyper skills + WORKER.md (repo copy; install.sh copies it to ~/.claude/hyperdo/).
2. Auto mode: when auto mode is active, lead/workers proceed without confirmation questions (skip AskUserQuestion except genuinely-blocking decisions, pick defaults and log them `[lead] DEFAULT ...`), use Bash freely for reads/edits, still never do destructive/outward-facing actions without asking.
3. Plan mode: when plan mode is active, /hyper:plan does research read-only, drafts the threads, and presents them via ExitPlanMode (it must not write PLAN.md/.hyper or launch workers before approval); after approval write PLAN.md and orchestrate. /hyper:add, do and init: in plan mode, describe what would be added/done and exit plan mode before writing anything.
4. Keep edits short; one "Modes" section per skill rather than scattered notes.
check: grep shows a Modes section covering auto + plan in plan/do/WORKER.md, and add/init where they're touched.

### T4 hyper-clean command · p:5 · m:sonnet · owns: plugins/hyper/skills/clean/SKILL.md · shares: .claude-plugin/marketplace.json, install.sh · deps: — · status: done
1. Read sibling skills (status, init) for format + Modes section conventions.
2. Write plugins/hyper/skills/clean/SKILL.md: `/hyper:clean [--keep-plan]` removes all hyper state (`.hyper/` dir: config, log.md, locks/; PLAN.md unless --keep-plan; any other hyper tracer files found). Refuse/ask if workers are running (non-stale locks). List what will be deleted and confirm first (even in auto mode — destructive); without flag, ask whether to keep PLAN.md.
3. Include Modes section (plan mode: describe only).
4. Add /hyper:clean to command lists in marketplace.json and install.sh.
check: SKILL.md frontmatter matches siblings; hyper:clean appears in both listings.

### T5 world-class README · p:5 · m:sonnet · owns: README.md · deps: — · status: done
1. Read install.sh, uninstall.sh, WORKER.md, all plugins/hyper/skills/*/SKILL.md and .claude-plugin/marketplace.json to understand exactly what the system does.
2. Pick a better product name/tagline for "minimalistic, parallel, orchestrator-style agentic dev system" (propose 3, choose 1, note others in log; don't rename files/commands).
3. Write README.md: hook + one-line pitch, 30-second demo (commands + sample PLAN.md/log), why it's different, install, command reference, how it works (lead/workers/locks/log diagram), config, FAQ, contributing, license.
4. Keep it skimmable, accurate (no invented features), GitHub-flavored markdown with badges and a mermaid diagram.
check: every command and flag mentioned exists in the skills; install steps match install.sh.

### T6 code-mode option · p:5 · m:sonnet · owns: plugins/hyper/skills/init/SKILL.md, plugins/hyper/skills/config/SKILL.md · shares: WORKER.md, README.md, plugins/hyper/skills/do/SKILL.md, plugins/hyper/skills/plan/SKILL.md · deps: — · status: done
1. Read init, config, plan, do SKILL.md, WORKER.md, README.md. Decide what "code mode" means here (most likely: workers execute via code/scripts — Bash-first, write-and-run code to do work, batch edits via scripts — vs. step-by-step tool calls); log the definition as `[T6] DEFAULT code_mode = ...`.
2. init: add question "Do you plan to use code mode?" (yes/no) to the config questions; store `code_mode=on|off` in `.hyper/config` (default off; --defaults → off).
3. Wire it in: when `code_mode=on`, the worker prompt/WORKER.md tells workers how to operate in code mode (concise rules that make it work well); plan/do pass it through like rigor.
4. config: add code_mode toggle (on/off) to the question UI and key=value form; reword existing wording as needed so it reads cleanly.
5. Update README.md config section if it lists keys.
check: grep code_mode shows it in init, config, WORKER.md (and plan/do if passed); default off documented.

### T7 code-mode = Claude Code Code Mode (rework T6) · p:6 · m:sonnet · owns: plugins/hyper/skills/init/SKILL.md, plugins/hyper/skills/config/SKILL.md, WORKER.md, README.md, plugins/hyper/skills/do/SKILL.md, plugins/hyper/skills/plan/SKILL.md · deps: T6 · status: done
T6 misread "code mode". User means Claude Code's experimental Code Mode: env `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE=1` (docs: https://code.claude.com/docs/en/code-mode.md). Facts: Claude writes JS that batches several tool calls in one step; enable via shell env or `~/.claude/settings.json` "env" (PROJECT settings are ignored for this var); `=0` disables; first session asks to confirm; needs restart of claude; keep set for --continue/--resume. Requires v2.1.323+ native build, interactive terminal only (not -p/VS Code/Desktop/cloud), no Bedrock/Vertex/gateways, 5.5/Fable 5.2 models; incompatible with apiKeyHelper, OpenTelemetry, DISABLE_TELEMETRY; code runs stop after 10 min unless backgrounded; permission rules + hooks still apply per tool (PreToolUse can match `REPL`). Subagent inheritance not documented.
1. Remove T6's "Bash-first scripting" definition everywhere (WORKER.md Code mode section, plan/do prompt passthrough, README wording); keep `code_mode=on|off` key in `.hyper/config` as hyper's record of the setting.
2. init: question "Do you plan to use Claude Code's Code Mode (experimental)?" with short description. If yes: check `claude --version` ≥ 2.1.323, show the change, and on confirmation merge `"CLAUDE_CODE_EXPERIMENTAL_CODE_MODE": "1"` into `env` of `~/.claude/settings.json` (preserve other keys; user-global change → always confirm, even in auto mode); also offer `export` line for shell. Tell user to restart claude. Set code_mode=on.
3. config: code_mode on/off toggle; off → set the env value to "0" (or remove it) in ~/.claude/settings.json with confirmation; note restart required. Reword so it's clear it's a Claude Code setting, not a hyper worker behavior.
4. WORKER.md: short note only — under Code Mode, batch independent reads/edits/checks into one code step; long checks (>10 min) run in background; locks/ownership rules unchanged. No prompt passthrough needed (it's session env).
5. README: config row + caveats line (experimental, terminal-only, restart needed, link to docs).
check: grep code_mode/CODE_MODE shows env-var wiring in init+config, no leftover "Bash-first" definition, README links docs.

### T8 silent-on-success testing · p:5 · m:sonnet · owns: WORKER.md, plugins/hyper/skills/plan/SKILL.md, plugins/hyper/skills/do/SKILL.md, plugins/hyper/skills/init/SKILL.md, plugins/hyper/skills/status/SKILL.md, README.md · shares: plugins/hyper/skills/config/SKILL.md · deps: T7 · status: done
1. Read WORKER.md and all hyper skills; find every place checks/tests run or results are reported (check:, rigor levels, DONE log lines, final replies).
2. Add one "Checks" rule (WORKER.md primary, skills point to it): run checks with full output going to `.hyper/logs/T<k>-<check>.log` (e.g. `cmd >.hyper/logs/T5-test.log 2>&1`); on exit 0 print/log nothing beyond the DONE line; on failure show only the exit code + the first relevant error lines (≤10, e.g. `grep -m10 -iE 'error|fail'` or tail), plus the log path.
3. Details on demand: document rerun with the tool's verbose flag (`-v`, `--verbose`) or `grep`/read the log file; `/hyper:status` lists failing threads with their log paths.
4. init/clean: create `.hyper/logs/`; ensure clean removes it (via log/plan note if clean not owned — add to shares). README: brief note.
check: grep shows the Checks rule in WORKER.md, `.hyper/logs` referenced in init + status, no instruction to echo full test output on success.

### T9 dev modes solo/pro/prod · p:6 · m:sonnet · owns: plugins/hyper/skills/config/SKILL.md, WORKER.md, plugins/hyper/skills/plan/SKILL.md, plugins/hyper/skills/do/SKILL.md, plugins/hyper/skills/init/SKILL.md, README.md · deps: — · status: done
Add `dev_mode=solo|pro|prod` (default solo — used ~90% of the time) to `.hyper/config`.
1. config: dev_mode question (solo first, Recommended) + key=value; init: ask it too (default solo; --defaults → solo).
2. WORKER.md "Dev mode" section, terse:
   - solo: work in the shared tree, no worktrees unless two workers must edit the same file; commit small on main (or current branch) as each step passes, `git pull --rebase` then `git push` to origin often; no PRs. Choosing solo is the user's standing approval for these pushes.
   - pro: branch (or worktree when parallel workers overlap) per thread, conventional commits, run affected tests (rigor ≥ medium), push branch + open PR via `gh`, lead merges after checks pass; never push to main directly.
   - prod: everything in pro, plus rigor=slow, worktree per thread, fresh-context review before merge, CI must be green, no force-push, release notes/CHANGELOG entry, explicit user approval before merge/deploy.
3. plan/do: pass `Dev mode: <mode>` in the worker prompt; lead merges/pushes per mode. No git repo → skip git steps silently.
4. README: config row + 3-line mode table.
check: grep dev_mode in config, init, plan, do, WORKER.md, README; default solo.

### T10 --split flag for add/do · p:5 · m:sonnet · owns: plugins/hyper/skills/add/SKILL.md, plugins/hyper/skills/do/SKILL.md · shares: README.md · deps: — · status: done
1. Read add, do, plan SKILL.md (plan's thread-splitting rules) and WORKER.md.
2. `--split`: lead judges whether the task splits into 2+ independent parts with disjoint files; if yes, add/launch one thread (add) or worker (do) per part, respecting max_workers/max_do, with deps between parts where order matters; if not, log `[lead] NOSPLIT <why>` and run as one. `--split --force`: always split into ≥2 parts (best seam, use shares:/deps if files overlap). `--force` without `--split` implies it.
3. Update usage lines/frontmatter descriptions; reply line lists all ids.
4. README command reference: add the flags.
check: grep shows --split and --force in add, do, README with the no-split fallback.

### T11 git init + private GitHub repo · p:5 · m:haiku · owns: .gitignore · deps: — · status: doing:T11
User-approved outward action: create PRIVATE repo github.com/grplyler/hyperdo and push.
1. `git init -b main`; write .gitignore: `.hyper/locks/`, `.hyper/logs/`, `.DS_Store`, `.claude/settings.local.json`. Check no secrets (grep -rIl for key/token patterns); stop and report if found.
2. Commit all files (in-progress edits by other workers are fine; they'll commit later per solo mode).
3. `gh repo create grplyler/hyperdo --private --source=. --remote=origin --push`. If it already exists: `git remote add origin https://github.com/grplyler/hyperdo.git && git push -u origin main` (never force-push).
4. Set `dev_mode=solo` line in .hyper/config if missing is NOT your job — just log the repo URL.
check: `gh repo view grplyler/hyperdo --json visibility -q .visibility` = PRIVATE and `git status -sb` shows tracking origin/main.
