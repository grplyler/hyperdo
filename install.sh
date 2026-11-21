#!/usr/bin/env bash
# Installs Hyperdo for whichever of Claude Code and Codex is on PATH.
set -e
D="$(cd "$(dirname "$0")" && pwd)"; ok=
if command -v claude >/dev/null; then
  mkdir -p ~/.claude/hyperdo && cp "$D/WORKER.md" ~/.claude/hyperdo/WORKER.md
  claude plugin marketplace add "$D" 2>/dev/null || claude plugin marketplace update hyperdo
  claude plugin install hyper@hyperdo --scope user 2>/dev/null || claude plugin update hyper@hyperdo
  ok=1; echo "Claude Code: /hyper:init, /hyper:plan, /hyper:add, /hyper:do, /hyper:config, /hyper:status, /hyper:clean (restart Claude Code)"
fi
if command -v codex >/dev/null; then
  C="${CODEX_HOME:-$HOME/.codex}"; port() { sed -e "s/^name: $2\$/name: hyper-$2/" -e 's#~/\.claude/hyperdo#~/.codex/hyperdo#g' "$1" | cat - "$D/CODEX.md" > "$3"; }
  mkdir -p "$C/hyperdo" && port "$D/WORKER.md" - "$C/hyperdo/WORKER.md"
  for s in "$D"/plugins/hyper/skills/*/; do n="$(basename "$s")"; mkdir -p "$C/skills/hyper-$n" && port "$s/SKILL.md" "$n" "$C/skills/hyper-$n/SKILL.md"; done
  ok=1; echo "Codex (experimental): \$hyper-init, \$hyper-plan, \$hyper-add, \$hyper-do, \$hyper-config, \$hyper-status, \$hyper-clean (restart Codex)"
fi
[ -n "$ok" ] || { echo "Neither claude nor codex found on PATH." >&2; exit 1; }
