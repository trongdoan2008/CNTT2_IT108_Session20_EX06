#!/usr/bin/env bash
# Cài pre-push hook cho bản clone hiện tại.
set -e
ROOT="$(git rev-parse --show-toplevel)"
cp "$ROOT/scripts/pre-push" "$ROOT/.git/hooks/pre-push"
chmod +x "$ROOT/.git/hooks/pre-push" "$ROOT/scripts/scan-secrets.sh"
echo "✓ Đã cài pre-push hook."
