#!/usr/bin/env bash
rm -rf ~/.claude/hyperdo ~/.claude/skills/hyperplan
claude plugin uninstall hyper@hyperdo 2>/dev/null
claude plugin marketplace remove hyperdo 2>/dev/null
echo "Uninstalled hyperdo."
