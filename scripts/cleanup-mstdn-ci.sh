#!/usr/bin/env bash
# cleanup-mstdn-ci.sh — mstdn-ci project 限定の孤児コンテナ掃除
# STALE_HOURS 以上経過した mstdn-ci-* コンテナのみ削除（進行中テストを保護）
# ★ default project / 他サービスには絶対触れない
set -euo pipefail

STALE_HOURS="${STALE_HOURS:-24}"
STALE_SECS=$(( STALE_HOURS * 3600 ))
NOW=$(date +%s)

# incus list --format json で created_at を取得し、経過時間を計算
STALE_NAMES=$(incus list --project mstdn-ci --format json \
  | jq -r --argjson now "$NOW" --argjson stale_secs "$STALE_SECS" \
    '.[] | select(.name | startswith("mstdn-ci-"))
       | select(
           ( $now - (
               .created_at
               | gsub("\\.[0-9]+Z$"; "Z")
               | strptime("%Y-%m-%dT%H:%M:%SZ")
               | mktime
             )
           ) > $stale_secs
         )
       | .name' 2>/dev/null)

if [ -z "$STALE_NAMES" ]; then
  echo "No stale instances found (threshold: ${STALE_HOURS}h)."
  exit 0
fi

echo "Stale instances to delete (older than ${STALE_HOURS}h):"
echo "$STALE_NAMES"

while IFS= read -r name; do
  echo "Deleting: $name"
  incus delete --force "$name" --project mstdn-ci
done <<< "$STALE_NAMES"

echo "Cleanup done."
