#!/usr/bin/env bash
# rules.json の禁止パターンに対して、直前に Edit/Write されたファイルを自動検品する。
# PostToolUse hook から起動され、stdin に Claude Code の Hook JSON が渡ってくる。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="${REPO_ROOT}/rules.json"
INPUT="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  echo "警告: jq が見つからないため rules.json の自動検品をスキップしました。jq をインストールしてください。" >&2
  exit 0
fi

FILE_PATH="$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  *.html|*.tsx|*.ts|*.jsx|*.js) ;;
  *) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

if [ ! -f "$RULES_FILE" ]; then
  exit 0
fi

VIOLATIONS=""
TMP_MATCH="$(mktemp)"
trap 'rm -f "$TMP_MATCH"' EXIT

while IFS=$'\t' read -r id pattern reason severity; do
  [ -z "$pattern" ] && continue
  if grep -nE "$pattern" "$FILE_PATH" >"$TMP_MATCH" 2>/dev/null; then
    VIOLATIONS="${VIOLATIONS}
[${severity}] ${id}: ${reason}
  file: ${FILE_PATH}
$(cat "$TMP_MATCH")
"
  fi
done < <(jq -r '.rules[] | [.id, .pattern, .reason, .severity] | @tsv' "$RULES_FILE")

if [ -n "$VIOLATIONS" ]; then
  echo "rules.json 違反が検出されました。修正してください:" >&2
  echo "$VIOLATIONS" >&2
  exit 2
fi

exit 0
