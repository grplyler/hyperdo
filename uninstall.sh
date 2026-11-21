#!/usr/bin/env bash
D="$(cd "$(dirname "$0")" && pwd)"; C="${CODEX_HOME:-$HOME/.codex}"
rm -rf ~/.claude/hyperdo ~/.claude/skills/hyperplan "$C/hyperdo"
for s in "$D"/plugins/hyper/skills/*/; do rm -rf "$C/skills/hyper-$(basename "$s")"; done
if command -v claude >/dev/null; then
  claude plugin uninstall hyper@hyperdo 2>/dev/null
  claude plugin marketplace remove hyperdo 2>/dev/null
fi
echo "Uninstalled hyperdo."
