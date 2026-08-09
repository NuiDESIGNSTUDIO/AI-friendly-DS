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

ERRORS=""
WARNINGS=""
TMP_MATCH="$(mktemp)"
trap 'rm -f "$TMP_MATCH"' EXIT

while IFS=$'\t' read -r id pattern reason alternative severity; do
  [ -z "$pattern" ] && continue
  if grep -nE "$pattern" "$FILE_PATH" >"$TMP_MATCH" 2>/dev/null; then
    ENTRY="
[${severity}] ${id}: ${reason}
  file: ${FILE_PATH}
  代替: ${alternative}
$(cat "$TMP_MATCH")
"
    if [ "$severity" = "error" ]; then
      ERRORS="${ERRORS}${ENTRY}"
    else
      WARNINGS="${WARNINGS}${ENTRY}"
    fi
  fi
done < <(jq -r '.rules[] | [.id, .pattern, .reason, .alternative, .severity] | @tsv' "$RULES_FILE")

# severity=error は自動修正を促すためブロックする。severity=warning は報告のみで処理を止めない。
if [ -n "$ERRORS" ]; then
  echo "rules.json 違反(error)が検出されました。修正してください:" >&2
  echo "$ERRORS" >&2
  if [ -n "$WARNINGS" ]; then
    echo "" >&2
    echo "参考(warning、任意で見直してください):" >&2
    echo "$WARNINGS" >&2
  fi
  exit 2
fi

if [ -n "$WARNINGS" ]; then
  echo "rules.json 違反(warning)が検出されました。ブロックはしませんが、可能であれば見直してください:" >&2
  echo "$WARNINGS" >&2
fi

exit 0
