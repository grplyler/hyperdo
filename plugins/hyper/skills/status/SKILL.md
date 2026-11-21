---
name: status
description: Show hyper plan progress: threads by status, held locks, last log lines; clears stale locks on request. Trigger: /hyper:status, "hyper status".
---

# /hyper:status
Print compactly: done/total threads, each thread `id · status · x/y steps`, `ls .hyper/locks`, last 10 lines of `.hyper/log.md`. Phased plan: group by phase; done phases one line (`Phase 1 setup — 4/4 done, gate ok`), open phases expanded. Flat plans as above. Failing threads: for each unresolved `FAIL` line in the log (or `blocked:` thread with a check failure), list `id · check · exit code · .hyper/logs/T<k>-<check>.log` (`ls .hyper/logs`); show log contents only if asked. If a thread is `doing` but no worker is running and user says so, reset it to todo and rmdir its locks.
