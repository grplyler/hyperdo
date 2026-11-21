#!/usr/bin/env bash
set -e
D="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.claude/hyperdo && cp "$D/WORKER.md" ~/.claude/hyperdo/WORKER.md
claude plugin marketplace add "$D" 2>/dev/null || claude plugin marketplace update hyperdo
claude plugin install hyper@hyperdo --scope user 2>/dev/null || claude plugin update hyper@hyperdo
echo "Installed: /hyper:init, /hyper:plan, /hyper:add, /hyper:do, /hyper:config, /hyper:status, /hyper:clean (restart Claude Code)"
