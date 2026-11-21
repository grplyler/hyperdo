[lead] ADD T1 p:5: Add /hyper:init command like /init for hyper projects, prompting to run /hyper:plan
[T1 19:16] DONE: plugins/hyper/skills/init/SKILL.md, .claude-plugin/marketplace.json, install.sh
[lead] ADD T2 p:5: add/do accept --model override (s55/o55/f52/h55)
[T2 19:17] DONE: plugins/hyper/skills/add/SKILL.md, plugins/hyper/skills/do/SKILL.md
[lead] ADD T3 p:5: hyper works with Claude Code auto mode + plan mode
[T3 19:19] DONE: plugins/hyper/skills/{plan,do,add,init}/SKILL.md, WORKER.md
[lead] ADD T4 p:5: /hyper:clean clears hyper state, optional keep plan
[T4 19:25] DONE: plugins/hyper/skills/clean/SKILL.md, .claude-plugin/marketplace.json, install.sh
[lead] ADD T5 p:5: world-class README (rename/brand the system)
[T5 19:30] NAME proposals: Hyperlane (chosen), Swarmplan, Fanout. Repo/commands stay hyperdo + /hyper:*. No LICENSE file exists; README says so rather than inventing one.
[T5 19:36] DONE: README.md
[lead] ADD T6 p:5: code mode question in hyper:init, wire in, toggle in hyper:config
[T6 19:24] DEFAULT code_mode = workers do the work by writing and running code (Bash-first: scripts for batch/mechanical edits, one-shot verification scripts) instead of many single tool calls; off by default; config key code_mode=on|off
[T6 19:24] DONE: init, config SKILL.md, WORKER.md, plan, do, README.md
[lead] ADD T7 p:6: rework code mode → CLAUDE_CODE_EXPERIMENTAL_CODE_MODE (T6 misread)
[T7 19:27] DONE: WORKER.md, README.md, plugins/hyper/skills/{init,config,plan,do}/SKILL.md (Bash-first removed; code_mode=on|off kept as record; settings.json env edit always confirmed)
[lead] ADD T8 p:5: unix-style silent-on-success testing with logs for details
[T8 19:27] claimed; locked clean/SKILL.md
[T8 19:28] DONE: WORKER.md (Checks rule), plugins/hyper/skills/{plan,do,init,status,clean}/SKILL.md, README.md
[lead] ADD T9 p:6: dev_mode solo/pro/prod
[T9 19:30] DONE: config, init, plan, do SKILL.md, WORKER.md, README.md (dev_mode=solo|pro|prod)
[lead] ADD T10 p:5: --split/--force for add & do
[T10 19:31] DONE: plugins/hyper/skills/{add,do}/SKILL.md, README.md (--split/--force)
[lead] ADD T11 p:5: git init, private repo grplyler/hyperdo, push
[T11 19:31] claimed; owns .gitignore; secret scan clean; doing git init + private repo
[T11 19:32] DONE: .gitignore, initial commit ca9d163 on main, private repo https://github.com/grplyler/hyperdo pushed, tracking origin/main
[lead] ADD T12 p:7: rename Hyperlane → Hyperdo in README
[T12 19:33] claimed; owns README.md; renaming Hyperlane -> Hyperdo (only README hits)
[T12 19:33] DONE: README.md (Hyperlane -> Hyperdo; reworded naming notes at top and FAQ)
[lead] ADD T13 p:5: rigorously eval README.md and fix it for human readers / GitHub stars
[T13 20:05] claimed; owns README.md
[T13 20:06] EVAL 1 tagline says "swarm"/"one markdown file is the truth" (hype, and untrue: state spans PLAN.md + .hyper/); no plain statement of the problem solved
[T13 20:06] EVAL 2 install is 60 lines down, after a 7-bullet "Why it is different" wall; time-to-first-command too slow; clone placeholder <this-repo-url> instead of real URL
[T13 20:06] EVAL 3 5 badges, 2 are filler/misleading ("dependencies: none" though claude CLI + bash required; static version badge drifts); remove
[T13 20:06] EVAL 4 demo inaccuracies: `/hyper:add -p 9` logs `[lead] URGENT` but URGENT is p:10 only; `NEED T0→all` should be NEED T<k>→all from the posting worker; DONE line format is `[T<k>] DONE: ...` not `[T2 14:05] DONE`
[T13 20:06] EVAL 5 FAQ "Does anything leave my machine?" is misleading: agents call Claude, and solo dev_mode pushes to origin; reword accurately
[T13 20:06] EVAL 6 command table cells are paragraph-length (/hyper:add, /hyper:do); duplicated in "How it works"; Modes + Code Mode caveats + FAQ tests answer are walls of text
[T13 20:06] EVAL 7 jargon (threads, lead, contracts) used before defined; top blockquote about naming is noise for a first-time reader
[T13 20:06] EVAL 8 no "when to use / not use" guidance, so visitor can't judge fit; License section reads as an apology
[T13 20:06] EVAL 9 verified OK: install steps, uninstall, all commands/flags/aliases, config keys+defaults, mermaid syntax, no hyperlane; no LICENSE file exists (not inventing one)
[T13 20:12] DONE: README.md (rewritten; no LICENSE file exists, README says so; mermaid not machine-parsed, syntax reviewed by eye)
[lead] ADD T14 p:5: automatic phases — close the gate + grouping holes, keep it light
[T14 20:30] claimed; owns plan/add/do/status SKILL.md, WORKER.md, README.md
[T14 20:30] DESIGN 1 format: optional `## Phase N <name>` headings over threads + one `gate: <cmd|condition>` line; ids global; `· hold` suffix on heading = lead skips its todo threads (1 line, kept)
[T14 20:30] DESIGN 2 derivation: /hyper:plan groups by dep depth/milestone and writes gates; ≤4 threads or 1 dep level → no phases (flat plans unchanged)
[T14 20:30] DESIGN 3 binding: thread waits on gate of phase N only if it has a dep in phase N; otherwise deps+p as today; gate run once after phase's last thread done, silent per Checks, PHASE N DONE / PHASE N FAIL <log> + fix thread in that phase; prod asks approval before next phase
[T14 20:30] DESIGN 4 add: phase of latest dep, else current open phase; re-opens a gated phase; reply appends (phase N). do "<task>" outside phases; status: done phases one line, open expanded
[T14 20:36] DEFAULT prod approval asked once per gate before its dependent threads start; hold kept (1 line); clean/init untouched (phases live in PLAN.md, nothing breaks)
[T14] DONE: plugins/hyper/skills/{plan,add,do,status}/SKILL.md, WORKER.md, README.md (automatic phases). User must re-run install.sh to pick up new WORKER.md
[lead] ADD T15 p:5: emphasize simplicity/lightness; least-surprise audit of all skills (trim, no new features)
[T15 19:40] claimed
[T15] SIZE skills+WORKER.md=230 lines (add26 clean33 config20 do22 init43 plan52 status7 WORKER27); install.sh=7; README=204; commands=7; deps=none (markdown skills, no runtime)
[T15] SIZE README=204 before; uninstall.sh=5; config keys=6; flags: -p --model --split --force --keep-plan --defaults
[T15] SURPRISE add: auto-created config had only 3 keys, init/plan write 6 -> fixed (points to init defaults)
[T15] SURPRISE add: worker prompt omitted Dev mode while plan/do pass it -> fixed
[T15] SURPRISE config: max-workers choices 2/4/6/8 omit the default 3 that init offers -> fixed to 2/3/6/8
[T15] SURPRISE add: routing rule duplicated from plan -> now points at hyper:plan step 4
[T15] PROPOSE do with no args duplicates /hyper:plan resume (two ways to run the plan); consider dropping one
[T15] PROPOSE code_mode key edits ~/.claude/settings.json (state outside the project, unexpected for a project config); consider docs-only
[T15] PROPOSE init asks 6 questions though defaults exist; consider making --defaults the default and asking only via /hyper:config
[T15] PROPOSE /hyper:do keeps legacy --opus/--sonnet/--haiku beside --model (two ways); consider removing
[T15] NOTE user must re-run install.sh to pick up skill changes
[T15] DONE: README.md, .claude-plugin/marketplace.json, plugins/hyper/skills/{add,config}/SKILL.md
[lead] ADD T16 p:5: align README subtitle to the GitHub description (queued: deps T15, which owns README.md)
[T16 19:41] DONE: README.md (subtitle replaced verbatim with GitHub description)
[lead] ADD T17 p:5: add MIT LICENSE (Copyright 2026 Ryan Plyler), update README license section
[T17 19:42] claimed; locks README.md, .claude-plugin/marketplace.json; LICENSE owned
[T17 19:42] DONE: LICENSE, README.md (commit cf21d05, pushed); marketplace/plugin.json have no license field, left unchanged
